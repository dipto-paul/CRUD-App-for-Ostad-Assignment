import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../model/product_model.dart';

class UpdateProduct extends StatefulWidget {
  final Data product;

  const UpdateProduct({
    super.key,
    required this.product,
  });

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  late TextEditingController productNameController;
  late TextEditingController productCodeController;
  late TextEditingController productPriceController;
  late TextEditingController productImageController;
  late TextEditingController productQTYController;

  ProductController productController =
      ProductController();

  @override
  void initState() {
    super.initState();

    productNameController = TextEditingController(
      text: widget.product.productName ?? "",
    );

    productCodeController = TextEditingController(
      text: widget.product.productCode?.toString() ?? "",

    );

    productPriceController = TextEditingController(
      text: widget.product.unitPrice?.toString() ?? "",
    );

    productImageController = TextEditingController(
      text: widget.product.img ?? "",
    );

    productQTYController = TextEditingController(
      text: widget.product.qty?.toString() ?? "",
    );
  }

  Future<void> updateProduct() async {
    if (productNameController.text.isEmpty ||
        productCodeController.text.isEmpty ||
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

    int price =
        int.parse(productPriceController.text);

    int qty =
        int.parse(productQTYController.text);

    Data data = Data(
      sId: widget.product.sId,
      productName: productNameController.text,
      productCode:
          int.parse(productCodeController.text),
      img: productImageController.text,
      qty: qty,
      unitPrice: price,
      totalPrice: price * qty,
    );

    bool result =
        await productController.updateProduct(data);

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product Updated Successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product Update Failed"),
        ),
      );
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productCodeController.dispose();
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
          "Update Product",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                productNameController,
                "Product Name",
                Icons.shopping_bag,
              ),

              const SizedBox(height: 20),

              buildTextField(
                productCodeController,
                "Product Code",
                Icons.qr_code,
                number: true,
              ),

              const SizedBox(height: 20),

              buildTextField(
                productPriceController,
                "Unit Price",
                Icons.price_check_outlined,
                number: true,
              ),

              const SizedBox(height: 20),

              buildTextField(
                productQTYController,
                "QTY",
                Icons.production_quantity_limits,
                number: true,
              ),

              const SizedBox(height: 20),

              buildTextField(
                productImageController,
                "Image URL",
                Icons.image,
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF5346E0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Update Product",
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

  Widget buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
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
