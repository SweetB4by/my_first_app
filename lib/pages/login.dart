import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/config/internal_config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'dart:developer';

import 'package:my_first_app/pages/register.dart';
import 'showtrip.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    void register() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }

    /* var data = {"phone": "0817399999", "password": "1111"}; */
    void login() async {
      CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phoneNoCtl.text,
        password: passwordCtl.text,
      );

      http
          .post(
            Uri.parse("$API_ENDPOINT/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req),
          )
          .then((value) {
            log(value.body);
            CustomerLoginPostResponse customerLoginPostResponse =
                customerLoginPostResponseFromJson(value.body);
            log(customerLoginPostResponse.customer.fullname);
            log(customerLoginPostResponse.customer.email);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowTripPage()),
            );
          })
          .catchError((error) {
            log('Error $error');
          });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/Mordekaiser_6.jpg'),

            const Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Text("หมายเลขโทรศัพท์", style: TextStyle(fontSize: 15)),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneNoCtl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Text("รหัสผ่าน", style: TextStyle(fontSize: 15)),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: register,
                        child: const Text('ลงทะเบียน'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: login,
                        child: const Text('เข้าสู่ระบบ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
