import 'package:flutter/material.dart';
import 'CartPage.dart';
import 'GlobalState.dart';
import 'PopularItemPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  final Map<String, dynamic>? selectedItem;
  final String? selectedCategory;
  
  const MenuPage({super.key, this.selectedItem, this.selectedCategory});
  
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
   final List<Map<String, String>> cardData = const [
    {
      "image": "assets/sccoter.png",
      "title": "Instant Delivery",
      "Description": "We deliver your order within 30 minutes"

    },
   ];
  final GlobalState globalState = GlobalState();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  
  // Add state for expandable search
  bool _isSearchExpanded = false;
  
  // Use global state for menu items and cart
  List<Map<String, dynamic>> get menuItems => globalState.menuItems;
  List<Map<String, dynamic>> get cartItems => globalState.cartItems;
  
  // Add more items as needed
  List<Map<String, dynamic>> filteredItems = [];
  String selectedCategory = "All"; // Default category
  List<String> categories = ["All"]; // Will be populated with unique categories
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pickedImage;
  
  TabController? _tabController;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize blink animation
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    
    filteredItems = menuItems;
    _searchController.addListener(_filterItems);
    _populateCategories();
    
    // Apply selected category filter if provided
    if (widget.selectedCategory != null) {
      selectedCategory = widget.selectedCategory!;
      _filterByCategory(widget.selectedCategory!);
    }
    
    // Scroll to selected item if provided
    if (widget.selectedItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedItem();
      });
    }
  }

  void _populateCategories() {
    Set<String> uniqueCategories = {"All"};
    for (var item in menuItems) {
      uniqueCategories.add(item["category"]);
    }
    categories = uniqueCategories.toList();

    // Dispose previous controller if it exists
    _tabController?.dispose();
    _tabController = TabController(length: categories.length, vsync: this);
    setState(() {}); // To rebuild with new controller
  }

  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = menuItems.where((item) {
        bool matchesSearch = item["name"].toLowerCase().contains(query) ||
            item["category"].toLowerCase().contains(query);
        bool matchesCategory = selectedCategory == "All" || item["category"] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      String query = _searchController.text.toLowerCase();
      filteredItems = menuItems.where((item) {
        bool matchesSearch = item["name"].toLowerCase().contains(query) ||
            item["category"].toLowerCase().contains(query);
        bool matchesCategory = selectedCategory == "All" || item["category"] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      menuItems[index]["quantity"] = (menuItems[index]["quantity"] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if ((menuItems[index]["quantity"] ?? 0) > 0) {
        menuItems[index]["quantity"] = menuItems[index]["quantity"] - 1;
      }
    });
  }

  void _addToCart(Map<String, dynamic> item) {
    if (item["quantity"] > 0) {
      final addedQty = item["quantity"]; // Store the quantity before resetting

      globalState.addToCart(item);
      
      int itemIndex = menuItems.indexWhere((menuItem) => menuItem["name"] == item["name"]);
      if (itemIndex != -1) {
        menuItems[itemIndex]["quantity"] = 0;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$addedQty ${item["name"]} added to cart!"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select quantity first!"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _scrollToSelectedItem() {
    if (widget.selectedItem == null) return;
    
    final selectedItemName = widget.selectedItem!["name"];
    final selectedItemIndex = filteredItems.indexWhere((item) => item["name"] == selectedItemName);
    
    if (selectedItemIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final headerHeight = 54.0 + 50.0;
        final gridItemWidth = (MediaQuery.of(context).size.width - 24.0) / 2;
        final gridItemHeight = gridItemWidth / 0.6;
        final rowIndex = selectedItemIndex ~/ 2;
        final scrollPosition = (rowIndex * (gridItemHeight + 8.0)) - headerHeight;

        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );

        // Blink and elevate for 1 second
        _blinkController.repeat(reverse: true);
        Future.delayed(const Duration(seconds: 2), () {
          _blinkController.stop();
          _blinkController.reset();
        });
      });
    }
  }

  bool _isSelectedItem(Map<String, dynamic> item) {
    return widget.selectedItem != null && 
           widget.selectedItem!["name"] == item["name"];
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _imageUrlController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Menu"),
            Spacer(),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isSearchExpanded ? 200 : 50,
              height: 40,
              child: _isSearchExpanded
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isSearchExpanded = false;
                            _searchController.clear();
                            _filterItems();
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) => _filterItems(),
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearchExpanded = true;
                      });
                    },
                  ),
            ),
          ],
        ),
      ),
      
      body:
       Column(
        children: [
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 246, 180, 113),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      cardData[0]["image"] ?? "",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cardData[0]["title"] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        cardData[0]["Description"] ?? "",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 8, 8, 8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          
          // Category Filter Buttons
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Color(0xFFFEB57C),
                labelColor: Color(0xFFFEB57C),
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: categories.map((cat) => Tab(text: cat)).toList(),
                onTap: (index) {
                  _filterByCategory(categories[index]);
                },
              ),
            ),
          ),
          
          Expanded(
            child: Stack(
              children: [
                GridView.builder( 
                  controller: _scrollController,
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    return Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _blinkAnimation,
                          builder: (context, child) {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to product detail page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PopularItemDetailPage(
                                      item: {
                                        'title': item["name"],
                                        'image': item["imageUrl"] ?? 'assets/C1.jpg',
                                        'rating': '4.5',
                                        'price': '₹${_getDiscountedPrice(item)}',
                                        'description': item["description"] ?? 'Delicious food item with amazing taste and quality ingredients.',
                                        'originalPrice': item["price"],
                                        'discount': item["discount"] ?? 0,
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: _isSelectedItem(item) && _blinkController.isAnimating
                                  ? 10.0 + (_blinkAnimation.value * 2.0)
                                  : 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: _isSelectedItem(item) 
                                    ? BorderSide(
                                        color: Colors.orange.withOpacity(0.5 + (_blinkAnimation.value * 0.5)), // Animate border opacity
                                        width: 1.0 + (_blinkAnimation.value * 1.0), // Animate border width
                                      )
                                    : BorderSide.none,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (item["discount"] > 0)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 48,
                                          height: 24,
                                          margin: EdgeInsets.only(top: 8, right: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${item["discount"]}% off",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: buildProductImage(item["imageUrl"]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item["name"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )),
                                          SizedBox(height: 4),
                                          Text(
                                            "${item["description"]}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text("Price: "),
                                              if(item["discount"] > 0 && item["discount"] != null) ...[
                                                Text(
                                                  "₹${item["price"]}",
                                                  style: TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "₹${_getDiscountedPrice(item)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(255, 7, 7, 7),
                                                  ),
                                                ),
                                              ] else ...[
                                                Text(
                                                  "₹${item["price"]}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(255, 7, 7, 7),
                                                  ),
                                                )
                                              ]
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          // View Details Button
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                  side: BorderSide(color: Colors.orange),
                                                ),
                                              ),
                                              onPressed: () {
                                                // Navigate to product detail page
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PopularItemDetailPage(
                                                      item: {
                                                        'title': item["name"],
                                                        'image': item["imageUrl"] ?? 'assets/C1.jpg',
                                                        'rating': '4.5',
                                                        'price': '₹${_getDiscountedPrice(item)}',
                                                        'description': item["description"] ?? 'Delicious food item with amazing taste and quality ingredients.',
                                                        'originalPrice': item["price"],
                                                        'discount': item["discount"] ?? 0,
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "View Details",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          // Quantity Controls
                                          Row(
                                            children: [
                                              Text(
                                                "Quantity: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove_circle, color: Colors.red, size: 20),
                                                    onPressed: () {
                                                      int itemIndex = menuItems.indexWhere((menuItem) => menuItem["name"] == item["name"]);
                                                      if (itemIndex != -1) {
                                                        _decrementQuantity(itemIndex);
                                                      }
                                                    },
                                                  ),
                                                  Text("${item["quantity"] ?? 1}",
                                                  style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add_circle, color: Colors.green, size: 20),
                                                    onPressed: () {
                                                      int itemIndex = menuItems.indexWhere((menuItem) => menuItem["name"] == item["name"]);
                                                      if (itemIndex != -1) {
                                                        _incrementQuantity(itemIndex);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Are you sure?"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Do you want to add ${item["name"]} to your cart?"),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    if (item["imageUrl"] != null)
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: buildProductImage(item["imageUrl"]),
                                                      ),
                                                    SizedBox(width: 8),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            item["name"],
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Price: रु${double.parse(_getDiscountedPrice(item))}\nQuantity: ${item["quantity"]}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: const Color.fromARGB(255, 7, 7, 7),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "Total Price: रु${double.parse(_getDiscountedPrice(item)) * item["quantity"]}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15,
                                                              color: const Color.fromARGB(255, 7, 7, 7),
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ),

                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if(item["quantity"] <= 0) {
                                                    Navigator.pop(context); 
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text("Please select quantity first!"),
                                                        backgroundColor: Colors.orange,
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.pop(context);
                                                    _addToCart(item);
                                                  }
                                                },
                                                child: Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      child: Text("ADD TO CART",
                                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                       ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ]
                    );
                  },
                ),
              ],
              
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to cart - no need to pass cart items since it uses global state
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CartPage(),
          )); 
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add_shopping_cart,
        color: Colors.white,
        ),
        tooltip: 'View Cart',
      ),
    );
  }
  
  _getDiscountedPrice(Map<String, dynamic> item) {
    if (item["discount"] > 0) {
      double discountAmount = item["price"] * (item["discount"] / 100);
      return (item["price"] - discountAmount).toStringAsFixed(2);
    } else {
      return item["price"].toString();
    }
  }

  Widget buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(Icons.image, size: 80);
    }
    
    if (kIsWeb) {
      // On web, use Image.network for both http(s) and blob: URLs
      return Image.network(
        imageUrl,
        width: 100,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
    } else if (imageUrl.startsWith('http')) {
      // On mobile, use Image.network for URLs
      return Image.network(
        imageUrl,
        width: 100,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
    } else {
      // On mobile, use Image.file for local files
      try {
        return Image.file(
          File(imageUrl),
          width: 100,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        );
      } catch (e) {
        return Icon(Icons.error, size: 80);
      }
    }
  }
}