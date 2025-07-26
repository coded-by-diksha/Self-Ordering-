import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:spicebite/pages/GlobalState.dart';

class KhaltiPage extends StatelessWidget {
  final double amount;
  final int tableNumber;
  final List<Map<String, dynamic>> orderItems;
  
  const KhaltiPage({
    super.key, 
    required this.amount,
    required this.tableNumber,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    
    return KhaltiPaymentPage(
      title: 'Khalti Payment', 
      amount: amount, 
      tableNumber: tableNumber,
      orderItems: orderItems,
    );
  }
}


// KhaltiPaymentPage.dart
class KhaltiPaymentPage extends StatefulWidget {
  final String title;
  final double amount;
  final int tableNumber;
  final List<Map<String, dynamic>> orderItems;
  
  const KhaltiPaymentPage({
    required this.title, 
    required this.amount,
    required this.tableNumber,
    required this.orderItems,
    Key? key
  }) : super(key: key);

  @override
  State<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}


class _KhaltiPaymentPageState extends State<KhaltiPaymentPage> {

  // Initialize Khalti when the page loads
    
  bool _isLoading = false;
  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> _makePayment() async {
    setState(() => _isLoading = true);

    try {
      await KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: (widget.amount * 100).toInt(), // Amount in paisa
          productIdentity: widget.tableNumber.toString(),
          productName: 'Order Payment',
          productUrl: 'https://yourdomain.com/orders/${widget.tableNumber}',
        ),
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
        ],
        onSuccess: (success) {
          debugPrint('Payment Successful: ${success.toString()}');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment Successful!')),
          );
          // Add notification after payment
          final globalState = GlobalState();
          // Generate a unique orderId
          final orderId = 'ORDER${DateTime.now().millisecondsSinceEpoch}';
          // Add the order to globalState.orders
          globalState.orders.add({
            'orderId': orderId,
            'tableNo': widget.tableNumber,
            'orderDate': DateTime.now(),
            'items': widget.orderItems,
            'totalAmount': widget.amount,
            'status': 'Placed',
            'paymentMethod': 'Khalti',
            'subtotal': widget.amount,
          });
          // Create the notification message
          String message = 'Your order for ${widget.orderItems.map((item) => item['name']).join(', ')} has been placed! It will take 10-15 mins to be served.\nYour bill will be taken by the attendant.';
          globalState.addNotification(message, orderId);
        },
        onFailure: (failure) {
          debugPrint('Payment Error in Khalti: $failure');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Failed: ${failure.toString()}')),
          );
        },
      );
    } catch (e) {
      debugPrint('Payment Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/khalti.png', width: 100, height: 100),
            const SizedBox(height: 20),
            Text('Table: ${widget.tableNumber}', 
                style: const TextStyle(fontSize: 18)),
            Text('Amount: Rs.${widget.amount.toStringAsFixed(2)}', 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C2D91),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              key: const Key('khalti_pay_button'),
              onPressed: _isProcessing ? null : _makePayment,
             
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 182, 27, 27),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Pay with Khalti',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}