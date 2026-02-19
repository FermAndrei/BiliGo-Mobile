class Products {
  int? id;
  String? title;
  double? price;
  String? thumbnail;

  Products({this.id, this.title, this.price, this.thumbnail});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = (json['price'] as num?)?.toDouble();
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
