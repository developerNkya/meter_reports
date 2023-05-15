

//login page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/LOGIN/loginPressed.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:cool_alert/cool_alert.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final TextEditingController emailController1 = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final String imagePath = "assets/images/welcome_image.png";
  bool _isLoading = false;
    @override
  void dispose() {
    emailController1.dispose();
    passwordController1.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final errorAlert = _buildButton(
      onTap: () {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
          loopAnimation: false,
        );
      },
      text: 'Error',
      color: Colors.red,
    );

    return SafeArea(
      child: Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(imagePath),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Form(
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                        color: Style.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 20, right: 8, left: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                             backgroundColor: Colors.black,
                              radius: 45,
                              child: Icon(
                                Icons.person,
                                size: 65,
                              ),
                            ),
                            hSize(),
                            Text(
                              "Login",
                              style: GoogleFonts.acme(
                                  letterSpacing: .5,
                                  fontSize: 23,
                                  color: Style.black),
                            ),
                            hSize(),
                            customTextEditingController(
                                'Enter username',
                                Icon(
                                  Icons.person,
                                  color: Style.grey,
                                ),
                              emailController1

                            ),
                            hSize(),
                            passwordController(
                              'Enter Password',
                              Icon(
                                Icons.lock,
                                color: Style.grey,
                              ),
                                passwordController1
                            ),

                            SizedBox(height: 25,),
                            Row(
                              children: [

                                Spacer(),
                              ],
                            ),
                            hSize(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 19),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 14.7,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                  //check if password is correct::
                                    String email = emailController1.text;
                                    String password = passwordController1.text;
                                    String response = await login(email, password);
                                    //checking the response:::
                                    print(response);

                                    if(response == "Login success"){
                                      //setting sessions::

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );

                                    }else if(response == "Login failure"){
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        title: 'Oops...',
                                        text: 'Sorry, Wrong credidentials\n Try again',
                                        loopAnimation: false,
                                      );
                                    }
                                    await Future.delayed(Duration(seconds: 3));

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child:_isLoading ? CircularProgressIndicator() : Text(
                                    "Login",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                              ),
                            ),
                            hSize(),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome back!..Kindly login to proceed",
                                  style:
                                  TextStyle(color: Style.black, fontSize: 15),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildButton(
      {VoidCallback? onTap, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


  class Style {
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color grey = Colors.grey;
  static Color darkBlue = Colors.green.shade800;
  }

  Widget hSize() {
  return SizedBox(
  height: 8.5,
  );
  }

Widget customTextEditingController(
    String hint_text, Icon prefix_icon, TextEditingController emailController1) {
  return TextFormField(

    validator: (value) {
      if (value!.isEmpty) {
        return "PLease Enter Your Email";
      }
      if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "Please enter a valid email address";
      } else {
        return null;
      }
    },
//add controller here::
  controller: emailController1,
    style: TextStyle(color: Style.black),
    decoration: InputDecoration(
      hintText: hint_text,
      hintStyle: TextStyle(color: Style.grey),
      prefixIcon: prefix_icon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Style.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: new BorderSide(color: Style.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(width: 1, color: Style.grey),
      ),
    ),
  );
}


Widget passwordController(
    String hint_text, Icon prefix_icon,TextEditingController passwordController1) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "PLease Enter Your password";
      }
      if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "Please enter a valid email address";
      } else {
        return null;
      }
    },
    obscureText: true,
    controller: passwordController1,
    style: TextStyle(color: Style.black),
    decoration: InputDecoration(
      hintText: hint_text,
      hintStyle: TextStyle(color: Style.grey),
      prefixIcon: prefix_icon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Style.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      border: new OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: new BorderSide(color: Style.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(width: 1, color: Style.grey),
      ),
    ),
  );
}

