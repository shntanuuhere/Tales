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

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

// MockDocument to replace Firestore Document
class MockDocument {
  final String id;
  final Map<String, dynamic> data;
  
  MockDocument({required this.id, required this.data});
}

class FirestoreService {
  // Storage key prefix
  static const String _storageKeyPrefix = 'firestore_';
  
  // Auth service for user ID
  final AuthService _authService;
  
  // Constructor
  FirestoreService(this._authService);
  
  // Get user ID
  String? get _userId => _authService.userId;
  
  // Collection key
  String _getCollectionKey(String collection) {
    return '$_storageKeyPrefix${_userId ?? "anonymous"}_$collection';
  }
  
  // Document key
  String _getDocumentKey(String collection, String documentId) {
    return '${_getCollectionKey(collection)}_$documentId';
  }
  
  // Add a document to a collection
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      // Generate an ID
      final String documentId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Add timestamp
      data['createdAt'] = DateTime.now().toIso8601String();
      data['updatedAt'] = DateTime.now().toIso8601String();
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _getDocumentKey(collection, documentId),
        jsonEncode(data),
      );
      
      // Update collection index
      await _updateCollectionIndex(collection, documentId, true);
      
      return documentId;
    } catch (e) {
      debugPrint('Error adding document: $e');
      rethrow;
    }
  }
  
  // Get a document by ID
  Future<MockDocument?> getDocument(String collection, String documentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(_getDocumentKey(collection, documentId));
      
      if (jsonData == null) {
        return null;
      }
      
      return MockDocument(
        id: documentId,
        data: jsonDecode(jsonData) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('Error getting document: $e');
      return null;
    }
  }
  
  // Update a document
  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(_getDocumentKey(collection, documentId));
      
      if (jsonData == null) {
        throw 'Document not found';
      }
      
      // Get existing data
      final Map<String, dynamic> existingData = jsonDecode(jsonData) as Map<String, dynamic>;
      
      // Merge data
      existingData.addAll(data);
      
      // Update timestamp
      existingData['updatedAt'] = DateTime.now().toIso8601String();
      
      // Save to SharedPreferences
      await prefs.setString(
        _getDocumentKey(collection, documentId),
        jsonEncode(existingData),
      );
    } catch (e) {
      debugPrint('Error updating document: $e');
      rethrow;
    }
  }
  
  // Delete a document
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getDocumentKey(collection, documentId));
      
      // Update collection index
      await _updateCollectionIndex(collection, documentId, false);
    } catch (e) {
      debugPrint('Error deleting document: $e');
      rethrow;
    }
  }
  
  // Get all documents in a collection
  Future<List<MockDocument>> getCollection(String collection) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> documentIds = await _getCollectionIndex(collection);
      
      final List<MockDocument> documents = [];
      
      for (final documentId in documentIds) {
        final String? jsonData = prefs.getString(_getDocumentKey(collection, documentId));
        
        if (jsonData != null) {
          documents.add(MockDocument(
            id: documentId,
            data: jsonDecode(jsonData) as Map<String, dynamic>,
          ));
        }
      }
      
      return documents;
    } catch (e) {
      debugPrint('Error getting collection: $e');
      return [];
    }
  }
  
  // Update collection index
  Future<void> _updateCollectionIndex(String collection, String documentId, bool add) async {
    try {
      final List<String> documentIds = await _getCollectionIndex(collection);
      
      if (add) {
        // Add if not exists
        if (!documentIds.contains(documentId)) {
          documentIds.add(documentId);
        }
      } else {
        // Remove if exists
        documentIds.remove(documentId);
      }
      
      // Save updated index
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_getCollectionKey(collection), documentIds);
    } catch (e) {
      debugPrint('Error updating collection index: $e');
    }
  }
  
  // Get collection index (list of document IDs)
  Future<List<String>> _getCollectionIndex(String collection) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_getCollectionKey(collection)) ?? [];
    } catch (e) {
      debugPrint('Error getting collection index: $e');
      return [];
    }
  }
  
  // Stream a collection (simulated)
  Stream<List<MockDocument>> streamCollection(String collection) {
    // Use a StreamController to simulate Firestore streams
    final StreamController<List<MockDocument>> controller = StreamController<List<MockDocument>>.broadcast();
    
    // Initial data
    _loadInitialData(collection, controller);
    
    // Return the stream
    return controller.stream;
  }
  
  // Load initial data for stream
  Future<void> _loadInitialData(String collection, StreamController<List<MockDocument>> controller) async {
    try {
      final documents = await getCollection(collection);
      controller.add(documents);
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      controller.add([]);
    }
  }
}