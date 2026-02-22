import 'package:flutter/material.dart';
import 'package:bilibo/services/dummyJson.dart';
import '../model/dummyJson_categories.dart';

class CategordyCard extends StatefulWidget {
  const CategordyCard({super.key});

  @override
  State<CategordyCard> createState() => _CategordyCardState();
}

class _CategordyCardState extends State<CategordyCard> {
  final DummyJSON service = DummyJSON();
  late Future<List<Categories>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = service.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: FutureBuilder<List<Categories>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }

                final categories = snapshot.data ?? [];

                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return GestureDetector(
                      onTap: () {
                        debugPrint("Selected: ${category.slug}");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: const Icon(Icons.category, size: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.name ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
