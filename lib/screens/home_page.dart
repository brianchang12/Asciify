import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


final ImageProvider image = AssetImage('assets/camera.png');
final String title = "ASCIIFY";
final String caption = 'Turn your regular photos into Ascii photos';



class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
              onPressed: () {},)
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Welcome To Asciify'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return HomePortrait();
          } else {
            return HomeLandscape();
          }
        },
      ),
    );
  }
}



class HomeLandscape extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200.0,
          height: 250.0,
          child: Card(
          ),
        )
      ],
    );
  }
}

class HomePortrait extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Container(
            width: 400.0,
            height: 435.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Image(
                        image: image,
                        width: 250.0,
                        height: 250.0,
                      )
                  ),
                  Container(
                    child: Text(title,
                      style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  Container(
                    child: Text(caption,
                    style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
