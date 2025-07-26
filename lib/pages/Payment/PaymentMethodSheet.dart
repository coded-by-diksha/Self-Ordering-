import 'package:flutter/material.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'EsewaPage.dart';
import 'KhaltiPage.dart';
import 'Cash.dart';

class PaymentMethodSheet extends StatelessWidget {
  final double amount;
  final int tableNumber;
  final List<Map<String, dynamic>> orderItems;

  const PaymentMethodSheet({
    super.key,
    required this.amount,
    required this.tableNumber,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    final globalState = GlobalState();
    final discountedAmount = globalState.discountedTotal;
    final originalAmount = globalState.cartTotal;
    
    final paymentMethods = [
      {
        'name': 'eSewa',
        'icon': 'assets/esewa.jpg',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EsewaPage(
                amount: discountedAmount,
                tableNumber: tableNumber,
                orderItems: orderItems,
              ),
            ),
          );
        },
      },
      
      {
        'name': 'Cash',
        'icon': 'assets/cash.png',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CashPage(
              
              ),
            ),
          );
        },
      },
      {
        'name': 'Fonepay',
        'icon': 'assets/fonepay.png',
        'onTap': () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Coming Soon😘'),
                content: Row(
                  children: [
                    
                  Image.asset(
                    'assets/fonepay.png',
                    width: 100,
                    height: 100,),
                    const SizedBox(width: 12),
                Text('FonePay is currently under development\nand will be available soon✌️.'),

              
                  ]
                ),
                
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );

          // // ScaffoldMessenger.of(context).showSnackBar(
          // //   SnackBar(
          // //     content: const Text(
          // //       'FonePay is currently under development',
          // //       style: TextStyle(color: Colors.white),
          // //     ),
          // //     duration: const Duration(seconds: 10),
          // //     backgroundColor: const Color.fromARGB(255, 216, 32, 11),
          // //     behavior: SnackBarBehavior.floating,
          // //     margin: EdgeInsets.only(
          // //       bottom: MediaQuery.of(context).size.height - 120,
          // //       left: 20,
          // //       right: 20,
          // //     ),
          // //     shape: RoundedRectangleBorder(
          // //       borderRadius: BorderRadius.circular(10),
          // //     ),
          // //     padding: const EdgeInsets.symmetric(
          // //       horizontal: 20,
          // //       vertical: 15,
          // //     ),
          // //   ),
          // );
        },
      },
      {
        'name': 'Khalti',
        'icon': 'assets/khalti.png',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KhaltiPage(
                amount: discountedAmount,
                tableNumber: tableNumber,
                orderItems: orderItems,
            
              ),
            ),
          );
        },
      },
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select your payment method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (globalState.isPromoCodeApplied) ...[
                Text(
                  'Table $tableNumber • Rs. ${originalAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[600], decoration: TextDecoration.lineThrough),
                ),
                Text(
                  'Table $tableNumber • Rs. ${discountedAmount.toStringAsFixed(2)} (${globalState.promoCode} applied)',
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                ),
              ] else ...[
                Text(
                  'Table $tableNumber • Rs. ${discountedAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    var method = paymentMethods[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Image.asset(
                          method['icon'] as String,
                          width: 35,
                        ),
                        title: Text(method['name'] as String),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          (method['onTap'] as Function?)?.call();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}