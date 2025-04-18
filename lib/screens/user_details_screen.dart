import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tales/screens/auth/login_screen.dart';
import 'package:local_auth/local_auth.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _authenticated = false;
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheck = await auth.canCheckBiometrics;
    bool didAuth = false;
    if (canCheck) {
      try {
        didAuth = await auth.authenticate(
          localizedReason: 'Authenticate to view your details',
          options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
        );
      } catch (e) {
        didAuth = false;
      }
    }
    setState(() {
      _authenticated = didAuth;
      _user = FirebaseAuth.instance.currentUser;
      _isLoading = false;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 80, color: Colors.white54),
                        const SizedBox(height: 16),
                        const Text('Authentication required', style: TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _checkBiometric,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.maybePop(context);
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
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}