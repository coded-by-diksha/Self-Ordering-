import 'package:flutter/material.dart';

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
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Map<String, dynamic>> menuItems = [
    {"name": "Bacon Burger", "description":"Extremely tasty", "category": "Burgers", "price": 150, "discount": 40, "isBestseller": true, "imageUrl": "https://appetizing-cactus-7139e93734.media.strapiapp.com/Avocado_Bacon_Barbecue_Burger_6395900f58.jpeg"},
    {"name": "Grilled Chicken", "description":"This might contain some ingrediants if required", "category": "Salads", "price": 150, "discount": 40, "isBestseller": true, "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_7mct1A792qL8zopviKQXLsZdtNxOf28HFw&s"},
  ];
  //adding the quantity option in it 
  int quantity = 0; // Default quantity

  // Add more items as needed
  List<Map<String, dynamic>> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    filteredItems = menuItems;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = menuItems.where((item) {
        return item["name"].toLowerCase().contains(query) ||
            item["category"].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _discountController,
                decoration: InputDecoration(labelText: "Discount (%)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _categoryController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty &&
                  _imageUrlController.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty
                  
                  ) {
                setState(() {
                  menuItems.add({
                    "name": _nameController.text,
                    "description": _descriptionController.text,
                    "category": _categoryController.text,
                    "price": int.parse(_priceController.text),
                    "discount": int.parse(_discountController.text),
                    "isBestseller": false,
                    "imageUrl": _imageUrlController.text,
                  });
                  filteredItems = menuItems;
                });
                _nameController.clear();
                _categoryController.clear();
                _priceController.clear();
                _discountController.clear();
                _imageUrlController.clear();
                Navigator.pop(context);
                print("Product added: ${_imageUrlController.text}");
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Items"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProduct,
          ),
        ],
      ),
      body:
       Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "What are you looking for?",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          
          

         Expanded(
          child: Stack(
            children: [
              GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];


          // Category filter bar below the search bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // "All" button
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        filteredItems = menuItems;
                        _searchController.clear();
                      });
                    },
                    child: Text("All"),
                  ),
                  SizedBox(width: 8),
                  // Category buttons
                  ...menuItems
                      .map((item) => item["category"])
                      .toSet()
                      .map((category) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueGrey,
                              ),
                              onPressed: () {
                                setState(() {
                                  filteredItems = menuItems
                                      .where((item) => item["category"] == category)
                                      .toList();
                                  _searchController.clear();
                                });
                              },
                              child: Text(category),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          );
                  return Stack(
                    children: [
                      Card(
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
                              child: Image.network(
                                item["imageUrl"],
                                width: 150,
                                height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
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
                                    "Description: ${item["description"]}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text("Price: "),
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
                                            Image.network(
                                              item["imageUrl"],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
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
                                                  "Price: ₹${_getDiscountedPrice(item)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: const Color.fromARGB(255, 7, 7, 7),
                                                  ),
                                                )
                                              ],
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
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(

                                            //adding the item to cart

                                            SnackBar(
                                              content: Text("${item["name"]} added to cart!"),
                                              backgroundColor: Colors.green,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text("ADD TO CART"),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Remove Item"),
                                content: Text("Are you sure you want to remove ${item["name"]}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        menuItems.remove(item);
                                        filteredItems = menuItems.where((element) {
                                          String query = _searchController.text.toLowerCase();
                                          return element["name"].toLowerCase().contains(query) ||
                                              element["category"].toLowerCase().contains(query);
                                        }).toList();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Remove", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          //   child: GridView.builder(
          //     padding: EdgeInsets.all(8.0),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.75,
          //       crossAxisSpacing: 8.0,
          //       mainAxisSpacing: 8.0,
          //     ),
          //     itemCount: filteredItems.length,
          //     itemBuilder: (context, index) {
          //       final item = filteredItems[index];
          //       return Card(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
                                          
          //                     if (item["discount"] > 0)
                                
          //                       Align(
          //                         alignment: Alignment.topRight,
          //                         child: Container(
          //                           width: 48,
          //                           height: 24,
          //                           margin: EdgeInsets.only(top: 8, right: 8),
          //                           decoration: BoxDecoration(
          //                             color: Colors.green,
          //                             borderRadius: BorderRadius.circular(12),
          //                           ),
          //                           child: Center(
          //                             child: Text(
          //                               "${item["discount"]}% off",
          //                               style: TextStyle(
          //                                 color: Colors.white,
          //                                 fontWeight: FontWeight.bold,
          //                                 fontSize: 12,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
                                                 
                                
          //             ClipRRect(
          //               borderRadius: BorderRadius.circular(8.0),
          //               child: Image.network(
          //                 item["imageUrl"],
          //                 width: 150,
          //                 height: 130,
          //                 fit: BoxFit.cover,
          //                 errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(item["name"], 
                            
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 16,
                              
          //                     )),
          //                     SizedBox(height: 4),
          //                   Text("Description: ${item["description"]}",
          //                   style: TextStyle(
          //                     fontSize: 12,
          //                     color: Colors.grey[600],

          //                   )),
          //                   SizedBox(height: 4),

          //                   Row(
          //                     children: [
          //                       Text("Price: "),
          //                       Text(
          //                         "₹${item["price"]}",
          //                         style: TextStyle(
          //                           decoration: TextDecoration.lineThrough,
          //                           color: Colors.grey,
          //                           fontSize: 14,
          //                         ),
          //                       ),
          //                       SizedBox(width: 8),
          //                       Text(
          //                         "₹${_getDiscountedPrice(item)}",
          //                         style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 16,
          //                           color: const Color.fromARGB(255, 7, 7, 7),
          //                         ),
          //                       ),
          //                     ],
          //                   ),

          //                 ],
          //               ),
          //             ),
          //             ElevatedButton(
          //               onPressed: () {
          //                   showDialog(
          //                   context: context,
          //                   builder: (context) => AlertDialog(
          //                     title: Text("Are you sure?"),
          //                     content: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text("Do you want to add ${item["name"]} to your cart?"),
          //                       SizedBox(height: 5),
          //                       Row(
          //                       children: [
          //                         Image.network(
          //                         item["imageUrl"],
          //                         width: 50,
          //                         height: 50,
          //                         fit: BoxFit.cover,
          //                         errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          //                         ),
          //                         SizedBox(width: 8),
          //                         Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                           item["name"],
          //                           style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 16,
          //                           ),
          //                           ),
          //                           Text(
          //                           "Price: ₹${_getDiscountedPrice(item)}",
          //                           style: TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 14,
          //                             color: const Color.fromARGB(255, 7, 7, 7),
          //                           ),
          //                           )
          //                         ],
          //                         )
          //                       ],
          //                       ),
          //                       SizedBox(height: 8), // Reduce this value to make the gap smaller
          //                     ],
          //                     ),
          //                     actions: [
          //                     TextButton(
          //                       onPressed: () => Navigator.pop(context), // No
          //                       child: Text("No"),
          //                     ),
          //                     TextButton(
          //                       onPressed: () {
          //                       Navigator.pop(context); // Close dialog

          //                       // Add to cart functionality
          //                       ScaffoldMessenger.of(context).showSnackBar(
          //                         SnackBar(
          //                         content: Text("${item["name"]} added to cart!"),
          //                         backgroundColor: Colors.green,
          //                         behavior: SnackBarBehavior.floating,
          //                         ),
          //                       );
          //                       },
          //                       child: Text("Yes"),
          //                     ),
          //                     ],
          //                   ),
          //                   );

          //                 // Add to cart functionality
                         
                          
          //               },
          //               child: Text("ADD TO CART"),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          ),
        ],
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
}