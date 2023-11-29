import 'package:fastfoodweb/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:fastfoodweb/Screens/auth/admin_signup.dart';
import 'package:fastfoodweb/Screens/menu_screen.dart';
import 'package:fastfoodweb/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AdminLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: _AdminLoginPage(),
    );
  }
}

class _AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<_AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // State variable to manage loading state

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: const Text(
            'Admin Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 600,
          width: 700,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 201, 200, 200), // Background color (orange)
            borderRadius: BorderRadius.circular(10), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Shadow color
                spreadRadius: 3, // Spread radius
                blurRadius: 5, // Blur radius
                offset: const Offset(0, 3), // Changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                radius: 70,
              ),
              Center(
                child: Text(
                  'WELCOME TO FASTFOOOD',
                  style: TextStyle(
                      color: const Color.fromRGBO(255, 152, 0, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _emailController,
                  style: const TextStyle(
                      color: Colors.black), // Text field text color (white)
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(
                      color: Colors.black), // Text field text color (white)
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              TextButton(
                  onPressed: () {
                    authProvider.resetPassword(
                        email: _emailController.text, context: context);
                  },
                  child: const Text('Forget Password')),
              _isLoading // Display circular progress indicator if loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Start showing the indicator
                        });

                        try {
                          final user =
                              await authProvider.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuScreen(),
                              ),
                            );
                          } else {
                            _showSignInFailedDialog(context);
                          }
                        } catch (e) {
                          print(e);
                          _showSignInFailedDialog(context);
                        } finally {
                          setState(() {
                            _isLoading = false; // Hide the indicator
                          });
                        }
                      },
                      child: const Text('Log In'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminSignUpPage()),
                  );
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignInFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign-In Failed'),
          content: const Text('Login failed. Please check your credentials.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
