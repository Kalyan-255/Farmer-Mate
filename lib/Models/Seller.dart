class Seller {
  String name;
  Map<String, dynamic> coordinates;
  Map<String, dynamic> address;
  var poducts = [];
  var recievedOrders = [];
  double earnings;
}

class Orders {
  String buyer;
  Product p;
  Orders(this.buyer, this.p);
}

class Product {
  double weight;
  double price;
  String cat, product, imUrl;
  Product(this.weight, this.price, this.cat, this.product, this.imUrl);
  Map<String, dynamic> getMap() {
    return {
      'Weight': weight,
      'Price': price,
      'Catagory': cat,
      'Name': product,
      'imUrl': imUrl
    };
  }
}
