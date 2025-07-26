import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spicebite/pages/CartPage.dart';
import 'package:spicebite/pages/MenuCatPage.dart';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:spicebite/pages/navigationBar.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spicebite/pages/NotificationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigation(selectedIndex: 0),
    );
  }
}


class Dashboard extends StatefulWidget {
   Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, String>> slideshowCards = const [
    {
      "image": "assets/C1.jpg",
      "title": "MeatLover Pizza",
      "offer": "20% Off"
    },
    {
      "image": "assets/C2.jpg",
      "title": "Special Momo",
      "offer": "15% Off"
    },
    {
      "image": "assets/C3.jpg",
      "title": "Burger with Fries",
      "offer": "25% Off"
    },
  ];

  // Get dynamic menu categories from GlobalState
  List<Map<String, dynamic>> get menuCategories {
    final GlobalState globalState = GlobalState();
    return globalState.getCategoriesWithImages();
  }

  
  @override
  void initState() {
    super.initState();
    // Force a rebuild after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  // Get bestseller items from GlobalState
  List<Map<String, dynamic>> get bestsellerItems {
    final GlobalState globalState = GlobalState();
    final allItems = globalState.menuItems;
    print("Total menu items: ${allItems.length}");
    
    final bestsellers = allItems.where((item) =>
      item['isBestseller'] == true || item['isBestseller'] == 'true'
    ).toList();
    
    print("Bestseller items found: ${bestsellers.length}");
    if (bestsellers.isNotEmpty) {
      print("First bestseller: ${bestsellers.first["name"]}");
    }
    
    return bestsellers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Search + Icons Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(left: 23, right: 23),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search),
                          SizedBox(width: 7),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(width: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: GlobalState().notificationCount,
                    builder: (context, notificationCount, child) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
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
                  ValueListenableBuilder<int>(
                    valueListenable: GlobalState().cartCount,
                    builder: (context, cartCount, child) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(),
                                ),
                              );
                            },
                          ),
                          if (cartCount > 0)
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
                                  '$cartCount',
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
                ],
              ),
              const SizedBox(height: 20),

              /// Slideshow Card Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 192,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: slideshowCards.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[600],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            /// Left side content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Today's Special !",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '"${item["title"]}"',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[100],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>  MenuPage(),
                                        ),
                                      );
                                    },
                                    child: const Text("Order Now",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.local_fire_department,
                                          color: Colors.yellow, size: 20),
                                      const SizedBox(width: 5),
                                      Text(
                                        item["offer"]!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            /// Right side image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item["image"]!,
                                width: 130,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

            // Menu Category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Menu Categories",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menuCategories.length,
                      itemBuilder: (context, index) {
                        var category = menuCategories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () {
                              // Navigate to menu page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuPage(selectedCategory: category["name"]),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildCategoryImage(category["imageUrl"]),
                                ),
                                const SizedBox(height: 10),
                                Text(category["name"],
                                    style: const TextStyle(fontSize: 14))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                 // Bestseller Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("🔥 Bestsellers",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPage(),
                          ),
                        );
                      },
                      child: const Text("View More"),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Bestseller Grid
                if (bestsellerItems.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: bestsellerItems.length > 4 ? 4 : bestsellerItems.length, // Show max 4 items
                    itemBuilder: (context, index) {
                      final item = bestsellerItems[index];
                      return _buildBestsellerCard(context, item);
                    },
                  )
                else
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "No bestseller items available",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Debug section - show data info
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "DEBUG: Total items: ${GlobalState().menuItems.length}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Bestseller items: ${bestsellerItems.length}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "First 3 items:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...GlobalState().menuItems.take(3).map((item) => Text(
                              "• ${item["name"]} (isBestseller: ${item["isBestseller"]})",
                              style: const TextStyle(fontSize: 12),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildBestsellerCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        // Navigate to menu page with the selected item
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(selectedItem: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with bestseller badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: _buildProductImage(item["imageUrl"]),
                ),
                // Bestseller badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "🔥 HOT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item["name"],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    item["description"],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text(
                            "${item["rating"] ?? 4.5}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      // Price
                      Text(
                        "₹${item["price"]}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 120,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Icon(Icons.fastfood, color: Colors.grey),
      );
    }
    
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 120,
          width: double.infinity,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 120,
          width: double.infinity,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else {
      try {
        return Image.file(
          File(imageUrl),
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey[200],
            child: const Icon(Icons.error, color: Colors.grey),
          ),
        );
      } catch (e) {
        return Container(
          height: 120,
          width: double.infinity,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        );
      }
    }
  }

  Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 110,
        height: 70,
        color: Colors.grey[200],
        child: const Icon(Icons.fastfood, color: Colors.grey),
      );
    }
    
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: 110,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 110,
          height: 70,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 110,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 110,
          height: 70,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else {
      try {
        return Image.file(
          File(imageUrl),
          width: 110,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 110,
            height: 70,
            color: Colors.grey[200],
            child: const Icon(Icons.error, color: Colors.grey),
          ),
        );
      } catch (e) {
        return Container(
          width: 110,
          height: 70,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        );
      }
    }
  }

  // Example: Remove item from cart
  void removeFromCart(Map<String, dynamic> item) {
    GlobalState().cartItems.remove(item);
    GlobalState().cartCount.value = GlobalState().cartItems.length; // Update the ValueNotifier so UI updates
  }
}