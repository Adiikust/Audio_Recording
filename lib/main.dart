import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('voiceRecordingsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recorder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RecordingScreen(),
    );
  }
}

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final voiceRecordingsBox = Hive.box('voiceRecordingsBox');
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = " ";

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
  }

  @override
  void dispose() {
    super.dispose();
    audioRecord.dispose();
    audioPlayer.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e, stackTrace) {
      print('Error Start Recording::::::: $e');
      print('Stack Trace:::::::>>>>>>> $stackTrace');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
        voiceRecordingsBox.add(audioPath);
      });
    } catch (e) {
      print('Error stop Recording $e');
    }
  }

  // Future<void> playRecording({required String  audioPath1}) async {
  //   try {
  //     Source urlSource = UrlSource(audioPath1);
  //     await audioPlayer.play(urlSource);
  //     //print('Hive Playing Recording ${voiceRecordingsBox.values.cast<String>().toList().toString()}');
  //   } catch (e) {
  //     print('Error Playing Recording $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final voiceRecordings = voiceRecordingsBox.values.cast<String>().toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: voiceRecordings.length != 0
          ? ListView.builder(
              itemCount: voiceRecordings.length,
              itemBuilder: (context, index) {
                final filePath = voiceRecordings[index];
                return ListTile(
                  title: Text('Voice Recording $index'),
                  onTap: () {},
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.play_circle,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            try {
                              Source urlSource = UrlSource(filePath);
                              await audioPlayer.play(urlSource);
                            } catch (e) {
                              print('Error Playing Recording $e');
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            try {
                              voiceRecordingsBox.deleteAt(index).then((value) {
                                const snackBar = SnackBar(
                                  content: Text('Delete Voice Message'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                setState(() {});
                              });
                            } catch (e) {
                              print('Error Playing Recording $e');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              })
          : const Center(child: Text(" Empty Data")),
      floatingActionButton: ElevatedButton(
        onPressed: isRecording ? stopRecording : startRecording,
        child: isRecording
            ? const Text("Stop Recording")
            : const Text("Start Recording"),
      ),
    );
  }
}
