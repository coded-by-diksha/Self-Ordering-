import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class FonePayIntegrationScreen extends StatefulWidget {
  final double amount;
  final String orderId;
  final String merchantName;
  final Function(bool) onPaymentComplete;

  const FonePayIntegrationScreen({
    Key? key,
    required this.amount,
    required this.orderId,
    required this.merchantName,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  _FonePayIntegrationScreenState createState() => _FonePayIntegrationScreenState();
}

class _FonePayIntegrationScreenState extends State<FonePayIntegrationScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // FonePay configuration - REPLACE WITH YOUR ACTUAL CREDENTIALS
  final String _merchantCode = "YOUR_MERCHANT_CODE";
  final String _merchantSecret = "YOUR_SECRET_KEY";
  final String _returnUrl = "https://yourdomain.com/payment-callback";
  final String _fonepayApiUrl = "https://clientapi.fonepay.com/api/merchantRequest";

  Future<void> _initiateFonePayPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Generate unique reference ID
      final referenceId = "ORDER_${widget.orderId}_${DateTime.now().millisecondsSinceEpoch}";

      // Prepare payment parameters
      final paymentParams = {
        'PID': _merchantCode,
        'MD': 'P',  // Payment mode
        'AMT': widget.amount.toStringAsFixed(2),
        'CRN': widget.orderId,
        'DT': DateTime.now().toIso8601String(),
        'R1': widget.merchantName,
        'R2': 'Payment',
        'RU': _returnUrl,
        'PRN': referenceId,
      };

      // Generate secure hash
      final hashData = "${paymentParams['PID']},${paymentParams['MD']},"
          "${paymentParams['AMT']},${paymentParams['CRN']},${paymentParams['DT']},"
          "${paymentParams['R1']},${paymentParams['R2']},${paymentParams['RU']},"
          "${paymentParams['PRN']},$_merchantSecret";
      
      // final hash = sha256.convert(utf8.encode(hashData)).toString();
      // paymentParams['DV'] = hash;

      // Make API request to FonePay
      final response = await http.post(
        Uri.parse(_fonepayApiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: paymentParams,
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        // Launch payment URL
        final paymentUrl = responseData['redirectUrl'];
        if (await canLaunchUrl(Uri.parse(paymentUrl))) {
          await launchUrl(
            Uri.parse(paymentUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw "Could not launch payment page";
        }
      } else {
        throw responseData['message'] ?? "Payment initiation failed";
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
      });
      widget.onPaymentComplete(false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FonePay Payment'),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/fonepay_logo.png', // Ensure you have this asset
              height: 100,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.payment, size: 100, color: Colors.red),
            ),
            const SizedBox(height: 30),
            Text(
              'Amount to Pay: Rs. ${widget.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order #${widget.orderId}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'You will be redirected to FonePay secure payment page',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _initiateFonePayPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Pay with FonePay',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}