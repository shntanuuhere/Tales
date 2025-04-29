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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
// import '../models/podcast.dart';
import 'auth_service.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;
  bool _isInitialized = false;
  User? _user;
  bool _isLoading = false;
  String? _error;

  FirebaseService(this._authService);

  bool get isInitialized => _isInitialized;
  User? get currentUser => _user;
  bool get isUserLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        // Firebase is already initialized, just use the existing app
        developer.log('Firebase already initialized, using existing app', name: 'firebase_service');
        _isInitialized = true;
      } else {
        // Initialize Firebase with a specific name to avoid conflicts
        await Firebase.initializeApp(name: 'tales_service');
        _isInitialized = true;
      }

      _user = _auth.currentUser;
      _auth.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      developer.log('Failed to initialize Firebase: $e', name: 'firebase_service', error: e);
      _isInitialized = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      developer.log('Sign in failed: $e', name: 'firebase_service', error: e);
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      developer.log('Registration failed: $e', name: 'firebase_service', error: e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> saveUserPodcast(String podcastUrl) async {
    if (_user == null) return;

    try {
      await _firestore.collection('users').doc(_user!.uid).collection('podcasts').add({
        'url': podcastUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      developer.log('Failed to save podcast: $e', name: 'firebase_service', error: e);
      rethrow;
    }
  }

  Future<List<String>> getUserPodcasts() async {
    if (_user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('podcasts')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()['url'] as String).toList();
    } catch (e) {
      developer.log('Failed to get podcasts: $e', name: 'firebase_service', error: e);
      return [];
    }
  }

  // Get user collection reference
  CollectionReference get _usersCollection =>
      _firestore.collection('users');

  // Get current user document reference
  DocumentReference get _userDoc =>
      _usersCollection.doc(_authService.userId);

  // Get user podcasts collection reference
  CollectionReference get _userPodcastsCollection =>
      _userDoc.collection('podcasts');


  // Simplified version that doesn't use the Podcast class
  Future<bool> savePodcast(Map<String, String> podcastData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if user is authenticated
      if (!_authService.isAuthenticated) {
        throw 'User not authenticated';
      }

      // Add timestamp
      final dataWithTimestamp = {
        ...podcastData,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Save podcast to Firestore
      await _userPodcastsCollection.doc(podcastData['title']).set(dataWithTimestamp);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get user's podcasts
  Stream<List<Map<String, dynamic>>> getUserPodcastsStream() {
    if (!_authService.isAuthenticated) {
      return Stream.value([]);
    }

    return _userPodcastsCollection
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Remove a podcast
  Future<bool> removePodcast(String podcastId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if user is authenticated
      if (!_authService.isAuthenticated) {
        throw 'User not authenticated';
      }

      // Delete podcast from Firestore
      await _userPodcastsCollection.doc(podcastId).delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Save user preferences
  Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if user is authenticated
      if (!_authService.isAuthenticated) {
        throw 'User not authenticated';
      }

      // Add timestamp
      preferences['lastUpdated'] = FieldValue.serverTimestamp();

      // Save preferences to Firestore
      await _userDoc.set({
        'preferences': preferences
      }, SetOptions(merge: true));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get user preferences
  Future<Map<String, dynamic>> getUserPreferences() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if user is authenticated
      if (!_authService.isAuthenticated) {
        _isLoading = false;
        notifyListeners();
        return {};
      }

      // Get user document
      final docSnapshot = await _userDoc.get();

      _isLoading = false;
      notifyListeners();

      if (!docSnapshot.exists) {
        return {};
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      return data['preferences'] ?? {};
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return {};
    }
  }

  // Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}