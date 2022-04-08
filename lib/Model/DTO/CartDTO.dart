import 'package:logger/logger.dart';

import 'index.dart';

final logger = Logger(
    printer: PrettyPrinter(
  methodCount: 0,
  errorMethodCount: 5,
  lineLength: 50,
  colors: true,
  printEmojis: true,
  printTime: false,
));

class Cart {
  List<CartItem> items;
  int payment;
  List<SupplierNoteDTO> notes;
  // User info
  String cardNumber;

  // _vouchers
  List<VoucherDTO> _vouchers;

  Cart.get({this.items, this.payment, this.notes, this.cardNumber});

  Cart() {
    items = [];
    _vouchers = [];
  }

  List<VoucherDTO> get vouchers {
    if (_vouchers == null) {
      _vouchers = [];
    }
    return _vouchers;
  }

  factory Cart.fromJson(dynamic json) {
    List<CartItem> list = [];
    if (json["items"] != null) {
      var itemJson = json["items"] as List;
      list = itemJson.map((e) => CartItem.fromJson(e)).toList();
    }
    return Cart.get(
        items: list,
        payment: json['payment'],
        notes: (json['supplier_notes'] as List)
            ?.map((e) => SupplierNoteDTO.fromJson(e))
            ?.toList());
  }

  void addVoucher(VoucherDTO voucher) {
    final existedVoucher = _vouchers?.firstWhere(
        (e) => e.voucherCode == voucher.voucherCode,
        orElse: () => null);
    if (existedVoucher == null) {
      vouchers?.add(voucher);
    }
  }

  void removeOnlyVoucher() {
    vouchers?.clear();
  }

  void removeVoucher(VoucherDTO voucher) {
    final existedVoucher = _vouchers.firstWhere(
        (e) => e.voucherCode == voucher.voucherCode,
        orElse: () => null);
    if (existedVoucher != null) {
      vouchers?.remove(existedVoucher);
    }
  }

  void addCardNumber(String cardNumberInput) {
    cardNumber = cardNumberInput;
  }

  Map<String, dynamic> toJson() {
    List listCartItem = items.map((e) => e.toJson()).toList();
    return {
      "items": listCartItem,
      "payment": payment,
      "supplier_notes":
          notes != null ? notes.map((e) => e.toJson())?.toList() : []
    };
  }

  Map<String, dynamic> toJsonAPi() {
    List<Map<String, dynamic>> listCartItem = new List();
    items.forEach((element) {
      listCartItem.add(element.toJsonApi());
    });

    Map<String, dynamic> map = {
      "payment": payment,
      "products_list": listCartItem,
      "supplier_notes":
          notes != null ? notes.map((e) => e.toJson())?.toList() : [],
      "vouchers": _vouchers != null
          ? _vouchers?.map((voucher) => voucher.voucherCode)?.toList()
          : null,
      "card_number": cardNumber
    };
    logger.i("Order: " + map.toString());
    return map;
  }

  bool get isEmpty => items != null && items.isEmpty;
  int itemQuantity() {
    int quantity = 0;
    for (CartItem item in items) {
      quantity += item.quantity;
    }
    return quantity;
  }

  void addItem(CartItem item) {
    for (CartItem cart in items) {
      if (cart.findCartItem(item)) {
        cart.quantity += item.quantity;
        return;
      }
    }
    items.add(item);
  }

  void removeItem(CartItem item) {
    print("Quantity: ${item.quantity}");
    items.removeWhere((element) =>
        element.findCartItem(item) && element.quantity == item.quantity);
  }

  void updateQuantity(CartItem item) {
    for (CartItem cart in items) {
      if (cart.findCartItem(item)) {
        print("Found item");
        cart.quantity = item.quantity;
      }
    }
  }
}

class CartItem {
  ProductDTO master;
  List<ProductDTO> products;
  String description;
  int quantity;

  CartItem(this.master, this.products, this.description, this.quantity);

  bool findCartItem(CartItem item) {
    bool found = true;

    if (this.master.id != item.master.id ||
        this.master.type != item.master.type) {
      return false;
    }

    if (this.products.length != item.products.length) {
      return false;
    }
    for (int i = 0; i < this.products.length; i++) {
      if (item.products[i].id != this.products[i].id) found = false;
    }
    if (item.description != this.description) {
      found = false;
    }
    return found;
  }

  factory CartItem.fromJson(dynamic json) {
    List<ProductDTO> list = new List();
    if (json["products"] != null) {
      var itemJson = json["products"] as List;
      list = itemJson.map((e) => ProductDTO.fromJson(e)).toList();
    }
    return CartItem(
      ProductDTO.fromJson(json['master']),
      list,
      json['description'] as String,
      json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    List listProducts = products.map((e) => e.toJson()).toList();
    return {
      "master": master.toJson(),
      "products": listProducts,
      "description": description,
      "quantity": quantity
    };
  }

  // TODO: Xem lai quantity cua tung CartItem
  Map<String, dynamic> toJsonApi() {
    // List<Map<String, dynamic>> map = new List();
    List productChilds = products
        .map((productChild) => {
              "product_id": productChild.id,
              "product_in_menu_id": productChild.productInMenuId,
              "quantity": quantity, // TODO: Kiem tra lon hon max va < min
            })
        .toList();

    return {
      "master_product": master.productInMenuId,
      "product_childs": productChilds,
      "description": description,
      "quantity": quantity
    };

    // if (master.type != ProductType.MASTER_PRODUCT) {
    //   map.add({
    //     "product_id": master.id,
    //     "quantity": quantity,
    //     "parent_id": master.catergoryId
    //   });
    // }

    // products.forEach((element) {
    //   map.add({
    //     "product_id": element.id,
    //     "quantity": quantity,
    //     "parent_id": element.catergoryId
    //   });
    // });
    // return map;
  }
}
