import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
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
      title: 'Adapt Android 13',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adapt Android 13'),
      ),
      body: _filepath != null
          ? Center(
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
                      onPressed: sendMessage,
                      // onPressed: () {
                      //   shareWhatsapp.share(
                      //       text: 'hiiii safi',
                      //       phone: '+917868920541',
                      //       file: XFile(_filepath!));
                      // },
                      child: Text("Whatsapp"))
                ],
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

  void sendMessage() async {
    await WhatsAppSenderFlutter.send(
      phones: ["917868920541", "919842068520"],
      message: "Hello",
      file: File("path-to-file.pdf"),
      onEvent: (WhatsAppSenderFlutterStatus status) {
        print(status);
      },
      onQrCode: (String qrCode) {
        print(qrCode);
      },
      onSending: (WhatsAppSenderFlutterCounter counter) {
        print(counter.success.toString());
        print(counter.fails.toString());
      },
      onError: (WhatsAppSenderFlutterErrorMessage errorMessage) {
        print(errorMessage);
      },
    );
    // await WhatsAppSenderFlutter.send(
    //   phones: ["917868920541", "919842068520"],
    //   message: "Hello",
    // );
  }

  Future<void> _pickFile() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> statusess;

    if (androidInfo.version.sdkInt <= 32) {
      statusess = await [
        Permission.storage,
      ].request();
    } else {
      statusess = await [Permission.photos, Permission.notification].request();
    }

    var allAccepted = true;
    statusess.forEach((permission, status) {
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
