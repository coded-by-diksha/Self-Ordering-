import 'package:flutter/material.dart';
import 'CartPage.dart';
import 'GlobalState.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class PopularItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const PopularItemDetailPage({super.key, required this.item});

  @override
  State<PopularItemDetailPage> createState() => _PopularItemDetailPageState();
}

class _PopularItemDetailPageState extends State<PopularItemDetailPage> {
  final GlobalState globalState = GlobalState();
  
  String selectedSize = 'Small';
  String spiceLevel = 'Mild';
  int quantity = 1;
  int tableNumber = 1;
  double rating = 0.0;
  String reviewText = '';
  
  // Sample reviews data - this would typically come from a database
  List<Map<String, dynamic>> reviews = [
    {
      'userName': 'Bibek Ghimire',
      'rating': 4.5,
      'comment': 'Amazing taste! The spice level was perfect for me.',
      'date': '2024-01-15',
      'spiceLevel': 'Medium'
    },
    {
      'userName': 'Dina Shrestha',
      'rating': 5.0,
      'comment': 'Best pizza I\'ve ever had! Will definitely order again.',
      'date': '2024-01-14',
      'spiceLevel': 'Mild'
    },
    {
      'userName': 'Dikshu Ghimire',
      'rating': 4.0,
      'comment': 'Good food, but could be spicier next time.',
      'date': '2024-01-13',
      'spiceLevel': 'Extra Spicy'
    },
  ];

  // Size options with prices
  Map<String, double> sizePrices = {
    'Small': 450.0,
    'Medium': 550.0,
    'Large': 750.0,
  };

  // Spice level descriptions
  Map<String, String> spiceDescriptions = {
    'Mild': 'Perfect for those who prefer subtle flavors',
    'Medium': 'Balanced heat that enhances the taste',
    'Extra Spicy': 'For spice lovers who want a fiery experience',
  };

  @override
  Widget build(BuildContext context) {
    double currentPrice = sizePrices[selectedSize] ?? 450.0;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: Colors.orange,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Product Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _buildProductImage(widget.item['image'] ?? 'assets/C1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Back button
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    // Cart button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Product Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item['title'] ?? 'Product Name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                widget.item['rating'] ?? '4.5',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    Text(
                      '₹${currentPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    const Text(
                      "About This Item",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.item['description'] ?? 
                      "A fiery twist on a classic! This spicy vegetarian Margherita pizza has a thin, crispy crust with zesty, chili-infused tomato sauce, mozzarella, fresh basil, and spicy olive oil. Perfect for those who love bold flavors and authentic Italian taste with a modern spicy kick.",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Customization Section
                    _buildCustomizationSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Reviews Section
                    _buildReviewsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Add Review Section
                    _buildAddReviewSection(),
                    
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Order Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.orange),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.orange),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Total price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '₹${(currentPrice * quantity).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            
            // Order button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _showOrderConfirmation();
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build product image
  ImageProvider _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    } else if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else if (kIsWeb) {
      return NetworkImage(imageUrl);
    } else {
      try {
        return FileImage(File(imageUrl));
      } catch (e) {
        return const AssetImage('assets/C1.jpg');
      }
    }
  }

  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Customize Your Order",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        
        // Size Selection
        const Text(
          "Size:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: sizePrices.keys.map((size) {
            return ChoiceChip(
              label: Text('$size (₹${sizePrices[size]?.toInt()})'),
              selected: selectedSize == size,
              onSelected: (val) {
                setState(() {
                  selectedSize = size;
                });
              },
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: selectedSize == size ? Colors.white : Colors.black87,
                fontWeight: selectedSize == size ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Spice Level Selection
        const Text(
          "Spice Level:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: spiceDescriptions.keys.map((level) {
            return ChoiceChip(
              label: Text(level),
              selected: spiceLevel == level,
              onSelected: (val) {
                setState(() {
                  spiceLevel = level;
                });
              },
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: spiceLevel == level ? Colors.white : Colors.black87,
                fontWeight: spiceLevel == level ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  spiceDescriptions[spiceLevel] ?? '',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Table Number
        const Text(
          "Table Number:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter your table number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.orange),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
            prefixIcon: Icon(Icons.table_restaurant, color: Colors.orange),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              tableNumber = int.tryParse(value) ?? 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Customer Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              '${reviews.length} reviews',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Average rating
        Row(
          children: [
            Text(
              '${(reviews.fold(0.0, (sum, review) => sum + review['rating']) / reviews.length).toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(5, (index) {
                double avgRating = reviews.fold(0.0, (sum, review) => sum + review['rating']) / reviews.length;
                return Icon(
                  index < avgRating.floor() ? Icons.star : 
                  (index < avgRating.ceil() && index >= avgRating.floor()) ? Icons.star_half : Icons.star_border,
                  color: Colors.orange,
                  size: 20,
                );
              }),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Reviews list
        ...reviews.map((review) => _buildReviewCard(review)).toList(),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  review['userName'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review['rating'] ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  review['spiceLevel'],
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddReviewSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Your Review",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Rating
          Row(
            children: [
              const Text(
                "Rating: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ...List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                  child: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 24,
                  ),
                );
              }),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Review text
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Share your experience with this dish...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orange),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                reviewText = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: rating > 0 ? () {
                _submitReview();
              } : null,
              child: const Text(
                'Submit Review',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReview() {
    if (rating > 0 && reviewText.isNotEmpty) {
      setState(() {
        reviews.insert(0, {
          'userName': 'You',
          'rating': rating,
          'comment': reviewText,
          'date': DateTime.now().toString().split(' ')[0],
          'spiceLevel': spiceLevel,
        });
      });
      
      setState(() {
        rating = 0.0;
        reviewText = '';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showOrderConfirmation() {
    double currentPrice = sizePrices[selectedSize] ?? 450.0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add to Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: _buildProductImage(widget.item['image'] ?? 'assets/C1.jpg'),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['title'] ?? 'Product Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size: $selectedSize',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Spice: $spiceLevel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity:'),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price per item:'),
                Text(
                  '₹${currentPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '₹${(currentPrice * quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
              _addToCart();
            },
            child: const Text(
              'Add to Cart',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart() {
    double currentPrice = sizePrices[selectedSize] ?? 450.0;
    
    Map<String, dynamic> cartItem = {
      'name': widget.item['title'],
      'description': widget.item['description'] ?? '',
      'price': currentPrice,
      'discount': (widget.item['discount'] is num) ? widget.item['discount'] : 0,
      'size': selectedSize,
      'spiceLevel': spiceLevel,
      'quantity': quantity,
      'imageUrl': widget.item['image'] ?? '',
      'categoryImageUrl': widget.item['categoryImageUrl'] ?? '',
      'rating': (widget.item['rating'] is num)
          ? widget.item['rating'].toDouble()
          : 4.5,
      'tableNumber': tableNumber,
      'totalPrice': currentPrice * quantity,
    };
    
    globalState.addToCart(cartItem);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    );
  }
} 