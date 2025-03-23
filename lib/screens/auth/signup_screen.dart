import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kib_theme_switcher/common_export.dart' show ThemeService, getIt;
import 'package:kib_theme_switcher/screens/auth/login_screen.dart'
    show LoginScreen;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _themeService = getIt<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        actions: [
          IconButton(
            icon: Icon(
              _themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: _themeService.toggleTheme,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'full_name',
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  key: _emailFieldKey,
                  name: 'email',
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'password',
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'confirm_password',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: (_formKey.currentState
                                ?.fields['confirm_password']?.hasError ??
                            false)
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      _formKey.currentState?.fields['password']?.value != value
                          ? 'No coinciden'
                          : null,
                ),
                const SizedBox(height: 10),
                FormBuilderFieldDecoration<bool>(
                  name: 'test',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.equal(true),
                  ]),
                  // initialValue: true,
                  decoration: const InputDecoration(labelText: 'Accept Terms?'),
                  builder: (FormFieldState<bool?> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        errorText: field.errorText,
                      ),
                      child: SwitchListTile(
                        title: const Text(
                            'I have read and accept the terms of service.'),
                        onChanged: field.didChange,
                        value: field.value ?? false,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      if (true) {
                        // Either invalidate using Form Key
                        _formKey.currentState?.fields['email']
                            ?.invalidate('Email already taken.');
                        // OR invalidate using Field Key
                        // _emailFieldKey.currentState?.invalidate('Email already taken.');
                      }
                    }
                    debugPrint(_formKey.currentState?.value.toString());
                  },
                  child: const Text('Signup'),
                ),
                // Added login navigation section
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate back to login screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
