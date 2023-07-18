import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:task1/ProductPage.dart';
import 'package:task1/rating%20widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product View',
      theme: ThemeData(),
      home: const ProductPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.title});

  final String title;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  String searchQuery = '';

  Future<List<Product>> viewprocts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final List<Product> products = Product.parseProducts(response.body);
      return products;
    } else {
      throw Fluttertoast.showToast(
          msg: "Data fetching error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[300],
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  addToCart(Product product) async* {
    await cart.add(product.toJson());
    Fluttertoast.showToast(
        msg: "Item added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green[300],
        textColor: Colors.white,
        fontSize: 12.0);
  }

  List<Product> filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Home page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.pink[100],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: viewprocts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text(
                    'Something went wrong...:',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (snapshot.hasData) {
                  final List<Product> products = snapshot.data!;
                  filteredProducts = searchQuery.isEmpty
                      ? products // No search query, show all products
                      : products
                          .where((product) => product.title
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                          .toList();

                  if (filteredProducts.isEmpty) {
                    return const Text('No matching products found.');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Product product = snapshot.data![index];
                      return Container(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              trailing: IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () {
                                  addToCart(snapshot.data![index]);
                                },
                              ),
                              title: Text(
                                snapshot.data![index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price: \$${snapshot.data![index].price}',
                                    style: const TextStyle(),
                                  ),
                                  StarRating(
                                      rating: snapshot.data![index].rating)
                                ],
                              ),
                              leading: Image.network(
                                snapshot.data![index].thumbnail,
                                height: 120,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ),
          // Add rest of the page content here
        ],
      ),
    );
  }
}
