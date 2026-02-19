import 'package:bilibo/model/dummyJson_categories.dart';
import 'package:bilibo/model/dummyJson_product.dart';

import 'api_services.dart';

class DummyJSON {
  final ApiService apiService = ApiService(baseURL: 'https://dummyjson.com');

  Future<List<Categories>> fetchCategory() async {
    final response = await apiService.get('/products/categories');
    print('Categroy $response');
    final List productJson = response as List;
    return productJson.map((json) => Categories.fromJson(json)).toList();
  }

  Future<List<Products>> fetchProduct() async {
    final response = await apiService.get(
      '/products?limit=10&skip=10&select=title,price,thumbnail',
    );
    print('Tangina mo jepoy dizon $response');
    final List productJson = response['products'];
    return productJson.map((json) => Products.fromJson(json)).toList();
  }
}
