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


// spotify_auth_service.dart (auth disabled for testing)

class SpotifyAuthService {
  // Dummy credentials (not used during testing)
  final clientId = '8010f9a98b454ddca510cdc46fd5145a';
  final clientSecret = 'f48182bdf44b4f1987fb8c41ee9316e3';
  final redirectUri = 'talesapp://callback';

  // Disabled authentication
  Future<String?> authenticate() async {
    // Spotify authentication is disabled for UI testing
    return 'dummy_access_token';
  }
}
