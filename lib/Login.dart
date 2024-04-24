import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Dashboard.dart';
import 'SignUpPage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }



  bool _isObscure = true;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(
            color: Color(0xFF1C1F34),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome Back, You Have Been\n       Missed For Long Time',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                suffixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  child: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  fillColor: MaterialStateColor.resolveWith(
                    (states) => _isChecked ? Colors.red : Colors.transparent,
                  ),
                ),
                Text(
                  'Remember Me',
                  style: TextStyle(color: _isChecked ? Colors.red : null),
                ),
                Spacer(),
                Text('Forgot Password ?'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                login();
              },
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
                  child: Text('Go to Sign Up'),
                ),

              ],
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: Text('__________  Or Continue With  __________'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _handleSignIn();
                  },
                  icon: SvgPicture.asset(
                    'assets/Google.svg',
                    width: 34,
                    height: 34,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () {

                  },
                  icon: Image.asset(
                    'assets/Phone.png',
                    width: 34,
                    height: 34,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user != null) {
        // Navigate to the Dashboard if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      } else {
        // Show an error message if user is null (login failed)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Handle the case where the user is not found
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User Not Found'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('User not found. Would you like to sign up?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        // Handle the case where the provided password is wrong
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong password provided for that user.'),
        ));
      } else {
        // Handle other FirebaseAuthException errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${e.message}'),
        ));
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ));
    }
  }

  void _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // Sign in was successful, proceed with your app's logic
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle sign-in errors, if any
    }
  }


}
