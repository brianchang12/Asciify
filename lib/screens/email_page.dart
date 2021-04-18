
import 'dart:io';
import 'package:asciify/icon/custom_icons.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<File>? _files;
  TextEditingController? _recipientController;
  TextEditingController? _subjectController;
  TextEditingController? _bodyController;

  @override
  void initState() {
    super.initState();
    _files = [];
    _recipientController = TextEditingController();
    _subjectController = TextEditingController();
    _bodyController = TextEditingController();
  }


  @override
  void dispose() {
    _files = null;
    _recipientController!.dispose();
    _subjectController!.dispose();
    _bodyController!.dispose();
    super.dispose();
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

  Widget _fileDisplay() {
    if (_files!.isEmpty == true) {
      return Container(
        color: Color(0xFF11224D),
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Center(
          child: Text("No Files Selected"),
        ),
      );
    } else {
      return Container(
        color: Color(0xFF11224D),
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.25,
        child: ListView.builder(
            itemCount: _files!.length,
            itemBuilder: (context, index) {
              List<String> pathComponents = _files![index].path.split(r"/");
              String fileName = pathComponents.last;
              return Card(
                child: ListTile(
                  title: Text(fileName),
                  subtitle: Text(_files![index].path),
                  trailing: Icon(Icons.indeterminate_check_box_outlined),
                ),
              );
            }),
      );
    }
  }

  Widget _sendButton() {
    return Container(
      margin: EdgeInsets.only(top: 7.5),
      width: MediaQuery.of(context).size.width * 0.90,
      child: ElevatedButton(onPressed: () {},
          child: Icon(Icons.email,
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.menu),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                }),
            IconButton(icon: Icon(Icons.camera),
                onPressed: () {
                  Navigator.pushNamed(context, '/camera');
                }),
            IconButton(icon: Icon(Icons.storage_rounded),
              onPressed: () {
              },)
          ],
        ),
      ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.90,
                  child: emailFields(
                      'Recipient', 15.0, 7.5, 1, _recipientController!)),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.90,
                  child: emailFields(
                      'Subject', 7.5, 7.5, 1, _subjectController!)),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.90,
                  child: emailFields('Body', 7.5, 7.5, 6, _bodyController!)
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Files to be Sent",
                          style: TextStyle(
                            color: Color(0xFFF98125),
                          ),
                        ),
                        Icon(Icons.add,
                        size: 35,
                          color:  Color(0xFFF98125),
                        ),
                      ]
                  ),
                  Divider(
                    indent: 17,
                    endIndent: 17,
                    height: 15,
                    thickness: 2,
                    color: Color(0xFF939BB1),
                  ),
                  _fileDisplay(),
                  _sendButton(),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
