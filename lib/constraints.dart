import 'package:flutter/material.dart';

const kPrimary = Color(0xFF4fba6f);
final kSecondary = Color(0xFF438029);
final kBean = Color(0xffffe844);
final kSuccess = Colors.green;
final kFail = Colors.red;
final kBackgroundGrey = [
  Color(0xFFFFFFFF),
  Color(0xfffafafa),
  Color(0xfff5f5f5),
  Color(0xffe0e0e0),
  Color(0xffbdbdbd),
  Color(0xff9e9e9e),
  Color(0xff757575),
];
final kGreyTitle = Color(0xFF575757);

final kTextPrimary = TextStyle(color: Color(0xFFFFFFFF));
final kTextSecondary = TextStyle(color: kPrimary);

const String CART_TAG = "cartTag";

const double DELIVERY_FEE = 5000;
const UNIBEAN_STORE = 150;
const UNIBEAN_BRAND = 10;
const MASTER_PRODUCT = 6;
const double DIALOG_ICON_SIZE = 60;
const String defaultImage =
    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Fdefault_image.png?alt=media&token=3c1cf2f4-52be-4df1-aed5-cdb5fd4990d8";
const String defaultPromotionImage =
    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Fstores%2Ffood-drink-banner.jpg?alt=media&token=96b3c6dc-c93b-4066-b3fa-dacc64f14edc";

const String TIME = "12:10";
const String VERSION = "0.0.1";
const TEST_STORE = 69;
const int ORDER_NEW_STATUS = 1;
const int ORDER_DONE_STATUS = 3;
const int VIRTUAL_STORE_TYPE = 8;

class ProductType {
  static const int MASTER_PRODUCT = 6;
  static const int DETAIL_PRODUCT = 7;
  static const int COMPLEX_PRODUCT = 10;
  static const int GIFT_PRODUCT = 12;
}


