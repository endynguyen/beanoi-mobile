import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/format_price.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionDTO transaction;

  TransactionDetailScreen({Key key, this.transaction}) : super(key: key);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
    super.initState();
    // orderDetailModel.getOrderDetail(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Chi tiết giao dịch",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: buildTitle(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: buildDetail(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    String status;
    switch (widget.transaction.status) {
      case TransactionStatus.APPROVE:
        status = "Đã duyệt";
        break;
      case TransactionStatus.NEW:
        status = "Mới";
        break;
      case TransactionStatus.CANCEL:
        status = "Đã hủy";
        break;
      default:
        status = "Chưa xác định";
    }
    return Container(
      width: Get.width,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          Text(
            widget.transaction.name ?? "Giao dịch",
            style: Get.theme.textTheme.headline1.copyWith(color: Colors.black),
          ),
          SizedBox(height: 16),
          Text(
            "${widget.transaction.isIncrease ? "+" : "-"} ${formatPriceWithoutUnit(widget.transaction.amount)}",
            style: Get.theme.textTheme.subtitle2.copyWith(color: Colors.black),
          ),
          SizedBox(height: 16),
          Text(
            status,
            style: Get.theme.textTheme.headline2,
          ),
        ],
      ),
    );
  }

  Widget buildDetail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          buildItemDetail("Mã giao dịch", widget.transaction.code.toString()),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Divider(),
          ),
          buildItemDetail("Thời gian giao dịch",
              DateFormat("dd/MM/yyyy HH:mm").format(widget.transaction.date)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Divider(),
          ),
          buildItemDetail("Loại giao dịch", widget.transaction.currency,
              descriptionStyle:
                  Get.theme.textTheme.headline4.copyWith(color: Colors.orange)),
        ],
      ),
    );
  }

  Widget buildItemDetail(String title, String description,
      {TextStyle titleStyle, TextStyle descriptionStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ??
              Get.theme.textTheme.headline2.copyWith(color: Colors.grey),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          child: Column(
            children: [
              Text(
                description.split(' ')[0].toString(),
                style: descriptionStyle ??
                    Get.theme.textTheme.headline2.copyWith(color: kTextColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
