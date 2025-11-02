import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
/*  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  */
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authFacadeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_isRegister) {
                    await auth.registerWithEmail(
                      _emailCtrl.text.trim(),
                      _passCtrl.text.trim(),
                    );
                  } else {
                    await auth.signInWithEmail(
                      _emailCtrl.text.trim(),
                      _passCtrl.text.trim(),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: Text(_isRegister ? 'Register' : 'Sign In'),
            ),
            TextButton(
              onPressed: () => setState(() => _isRegister = !_isRegister),
              child: const Text('Toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
