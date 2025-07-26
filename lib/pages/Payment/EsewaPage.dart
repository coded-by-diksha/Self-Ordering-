import 'package:flutter/material.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EsewaPage extends StatelessWidget {
  final double amount;
  final int tableNumber;
  final List<Map<String, dynamic>> orderItems;

  EsewaPage({
    super.key, 
    required this.amount,
    required this.tableNumber,
    required this.orderItems,
  });

  Future<bool> _verifyEsewaTransaction({
    required String refId,
    required String productId,
    required String amount,
  }) async {
    try {
      final url = Uri.parse(
        'https://rc.esewa.com.np/mobile/transaction?txnRefId=$refId',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'merchantId': 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
          'merchantSecret': 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final status = data[0]['transactionDetails']['status'];
        return status == 'COMPLETE';
      }
      return false;
    } catch (e) {
      debugPrint('Verification error: $e');
      return false;
    }
  }

  Future<void> _initiateEsewaPayment(BuildContext context) async {
    try {
      debugPrint('Initializing eSewa payment with amount: $amount');
      
      final config = EsewaConfig(
        clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",

        secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
        environment: Environment.test,
      );
      debugPrint('Config created: ${config.toString()}');

      final payment = EsewaPayment(
         productId: "TEST_${DateTime.now().millisecondsSinceEpoch}",
        productName: "Table $tableNumber Order",
        productPrice: amount.toStringAsFixed(2),
        callbackUrl: "https://example.com/success",
      );
      debugPrint('Payment details: ${payment.toString()}');

      debugPrint('Starting payment process...');



      EsewaFlutterSdk.initPayment(
        esewaConfig: config,
        esewaPayment: payment,

        onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
          debugPrint('Payment success: ${data.toJson()}');
          bool isVerified = await _verifyEsewaTransaction(
            refId: data.refId, 
            productId: payment.productId,
            amount: payment.productPrice,
          );

          if (isVerified) {
            // Step 2: Only proceed if verification succeeds
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Payment Verified! Ref: ${data.refId}")),
            );
            
            // Step 3: Save the order to GlobalState
                _saveOrderToHistory(context, data.refId);

            
            Navigator.pop(context, true);
          } else {
            // Handle failed verification (e.g., suspicious transaction)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment failed verification!")),
            );
          }
        },
        
       onPaymentFailure: (data) {
        debugPrint('Payment failed: ${data?.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${data?.message ?? 'Unknown error'}")),
        );
      },
      onPaymentCancellation: () {
        debugPrint('User cancelled payment');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment cancelled.")),
        );
      },
      );
    } catch (e, stack) {
      debugPrint('Payment error: $e\n$stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
    debugPrint("eSewa payment initialized (check if SDK opens)");
  }
  // Future<void> _initiateEsewaPayment(BuildContext context) async {
  //   try {
  //     // 1. Configuration for eSewa SDK v2.4.2
  //    final config = EsewaConfig(
  //     clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
  //     secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
  //     environment: Environment.test, 
  //   );
  //     // 2. Payment details
  //     final payment = EsewaPayment(
  //       productId: "T${tableNumber}_${DateTime.now().millisecondsSinceEpoch}",
  //       productName: "Table $tableNumber Order",
  //       productPrice: amount.toStringAsFixed(2),
  //       callbackUrl: "myapp://payment-success", // Your custom scheme
  //     );

  //     // 3. Initialize payment
  //     EsewaFlutterSdk.initPayment(
  //       esewaConfig: config,
  //       esewaPayment: payment,
  //       onPaymentSuccess: (EsewaPaymentSuccessResult result) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Payment Successful! Ref: ${result.refId}")),
  //         );
  //         Navigator.pop(context, true);
  //       },
  //       onPaymentFailure: (result) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Payment Failed!")),
  //         );
  //       },
  //       onPaymentCancellation: () {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Payment Cancelled")),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: ${e.toString()}")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSewa Payment'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/esewa.png', height: 100),
            const SizedBox(height: 20),
            Text('Table: $tableNumber', style: const TextStyle(fontSize: 18)),
            Text('Amount: Rs.${amount.toStringAsFixed(2)}', 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              key: Key('esewa_pay_button'),
              onPressed: () => _initiateEsewaPayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Pay with eSewa', 
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            
          ],
        ),
      ),
    );
  }
  
  void _saveOrderToHistory(BuildContext context, refId) {
   final globalState = GlobalState();
  if (globalState.cartItems.isNotEmpty) {
    double subtotal = globalState.discountedTotal;
    double totalAmount = subtotal;

    final order = {
      "orderId": "ESEWA-$refId", // Use eSewa's reference ID
      "orderDate": DateTime.now(),
      "tableNo": globalState.tableNo ?? 1,
      "items": List<Map<String, dynamic>>.from(globalState.cartItems),
      "subtotal": subtotal,
      "totalAmount": totalAmount,
      "status": "Paid (Verified)",
      "paymentMethod": "eSewa",
    };

    globalState.orders.insert(0, order);
    globalState.clearCart();
    globalState.clearPromoCode();
    // Add notification after payment
     String orderId = order['orderId'] as String;
          String message = 'Your order for  ${globalState.cartItems.map((item) => item['name']).join(', ')} has been placed! It will take 10-15 mins to be served.';
          globalState.addNotification(message, orderId);
  }
  }
}