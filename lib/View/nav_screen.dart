import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/profile.dart';
import 'package:unidelivery_mobile/ViewModel/root_viewModel.dart';
import 'package:unidelivery_mobile/acessories/bottomnavigator.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    Scaffold(),
    ProfileScreen(AccountDTO(name: 'Hung Bui')),
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.card_giftcard,
    Icons.person,
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    requestObj.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<RootViewModel>(
      model: RootViewModel(),
      child: DefaultTabController(
        length: _icons.length,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (e) {
            print("On Drag");
          },
          onLongPress: () {
            print("Press screen");
          },
          onTap: () {
            print("Tap screen");
            // TODO:
            // FEATURE: HIEN GOI Y KHI USER KHONG TAP VAO SCREEN MOT KHOANG THOI GIAN
          },
          child: Scaffold(
              body: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
              bottomNavigationBar: Container(
                // padding: const EdgeInsets.only(bottom: 12.0),
                color: Colors.white,
                child: CustomTabBar(
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )),
        ),
      ),
    );
  }
}
