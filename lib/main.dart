import 'package:flutter/material.dart';
import 'package:laba5/helper_functions/download_file.dart';

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
        title: Center(child: Text('Загрузка pdf файлов')),
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
                child: Text('Скачать файл'),
              ),
              if (_isLoading) ...{
                SizedBox(
                  height: 8,
                ),
                Text('Загрузка файла: $_progressValue')
              },
              if (_isError) ...{
                SizedBox(height: 8,),
                Text('Указанный файл не найден!')
              },
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Скачанные файлы'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
