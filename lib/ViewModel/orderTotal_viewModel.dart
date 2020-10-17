import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';

class OrderViewModel extends BaseModel {
  AnalyticsService _analyticsService;
  OrderViewModel() {
    _analyticsService = AnalyticsService.getInstance();
  }

  Future<Cart> get cart async {
    return await getCart();
  }

  double countPrice(Cart cart) {
    double total = 0;
    for (CartItem item in cart.items) {
      double subTotal = item.master.price;
      for (ProductDTO dto in item.products) {
        subTotal += dto.price;
      }
      total += (subTotal * item.quantity);
    }
    total += DELIVERY_FEE;
    return total;
  }

  Future<void> orderCart(String orderNote, double total) async {
    try {
      showLoadingDialog();
      StoreDTO storeDTO = await getStore();
      OrderDAO dao = new OrderDAO();
      // LOG ORDER

      await _analyticsService.logBeginCheckout(total);
      OrderStatus result = await dao.createOrders(orderNote, storeDTO.id);
      if (result == OrderStatus.Success) {
        await _analyticsService.logOrderCreated(total);
        await deleteCart();
        hideDialog();
        Get.back(result: true);
      } else if (result == OrderStatus.Fail) {
        hideDialog();
        await showStatusDialog(
            Icon(
              Icons.error_outline,
              color: kFail,
            ),
            "Thất bại :(",
            "Vui lòng thử lại sau");
      } else if (result == OrderStatus.NoMoney) {
        hideDialog();
        await RootViewModel.getInstance().fetchUser();
        await showStatusDialog(
            Icon(
              Icons.error_outline,
              color: kFail,
            ),
            "Thất bại :(",
            "Có đủ tiền đâu mà mua (>_<)");
      } else if (result == OrderStatus.Timeout) {
        hideDialog();
        await showStatusDialog(
            Icon(
              MaterialCommunityIcons.timer_off,
              color: kFail,
            ),
            "Thất bại :(",
            "Hết giờ rồi bạn ơi, mai đặt sớm nhen <3");
      }
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await orderCart(orderNote, total);
      } else
        setState(ViewStatus.Error);
    }
  }

  double countPrice(Cart cart) {
    double total = 0;
    for (CartItem item in cart.items) {
      double subTotal = item.master.price;
      for (ProductDTO dto in item.products) {
        subTotal += dto.price;
      }
      total += (subTotal * item.quantity);
    }
    total += DELIVERY_FEE;
    return total;
  }
}
