import 'package:flutter/material.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:spicebite/pages/NotificationPage.dart';
import 'package:intl/intl.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _addTestOrderAndNotification() {
    final globalState = GlobalState();

    // Generate unique orderId based on time for testing
    final orderId = 'ORDER${DateTime.now().millisecondsSinceEpoch}';

    // Add dummy order
    globalState.orders.add({
      'orderId': orderId,
      'tableNo': 5,
      'orderDate': DateTime.now(),
      'items': [
        {
          'name': 'Veg Burger',
          'quantity': 2,
          'price': 150,
        },
        {
          'name': 'Cold Coffee',
          'quantity': 1,
          'price': 120,
        },
      ],
      'totalAmount': 420,
      'status': 'Completed',
      'paymentMethod': 'Cash',
      'subtotal': 420
    });

    // Add related notification
    globalState.notifications.add({
      'message': 'Your order $orderId is completed!',
      'orderId': orderId, // Important: link this notification to the order
      'timestamp': DateTime.now(),
      'read': false,
    });

    globalState.notificationCount.value++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added order & notification for $orderId')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: GlobalState().notificationCount,
              builder: (context, notificationCount, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      iconSize: 40,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(),
                          ),
                        );
                      },
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _addTestOrderAndNotification,
              icon: const Icon(Icons.add),
              label: const Text('Add Test Order & Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
