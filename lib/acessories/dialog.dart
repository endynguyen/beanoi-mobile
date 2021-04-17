import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import '../constraints.dart';

Future<void> showStatusDialog(
    String imageUrl, String status, String content) async {
  hideDialog();
  await Get.dialog(WillPopScope(
    onWillPop: () {},
    child: Dialog(
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(imageUrl),
              width: 96,
              height: 96,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                status,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: kPrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content,
                style: kTitleTextStyle.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                color: kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16))),
                onPressed: () {
                  hideDialog();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    "Đồng ý",
                    style: kTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}

void showLoadingDialog() {
  hideDialog();
  Get.defaultDialog(
      barrierDismissible: true,
      title: "Chờ mình xý nha...",
      content: WillPopScope(
        onWillPop: () {},
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/loading.gif"),
              ),
            ],
          ),
        ),
      ),
      titleStyle: TextStyle(fontSize: 16));
}

Future<bool> showErrorDialog() async {
  hideDialog();
  bool result = false;
  await Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  AntDesign.closecircleo,
                  color: Colors.red,
                ),
                onPressed: () {
                  hideDialog();
                },
              ),
            ),
            Text(
              "Có một chút trục trặc nhỏ!!",
              style: TextStyle(fontSize: 16, color: kPrimary),
            ),
            SizedBox(
              height: 8,
            ),
            Image(
              width: 96,
              height: 96,
              image: AssetImage("assets/images/error.png"),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                color: kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16))),
                onPressed: () {
                  result = true;
                  hideDialog();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    "Thử lại",
                    style: kTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true);
  return result;
}

Future<int> showOptionDialog(String text,
    {String firstOption, String secondOption}) async {
  hideDialog();
  int option;
  await Get.dialog(
    WillPopScope(
      onWillPop: () {},
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      AntDesign.closecircleo,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      option = 0;
                      hideDialog();
                    },
                  ),
                ),
                SizedBox(
                  height: 54,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: kTextSecondary,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          // color: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            // bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Center(
                              child: Text(
                                firstOption ?? "Hủy",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            option = 0;
                            hideDialog();
                          },
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          color: kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                              // bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Center(
                              child: Text(
                                secondOption ?? "Đồng ý",
                                style: kTextPrimary,
                              ),
                            ),
                          ),
                          onPressed: () {
                            option = 1;
                            hideDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: -54,
              right: -8,
              child: Image(
                image: AssetImage("assets/images/option.png"),
                width: 160,
                height: 160,
              ),
            )
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
  return option;
}

void hideDialog() {
  if (Get.isDialogOpen) {
    Get.back();
  }
}

void hideSnackbar() {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
}

