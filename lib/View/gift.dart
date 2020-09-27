import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/constraints.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: 70,
                    child: Text(
                      "COMING SOON",
                      style: TextStyle(
                        fontSize: 30,
                        color: kPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: 250.0,
                height: 100,
                child: FadeAnimatedTextKit(
                    duration: Duration(seconds: 3),
                    // isRepeatingAnimation: true,
                    repeatForever: true,
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "Tính năng đổi quà đang được phát triển",
                      "Hãy Tích điểm thật nhiều để đổi thật nhiều quà nhá \n^0^",
                    ],
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    alignment:
                        AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
              ),
              Container(
                // color: Colors.amber,
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Image.asset(
                  'assets/images/new-idea.png',
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
