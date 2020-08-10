import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopicker/photopicker.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '图片分享',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _file;
  bool _registerWXSuccess = false;
  bool _installWXSuccess = false;

  @override
  void initState() {
    super.initState();
    _initWX();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片分享'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () async {
              final photoFile = await PhotoPicker.pickPhoto();
              print('photoFile : $photoFile');
              setState(() {
                _file = photoFile;
              });
            },
          ),
        ],
      ),
      body: _file == null
          ? Center(
              child: Text('选择图片分享'),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!_installWXSuccess || !_registerWXSuccess)
                    Card(
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text('微信未安装或注册失败'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () => shareImageToWeChat,
                    child: Text('分享图片到微信'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: Card(
                      child: Image.file(_file),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _initWX() async {
    _registerWXSuccess = await registerWxApi(
      appId: "wxd930ea5d5a258f4f",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://",
    );
    _installWXSuccess = await isWeChatInstalled;
  }

  Future<void> shareImageToWeChat() async {
    print('shareImageToWeChat');
    if (!_registerWXSuccess || !_installWXSuccess) return;
    await shareToWeChat(
      WeChatShareImageModel(
        WeChatImage.file(_file),
      ),
    );
  }
}
