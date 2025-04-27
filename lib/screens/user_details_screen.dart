import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tales/screens/home_screen.dart';
import 'package:tales/screens/auth/login_screen.dart';
import 'package:tales/services/auth_service.dart';
import 'home_page.dart';

class UserDetailsScreen extends StatefulWidget {
  final bool requireBiometrics;
  
  const UserDetailsScreen({
    super.key, 
    this.requireBiometrics = true,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _authenticated = false;
  bool _isLoading = true;
  bool _authFailed = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Get current user
    _user = FirebaseAuth.instance.currentUser;
    
    // Only run biometric check if required
    if (widget.requireBiometrics) {
      await _authenticateWithBiometrics();
    } else {
      setState(() {
        _authenticated = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!mounted) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Check if biometrics are available on device
    bool isBiometricsAvailable = await authService.isBiometricsAvailable();
    bool didAuth = true;
    
    // Only prompt for biometrics if available
    if (isBiometricsAvailable) {
      didAuth = await authService.authenticateWithBiometrics();
    }
    
    if (!mounted) return;
    
    setState(() {
      _authenticated = didAuth;
      _authFailed = !didAuth;
      _isLoading = false;
    });
    
    // If authenticated, navigate to home screen after a brief pause
    if (didAuth) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      });
    }
  }

  void _logout() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : !_authenticated
                ? _buildAuthScreen()
                : _buildProfileScreen(),
      ),
    );
  }
  
  Widget _buildAuthScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 80, color: Colors.white54),
          const SizedBox(height: 16),
          const Text('Biometric Authentication Required', 
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Please authenticate using your fingerprint or face ID to access your notes',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 24),
          if (_authFailed)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Authentication failed. Please try again.',
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ),
          ElevatedButton(
            onPressed: _authenticateWithBiometrics,
            child: const Text('Try Again'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _logout,
            child: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileScreen() {
    return Stack(
      children: [
        Positioned(
          top: 16,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
        ),
        Positioned(
          top: 16,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _logout,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white12,
                child: Icon(Icons.person, size: 60, color: Colors.white54),
              ),
              const SizedBox(height: 24),
              Text(
                _user?.displayName ?? _user?.email ?? _user?.phoneNumber ?? 'User',
                style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_user?.email != null)
                Text(_user!.email!, style: const TextStyle(color: Colors.white70, fontSize: 18)),
              if (_user?.phoneNumber != null)
                Text(_user!.phoneNumber!, style: const TextStyle(color: Colors.white70, fontSize: 18)),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: const Text('Go to App', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}