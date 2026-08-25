import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../model/product_model.dart';
import 'add_product.dart';
import 'update_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await productController.getProduct();

    setState(() {});
  }

  Future<void> deleteProduct(String id) async {
    bool result = await productController.deleteProduct(id);

    if (result) {
      await fetchData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product deleted successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product delete failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5346E0),
        title: const Text(
          'Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          ),
        ],
      ),

      body: productController.products.isEmpty
          ? const Center(
              child: Text(
                "No Products Found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final Data product =
                    productController.products[index];

                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            product.img ?? "",
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 60,
                              );
                            },
                          ),
                        ),

                        Text(
                          product.productName ?? "No Name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Price: ${product.unitPrice ?? 0}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "QTY: ${product.qty ?? 0}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final result =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProduct(
                                      product: product,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  await fetchData();
                                }
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                            ),

                            IconButton(
                              onPressed: () {
                                if (product.sId != null) {
                                  deleteProduct(product.sId!);
                                }
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5346E0),
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProduct(),
            ),
          );

          if (result == true) {
            await fetchData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
