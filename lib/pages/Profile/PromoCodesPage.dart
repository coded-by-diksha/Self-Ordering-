import 'package:flutter/material.dart';
import 'package:spicebite/pages/GlobalState.dart';

class PromocodesPage extends StatefulWidget {
  const PromocodesPage({Key? key}) : super(key: key);

  @override
  State<PromocodesPage> createState() => _PromocodesPageState();
}

class _PromocodesPageState extends State<PromocodesPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _promoController = TextEditingController();
  bool _isVerifying = false;
  String? _message;
  bool _isSuccess = false;
  double _discount = 0.0;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  // Simulated promo code verification
  Future<Map<String, dynamic>> verifyPromoCode(String code) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate some codes
    if (code.trim().toUpperCase() == "WELCOME10") {
      return {
        "success": true,
        "discount": 0.10,
        "message": "Promo code applied! 10% discount added."
      };
    } else if (code.trim().toUpperCase() == "FREEMEAL") {
      return {
        "success": true,
        "discount": 0.25,
        "message": "Promo code applied! 25% discount added."
      };
    } else {
      return {
        "success": false,
        "discount": 0.0,
        "message": "Invalid promo code. Please try again."
      };
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _applyPromo() async {
    FocusScope.of(context).unfocus();
    
    // Check if promo code is already applied
    final globalState = GlobalState();
    if (globalState.isPromoCodeApplied && 
        globalState.promoCode == _promoController.text.trim().toUpperCase()) {
      setState(() {
        _message = "This promo code is already applied!";
        _isSuccess = false;
      });
      _animationController?.forward(from: 0);
      return;
    }
    
    setState(() {
      _isVerifying = true;
      _message = null;
      _isSuccess = false;
      _discount = 0.0;
    });
    _animationController?.reset();

    final result = await verifyPromoCode(_promoController.text);

    setState(() {
      _isVerifying = false;
      _isSuccess = result["success"];
      _discount = result["discount"];
      _message = result["message"];
    });

    // Store promo code in GlobalState if successful
    if (_isSuccess && _discount > 0) {
      globalState.applyPromoCode(_promoController.text.trim().toUpperCase(), _discount);
    }

    _animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 248, 145, 10);

    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: Text(
          "My Promocodes",
          style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: themeColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        color: Color.fromARGB(255, 248, 145, 10),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Enter your promo code",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 40, 40, 40),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Unlock exclusive discounts and offers by applying your promo code below.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _promoController,
                        enabled: !_isVerifying,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: "PROMOCODE",
                          filled: true,
                          fillColor: const Color(0xFFF7F8FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.local_offer_outlined),
                        ),
                        style: const TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                        onSubmitted: (_) => _applyPromo(),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isVerifying
                              ? null
                              : () {
                                  if (_promoController.text.trim().isEmpty) {
                                    setState(() {
                                      _message = "Please enter a promo code.";
                                      _isSuccess = false;
                                    });
                                    _animationController?.forward(from: 0);
                                    return;
                                  }
                                  _applyPromo();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isVerifying
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "APPLY",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _fadeAnimation!,
                        child: _message == null
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isSuccess
                                        ? Icons.check_circle_rounded
                                        : Icons.error_outline_rounded,
                                    color: _isSuccess
                                        ? Colors.green
                                        : Colors.redAccent,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _message!,
                                      style: TextStyle(
                                        color: _isSuccess
                                            ? Colors.green
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (_isSuccess && _discount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.percent, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  "Discount: ${(_discount * 100).toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Example of user's applied codes (could be fetched from backend)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Active Promocodes",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _isSuccess && _discount > 0
                    ? Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.card_giftcard,
                              color: Color.fromARGB(255, 248, 145, 10)),
                          title: Text(
                            _promoController.text.trim().toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Discount: ${(_discount * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(
                                color: Colors.green, fontWeight: FontWeight.w600),
                          ),
                          trailing: const Icon(Icons.verified, color: Colors.green),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: const Text(
                          "No active promocodes yet.",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