Future<void> changeCampusDialog(RootViewModel model, Function function) async {
  hideDialog();
  await Get.dialog(
      WillPopScope(
        onWillPop: () {},
        child: ScopedModel(
          model: model,
          child: ScopedModelDescendant<RootViewModel>(
              builder: (context, child, model) {
            return Dialog(
              backgroundColor: Colors.white,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Chọn khu vực",
                            style: TextStyle(color: kPrimary, fontSize: 16),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            AntDesign.closecircleo,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            hideDialog();
                            model.changeAddress = false;
                            model.notifyListeners();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  for (int i = 0; i < model.campuses.length; i++)
                    RadioListTile(
                      activeColor: kFail,
                      groupValue: model.tmpStore.id,
                      value: model.campuses[i].id,
                      title: Text(
                        "${model.campuses[i].name}",
                        style: kTextSecondary.copyWith(
                            fontSize: 14,
                            color: model.campuses[i].available
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onChanged: (value) {
                        model.changeLocation(value);
                      },
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: kPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16))),
                      onPressed: function,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Xác nhận",
                          style: kTextPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      barrierDismissible: true);
}

Future<void> changeLocationDialog(
  OrderViewModel model,
) async {
  await Get.dialog(
      WillPopScope(
          onWillPop: () {},
          child: ScopedModel(
            model: model,
            child: ScopedModelDescendant<OrderViewModel>(
              builder: (context, child, model) {
                return Dialog(
                  backgroundColor: Colors.white,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Chọn địa chỉ nhận hàng",
                                style: TextStyle(color: kPrimary, fontSize: 16),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                AntDesign.closecircleo,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                hideDialog();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      for (int i = 0; i < model.campusDTO.locations.length; i++)
                        RadioListTile(
                          activeColor: kFail,
                          groupValue: model.tmpLocation != null
                              ? model.tmpLocation.id
                              : null,
                          value: model.campusDTO.locations[i].id,
                          title: Text(
                            "${model.campusDTO.locations[i].address}",
                            style: kTextSecondary.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (value) {
                            model.selectLocation(value);
                          },
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        child: model.tmpLocation != null
                            ? FlatButton(
                                color: kPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(16))),
                                onPressed: () async {
                                  await model.confirmLocation();
                                  hideDialog();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 16),
                                  child: Text(
                                    "Xác nhận",
                                    style: kTextPrimary,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          )),
      barrierDismissible: true);
}

Future<void> showTimeDialog(RootViewModel model) async {
  await Get.dialog(
      ScopedModel(
        model: model,
        child: ScopedModelDescendant<RootViewModel>(
            builder: (context, child, model) {
          List<Widget> timeSlots = new List();
          model.currentStore.timeSlots.forEach((element) {
            // int fromHour = double.parse(element.from.split(":")[0]).toInt();
            // int fromMinute = double.parse(element.from.split(":")[1]).toInt();
            //
            // int toHour = double.parse(element.from.split(":")[0]).toInt();
            // int toMinute = double.parse(element.from.split(":")[1]).toInt();

            timeSlots.add(
              RadioListTile(
                activeColor: Colors.red,
                value: element.menuId,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Bắt đầu: ",
                        children: [
                          TextSpan(
                            text: "${element.from.substring(0, 5)}",
                            style: TextStyle(
                                fontSize: 13,
                                color:
                                    element.available ? kPrimary : Colors.grey),
                          )
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Chốt đơn: ",
                        children: [
                          TextSpan(
                            text: "${element.to.substring(0, 5)}",
                            style: TextStyle(
                                fontSize: 13,
                                color:
                                    element.available ? kPrimary : Colors.grey),
                          )
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                groupValue: model.tmpTimeSlot.menuId,
                onChanged: (value) {
                  model.selectTimeSlot(value);
                },
              ),
            );
          });
          String recieveDate = "Hôm nay";
          DateTime currentDate = DateTime.now();
          int hour =
              double.parse(model.tmpTimeSlot.arrive.split(":")[0]).toInt();
          int minute =
              double.parse(model.tmpTimeSlot.arrive.split(":")[1]).toInt();
          DateTime recieveTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
              "${currentDate.year}-${currentDate.month}-${currentDate.day} $hour:$minute:00");
          print(recieveTime.toString());
          if (recieveTime.compareTo(currentDate) < 0) {
            recieveDate = "Ngày mai";
          }

          return WillPopScope(
            onWillPop: () {},
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Đặt lúc",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text.rich(
                        TextSpan(
                            text: "🔔 Dự kiến giao: $recieveDate vào ",
                            children: [
                              TextSpan(
                                  text:
                                      "${model.tmpTimeSlot.arrive.substring(0, 5)}",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold))
                            ]),
                        style: TextStyle(fontSize: 14)),
                    SizedBox(
                      height: 4,
                    ),
                    ...timeSlots,
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                          padding: EdgeInsets.all(8),
                          textColor: Colors.white,
                          color: kPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          onPressed: () {
                            model.confirmTimeSlot();
                          },
                          child: Text("Đồng ý")),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      barrierDismissible: true);
}

Future<String> inputDialog(String title, String buttonTitle,
    {String value, int maxLines = 6}) async {
  hideDialog();
  TextEditingController controller = TextEditingController(text: value);
  await Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, color: kPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      AntDesign.closecircleo,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (value == null || value.isEmpty) {
                        controller.clear();
                      } else {
                        controller.text = value;
                      }
                      hideDialog();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: kPrimary)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            controller.clear();
                          },
                        )),
                    style: TextStyle(color: Colors.grey),
                    keyboardType: TextInputType.multiline,
                    maxLines: maxLines,
                    autofocus: true,
                    onFieldSubmitted: (value) {
                      controller.text = value;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                color: kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16))),
                onPressed: () {
                  hideDialog();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    buttonTitle,
                    style: kTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
  return controller.text;
}
