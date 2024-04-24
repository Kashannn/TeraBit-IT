import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool mondayToFriday = false;
  bool mondayTuesdayFriday = false;
  bool allTimeOpen = false;
  bool customAdd = false;
  String selectedDay = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController toTimeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  late ImagePicker _picker;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : null,
                    child: _imageFile == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                // Rest of the form fields
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Email text field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Password text field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Phone number text field
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Address text field
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Availability text field
                TextField(
                  controller: availabilityController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Availability',
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Set Availability',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20.0,
                                          fontFamily: 'Lobster',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Column(
                                        children: [
                                          RadioListTile(
                                            title: Text('Monday to Friday'),
                                            value: 'Monday to Friday',
                                            groupValue: selectedDay,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDay = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            title:
                                                Text('Monday, Tuesday, Friday'),
                                            value: 'Monday, Tuesday, Friday',
                                            groupValue: selectedDay,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDay = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text('All Time Open'),
                                            value: 'All Time Open',
                                            groupValue: selectedDay,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDay = value.toString();
                                              });
                                            },
                                          ),
                                          RadioListTile(
                                            title: Text('Custom Add'),
                                            value: 'Custom Add',
                                            groupValue: selectedDay,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDay = value.toString();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        'Set Time',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20.0,
                                          fontFamily: 'Lobster',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: fromTimeController,
                                              decoration: InputDecoration(
                                                labelText: 'From',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.green,
                                                      width: 2.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Expanded(
                                            child: TextField(
                                              controller: toTimeController,
                                              decoration: InputDecoration(
                                                labelText: 'To',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.green,
                                                      width: 2.0),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (selectedDay.isNotEmpty) {
                                              String availability =
                                                  '$selectedDay From: ${fromTimeController.text} To: ${toTimeController.text}';
                                              availabilityController.text =
                                                  availability;
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(double.infinity, 50)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'ADD',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                ),

                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      // If the user is created successfully, show a confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration successful'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Optionally, you can navigate to the next screen or perform any other actions
                    } catch (e) {
                      // Handle any errors that occur during the sign up process
                      print('Error creating user: $e');
                      // Show a snackbar or dialog to inform the user about the error
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}
