import 'package:flutter/material.dart';

class PaymentFormPage extends StatelessWidget {
  final String title;

const PaymentFormPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController cvvController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: Colors.orangeAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Bibek dai', style: TextStyle(fontSize: 20, color: Colors.white)),
                    SizedBox(height: 10),
                    Text('1245 78412 541236', style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(height: 10),
                    Text('Balance: Rs.25000', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: expiryDateController,
                    decoration: const InputDecoration(labelText: 'Expiry Date'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Save your card info'),
                const Spacer(),
                Switch(value: true, onChanged: (value) {}),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Pay 2535.50', style: TextStyle(color: Colors.white70)),
            )
          ],
        ),
      ),
    );
  }
}
