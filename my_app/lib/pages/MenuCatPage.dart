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
    {"name": "Bacon Burger", "category": "Burgers", "price": 150, "discount": 40, "isBestseller": true, "imageUrl": "https://via.placeholder.com/50?text=Bacon+Burger"},
    {"name": "Grilled Chicken", "category": "Salads", "price": 150, "discount": 40, "isBestseller": true, "imageUrl": "https://via.placeholder.com/50?text=Grilled+Chicken"},
  ];

  List<Map<String, dynamic>> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

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
                  _discountController.text.isNotEmpty &&
                  _imageUrlController.text.isNotEmpty) {
                setState(() {
                  menuItems.add({
                    "name": _nameController.text,
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
      body: Column(
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
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      item["imageUrl"],
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                    title: Text(item["name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${item["category"]}"),
                        Text("₹${item["price"]} ${item["discount"]}% off"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: Text("ADD"),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}