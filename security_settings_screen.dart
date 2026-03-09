import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwd = TextEditingController();
  final _newPwd = TextEditingController();
  final _confirmPwd = TextEditingController();
  bool _twoFA = false;

  @override
  void dispose() {
    _currentPwd.dispose();
    _newPwd.dispose();
    _confirmPwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Security Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('Change Password', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _currentPwd,
                      decoration: const InputDecoration(labelText: 'Current Password'),
                      obscureText: true,
                      validator: (v) => (v == null || v.isEmpty) ? 'Enter current password' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _newPwd,
                      decoration: const InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                      validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmPwd,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (v) => (v != _newPwd.text) ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password updated')),
                          );
                        }
                      },
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('Update Password'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Two-Factor Authentication', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _twoFA,
                title: const Text('Enable 2FA'),
                subtitle: const Text('Add an extra layer of security to your account'),
                onChanged: (v) => setState(() => _twoFA = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


