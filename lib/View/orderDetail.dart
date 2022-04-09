import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import "package:collection/collection.dart";
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/format_time.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistoryDetail extends StatefulWidget {
  final OrderDTO order;

  OrderHistoryDetail({Key key, this.order}) : super(key: key);

  @override
  _OrderHistoryDetailState createState() => _OrderHistoryDetailState();
}

class _OrderHistoryDetailState extends State<OrderHistoryDetail> {
  final orderDetailModel = Get.find<OrderHistoryViewModel>();

  @override
  void initState() {
    super.initState();
    orderDetailModel.getOrderDetail(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: orderDetailModel,
      child: Scaffold(
        bottomNavigationBar: _buildCancelBtn(),
        appBar: DefaultAppBar(
          title: "${widget.order.invoiceId.toString()}" ?? 'Đơn hàng',
          backButton: Container(
            child: IconButton(
              icon: Icon(
                AntDesign.down,
                size: 24,
                color: kPrimary,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ScopedModelDescendant<OrderHistoryViewModel>(
            builder: (context, child, model) {
              final status = model.status;
              if (status == ViewStatus.Loading)
                return AspectRatio(
                  aspectRatio: 1,
                  child: Center(child: CircularProgressIndicator()),
                );

              final orderDetail = model.orderDetail;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kBackgroundGrey[0],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                alignment: Alignment.centerLeft,
                                child: orderDetail.status == OrderFilter.NEW
                                    ? Text(
                                        'Đang thực hiện ☕',
                                        style: Get.theme.textTheme.headline3
                                            .copyWith(color: kPrimary),
                                        textAlign: TextAlign.start,
                                      )
                                    : Text('Hoàn thành',
                                        style: Get.theme.textTheme.headline3
                                            .copyWith(color: kPrimary)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Divider(),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Divider(),
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm dd/MM').format(
                                    DateTime.parse(orderDetail.orderTime)),
                                style: Get.theme.textTheme.headline4,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text("🎯 Nhận đơn tại: ",
                                  style: Get.theme.textTheme.headline4),
                              Text(orderDetail.address,
                                  style: Get.theme.textTheme.headline4),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(" Giờ nhận đơn: ",
                                  style: Get.theme.textTheme.headline4),
                              Text(formatTime(orderDetail.arriveTime),
                                  style: Get.theme.textTheme.headline4),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: kBackgroundGrey[0],
                      ),
                      child: buildOrderSummaryList(orderDetail),
                    ),
                    SizedBox(height: 8),
                    layoutSubtotal(orderDetail),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCancelBtn() {
    OrderFilter status = this.widget.order.status;

    if (status == OrderFilter.NEW) {
      return ScopedModelDescendant<OrderHistoryViewModel>(
          builder: (context, child, model) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          height: 125,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Container(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kPrimary, width: 2),
                  ),
                  child: TextButton(
                      onPressed: () async {
                        int option = await showOptionDialog(
                            "Vui lòng liên hệ FanPage",
                            firstOption: "Quay lại",
                            secondOption: "Liên hệ");
                        if (option == 1) {
                          if (!await launch("https://www.m.me/beanoivn"))
                            throw 'Could not launch https://www.m.me/beanoivn';
                        }
                      },
                      child: Text(
                        "Ét o ét! Liên hệ BeanOi ngay! ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: kPrimary,
                            fontSize: 16),
                      )),
                ),
                SizedBox(
                  height: 6,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      model.cancelOrder(this.widget.order.id);
                    },
                    child: Text("Hủy đơn 😢",
                        style: Get.theme.textTheme.headline3
                            .copyWith(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    } else if (status == OrderFilter.DONE) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kPrimary, width: 3),
              ),
              child: TextButton(
                onPressed: () async {
                  int option = await showOptionDialog(
                      "Vui lòng liên hệ FanPage",
                      firstOption: "Quay lại",
                      secondOption: "Liên hệ");
                  if (option == 1) {
                    if (!await launch("https://www.m.me/beanoivn"))
                      throw 'Could not launch https://www.m.me/beanoivn';
                  }
                },
                child: Text(
                  "Ét o ét! Liên hệ BeanOi ngay! ",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: kPrimary,
                      fontSize: 18),
                ),
              )));
    } else {
      return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Text('Các đầu bếp đang chuẩn bị cho bạn đó 🥡',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.headline4.copyWith(color: Colors.grey)),
      );
    }
  }

