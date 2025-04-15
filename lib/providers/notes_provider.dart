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
import 'dart:convert';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  static const String _storageKey = 'notes';
  List<Note> _notes = [];
  late SharedPreferences _prefs;
  bool _initialized = false;

  List<Note> get notes => List.unmodifiable(_notes);

  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    await loadNotes();
    _initialized = true;
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

  Future<void> addNote(String title, String content) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
    notifyListeners();
  }
}