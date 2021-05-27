import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  Widget backButton;
  DefaultAppBar({Key key, @required this.title, this.backButton})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  _AppBarSate createState() {
    return new _AppBarSate();
  }
}

class _AppBarSate extends State<DefaultAppBar> {
  Icon actionIcon = Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5.0,
      centerTitle: true,
      leading: widget.backButton != null
          ? widget.backButton
          : Container(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: kPrimary,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
      title: Text(
        widget.title,
        style: TextStyle(
          color: kPrimary,
        ),
      ),
    );
  }
}

class GiftAppBar extends StatefulWidget {
  @override
  _GiftAppBarSate createState() {
    return new _GiftAppBarSate();
  }
}

class _GiftAppBarSate extends State<GiftAppBar> {
  @override
  void initState() {
    super.initState();
  }

  Color _primeColor = Color(0xFF619a46);

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<AccountViewModel>(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: _primeColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: ScopedModelDescendant<AccountViewModel>(
                        builder: (context, child, model) {
                          return GestureDetector(
                            onTap: () async {
                              await model.fetchUser();
                            },
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Image(
                                image: AssetImage("assets/images/avatar.png"),
                                width: 45,
                                height: 45,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: -5,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: _buildWelcome()),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Image(
                            image: AssetImage("assets/images/balance.png"),
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 8),
                          Flexible(child: _buildBalance()),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/images/history.png',
                        width: 24,
                      )
                      // Icon(
                      //   Foundation.clipboard_notes,
                      //   size: 30,
                      //   color: Colors.white,
                      // ),
                      ),
                  onTap: () {
                    Get.toNamed(RouteHandler.ORDER_HISTORY);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return ScopedModelDescendant<AccountViewModel>(
      builder: (context, child, model) {
        final status = model.status;
        final user = model.currentUser;
        if (status == ViewStatus.Loading)
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 20,
              color: Colors.grey,
            ),
          );
        else if (status == ViewStatus.Error) return Text("＞﹏＜");
        return RichText(
          text: TextSpan(
              text: "Chào ",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${user?.name?.toUpperCase() ?? "-"}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    // color: Colors.white,
                  ),
                ),
                TextSpan(text: ", Đừng để bụng đói nha!"),
              ]),
        );
      },
    );
  }

  Widget _buildBalance() {
    return ScopedModelDescendant<AccountViewModel>(
      builder: (context, child, model) {
        final status = model.status;
        final user = model.currentUser;
        if (status == ViewStatus.Loading)
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 20,
              color: Colors.grey,
            ),
          );
        else if (status == ViewStatus.Error) return Text("＞﹏＜");
        return RichText(
          text: TextSpan(
              text: "Bạn có ",
              style: TextStyle(
                fontSize: 12,
                // fontWeight: FontWeight.w100,
                color: Colors.black45,
              ),
              children: [
                TextSpan(
                  text: "${user?.balance?.floor() ?? "-"} xu",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                TextSpan(text: " và "),
                TextSpan(
                  text: "${user?.point?.floor() ?? "-"} ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kBean,
                  ),
                ),
                WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Image(
                      image: AssetImage("assets/images/icons/bean_coin.png"),
                      width: 20,
                      height: 20,
                    ))
              ]),
        );
      },
    );
  }
}
