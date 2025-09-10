import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:my_first_app/pages/login.dart';
import 'package:http/http.dart' as http;

import 'package:my_first_app/model/request/customer_post_req.dart';
import 'package:my_first_app/model/response/customer_post_res.dart';

import 'package:my_first_app/config/config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String url = "";

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController confirmPasswordCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  Widget build(BuildContext context) {
    void youhave() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

    void register() {
      if (passwordCtl.text != confirmPasswordCtl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน')),
        );
        return;
      }

      CustomerPostRequest req = CustomerPostRequest(
        fullname: fullnameCtl.text,
        phone: phoneCtl.text,
        email: emailCtl.text,
        password: passwordCtl.text,
        image: "default.png",
      );

      http
          .post(
            Uri.parse("$url/customers"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerPostRequestToJson(req),
          )
          .then((value) {
            log(value.body);
            final res = customerPostResponseFromJson(value.body);
            log(res.message);
            log('Created customer id: ${res.id}');

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          })
          .catchError((error) {
            log('Error $error');
          });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text("ชื่อ-นามสกุล", style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextField(
                controller: fullnameCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text("หมายเลขโทรศัพท์", style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextField(
                controller: phoneCtl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text("อีเมลล์", style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextField(
                controller: emailCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text("รหัสผ่าน", style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextField(
                controller: passwordCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text("ยืนยันรหัสผ่าน", style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextField(
                controller: confirmPasswordCtl,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: register,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: Text('สมัครสมาชิก'),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: TextButton(
                    onPressed: youhave,
                    child: Text('หากมีบัญชีอยู่แล้ว?'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 35),
                  child: TextButton(
                    onPressed: youhave,
                    child: Text('เข้าสู่ระบบ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
