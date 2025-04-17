import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/MoneyTransferPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': _fullNameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'age': _ageController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration successful!')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MoneyTransferPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed!')));
    }
  }

  Widget customTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF6366F1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              customTextField(
                'Full Name',
                _fullNameController,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your full name' : null,
              ),
              customTextField(
                'Phone',
                _phoneController,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Please enter your phone number'
                            : null,
              ),
              customTextField(
                'Email',
                _emailController,
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value!.isEmpty || !value.contains('@')
                            ? 'Please enter a valid email'
                            : null,
              ),
              customTextField(
                'Address',
                _addressController,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your address' : null,
              ),
              customTextField(
                'Age',
                _ageController,
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty || int.tryParse(value) == null
                            ? 'Please enter a valid age'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registerUser();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
