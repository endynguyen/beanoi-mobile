import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class SignUp extends StatefulWidget {
  final AccountDTO user;

  @override
  _SignUpState createState() => _SignUpState();

  SignUp({this.user});
}

class _SignUpState extends State<SignUp> {
  final form = FormGroup({
    'name': FormControl(validators: [
      Validators.required,
    ], touched: false),
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ScopedModel(
      model: SignUpViewModel(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: ReactiveForm(
            formGroup: this.form,
            child: Container(
              color: Color(0xFFddf1ed),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HELLO SECTION
                        Text(
                          "Cho mình xin cái tên nhé ☺",
                          style: TextStyle(
                            color: Color(0xFF00d286),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        // FORM ITEM
                        FormItem("Họ Tên", "vd: Nguyễn Văn A", "name"),

                        //SIGN UP BUTTON
                        ReactiveFormConsumer(builder: (context, form, child) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 10),
                            child: Center(
                              child: ScopedModelDescendant<SignUpViewModel>(
                                builder: (context, child, model) =>
                                    RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    // side: BorderSide(color: Colors.red),
                                  ),
                                  color: form.valid
                                      ? Color(0xFF00d286)
                                      : Colors.grey,
                                  onPressed: () async {
                                    if (model.status ==
                                        ViewStatus.Completed) if (form.valid) {
                                      await model.signupUser(form.value);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: model.status == ViewStatus.Loading
                                        ? CircularProgressIndicator(
                                            backgroundColor: Color(0xFFFFFFFF))
                                        : Text(
                                            form.valid
                                                ? "Hoàn thành"
                                                : "Bạn chưa điền xong",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        // BACK TO NAV SCREEN
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipPath(
                        clipper: TriangleClipPath(),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.25,
                        // width: 250,
                        child: Image.asset(
                          'assets/images/sign_up_character.png',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

