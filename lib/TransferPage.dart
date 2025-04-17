import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCardType;
  final cardTypes = ['MasterCard', 'Visa', 'Bank Card'];

  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Color(0xFF6366F1),
        title: Text("Transfer Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCardType,
                decoration: inputDecoration("Select Card Type"),
                dropdownColor: Color(0xFF1E293B),
                style: TextStyle(color: Colors.white),
                items:
                    cardTypes.map((card) {
                      return DropdownMenuItem(value: card, child: Text(card));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCardType = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Please select card type' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Card Number"),
                style: TextStyle(color: Colors.white),
                validator:
                    (value) => value!.isEmpty ? 'Enter card number' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: cardHolderController,
                decoration: inputDecoration("Card Holder Name"),
                style: TextStyle(color: Colors.white),
                validator:
                    (value) => value!.isEmpty ? 'Enter card holder name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: expiryDateController,
                keyboardType: TextInputType.datetime,
                decoration: inputDecoration("Expiry Date (MM/YY)"),
                style: TextStyle(color: Colors.white),
                validator:
                    (value) => value!.isEmpty ? 'Enter expiry date' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: inputDecoration("CVV"),
                style: TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Enter CVV' : null,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle payment logic
                      print("Transfer successful");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF14B8A6),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Transfer",
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
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Color(0xFF1E293B),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
