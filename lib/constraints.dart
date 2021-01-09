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
    "https://scontent.fsgn2-5.fna.fbcdn.net/v/t1.0-9/121323906_2758776227677425_3020435246082138067_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=rrVR7mqoAmsAX_xMx0L&_nc_ht=scontent.fsgn2-5.fna&oh=97d2f9a697d253e1c34169f716ea0415&oe=601E072C";
const String TIME = "12:10";
const String VERSION = "0.0.1";
const TEST_STORE = 69;
const int ORDER_NEW_STATUS = 0;
const int ORDER_DONE_STATUS = 4;
const int VIRTUAL_STORE_TYPE = 8;

class ProductType {
  static const int MASTER_PRODUCT = 6;
  static const int DETAIL_PRODUCT = 7;
  static const int COMPLEX_PRODUCT = 10;
}

class PaymentType {
  static const int CASH = 1;
  static const int BEAN = 3;

  static Map<int, String> options = {
    PaymentType.CASH: "Tiền mặt",
    PaymentType.BEAN: "Tiền trong ví"
  };

  static String getPaymentName(int type) {
    return options[type] ?? "N/A";
  }
}
