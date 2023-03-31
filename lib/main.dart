import 'dart:io';
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_to_whatsapp/whatsapp_share.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:whatsapp_ckeckup/shareWhatsapp.dart';
import 'package:whatsapp_sender_flutter/whatsapp_sender_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _filepath;
  String mobileNumber = '+917010779720';
  // AppinioSocialShare appinioSocialShare = AppinioSocialShare();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whatsapp Check'),
      ),
      body: _filepath != null
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 250.0,
                      height: 250.0,
                      child: Image.file(File(_filepath!)),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          shareWhatsapp.share(
                              text: 'hello ',
                              phone: mobileNumber,
                              file: XFile(_filepath!));
                        },
                        child: const Text("share_whatsapp")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        // onPressed:
                        // sendMessage,
                        onPressed: () async {
                          //   FlutterOpenWhatsapp.sendSingleMessage(
                          //       mobileNumber, "Hello");
                        },
                        child: const Text("open_whatsapp")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        // onPressed:
                        // sendMessage,
                        onPressed: () async {
                          shareWhatsapp.share(
                              text: 'hiii',
                              file: XFile(_filepath!),
                              phone: mobileNumber);
                        },
                        child: const Text("Share Whatsapp")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        // onPressed:
                        // sendMessage,
                        onPressed: () async {
                          await WhatsAppSenderFlutter.send(
                            phones: [mobileNumber],
                            message: "Hello",
                            file: File(_filepath!),
                          );
                        },
                        child: const Text("Whatsapp sender Flutter")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        // onPressed:
                        // sendMessage,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                        },
                        child: const Text("To Direct Message")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        // onPressed:
                        // sendMessage,
                        onPressed: () async {
                          await WhatsappShare.shareFile(
                            text: 'Whatsapp share text',
                            phone: mobileNumber,
                            filePath: [_filepath!, _filepath!],
                          );
                        },
                        child: const Text("Share to whatsapp")),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStateProperty.all(Colors.green)),
                    //     // onPressed:
                    //     // sendMessage,
                    //     onPressed: () {
                    //       shareWhatsapp.share(
                    //           text: 'hello ',
                    //           phone: mobileNumber,
                    //           file: XFile(_filepath!));
                    //     },
                    //     child: const Text("Whatsapp")),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStateProperty.all(Colors.green)),
                    //     // onPressed:
                    //     // sendMessage,
                    //     onPressed: () {
                    //       shareWhatsapp.share(
                    //           text: 'hello ',
                    //           phone: mobileNumber,
                    //           file: XFile(_filepath!));
                    //     },
                    //     child: const Text("Whatsapp")),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStateProperty.all(Colors.green)),
                    //     // onPressed:
                    //     // sendMessage,
                    //     onPressed: () {
                    //       shareWhatsapp.share(
                    //           text: 'hello ',
                    //           phone: mobileNumber,
                    //           file: XFile(_filepath!));
                    //     },
                    //     child: const Text("Whatsapp")),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStateProperty.all(Colors.green)),
                    //     // onPressed:
                    //     // sendMessage,
                    //     onPressed: () {
                    //       shareWhatsapp.share(
                    //           text: 'hello ',
                    //           phone: mobileNumber,
                    //           file: XFile(_filepath!));
                    //     },
                    //     child: const Text("Whatsapp")),
                    Text("Nearly 6 packages not working")
                  ],
                ),
              ),
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        tooltip: 'Pick image',
        child: const Icon(Icons.add),
      ),
    );
  }

  snackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickFile() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final Map<Permission, PermissionStatus> statuses;

    if (androidInfo.version.sdkInt <= 32) {
      statuses = await [
        Permission.storage,
      ].request();
    } else {
      statuses = await [Permission.photos, Permission.notification].request();
    }

    var allAccepted = true;
    statuses.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (allAccepted) {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      final path = result?.files.single.path;

      if (path != null) {
        setState(() {
          _filepath = path;
        });
      }
    }
  }
}
