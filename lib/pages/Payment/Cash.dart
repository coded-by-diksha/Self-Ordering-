import 'package:flutter/material.dart';
import 'package:spicebite/pages/CartPage.dart';
import 'package:spicebite/pages/OrderHistory.dart';
import 'package:spicebite/pages/GlobalState.dart';

class CashPage extends StatefulWidget {
  const CashPage({Key? key}) : super(key: key);

  @override
  State<CashPage> createState() => _CashPageState();
}

class _CashPageState extends State<CashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  bool _paymentDone = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        setState(() {
          _paymentDone = true;
          
        });

        final globalState = GlobalState();

        if (globalState.cartItems.isNotEmpty) {
          // Calculate subtotal using discounted amount
          double subtotal = globalState.discountedTotal;
          double totalAmount = subtotal;

          final order = {
            "orderId": "CASH-${DateTime.now().millisecondsSinceEpoch}",
            "orderDate": DateTime.now(),
            "tableNo": globalState.tableNo ?? 1,
            "items": List<Map<String, dynamic>>.from(globalState.cartItems),
            "subtotal": subtotal,
            "totalAmount": totalAmount,
            "status": "Pending Payment",
            "paymentMethod": "Cash",
          };

          globalState.orders.insert(0, order); // Add to order history
          globalState.updateCartCount(); // Update cart count notifier
          globalState.clearCart();
          globalState.clearPromoCode(); // Clear promo code after payment
          // Add notification after payment
          String orderId = order['orderId'] as String;
          String message = 'Your order for  ${globalState.cartItems.map((item) => item['name']).join(', ')} has been placed! It will take 10-15 mins to be served.\nYour bill with be taken by the attendant.';
          globalState.addNotification(message, orderId);
        }

        // Example: send required details to _buildOrderCard
        // You need to provide a Map<String, dynamic> order and an int index.
        // Here is a demonstration with dummy data:
       // Replace with actual index if needed

        // TODO: Add order to history using the correct method or provider.
        // For now, just print for demonstration:
        print('Payment (Cash) added to history at ${DateTime.now()}');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedMessage() {
    if (_paymentDone) {
      return FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 80, color: const Color.fromARGB(255, 225, 149, 36)),
              const SizedBox(height: 24),
              Text(
                "Payment Pending Wait for Attendant!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:  const Color.fromARGB(255, 225, 149, 36),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                "Thank you for your Patience.\nAn attendant will arrive shortly to receive your payment during your dish is served.",
                style: TextStyle(
                  fontSize: 17,
                  color: const Color.fromARGB(255, 225, 149, 36),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_money, size: 80, color: Colors.orange[700]),
            const SizedBox(height: 24),
            Text(
              "Thank you for choosing Cash Payment!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              "An attendant will arrive to receive your payment before your dish is served.",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              strokeWidth: 3,
            ),
            const SizedBox(height: 18),
            Text(
              "Please wait...",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash Payment"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: _buildAnimatedMessage(),
        ),
      ),
    );
  }
}

