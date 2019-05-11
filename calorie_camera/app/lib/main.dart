import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

import 'camera.dart';
import 'service/baidu_recognize.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(new MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      
      
      debugShowCheckedModeBanner: false,
      
      title: '卡路里相机',
      
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.yellow,
      ),
      home: new MyHomePage(title: '卡路里相机',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _childButtons = List<UnicornButton>();
  String _imagePath;
  String _result;
  String _resultcalorie;
  var _bikeca = 200;
  var _walkca = 110;
  var _swimca = 1036;
  var _runca = 700;
  var _level;

  _MyHomePageState() {
    _childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: '拍摄',
        currentButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          heroTag: "car",
          child: Icon(Icons.camera_alt),
          onPressed: () {
            Navigator
                .push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => CameraApp()))
                .then((imagePath) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => Dialog(
                  child: Container(
                    height: 100.0,
                    width: 80.0,
                    alignment: Alignment.center,
                    child:  new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new CircularProgressIndicator(),
                        SizedBox(
                          height: 12.0,
                        ),
                        new Text("Loading"),
                      ],
                    ),
                  ),
                ),
              );
              fetchCarResult(imagePath).then((entity) {
                Navigator.pop(context);
                if (entity != null) {
                  print(entity.result.first);
                  setState(() {
                    _imagePath = imagePath;
                    _result = entity.result.first.name;
                    _resultcalorie = entity.result.first.calorie;
                  });
                }
              });
            });
          },
        ),
    ));
    _childButtons.add(
      UnicornButton(
        labelText: '相册',
        hasLabel: true,
        currentButton: FloatingActionButton(
          child: Icon(Icons.filter),
          backgroundColor: Colors.white,
          mini: true,
          onPressed: () {
              getImage().then((imagePath) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => Dialog(
                  child: Container(
                    height: 100.0,
                    width: 80.0,
                    alignment: Alignment.center,
                    child:  new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new CircularProgressIndicator(),
                        SizedBox(
                          height: 12.0,
                        ),
                        new Text("Loading"),
                      ],
                    ),
                  ),
                ),
              );
              fetchCarResult(imagePath).then((entity) {
                Navigator.pop(context);
                if (entity != null) {
                  print(entity.result.first);
                  setState(() {
                    _imagePath = imagePath;
                    _result = entity.result.first.name;
                    _resultcalorie = entity.result.first.calorie;
                    if(int.parse(_resultcalorie) < 100)
                    {
                      _level = 'http://s2.boohee.cn/food/star/shucaishala-5a8e9eb8cbb4194b4afffa720d2a0bf7.png';
                    }else if(int.parse(_resultcalorie) < 200){
                      _level = 'http://s2.boohee.cn/food/star/guobaorou2-1b8f6cf4bc7d66d8fc832d1b958fc3a0.png';
                    }else{
                      _level = 'http://s2.boohee.cn/food/star/naiyoudangao-f967544d7dbb34ada7b4a5fa281660a3.png';
                    }
                    
                  });
                }
              });
            });
          },
        ),
      )
    );
  }
  @override Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // _upLoadImage(image);
    return image.path;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _imagePath == null
            ? new Center(
                child: new Text(
                  '请拍摄想要识别的图片',
                ),
              )
            : Column(
                children: <Widget>[
                  Image.file(File(_imagePath)),
                  Text("$_result", style: TextStyle(fontSize: 22.0),),
                  SizedBox(height: 5.0,),
                  Text("热量：$_resultcalorie"" 大卡（100克）", style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 10.0,),
                  Image.network(_level),
                  SizedBox(height: 10.0,),
                  Text("≈", style: TextStyle(fontSize: 30.0),),
                  SizedBox(height: 10.0,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.directions_run),
                    SizedBox(width: 5.0,),
                    Text("跑步${(int.parse(_resultcalorie)/_runca*60).toStringAsFixed(0)}""分钟", style: TextStyle(fontSize: 20.0),),
                    SizedBox(width: 25.0,),
                    Icon(Icons.directions_bike),
                    SizedBox(width: 5.0,),
                    Text("骑车${(int.parse(_resultcalorie)/_bikeca*60).toStringAsFixed(0)}""分钟", style: TextStyle(fontSize: 20.0),)
                  ],),
                  SizedBox(height: 10.0,),

                  Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.pool),
                    SizedBox(width: 5.0,),
                    Text("游泳${(int.parse(_resultcalorie)/_swimca*60).toStringAsFixed(0)}""分钟", style: TextStyle(fontSize: 20.0),),
                    SizedBox(width: 25.0,),
                    Icon(Icons.directions_walk),
                    SizedBox(width: 5.0,),
                    Text("散步${(int.parse(_resultcalorie)/_walkca*60).toStringAsFixed(0)}""分钟", style: TextStyle(fontSize: 20.0),)
                  ],),
                  SizedBox(height: 10.0,),
                
                  
                ],
              ),
      ),
      floatingActionButton: new UnicornDialer(
        hasBackground: false,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.camera_alt),
        childButtons: _childButtons,
      ),
    );
  }
}