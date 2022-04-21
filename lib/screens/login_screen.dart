import 'dart:convert';

import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:disdukcapil_mobile/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    Widget loginButton() {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bluePrimaryColor,
        ),
        child: TextButton(
          onPressed: () {
            login();
          },
          child: Text(
            'Login',
            style: whiteTextStyle,
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bpjs.png',
                      width: 450,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Welcome to our Dashboard!',
                      style: greyMutedTextStyle,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: blackTitleTextStyle,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Enter your username',
                                  hintStyle: greyMutedTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: blackTitleTextStyle,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                controller: passwordController,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: 'Enter your password',
                                    hintStyle: greyMutedTextStyle,
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        })),
                              ),
                            ],
                          ),
                        ),
                        isLoading ? LoadingButton() : loginButton()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    String url = 'http://10.0.2.2:8000/api/login';
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var response = await http.post(Uri.parse(url), body: {
        "username": emailController.text,
        "password": passwordController.text,
      });
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        pageRoute(
          body['access_token'],
          body['roles'],
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Invalid User',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Gagal Login !',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void pageRoute(String accesToken, String role) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('login', accesToken);
    await pref.setString('role', role.toLowerCase());
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}
