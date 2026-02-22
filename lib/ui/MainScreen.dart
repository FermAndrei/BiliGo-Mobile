import 'package:bilibo/model/dummyJson_categories.dart';
import 'package:bilibo/model/dummyJson_product.dart';
import 'package:bilibo/services/dummyJson.dart';
import 'package:bilibo/widget/CategordyCard.dart';
import 'package:bilibo/widget/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

final List<String> imgList = [
  'assets/carousel/1.png',
  'assets/carousel/2.png',
  'assets/carousel/3.png',
  'assets/carousel/4.png',
  'assets/carousel/5.png',
];

IconData categoryIcon(String slug) {
  switch (slug) {
    case 'beauty':
      return Icons.face_retouching_natural;
    case 'fragrances':
      return Icons.local_florist;
    case 'furniture':
      return Icons.chair;
    case 'groceries':
      return Icons.shopping_basket;
    case 'home-decoration':
      return Icons.home;
    case 'kitchen-accessories':
      return Icons.kitchen;
    case 'laptops':
      return Icons.laptop;
    case 'smartphones':
      return Icons.smartphone;
    default:
      return Icons.category;
  }
}

class _MainscreenState extends State<Mainscreen> {
  final DummyJSON _service = DummyJSON();
  late Future<List<Categories>> _productsFuture;
  late Future<List<Products>> _product;

  @override
  void initState() {
    super.initState();
    _productsFuture = _service.fetchCategory();
    _product = _service.fetchProduct();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Image.asset(
              'assets/logo/biligo_logo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black45),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart, color: Colors.black45),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: imgList.map((item) {
                return Image.asset(
                  item,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                pauseAutoPlayOnTouch: true,
              ),
            ),
            Padding(padding: const EdgeInsets.all(3.0), child: CategordyCard()),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Products>>(
                  future: _product,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    final products = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 0.7,
                          ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          imageUrl: product.thumbnail ?? '',
                          title: product.title ?? '',
                          price: product.price ?? 0,
                          onTap: () {
                            debugPrint('Open product: ${product.id}');
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
