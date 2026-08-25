import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/product_model.dart';
import '../utils/urls.dart';

class ProductController {
  List<Data> products = [];

  // GET ALL PRODUCTS
  Future<bool> getProduct() async {
    final response = await http.get(
      Uri.parse(Urls.readURL),
    );

    print("GET STATUS: ${response.statusCode}");
    print("GET RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      ProductModel model =
          ProductModel.fromJson(jsonResponse);

      products = model.data ?? [];

      return true;
    }

    return false;
  }

  // CREATE PRODUCT
  Future<bool> createProduct(Data data) async {

    final url = Uri.parse(Urls.createURL);

    final body = {
      "ProductName": data.productName,
      "ProductCode": data.productCode,
      "Img": data.img,
      "Qty": data.qty,
      "UnitPrice": data.unitPrice,
      "TotalPrice": data.totalPrice,
    };

    print("CREATE URL: $url");
    print("CREATE BODY: $body");

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("CREATE STATUS: ${response.statusCode}");
    print("CREATE RESPONSE: ${response.body}");

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return true;
    }

    return false;
  }

  // UPDATE PRODUCT
  Future<bool> updateProduct(Data data) async {
    final response = await http.post(
      Uri.parse(Urls.updateURL(data.sId.toString())),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "ProductName": data.productName,
        "ProductCode": data.productCode,
        "Img": data.img,
        "Qty": data.qty,
        "UnitPrice": data.unitPrice,
        "TotalPrice": data.totalPrice,
      }),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE RESPONSE: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return true;
    }

    return false;
  }

  // DELETE PRODUCT
  Future<bool> deleteProduct(String id) async {
    final response = await http.get(
      Uri.parse(Urls.deleteURL(id)),
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
