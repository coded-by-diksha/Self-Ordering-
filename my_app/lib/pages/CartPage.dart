import 'package:flutter/material.dart';
import 'package:my_app/pages/MenuCatPage.dart'; // Adjust the import based on your project structure

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({Key? key, this.cartItems = const []}) : super(key: key);

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: item['image'] != null
                      ? Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.shopping_bag),
                  title: Text(item['name'] ?? 'Product'),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('\$${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      // Implement checkout logic
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement logic to add a new item to the cart
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>  MenuPage(),
          )); 
        },
        child: const Icon(Icons.add_shopping_cart),
        tooltip: 'Add Item',
      ),
    );
  }
}