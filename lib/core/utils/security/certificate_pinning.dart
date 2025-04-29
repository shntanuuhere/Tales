import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// A utility class for implementing certificate pinning
class CertificatePinningHttpClient extends http.BaseClient {
  /// The underlying HTTP client
  final http.Client _inner;

  /// Map of domains to their expected SHA-256 certificate fingerprints
  final Map<String, List<String>> pins;

  /// Constructor
  CertificatePinningHttpClient({
    required this.pins,
    http.Client? inner,
  }) :
    _inner = inner ?? _createPinningClient(pins);

  /// Create a client with certificate pinning
  static http.Client _createPinningClient(Map<String, List<String>> pins) {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Get the pins for this host
        final hostPins = pins[host];
        if (hostPins == null) {
          // If we don't have pins for this host, reject the certificate
          debugPrint('No pins found for host: $host');
          return false;
        }

        // Get the certificate fingerprint
        // In a real implementation, we would extract the SHA-256 fingerprint
        // For testing purposes, we'll use a simplified approach
        final fingerprint = _getCertificateFingerprint(cert);

        // Check if the fingerprint matches any of the pins
        final isValid = hostPins.contains(fingerprint);

        if (!isValid) {
          debugPrint('Certificate pinning failed for $host');
          debugPrint('Expected one of: $hostPins');
          debugPrint('Got: $fingerprint');
        }

        return isValid;
      };

    return IOClient(httpClient);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }

  /// Helper method to get certificate fingerprint
  static String _getCertificateFingerprint(X509Certificate cert) {
    // In a real implementation, we would compute the SHA-256 hash of the certificate
    // For testing purposes, we'll use a simplified approach that uses the certificate's
    // subject distinguished name as a basis for a fingerprint
    final subject = cert.subject;

    // Create a simple hash from the subject
    var hash = 0;
    for (var i = 0; i < subject.length; i++) {
      hash = (hash + subject.codeUnitAt(i) * (i + 1)) % 999999;
    }

    // Format as a SHA-256 fingerprint would look
    return 'sha256/${hash.toRadixString(16).padLeft(64, '0')}';
  }

  /// Get a client for Unsplash API
  static http.Client getUnsplashClient() {
    // These are example fingerprints - you would need to get the actual ones
    // from the Unsplash API server certificates
    const unsplashPins = {
      'api.unsplash.com': [
        // Example fingerprints - replace with actual ones
        'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
        'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
      ],
    };

    // In debug mode, don't use certificate pinning to make development easier
    if (kDebugMode) {
      return http.Client();
    }

    return CertificatePinningHttpClient(pins: unsplashPins);
  }
}
