import 'package:bilibo/services/dummyJson.dart';
import 'package:bilibo/ui/MainScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/dummyJson_product.dart';
import '../model/dummyJson_selected_product.dart';
import '../widget/product_card.dart';

class ProductView extends StatefulWidget {
  final int? selectedId;

  const ProductView({super.key, this.selectedId});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  SelectedProduct? product;
  bool showAllReviews = false;
  final DummyJSON _service = DummyJSON();
  late Future<List<Products>> _product;

  @override
  void initState() {
    super.initState();
    getSelectedProduct();
    _product = _service.fetchProduct();
  }

  void getSelectedProduct() async {
    if (widget.selectedId != null) {
      final data = await DummyJSON().getSelectedProduct(widget.selectedId!);
      setState(() {
        product = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    int visibleReviews = showAllReviews ? product!.reviews!.length : 1;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    items: product?.images!.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: double.infinity,
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product!.title}",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${product!.category}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Text(
                            "Price: ₱${product!.price}",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text('|', style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                right: 4.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star, size: 15),
                                  Text("${product!.rating}"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Reviews',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if ((product!.reviews?.length ?? 0) > 1)
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                setState(() {
                                  showAllReviews = !showAllReviews;
                                });
                              },
                              child: Text(
                                showAllReviews ? "Show Less" : "Show More",
                              ),
                            ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleReviews,
                        itemBuilder: (context, index) {
                          final review = product!.reviews![index];
                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: ListTile(
                              title: Text(review.reviewerName ?? "Unknown"),
                              subtitle: Text(review.comment ?? ""),
                              trailing: Text("⭐ ${review.rating}"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Related Product',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: Text('see all'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: FutureBuilder<List<Products>>(
                        future: _product,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          final products = snapshot.data!;
                          return MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final product = products[index];

                              return ProductCard(
                                imageUrl: product.thumbnail ?? '',
                                title: product.title ?? '',
                                price: product.price ?? 0,
                                rating: product.rating ?? 0,
                                onTap: () {
                                  final productID = product.id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductView(selectedId: productID),
                                    ),
                                  );
                                  debugPrint('Open product: ${product.id}');
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   color: Colors.white,
              //   child: Padding(padding: EdgeInsetsGeometry.all(8),
              //   child: ,),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Add Cart'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
