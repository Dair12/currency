import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isBuySelected = true;
  String? selectedCurrency;

  // Warm style palette
  final Color warmBlue = const Color(0xFF4B607F);
  final Color softBeige = const Color(0xFFE8D8C9);
  final Color brightGreen = const Color(0xFF4CAF50); // slightly softened green
  final Color brightRed = const Color(0xFFF44336);   // slightly softened red

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              warmBlue,
              softBeige,
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Купить" and "Продать" buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _toggleButton("Купить", isBuySelected, () {
                      setState(() => isBuySelected = true);
                    }, brightGreen),
                    _toggleButton("Продать", !isBuySelected, () {
                      setState(() => isBuySelected = false);
                    }, brightRed),
                  ],
                ),
                const SizedBox(height: 20),

                // Currency dropdown
                _buildDropdown(),

                const SizedBox(height: 16),
                _inputField(controller: _quantityController, hint: 'Amount'),
                const SizedBox(height: 16),
                _inputField(controller: _courseController, hint: 'Exchange Rate'),
                const SizedBox(height: 16),
                _inputField(controller: _descriptionController, hint: 'Description'),
                const SizedBox(height: 24),

                // Add Event button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warmBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add Event',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
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

  // Toggle button: Купить / Продать
  Widget _toggleButton(String label, bool isActive, VoidCallback onTap, Color activeColor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Dropdown field
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      decoration: InputDecoration(
        labelText: selectedCurrency == null ? 'Валюта' : null,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['USD', 'EUR', 'KGS'].map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedCurrency = value);
      },
      icon: const Icon(Icons.arrow_drop_down),
      dropdownColor: Colors.white,
    );
  }

  // Input field
  Widget _inputField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
