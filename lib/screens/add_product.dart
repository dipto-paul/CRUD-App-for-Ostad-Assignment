import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../model/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameController =
      TextEditingController();


  TextEditingController productPriceController =
      TextEditingController();

  TextEditingController productImageController =
      TextEditingController();

  TextEditingController productQTYController =
      TextEditingController();

  ProductController productController =
      ProductController();

  Future<void> saveProduct() async {
    if (productNameController.text.isEmpty ||
        productPriceController.text.isEmpty ||
        productQTYController.text.isEmpty ||
        productImageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(

          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    Data data = Data(
      productName: productNameController.text,

      img: productImageController.text,
      qty: int.parse(
        productQTYController.text,
      ),
      unitPrice: int.parse(
        productPriceController.text,
      ),
      totalPrice:
          int.parse(productPriceController.text) *
              int.parse(productQTYController.text),
    );

    bool result =
        await productController.createProduct(data);

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product Added Successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product Add Failed"),
        ),
      );
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    //productCodeController.dispose();
    productPriceController.dispose();
    productImageController.dispose();
    productQTYController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5346E0),
        title: const Text(
          'Add Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              buildTextField(
                controller: productNameController,
                hintText: "Product Name",
                icon: Icons.shopping_bag,
              ),

              const SizedBox(height: 20),



              buildTextField(
                controller: productPriceController,
                hintText: "Unit Price",
                icon: Icons.price_check_outlined,
                number: true,
              ),

              const SizedBox(height: 20),

              buildTextField(
                controller: productQTYController,
                hintText: "QTY",
                icon: Icons.production_quantity_limits,
                number: true,
              ),

              const SizedBox(height: 20),

              buildTextField(
                controller: productImageController,
                hintText: "Image URL",
                icon: Icons.image,
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF5346E0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Save Product",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool number = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        hintText: hintText,
      ),
    );
  }
}
