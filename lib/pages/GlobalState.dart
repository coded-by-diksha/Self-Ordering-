import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io';



class GlobalState {
  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() => _instance;
  GlobalState._internal();

  // Global cart items 
  // Global cart items 
  List<Map<String, dynamic>> cartItems = [];
  // Add a ValueNotifier for cart count
  final ValueNotifier<int> cartCount = ValueNotifier<int>(0);
      final ValueNotifier<String?> selectedOrderId = ValueNotifier<String?>(null);


  // Promo code information
  bool isPromoCodeApplied = false;
  double promoDiscount = 0.0;
  String promoCode = "";

  // Authentication status
  bool isLoggedIn = false;

// Navigation
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
   Map<String, dynamic> userProfile = {
    "name": "SpiceBite",
    "email": "spicebite12@mail.com",
    "name": "SpiceBite",
    "email": "spicebite12@mail.com",
    "phone": "9800000000",
    "location": "Ohio, USA",
    "imagePath": "assets/Profile.jpg"
  };
  // Global menu items
  List<Map<String, dynamic>> menuItems = [
  {"name": "Onion Pakoda", "description": "Crispy fried onion fritters", "category": "Veg Starter", "price": 250, "discount": 0, "isBestseller": true, "imageUrl": "https://i0.wp.com/binjalsvegkitchen.com/wp-content/uploads/2014/12/Kanda-Bhaji-L2.jpg?resize=600%2C900&ssl=1", "categoryImageUrl": "https://i0.wp.com/binjalsvegkitchen.com/wp-content/uploads/2014/12/Kanda-Bhaji-L2.jpg?resize=600%2C900&ssl=1", "quantity": 1, "rating": 4.2},
  {"name": "Mushroom Pakoda", "description": "Fried mushroom fritters", "category": "Veg Starter", "price": 320, "discount": 0, "isBestseller": false, "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYgpX-zzdlFZDHyXvf1AYLI6QqrWM0IBbRKw&s", "categoryImageUrl": "https://i0.wp.com/binjalsvegkitchen.com/wp-content/uploads/2014/12/Kanda-Bhaji-L2.jpg?resize=600%2C900&ssl=1", "quantity": 1, "rating": 3.8},
  {"name": "Chicken Lollipop", "description": "Spicy chicken lollipop", "category": "Non-Veg Starter", "price": 400, "discount": 0, "isBestseller": true, "imageUrl": "https://thebigmansworld.com/wp-content/uploads/2023/09/chicken-lollipop-recipe.jpg", "categoryImageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.7},
  {"name": "Dragon Chicken", "description": "Spicy dragon-style chicken", "category": "Non-Veg Starter", "price": 450, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.5},
  {"name": "Sekuwa (Mutton)", "description": "Grilled meat skewers", "category": "Sekuwa & BBQ", "price": 300, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.1},
  
  {"name": "Jhaneko Sekuwa (Chicken)", "description": "Spiced grilled meat", "category": "Sekuwa & BBQ", "price": 351, "discount": 0, "isBestseller": true, "imageUrl": "https://hungrytom.com.np/wp-content/uploads/2022/07/ChickenPoleko-300x300.jpg?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.3},
  {"name": "Mutton Jhaneko Sekuwa", "description": "Spiced mutton skewers", "category": "Non-Veg Snacks", "price": 450, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.9},
  {"name": "Mutton Boil", "description": "Boiled mutton", "category": "Non-Veg Snacks", "price": 400, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.7},
  {"name": "Hot and Sour (Chicken)", "description": "Hot and sour soup", "category": "Soup", "price": 150, "discount": 0, "isBestseller": false, "imageUrl": "https://www.vegrecipesofindia.com/wp-content/uploads/2021/07/hot-and-sour-soup-1.jpg", "categoryImageUrl": "https://www.vegrecipesofindia.com/wp-content/uploads/2021/07/hot-and-sour-soup-1.jpg", "quantity": 1, "rating": 4.0},
  {"name": "Sweet Corn (Veg/Non-Veg)", "description": "Sweet corn soup", "category": "Soup", "price": 150, "discount": 0, "isBestseller": false, "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOA27oXpwFHbLA8Kqq3DBnRL-lkbjlKhnEmg&s", "categoryImageUrl": "https://www.vegrecipesofindia.com/wp-content/uploads/2021/07/hot-and-sour-soup-1.jpg", "quantity": 1, "rating": 3.5},
  {"name": "Fry Papad", "description": "Fried papad", "category": "Papad Items", "price": 120, "discount": 0, "isBestseller": false, "imageUrl": "", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.2},
  {"name": "Nepali Salad / Green Salad", "description": "Fresh Nepali salad", "category": "Salad", "price": 180, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.4},
  {"name": "Fruit Salad", "description": "Mixed fruit salad", "category": "Salad", "price": 350, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.6},
  {"name": "Tandoori Chicken (Full/Half)", "description": "Tandoori chicken", "category": "Tandoori", "price": 1200, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.8},
  {"name": "Chicken Tikka", "description": "Tandoori chicken tikka", "category": "Tandoori", "price": 400, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.9},
  {"name": "Golden Fry Prawns", "description": "Fried golden prawns", "category": "Fish/Sea Food", "price": 550, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.4},
  {"name": "Grilled Prawns", "description": "Grilled prawns", "category": "Fish/Sea Food", "price": 580, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.2},
  {"name": "Mix Veg Pizza", "description": "Vegetable pizza", "category": "Pizza", "price": 450, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.1},
  {"name": "Mushroom Pizza", "description": "Mushroom pizza", "category": "Pizza", "price": 450, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.8},
  {"name": "Veg Burger", "description": "Vegetable burger", "category": "Burger", "price": 250, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.9},
  {"name": "Chicken Burger", "description": "Chicken burger", "category": "Burger", "price": 350, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.3},
  {"name": "Veg Momo (Steam/Fried/Jhol/Chilly)", "description": "Vegetable momos", "category": "Momo", "price": 150, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.7},
  {"name": "Chicken Momo", "description": "Chicken momos", "category": "Momo", "price": 200, "discount": 0, "isBestseller": true, "imageUrl": "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.5},
  {"name": "Jeera Rice", "description": "Cumin-flavored rice", "category": "Rice & Noodles", "price": 180, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.6},
  {"name": "Steam Rice", "description": "Steamed rice", "category": "Rice & Noodles", "price": 100, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1558030006-450675393462?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.4},
  {"name": "Chinese Chop Suey (Veg/Non-Veg)", "description": "Chinese chop suey", "category": "Chop Suey", "price": 350, "discount": 0, "isBestseller": false, "imageUrl": "https://www.funfoodfrolic.com/wp-content/uploads/2021/03/Chopsuey-3.jpg?w=500&h=500&fit=crop", "categoryImageUrl": "https://www.funfoodfrolic.com/wp-content/uploads/2021/03/Chopsuey-3.jpg?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "American Chop Suey (Veg/Non-Veg)", "description": "American chop suey", "category": "Chop Suey", "price": 350, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&h=500&fit=crop", "categoryImageUrl": "https://www.funfoodfrolic.com/wp-content/uploads/2021/03/Chopsuey-3.jpg?w=500&h=500&fit=crop", "quantity": 1, "rating": 3.7},
  {"name": "Veg Thukpa", "description": "Vegetable thukpa", "category": "Thukpa", "price": 150, "discount": 0, "isBestseller": false, "imageUrl": "https://news24online.com/wp-content/uploads/2024/05/thukpa.jpg?w=500&h=500&fit=crop", "categoryImageUrl": "https://news24online.com/wp-content/uploads/2024/05/thukpa.jpg?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.2},
  {"name": "Chicken Thukpa", "description": "Chicken thukpa", "category": "Thukpa", "price": 220, "discount": 0, "isBestseller": false, "imageUrl": "https://i0.wp.com/savorytales.com/wp-content/uploads/2022/03/IMG_5896-1-scaled.jpg?fit=1920%2C2560&ssl=1?w=500&h=500&fit=crop", "categoryImageUrl": "https://news24online.com/wp-content/uploads/2024/05/thukpa.jpg?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "Veg Sizzler", "description": "Vegetable sizzler", "category": "Sizzler", "price": 450, "discount": 0, "isBestseller": false, "imageUrl": "https://images.squarespace-cdn.com/content/v1/5ec30182cff13b4331c5384d/1674664714274-JT5G0H6IHSAGPRCUQ1IL/IMG_8864.jpeg?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.squarespace-cdn.com/content/v1/5ec30182cff13b4331c5384d/1674664714274-JT5G0H6IHSAGPRCUQ1IL/IMG_8864.jpeg?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "Non-Veg Sizzler", "description": "Non-veg sizzler", "category": "Sizzler", "price": 600, "discount": 0, "isBestseller": false, "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDbUr18--pF7C0cDfFMExh-ny-PfdsH8v5HA&s?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.squarespace-cdn.com/content/v1/5ec30182cff13b4331c5384d/1674664714274-JT5G0H6IHSAGPRCUQ1IL/IMG_8864.jpeg?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "Veg Biryani", "description": "Vegetable biryani", "category": "Biryani", "price": 340, "discount": 0, "isBestseller": false, "imageUrl": "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500&h=500&fit=crop", "categoryImageUrl": "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "Chicken Biryani", "description": "Chicken biryani", "category": "Biryani", "price": 500, "discount": 0, "isBestseller": true, "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwaF6-1Auf1DuOXo9FhalxTrx1j-BnkoOu4A&s", "categoryImageUrl": "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "Kadai Paneer", "description": "Paneer in kadai masala", "category": "Veg Curry", "price": 450, "discount": 0, "isBestseller": false, "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-j1XdLKn31g1i4xhsLYgRw0eiuPzxMgyHpw&s?w=500&h=500&fit=crop", "categoryImageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-j1XdLKn31g1i4xhsLYgRw0eiuPzxMgyHpw&s?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0},
  {"name": "Mushroom Masala", "description": "Spiced mushroom curry", "category": "Veg Curry", "price": 450, "discount": 0, "isBestseller": false, "imageUrl": "https://www.yellowthyme.com/wp-content/uploads/2019/01/Insant-Pot-Mushroom-Masala-3-of-5.jpg?w=500&h=500&fit=crop", "categoryImageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-j1XdLKn31g1i4xhsLYgRw0eiuPzxMgyHpw&s?w=500&h=500&fit=crop", "quantity": 1, "rating": 4.0}
];
  
  // Order history
  List<Map<String, dynamic>> orders = [
   
  ];

  int? tableNo;

  // Notification state
  final ValueNotifier<int> notificationCount = ValueNotifier<int>(0);
  List<Map<String, dynamic>> notifications = [];

  void updateCartCount() {
    cartCount.value = cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  void addToCart(Map<String, dynamic> item) {
    int existingIndex = cartItems.indexWhere((cartItem) => cartItem["name"] == item["name"]);
    if (existingIndex != -1) {
      cartItems[existingIndex]["quantity"] += item["quantity"];
    } else {
      cartItems.add({
        "name": item["name"],
        "description": item["description"],
        "price": double.parse(_getDiscountedPrice(item)),
        "size": item["size"],
        "spiceLevel": item["spiceLevel"],
        "quantity": item["quantity"],
        "image": item["imageUrl"],
        "categoryImage": item["categoryImageUrl"],
        "rating": item["rating"] ?? 4.5,
        "review": item["review"],
      });
    }
    updateCartCount();
  }

  void addMenuItem(Map<String, dynamic> item) {
    menuItems.add(item);
  }

  void removeMenuItem(Map<String, dynamic> item) {
    menuItems.remove(item);
    updateCartCount();
  }

  void clearCart() {
    cartItems.clear();
    updateCartCount();
  }

  void placeOrder(int tableNo, ) {
    if (cartItems.isNotEmpty) {
      final order = {
        "orderId": "ORD${DateTime.now().millisecondsSinceEpoch}",
        "orderDate": DateTime.now(),
        "tableNo": tableNo,
        "items": List<Map<String, dynamic>>.from(cartItems),
        "subtotal": cartTotal,
        "totalAmount": cartTotal,
        "status": "Pending Payment",
        "paymentMethod": "Cash",
      };
      orders.insert(0, order);
      clearCart();
    }
    updateCartCount();
  }

  // Get discounted price
  String _getDiscountedPrice(Map<String, dynamic> item) {
    if (item["discount"] > 0) {
      double discountAmount = item["price"] * (item["discount"] / 100);
      return (item["price"] - discountAmount).toStringAsFixed(2);
    } else {
      return item["price"].toString();
    }
  }

  // Get cart total
  double get cartTotal {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int));
  }

  // Apply promo code
  void applyPromoCode(String code, double discount) {
    isPromoCodeApplied = true;
    promoDiscount = discount;
    promoCode = code;
  }

  // Clear promo code
  void clearPromoCode() {
    isPromoCodeApplied = false;
    promoDiscount = 0.0;
    promoCode = "";
  }
   void setSelectedOrderId(String? orderId) {
    selectedOrderId.value = orderId;
  }

  // Get discounted total
  double get discountedTotal {
    if (isPromoCodeApplied) {
      return cartTotal * (1 - promoDiscount);
    }
    return cartTotal;
  }

  // Get category image for a specific category
  String getCategoryImage(String category) {
    final item = menuItems.firstWhere(
      (item) => item["category"] == category,
      orElse: () => {"categoryImageUrl": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500&h=500&fit=crop"}
    );
    return item["categoryImageUrl"];
  }

  // Get unique categories with their images
  List<Map<String, dynamic>> getCategoriesWithImages() {
    final categories = <String, String>{};
    for (var item in menuItems) {
      if (!categories.containsKey(item["category"])) {
        categories[item["category"]] = item["categoryImageUrl"];
      }
    }
    
    return categories.entries.map((entry) => {
      "name": entry.key,
      "imageUrl": entry.value,
    }).toList();
  }

  ImageProvider getProfileImage() {
    print(userProfile);
    final path = userProfile['imagePath'];
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else if (kIsWeb) {
      // On web, FileImage is not supported. Use a placeholder or network image if available.
      return AssetImage('assets/Profile.jpg');
    } else {
      return FileImage(File(path));
    }
  }



  void updateProfileImage(String path) {
    print( "the image is being updated");
    userProfile['imagePath'] = path;
  }

  void addNotification(String message, String orderId) {
    notifications.insert(0, {
      'message': message,
      'timestamp': DateTime.now(),
      'read': false,
      'orderId': orderId
    });
    notificationCount.value = notifications.where((n) => !n['read']).length;
  }

  void markAllNotificationsRead() {
    for (var n in notifications) {
      n['read'] = true;
    }
    notificationCount.value = 0;
  }


  void clearNotifications() {
    notifications.clear();
    notificationCount.value = 0;
  }

} 