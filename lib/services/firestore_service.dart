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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID or null if not authenticated
  String? get _userId => _auth.currentUser?.uid;

  // Reference to the user's notes collection
  CollectionReference<Map<String, dynamic>> get _notesCollection {
    if (_userId == null) {
      throw Exception('User must be logged in to access notes');
    }
    return _firestore.collection('users').doc(_userId).collection('notes');
  }

  // Check if user is authenticated
  bool get isAuthenticated => _userId != null;

  // Get all notes for the current user
  Stream<List<Note>> getNotes() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Note.fromJson({
          'id': doc.id,
          'title': data['title'] ?? '',
          'content': data['content'] ?? '',
          'createdAt': data['createdAt'] ?? DateTime.now().toIso8601String(),
          'updatedAt': data['updatedAt'] ?? DateTime.now().toIso8601String(),
        });
      }).toList();
    });
  }

  // Add a new note
  Future<String> addNote(String title, String content) async {
    if (_userId == null) {
      throw Exception('User must be logged in to add notes');
    }

    final now = DateTime.now();
    final docRef = await _notesCollection.add({
      'title': title,
      'content': content,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });

    return docRef.id;
  }

  // Update an existing note
  Future<void> updateNote(String id, String title, String content) async {
    if (_userId == null) {
      throw Exception('User must be logged in to update notes');
    }

    await _notesCollection.doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    if (_userId == null) {
      throw Exception('User must be logged in to delete notes');
    }

    await _notesCollection.doc(id).delete();
  }

  // Sync local notes to Firestore when user logs in
  Future<void> syncLocalNotesToFirestore(List<Note> localNotes) async {
    if (_userId == null) {
      throw Exception('User must be logged in to sync notes');
    }

    // Get existing notes from Firestore
    final snapshot = await _notesCollection.get();
    final existingNoteIds = snapshot.docs.map((doc) => doc.id).toSet();

    // Create a batch to handle multiple operations
    final batch = _firestore.batch();

    // Add or update each local note
    for (final note in localNotes) {
      final noteRef = _notesCollection.doc(note.id);
      
      // Convert note to Firestore format
      final noteData = {
        'title': note.title,
        'content': note.content,
        'createdAt': note.createdAt.toIso8601String(),
        'updatedAt': note.updatedAt.toIso8601String(),
      };

      if (existingNoteIds.contains(note.id)) {
        // Update existing note
        batch.update(noteRef, noteData);
      } else {
        // Create new note
        batch.set(noteRef, noteData);
      }
    }

    // Commit the batch
    await batch.commit();
  }
}