import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


final ImageProvider image = AssetImage('assets/camera.png');
final String title = "ASCIIFY";
final String caption = 'Turn your regular photos into Ascii photos';



class HomePage extends StatelessWidget{

  Widget _homePortrait(BuildContext homeContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(homeContext).size.width * 0.80,
          height: MediaQuery.of(homeContext).size.height * 0.70,
          child: Card(
            color:  Color(0xFF5B84C4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Image(
                      image: image,
                      width: MediaQuery.of(homeContext).size.width * 0.55,
                      height: MediaQuery.of(homeContext).size.height * 0.45,
                    )
                ),
                Container(
                  child: Text(title,
                    style: Theme.of(homeContext).textTheme.headline1,
                  ),
                ),
                Container(
                  child: Text(caption,
                    style: Theme.of(homeContext).textTheme.headline2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: image,
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.height * 0.30,
                    ),
                    Text(title,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Expanded(
                      child: Text(caption,
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
              onPressed: () {},)
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
  // @override
  // void initState(){
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  // }


}


