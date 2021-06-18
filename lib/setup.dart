import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Services/push_notification_service.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/ViewModel/product_filter_viewModel.dart';

import 'Services/firebase_dynamic_link_service.dart';

Future setUp() async {
  await Firebase.initializeApp();
  PushNotificationService ps = PushNotificationService.getInstance();
  await ps.init();
  await DynamicLinkService.initDynamicLinks();
}

void createRouteBindings() async {
  Get.put(RootViewModel());
  Get.put(HomeViewModel());
  Get.put(GiftViewModel());
  Get.put(AccountViewModel());
  Get.put(OrderHistoryViewModel());
  Get.put(ProductFilterViewModel());
}
