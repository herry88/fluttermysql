class Item {
  final int item_code;
  final String item_name;
  final int price;
  final int stock;

  Item({required this.item_code, required this.item_name, required this.price, required this.stock});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      item_code: json['item_code'],
      item_name: json['item_name'],
      price: json['price'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() => {
    'item_code': item_code,
    'item_name' : item_name,
    'price': price,
    'stock' : stock,
  };
}