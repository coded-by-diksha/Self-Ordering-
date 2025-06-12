import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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

   final List<Map<String, String>> menuCategories = const [
    {"title": "Momo", "image": "assets/C4.jpg"},
    {"title": "Thali", "image": "assets/C5.jpg"},
    {"title": "Grill", "image": "assets/C6.jpg"},
  ];

  final List<Map<String, dynamic>> popularItems = const [
    {
      "title": "Classic Chicken Burger",
      "image": "assets/C7.jpg",
      "rating": "4.5",
      "time": "10-15min",
      "price": "Rs.250",
      "quantity": "1"
    },
      {
      "title": "Classic Pizza",
      "image": "assets/C8.jpg",
      "rating": "4.5",
      "time": "10-15min",
      "price": "Rs.250",
      "quantity": "1"
    },
  ];



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
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Slideshow Card Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
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
                                          builder: (context) => const OrderPage(),
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
                                width: 120,
                                height: double.infinity,
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
              const Text("Menu Category",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              category["image"]!,
                              width: 110,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(category["title"]!,
                              style: const TextStyle(fontSize: 14))
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

                 // Our Popular
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Our Popular",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        // View More click
                      },
                      child: const Text("View More"),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: popularItems.length,
                  itemBuilder: (context, index) {
                    var item = popularItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[100],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16)),
                            child: Image.asset(
                              item["image"],
                              width: 100,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["title"],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 14, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(item["rating"]),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.access_time,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(item["time"]),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.shopping_cart,
                                              size: 16, color: Colors.orange),
                                          SizedBox(width: 4),
                                          Text("1"),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.orange,
                                        ),
                                        child: Text(item["price"],
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      )
                                    ],
                                  ),
                                        ],  
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Order Page
class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Page"),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          "Order your food here!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
