
import 'dart:io';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<File> _files;
  TextEditingController _recipientController;
  TextEditingController _subjectController;
  TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _files = [];
    _recipientController = TextEditingController();
    _subjectController = TextEditingController();
    _bodyController = TextEditingController();
  }

  Widget emailFields(String label, double topMargin,
      double bottomMargin, int lines, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      child: TextField(
        maxLines: lines,
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
          ),
          labelText: label
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: emailFields('Recipient', 15.0, 7.5, 1, _recipientController)),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: emailFields('Subject', 7.5, 7.5, 1, _subjectController)),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: emailFields('Body', 7.5, 7.5, 10, _bodyController)),
            ],
          ),
        ),
      ),
    );
  }
}
