class Urls {
  static const String baseUrl =
      "https://crud-api-ostad-live.onrender.com/api/v1";

  static String readURL = "$baseUrl/ReadProduct";

  static String createURL = "$baseUrl/CreateProduct";

  static String updateURL(String id) {
    return "$baseUrl/UpdateProduct/$id";
  }

  static String deleteURL(String id) {
    return "$baseUrl/DeleteProduct/$id";
  }
}
