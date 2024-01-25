import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/LOGIN/loginPressed.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:cool_alert/cool_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController1 = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final String imagePath = "assets/images/bg3.jpg";
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
                        color: Style.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 20, right: 8, left: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.5),
                              radius: 45,
                              child: IconButton(
                                  icon: Image.asset('assets/icons/person_lg.png'),
                                onPressed: () {  },
                                iconSize: 65,
                                // size: 65,
                              ),
                            ),
                            hSize(),
                            Text(
                              "Login",
                              style: GoogleFonts.aldrich(
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
                                emailController1),
                            hSize(),
                            passwordController(
                                'Enter Password',
                                Icon(
                                  Icons.lock,
                                  color: Style.grey,
                                ),
                                passwordController1),
                            SizedBox(
                              height: 25,
                            ),
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
                                    backgroundColor: Colors.black45,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    print('Loading...');
                                    // Check if password is correct
                                    String email = emailController1.text;
                                    String password = passwordController1.text;
                                    String response = await login(email, password);
                                    // Checking the response
                                    print(response);

                                    if (response == "Login success") {
                                      // Store access token
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      await prefs.setString('accessToken', 'your_access_token');

                                      //querry for the station id and the station name:::


                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                      );
                                    } else if (response == "Login failure") {
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        title: 'Oops...',
                                        text: 'Sorry, Wrong credentials\n Try again',
                                        loopAnimation: false,
                                      );
                                    }
                                    await Future.delayed(Duration(seconds: 3));

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                    "Login",
                                    style: TextStyle(fontSize: 19,color: Colors.white),
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
  static Color darkBlue = Colors.black45;
}

Widget hSize() {
  return SizedBox(
    height: 8.5,
  );
}

Widget customTextEditingController(
    String hintText, Icon prefixIcon, TextEditingController emailController1) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Please Enter Your Email";
      }
      if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "Please enter a valid email address";
      } else {
        return null;
      }
    },
    controller: emailController1,
    style: TextStyle(color: Style.black),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Style.grey),
      prefixIcon: prefixIcon,
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
    String hintText, Icon prefixIcon, TextEditingController passwordController1) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Please Enter Your Password";
      }
      return null;
    },
    obscureText: true,
    controller: passwordController1,
    style: TextStyle(color: Style.black),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Style.grey),
      prefixIcon: prefixIcon,
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
