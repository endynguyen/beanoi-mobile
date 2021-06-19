import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:collection/collection.dart';
import 'index.dart';

class RootViewModel extends BaseModel {
  String version;
  bool changeAddress = false;
  CampusDTO currentStore;
  List<CampusDTO> campuses;

  RootViewModel();

  Future getStores() async {
    setState(ViewStatus.Loading);
    StoreDAO dao = new StoreDAO();
    campuses = await dao.getStores();
    for (int i = 0; i < campuses.length; i++) {
      List<LocationDTO> locations = await dao.getLocations(campuses[i].id);
      campuses[i].locations = locations;
    }
    setState(ViewStatus.Completed);
  }

  getAllCampusesLocation() {}

  Future<void> setLocation(DestinationDTO destination, LocationDTO location,
      CampusDTO campus) async {
    if (campus.available) {
      if (campus.id != currentStore.id) {
        Cart cart = await getCart();
        int option = 1;

        if (cart != null) {
          option = await showOptionDialog(
              "Bạn có chắc không? Đổi khu vực rồi là giỏ hàng bị xóa đó!!");
        }

        if (option == 1 || cart == null) {
          showLoadingDialog();
          await deleteCart();
          currentStore = campus;
          setSelectedLocation(currentStore, location, destination);
          await setStore(currentStore);
          notifyListeners();
          hideDialog();
          Get.find<HomeViewModel>().getSuppliers();
          Get.find<GiftViewModel>().getGifts();
        }
      } else {
        setSelectedLocation(currentStore, location, destination);
        await setStore(currentStore);
        notifyListeners();
      }
    } else {
      await showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
    }
    Get.back();
  }

  Future<void> processChangeLocation() async {
    try {
      if (currentStore == null) {
        return;
      }
      changeAddress = true;
      notifyListeners();
      await changeCampusDialog(this);
      hideDialog();
      changeAddress = false;
      notifyListeners();
    } catch (e) {
      hideDialog();
      bool result = await showErrorDialog();
      if (result) {
        await processChangeLocation();
      } else {
        changeAddress = false;
        setState(ViewStatus.Error);
      }
    }
  }

  Future<void> confirmTimeSlot(TimeSlot timeSlot) async {
    if (timeSlot.menuId != currentStore.selectedTimeSlot.menuId) {
      if (!timeSlot.available) {
        showStatusDialog(
            "assets/images/global_error.png",
            "Khung giờ đã qua rồi",
            "Hiện tại khung giờ này đã đóng vào lúc ${timeSlot.to}, bạn hãy xem khung giờ khác nhé 😃.");
        return;
      }
      int option = 1;
      showLoadingDialog();
      Cart cart = await getCart();
      if (cart != null) {
        option = await showOptionDialog(
            "Bạn có chắc không? Đổi khung giờ rồi là giỏ hàng bị xóa đó!!");
      }

      if (option == 1) {
        showLoadingDialog();
        currentStore.selectedTimeSlot = timeSlot;
        await deleteCart();
        await setStore(currentStore);
        hideDialog();
        Get.find<HomeViewModel>().getSuppliers();
        Get.find<GiftViewModel>().getGifts();
      }
    }
  }