  Widget buildOrderSummaryList(OrderDTO orderDetail) {
    Map<int, List<OrderItemDTO>> map =
        groupBy(orderDetail.orderItems, (OrderItemDTO item) => item.supplierId);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          List<OrderItemDTO> items = map.values.elementAt(index);
          SupplierNoteDTO note = orderDetail.notes?.firstWhere(
              (element) => element.supplierId == items[0].supplierId,
              orElse: () => null);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                items[0].supplierName,
                style: Get.theme.textTheme.headline3,
              ),
              (note != null)
                  ? Container(
                      width: Get.width,
                      color: Colors.yellow[100],
                      margin: EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(4),
                      child: Text.rich(TextSpan(
                          text: "Ghi chú:\n",
                          style: Get.theme.textTheme.headline6
                              .copyWith(color: Colors.red),
                          children: [
                            TextSpan(
                                text: "- " + note.content,
                                style: Get.theme.textTheme.headline4
                                    .copyWith(color: Colors.grey))
                          ])),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: kBackgroundGrey[4]),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildOrderItem(items[index]);
                    },
                    separatorBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: MySeparator()),
                    itemCount: items.length),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: map.keys.length,
      ),
    );
  }

  Widget buildOrderItem(OrderItemDTO item) {
    final orderChilds = item.productChilds;

    double orderItemPrice = item.amount;
    orderChilds?.forEach((element) {
      orderItemPrice += element.amount;
    });
    // orderItemPrice *= orderMaster.quantity;
    Widget displayPrice = Text("${formatPrice(orderItemPrice)}");
    if (item.type == ProductType.GIFT_PRODUCT) {
      displayPrice = RichText(
          text: TextSpan(
              style: Get.theme.textTheme.headline4,
              text: orderItemPrice.toString() + " ",
              children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.bottom,
                child: Image(
                  image: AssetImage("assets/images/icons/bean_coin.png"),
                  width: 20,
                  height: 20,
                ))
          ]));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${item.quantity} x",
              style: Get.theme.textTheme.headline4.copyWith(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              width: Get.width * 0.6,
              child: Wrap(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.type != ProductType.MASTER_PRODUCT
                            ? Text(
                                item.masterProductName,
                                textAlign: TextAlign.start,
                              )
                            : SizedBox.shrink(),
                        ...orderChilds
                            .map(
                              (child) => Text(
                                child.type == ProductType.EXTRA_PRODUCT
                                    ? "+ " + child.masterProductName
                                    : child.masterProductName,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(child: displayPrice)
          ],
        ),
      ],
    );
  }

  Widget layoutSubtotal(OrderDTO orderDetail) {
    int index = orderDetailModel.listPayments.values
        .toList()
        .indexOf(orderDetail.paymentType);
    String payment = "Không xác định";
    if (index >= 0 && index < orderDetailModel.listPayments.keys.length) {
      payment = orderDetailModel.listPayments.keys.elementAt(index);
    }
    if (orderDetail.paymentType == PaymentTypeEnum.Momo) {
      payment = "Momo";
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng tiền",
                style: Get.theme.textTheme.headline3,
              ),
              Text(
                "${orderDetail.itemQuantity} món",
                style: Get.theme.textTheme.headline3,
              ),
            ],
          ),
          RichText(
            text: TextSpan(
                text: "P.Thức: ",
                style:
                    Get.theme.textTheme.headline6.copyWith(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: "${payment}",
                    style:
                        Get.theme.textTheme.headline5.copyWith(color: kPrimary),
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: kBackgroundGrey[4]),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tạm tính",
                      ),
                      Text("${formatPrice(orderDetail.total)}"),
                    ],
                  ),
                ),
                MySeparator(),
                // OTHER AMOUNTS GO HERE
                ..._buildOtherAmount(orderDetail.otherAmounts),
                Divider(color: Colors.black),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng cộng",
                        style: Get.theme.textTheme.headline3,
                      ),
                      Text(
                        orderDetail.paymentType == PaymentTypeEnum.Cash
                            ? "${formatPrice(orderDetail.finalAmount)}"
                            : "${formatBean(orderDetail.finalAmount)} xu",
                        style: Get.theme.textTheme.headline3,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOtherAmount(List<OtherAmount> otherAmounts) {
    if (otherAmounts == null) return [SizedBox.shrink()];

    return otherAmounts
        .map((amountObj) => OtherAmountWidget(
              otherAmount: amountObj,
            ))
        .toList();
  }

  void _launchUrl(String url, {bool isFB = false, forceWebView = false}) {
    // if(isFB){
    //   String fbProtocolUrl;
    //   if (Platform.isIOS) {
    //     fbProtocolUrl = 'fb://profile/Bean-Ơi-103238875095890';
    //   } else {
    //     fbProtocolUrl = 'fb://page/Bean-Ơi-103238875095890';
    //   }
    //   try {
    //     bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
    //
    //     if (!launched) {
    //       await launch(url, forceSafariVC: false);
    //     }
    //   } catch (e) {
    //     await launch(url, forceSafariVC: false);
    //   }
    // }else
    Get.toNamed(RouteHandler.WEBVIEW, arguments: url);
  }
}
