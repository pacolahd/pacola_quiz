import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/common/widgets/theme_toggle_dropdown.dart';

import 'input_processor.dart';

class QuizGenerationScreen extends StatefulWidget {
  const QuizGenerationScreen({Key? key}) : super(key: key);

  @override
  _QuizGenerationScreenState createState() => _QuizGenerationScreenState();
}

class _QuizGenerationScreenState extends State<QuizGenerationScreen> {
  List<Map<String, dynamic>> inputData = [];
  TextEditingController urlController = TextEditingController();
  TextEditingController textInputController = TextEditingController();

  Future<void> _pickFile(String fileType) async {
    List<String> allowedExtensions;
    if (fileType == 'image') {
      allowedExtensions = ['png', 'jpg', 'jpeg'];
    } else {
      allowedExtensions = [fileType];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String actualFileType =
          result.files.single.extension?.toLowerCase() ?? fileType;
      setState(() {
        inputData.add({
          'type': actualFileType,
          'file': file,
          'name': result.files.single.name,
        });
      });
    }
  }

  void _addUrl() {
    if (urlController.text.isNotEmpty) {
      setState(() {
        inputData.add({
          'type': 'url',
          'url': urlController.text,
        });
        urlController.clear();
      });
    }
  }

  void _addText() {
    if (textInputController.text.isNotEmpty) {
      setState(() {
        inputData.add({
          'type': 'text',
          'text': textInputController.text,
        });
        textInputController.clear();
      });
    }
  }

  //---------------------------------------------------

  void showScrollableSnackbar(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: SingleChildScrollView(
            child: Text(text),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //--------------------------------------------------

  void _removeInput(int index) {
    setState(() {
      inputData.removeAt(index);
    });
  }

  void _generateQuiz() async {
    if (inputData.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      String combinedText = await InputProcessor.processInputs(inputData);
      List<Map<String, dynamic>> quiz =
          await InputProcessor.generateQuiz(combinedText);

      Navigator.of(context).pop(); // Dismiss the loading indicator

      // TODO: Navigate to a new screen to display the generated quiz
      showScrollableSnackbar(context, combinedText);
      print('Quiz generated: $combinedText');
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating quiz: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ThemeToggle(),
              const Text(
                'Add your study materials:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickFile('pptx'),
                    child: const Text('Add PowerPoint'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickFile('pdf'),
                    child: const Text('Add PDF'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickFile('docx'),
                    child: const Text('Add DOCX'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickFile('txt'),
                    child: const Text('Add TXT'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickFile('image'),
                    child: const Text('Add Image'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        hintText: 'Enter URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addUrl,
                    child: const Text('Add URL'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: TextField(
                  controller: textInputController,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    hintText: 'Enter text',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addText,
                child: const Text('Add Text'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Added Materials:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: inputData.length,
                  itemBuilder: (context, index) {
                    final item = inputData[index];
                    return ListTile(
                      title: Text(item['type'] == 'url'
                          ? item['url'] as String
                          : item['type'] == 'text'
                              ? 'Text Input'
                              : item['name'] as String),
                      subtitle: Text(item['type'] as String),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeInput(index),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                // onPressed: () {
                //   if (inputData.isNotEmpty) {
                //     _extractTextFromTXT(inputData[0]['file']);
                //     textInputController.text = _extractedText;
                //     setState(() {});
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content:
                //             SingleChildScrollView(child: Text(_extractedText)),
                //       ),
                //     );
                //   }
                //   else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           content: Text('Please add some study materials')),
                //     );
                //   }
                // },
                onPressed: inputData.isNotEmpty ? _generateQuiz : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Generate Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