  Future<void> fetchStore() async {
    try {
      setState(ViewStatus.Loading);
      StoreDAO _storeDAO = new StoreDAO();
      Function eq = const ListEquality().equals;
      List<CampusDTO> listStore;
      currentStore = await getStore();

      if (currentStore == null) {
        listStore = await _storeDAO.getStores(id: UNIBEAN_STORE);
        currentStore = BussinessHandler.setSelectedTime(listStore[0]);
      } else {
        listStore = await _storeDAO.getStores(id: currentStore.id);
        currentStore.timeSlots = listStore[0].timeSlots;
        bool found = false;
        currentStore.timeSlots.forEach((element) {
          if (currentStore.selectedTimeSlot == null) {
            return;
          }
          if (element.menuId == currentStore.selectedTimeSlot.menuId &&
              element.from == currentStore.selectedTimeSlot.from &&
              element.to == currentStore.selectedTimeSlot.to &&
              element.arrive == currentStore.selectedTimeSlot.arrive) {
            currentStore.selectedTimeSlot.available = element.available;
            found = true;
          }
        });
        if (found == false) {
          currentStore = BussinessHandler.setSelectedTime(currentStore);
          Cart cart = await getCart();
          if (cart != null) {
            await showStatusDialog(
                "assets/images/global_error.png",
                "Khung giờ đã thay đổi",
                "Các sản phẩm trong giỏ hàng đã bị xóa, còn nhiều món ngon đang chờ bạn nhé");
            await deleteCart();
          }
        } else {
          final currentDate = DateTime.now();
          String currentTimeSlot = currentStore.selectedTimeSlot.to;
          var beanTime = new DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            double.parse(currentTimeSlot.split(':')[0]).round(),
            double.parse(currentTimeSlot.split(':')[1]).round(),
          );
          int differentTime = beanTime.difference(currentDate).inMilliseconds;
          if (differentTime <= 0) {
            DateTime arrive = DateFormat("HH:mm:ss")
                .parse(currentStore.selectedTimeSlot.arrive);
            await showStatusDialog(
              "assets/images/global_error.png",
              "Khung giờ đã kết thúc",
              "Đã hết giờ chốt đơn cho khung giờ ${DateFormat("HH:mm").format(arrive)} - ${DateFormat("HH:mm").format(arrive.add(Duration(minutes: 30)))}. \n Hẹn gặp bạn ở khung giờ khác nhé 😢.",
            );
            // remove cart
            await deleteCart();
          }
        }
      }

      await setStore(currentStore);

      List<LocationDTO> locations =
          await _storeDAO.getLocations(currentStore.id);
      if (!eq(locations, currentStore.locations)) {
        currentStore.locations.forEach((location) {
          if (location.isSelected) {
            DestinationDTO destination = location.destinations
                .where(
                  (element) => element.isSelected,
                )
                .first;
            locations.forEach((element) {
              if (element.id == location.id) {
                element.isSelected = true;
                element.destinations.forEach((des) {
                  if (des.id == destination.id) des.isSelected = true;
                });
              }
            });
          }
        });

        currentStore.locations = locations;
        await setStore(currentStore);
        setState(ViewStatus.Completed);
      }
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await fetchStore();
      } else {
        setState(ViewStatus.Error);
      }
    }
  }

  Future<void> openCart() async {
    hideSnackbar();
    await Get.toNamed(RouteHandler.ORDER);
    notifyListeners();
  }

  // _animateToIndex(i) => _scrollController.jumpTo(305.5 * i);

  Future<Cart> get cart async {
    return await getCart();
  }

  Future<void> openProductDetail(ProductDTO product) async {
    bool result =
        await Get.toNamed(RouteHandler.PRODUCT_DETAIL, arguments: product);
    hideSnackbar();
    if (result != null) {
      if (result) {
        Get.rawSnackbar(
          duration: Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          messageText: Text("Thêm món thành công ",
              style: Get.theme.textTheme.headline2),
          icon: Icon(
            Icons.check,
            color: kPrimary,
          ),
          mainButton: FlatButton(
            color: kPrimary,
            onPressed: () {
              Get.toNamed(RouteHandler.ORDER);
            },
            child: Text(
              "Xem 🛒",
              style: Get.theme.textTheme.headline2.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    await deleteCart();
    notifyListeners();
  }

  void setSelectedLocation(
      CampusDTO campus, LocationDTO location, DestinationDTO destination) {
    campus.locations.forEach((element) {
      if (element.id == location.id) {
        element.isSelected = true;
        element.destinations.forEach((des) {
          if (des.id == destination.id) {
            des.isSelected = true;
          }
        });
      } else {
        element.isSelected = false;
      }
    });
    currentStore = campus;
    notifyListeners();
  }

  bool get isCurrentMenuAvailable {
    return currentStore?.selectedTimeSlot?.available;
  }
}
