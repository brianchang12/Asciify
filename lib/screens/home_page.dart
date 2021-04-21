import 'dart:io';

import 'package:asciify/screens/email_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


final ImageProvider image = AssetImage('assets/camera.png');
final String title = "ASCIIFY";
final String caption = 'Turn your regular photos into Ascii photos';



class HomePage extends StatelessWidget{


  Widget _homeWidget() {
    return Builder(
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.80,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Card(
              color: Color(0xFF5B84C4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Image(
                          key: Key('cameraImage'),
                          image: image,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(title,
                          key: Key('title'),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(caption,
                        key: Key('caption'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
                }),
            IconButton(icon: Icon(Icons.camera),
                onPressed: () {
                  Navigator.pushNamed(context, '/camera');
                }),
            IconButton(icon: Icon(Icons.storage_rounded),
              onPressed: () {
              Navigator.pushNamed(context, '/email');
              },)
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Welcome To Asciify'),
      ),
      body: _homeWidget(),
      );
  }

}


