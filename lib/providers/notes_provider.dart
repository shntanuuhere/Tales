// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';

class NotesProvider extends ChangeNotifier {
  static const String _storageKey = 'notes';
  List<Note> _notes = [];
  late SharedPreferences _prefs;
  bool _initialized = false;
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<Note>>? _notesSubscription;
  bool _isCloudSynced = false;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isCloudSynced => _isCloudSynced;

  NotesProvider() {
    // Listen for auth state changes to handle sync
    FirebaseAuth.instance.authStateChanges().listen(_handleAuthStateChanged);
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    await loadNotes();
    _initialized = true;
    
    // If user is already authenticated, subscribe to Firestore
    if (_firestoreService.isAuthenticated) {
      _subscribeToFirestore();
    }
  }

  Future<void> loadNotes() async {
    final String? notesJson = _prefs.getString(_storageKey);
    if (notesJson != null) {
      final List<dynamic> decoded = jsonDecode(notesJson);
      _notes = decoded.map((item) => Note.fromJson(item)).toList();
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      notifyListeners();
    }
  }

  Future<void> _saveNotes() async {
    final String encoded = jsonEncode(_notes.map((note) => note.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
  }
  
  void _handleAuthStateChanged(User? user) async {
    if (user != null) {
      // User logged in, sync local notes to Firestore
      await _syncToFirestore();
      _subscribeToFirestore();
    } else {
      // User logged out, unsubscribe from Firestore
      _unsubscribeFromFirestore();
      _isCloudSynced = false;
      notifyListeners();
    }
  }
  
  Future<void> _syncToFirestore() async {
    try {
      if (_firestoreService.isAuthenticated && _notes.isNotEmpty) {
        await _firestoreService.syncLocalNotesToFirestore(_notes);
        _isCloudSynced = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error syncing to Firestore: $e');
    }
  }
  
  void _subscribeToFirestore() {
    if (!_firestoreService.isAuthenticated) return;
    
    _unsubscribeFromFirestore(); // Cancel any existing subscription
    
    _notesSubscription = _firestoreService.getNotes().listen((cloudNotes) {
      // Only update if we have cloud notes and they're different from local
      if (cloudNotes.isNotEmpty) {
        _notes = cloudNotes;
        _saveNotes(); // Update local storage with cloud data
        _isCloudSynced = true;
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint('Error getting notes from Firestore: $error');
    });
  }
  
  void _unsubscribeFromFirestore() {
    _notesSubscription?.cancel();
    _notesSubscription = null;
  }

  Future<void> addNote(String title, String content) async {
    final now = DateTime.now();
    String noteId = now.millisecondsSinceEpoch.toString();
    
    // If user is authenticated, save to Firestore first
    if (_firestoreService.isAuthenticated) {
      try {
        noteId = await _firestoreService.addNote(title, content);
      } catch (e) {
        debugPrint('Error adding note to Firestore: $e');
        // Continue with local storage even if Firestore fails
      }
    }
    
    final note = Note(
      id: noteId,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    _notes.insert(0, note);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        title: title,
        content: content,
      );
      await _saveNotes();
      
      // If user is authenticated, update in Firestore
      if (_firestoreService.isAuthenticated) {
        try {
          await _firestoreService.updateNote(id, title, content);
        } catch (e) {
          debugPrint('Error updating note in Firestore: $e');
          // Continue even if Firestore update fails
        }
      }
      
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
    
    // If user is authenticated, delete from Firestore
    if (_firestoreService.isAuthenticated) {
      try {
        await _firestoreService.deleteNote(id);
      } catch (e) {
        debugPrint('Error deleting note from Firestore: $e');
        // Continue even if Firestore delete fails
      }
    }
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _unsubscribeFromFirestore();
    super.dispose();
  }
}