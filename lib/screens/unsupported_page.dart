import 'package:flutter/material.dart';

class UnsupportedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Text("Sorry, this Application is not supported for your device.",
              key: Key('unsupportedCaption'),
              textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
