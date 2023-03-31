import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:direct_whatsapp/direct_whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScreenshotController controller = ScreenshotController();
  ScreenshotController controller1 = ScreenshotController();
  ScreenshotController controller2 = ScreenshotController();

  TextEditingController textController =
      TextEditingController(text: "This is sample direct message");
  TextEditingController codeController = TextEditingController(text: "91");
  TextEditingController phonenoController =
      TextEditingController(text: "8626043082");

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 200,
                  height: 100,
                  child: Screenshot(
                      child: FlutterLogo(
                        textColor: Colors.green,
                        style: FlutterLogoStyle.stacked,
                      ),
                      // Image.asset("assets/img.png"),
                      controller: controller)),
              Container(
                  width: 200,
                  height: 100,
                  child: Screenshot(
                      child: FlutterLogo(
                        textColor: Colors.purple,
                        style: FlutterLogoStyle.markOnly,
                      ),
                      // Image.asset("assets/1 copy.png"),
                      controller: controller1)),
              Container(
                  width: 200,
                  height: 100,
                  child: Screenshot(
                      child: FlutterLogo(
                        textColor: Colors.red,
                        style: FlutterLogoStyle.horizontal,
                      ),
                      // Image.asset("assets/2 copy.png"),
                      controller: controller2)),
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: textController,
                ),
              ),
              Container(
                  height: 80,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 60,
                        // height: 30,
                        child: TextField(
                          controller: codeController,
                        ),
                      ),
                      Container(
                        // height: 30,
                        width: w - 100,
                        child: TextField(
                          controller: phonenoController,
                        ),
                      )
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    int countryCode = 91;
                    String phoneNo = "8626043082";
                    String message = "This is sample direct message";
                    (await DirectWhatsapp.shareTextDirectToWhatsapp(
                        countryCode, phoneNo, textController.text));
                  },
                  child: Text("Direct Message on Whatsapp")),
              TextButton(
                  onPressed: () async {
                    Uint8List? imgData = await controller.capture();
                    Directory? dir = await getApplicationSupportDirectory();
                    // getExternalStorageDirectory();
                    File file = File(dir.path + "/tempImg.png");
                    await file.writeAsBytes(imgData!);
// Share.shareFiles([file.path]);
                    // File file;
                    if (imgData != null) {
                      log("filepath ${file.path}");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("sharing image image")));
                      (await DirectWhatsapp.shareImageToWhatsApp(file.path));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("null image")));
                    }
                  },
                  child: Text("share img DirectWhatsapp.pp")),
              TextButton(
                  onPressed: () async {
                    Uint8List? imgData = await controller.capture();
                    Directory? dir = await getApplicationSupportDirectory();
                    // getExternalStorageDirectory();
                    File file = File(dir.path + "/tempImg.png");
                    await file.writeAsBytes(imgData!);

                    // File file;
                    if (imgData != null) {
                      log("filepath ${file.path}");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("sharing image image")));
                      (await DirectWhatsapp.shareImage(file.path));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("null image")));
                    }
                  },
                  child: Text("Share Image")),
              TextButton(
                  onPressed: () async {
                    Uint8List? imgData = await controller.capture();
                    Uint8List? imgData1 = await controller1.capture();
                    Uint8List? imgData2 = await controller2.capture();

                    Directory? dir = await getApplicationSupportDirectory();
                    // getExternalStorageDirectory();
                    File file = File(dir.path + "/tempImg.png");
                    await file.writeAsBytes(imgData!);
                    File file1 = File(dir.path + "/tempImg1.png");
                    await file1.writeAsBytes(imgData1!);
                    File file2 = File(dir.path + "/tempImg2.png");
                    await file2.writeAsBytes(imgData2!);

                    // File file;
                    if (imgData != null) {
                      log("filepath ${file.path}");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("sharing image image")));
                      (await DirectWhatsapp.shareMultipleImagesToWhatsApp(
                        [file.path, file1.path, file2.path],
                      ));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("null image")));
                    }
                  },
                  child: Text("share multiples DirectWhatsapp.pp")),
              TextButton(
                  onPressed: () async {
                    Uint8List? imgData = await controller.capture();
                    Uint8List? imgData1 = await controller1.capture();
                    Uint8List? imgData2 = await controller2.capture();

                    Directory? dir = await getApplicationSupportDirectory();

                    File file = File(dir.path + "/tempImg.png");
                    await file.writeAsBytes(imgData!);
                    File file1 = File(dir.path + "/tempImg1.png");
                    await file1.writeAsBytes(imgData1!);
                    File file2 = File(dir.path + "/tempImg2.png");
                    await file2.writeAsBytes(imgData2!);

                    // File file;
                    if (imgData != null) {
                      log("filepath ${file.path}");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("sharing image image")));
                      (await DirectWhatsapp.shareMultipleImages(
                        [file.path, file1.path, file2.path],
                      ));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("null image")));
                    }
                  },
                  child: Text("share multiples images"))
            ],
          ),
        ),
      ),
    );
  }
}
