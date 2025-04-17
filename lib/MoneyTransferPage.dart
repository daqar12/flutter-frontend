import 'package:flutter/material.dart';

class MoneyTransferPage extends StatefulWidget {
  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String fromService = 'EVC';
  String toService = 'Zaad';
  double serviceCharge = 0.0;
  double netAmount = 0.0;
  int _currentIndex = 1;

  final List<String> services = ['EVC', 'Zaad', 'Edahab', 'Golis'];

  void calculateCharges() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    serviceCharge = amount * 0.02;
    netAmount = amount - serviceCharge;
  }

  void swapServices() {
    setState(() {
      final temp = fromService;
      fromService = toService;
      toService = temp;
    });
  }

  void onFromChanged(String? value) {
    if (value != null) {
      setState(() {
        fromService = value;
        if (fromService == toService) {
          toService = services.firstWhere((s) => s != fromService);
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to different pages based on the selected index
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      // Already on transfer page
    } else if (index == 2) {
      Navigator.pushNamed(context, '/users');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Transfer Money'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF6366F1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromService,
                    dropdownColor: Color(0xFF1E293B),
                    decoration: InputDecoration(
                      labelText: 'From',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items:
                        services.map((String service) {
                          return DropdownMenuItem<String>(
                            value: service,
                            child: Text(
                              service,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    onChanged: onFromChanged,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, color: Color(0xFF14B8A6)),
                  onPressed: swapServices,
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toService,
                    dropdownColor: Color(0xFF1E293B),
                    decoration: InputDecoration(
                      labelText: 'To',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items:
                        services.where((s) => s != fromService).map((
                          String service,
                        ) {
                          return DropdownMenuItem<String>(
                            value: service,
                            child: Text(
                              service,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        toService = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() => calculateCharges()),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => swapServices(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Swap"),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  rowItem(
                    'Amount',
                    _amountController.text.isEmpty
                        ? '0.0'
                        : _amountController.text,
                  ),
                  rowItem('Service Charge', serviceCharge.toStringAsFixed(2)),
                  rowItem('Net Amount', netAmount.toStringAsFixed(2)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF0F172A),
        unselectedItemColor: Color(0xFF6366F1),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
