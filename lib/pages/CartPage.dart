import 'package:flutter/material.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:spicebite/pages/Payment/PaymentMethodSheet.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalState globalState = GlobalState();
  int? tableNo;

  @override
  void initState() {
    super.initState();
    // Initialize tableNo from GlobalState if it exists
    tableNo = globalState.tableNo;
  }

  double get subtotal => globalState.cartTotal;
  int get totalQuantity => globalState.cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  double get totalAmount => subtotal ;

  void _removeItem(int index) {
    setState(() {
      globalState.cartItems.removeAt(index);
      globalState.updateCartCount();
    });
  }

  Future<int?> _getTableNumber() async {
    if (tableNo != null) return tableNo;

    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController tableController = TextEditingController();

        return AlertDialog(
          title: Text('Table Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter your table number:'),
              SizedBox(height: 16),
              TextField(
                controller: tableController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Table Number',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 5',
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredTable = int.tryParse(tableController.text);
                if (enteredTable != null && enteredTable > 0) {
                  setState(() {
                    tableNo = enteredTable;
                  });
                  // Save to GlobalState
                  globalState.tableNo = enteredTable;
                  Navigator.of(context).pop(enteredTable);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid table number'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Order Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Text('Table No:', style: TextStyle(fontSize: 16, color: Colors.black54)),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () async {
                    final newTableNo = await _getTableNumber();
                    if (newTableNo != null) {
                      setState(() {
                        tableNo = newTableNo;
                      });
                      // Save to GlobalState
                      globalState.tableNo = newTableNo;
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tableNo?.toString() ?? 'Not Set',
                            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.edit, size: 16, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: globalState.cartItems.length,
              separatorBuilder: (context, index) => Divider(height: 32),
              itemBuilder: (context, index) {
                final item = globalState.cartItems[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item['image'] != null && item['image'].toString().isNotEmpty
                          ? (item['image'].toString().startsWith('http')
                              ? Image.network(item['image'], width: 100, height: 100, fit: BoxFit.cover)
                              : kIsWeb
                                  ? Image.network(item['image'], width: 100, height: 100, fit: BoxFit.cover)
                                  : Image.file(File(item['image']), width: 100, height: 100, fit: BoxFit.cover))
                          : Container(width: 100, height: 100, color: Colors.grey[200], child: Icon(Icons.fastfood)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          if (item['description'] != null && item['description'].toString().isNotEmpty)
                            Text(item['description'],
                                maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13)),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 4),
                              Row(
                                children: List.generate(5, (i) {
                                  double rating = item['rating'] ?? 4.5;
                                  if (i < rating.floor()) {
                                    return Icon(Icons.star, color: Colors.orange, size: 16);
                                  } else if (i == rating.floor() && rating % 1 > 0) {
                                    return Icon(Icons.star_half, color: Colors.orange, size: 16);
                                  } else {
                                    return Icon(Icons.star_border, color: Colors.orange, size: 16);
                                  }
                                }),
                              ),
                              SizedBox(width: 4),
                             
                              Text('Qty: ${item['quantity']}', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text('Rs. ${item['price']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              SizedBox(width: 16),
                              Text('Total: Rs.${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(index),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('— Order Summary —', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 10),
                    _summaryRow('Total Quantity', '$totalQuantity'),
                    _summaryRow('Sub Total', 'Rs.${subtotal.toStringAsFixed(0)}'),
                    Divider(),
                    _summaryRow('Total Amount', 'Rs.${totalAmount.toStringAsFixed(0)}', isBold: true),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                 if (globalState.cartItems.isNotEmpty) {
    final finalTableNo = await _getTableNumber();
    if (finalTableNo != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PaymentMethodSheet(
          amount: totalAmount,
          tableNumber: finalTableNo,
          orderItems: globalState.cartItems,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cart is empty!'),
        backgroundColor: Colors.red,
      ),
    );
  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: Text('Pay Now', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}