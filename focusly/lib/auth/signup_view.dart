import 'package:flutter/material.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _auth = AuthenticationService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);

    final primaryColor =
        Theme.of(context).primaryColor; // primary color from the theme
    final secondaryColor =
        Theme.of(
          context,
        ).colorScheme.secondary; // Secondary color from the theme
    final tertiaryColor =
        Theme.of(context).colorScheme.tertiary; // tertiary color from the theme

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Container to ensure Stack has size
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            // ),

            // Ellipses at the top
            Positioned(
              top: -80,
              left: -10,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -70,
              right: -60,
              child: Container(
                width: 250,
                height: 300,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 75,
              left: -60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: tertiaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 250,
                    left: 40,
                  ), // Adjust position of the text
                  child: RichText(
                    textAlign: TextAlign.left, // Align text to the left
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Create\n",
                          style: TextStyle(
                            fontSize: 57,
                            fontWeight: FontWeight.w400,
                            color: tertiaryColor, // Use the primary color
                          ),
                        ),
                        TextSpan(
                          text: "Account",
                          style: TextStyle(
                            fontSize: 57,
                            fontWeight: FontWeight.w400,
                            color: tertiaryColor, // Use the primary color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tertiaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                
                                authService.createUserWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                  context: context,
                                );
                               
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Creating Account...'),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: () => authService.signIn(context: context),
                    child: const Text('Sign in with Google'),
                  ),
                ),
                const SizedBox(height: 20), // Add spacing at the bottom
              ],
            ),
          ],
        ),
      ),
    );
  }

  // _signUp() async {
  //   final user = await _auth.createUserWithEmailAndPassword(
  //     _emailController.text,
  //     _passwordController.text,
  //   );
  // }
}
