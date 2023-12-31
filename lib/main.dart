

import 'package:flutter/material.dart';
import 'package:laba5/helper_functions/download_file.dart';
import 'package:laba5/pages/downloaded_files_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentId = '';
  var _isLoading = false;
  var _progressValue = '';
  var _isError = false;
  var isHintNeeded = false;
  var _dontShowAnymore = false;

  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    Future((){
    readIsHintNeeded();
    });
  }

  void readIsHintNeeded() async {
    preferences = await SharedPreferences.getInstance();
    final showHint = preferences!.getBool("showHint");
    if(showHint == null) {
      if(mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text(
                    'Для скачивания pdf файла введите его id и нажмите кнопку "Скачать файл"'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        preferences!.setBool("showHint", true);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Больше не показывать'))
                ],
              );
            });
      }
    }
  }


  void showProgress(String progress) {
    setState(() {
      _progressValue = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Загрузка pdf файлов')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) => _currentId = value.trim(),
                decoration: InputDecoration(
                    hintText: "Id документа",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_isLoading) {
                    setState(() {
                      _isError = false;
                      _isLoading = true;
                    });
                    try {
                      await download(
                        url: 'https://ntv.ifmo.ru/file/journal/$_currentId.pdf',
                        filename: '${_currentId}article.pdf',
                        onProgressChange: (progressValue) =>
                            showProgress(progressValue),
                        onDownloadEnd: () {
                          setState(() {
                            _isLoading = false;
                            _progressValue = '';
                          });
                        },
                      );
                    } catch (exception) {
                      setState(() {
                        _isLoading = false;
                        _isError = true;
                      });
                    }
                  }
                },
                child: const Text('Скачать файл'),
              ),
              if (_isLoading) ...{
                const SizedBox(
                  height: 8,
                ),
                Text('Загрузка файла: $_progressValue')
              },
              if (_isError) ...{
                const SizedBox(
                  height: 8,
                ),
                const Text('Указанный файл не найден!')
              },
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DownloadedFilesPage()));
                },
                child: const Text('Скачанные файлы'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
