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
