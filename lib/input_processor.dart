import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart';

class InputProcessor {
  static Future<String> processInputs(List<Map<String, dynamic>> inputs) async {
    List<String> processedTexts = [];

    for (var input in inputs) {
      switch (input['type']) {
        case 'pdf':
          processedTexts
              .add('pdf:\n${await _extractTextFromPDF(input['file'] as File)}');
          break;
        case 'docx':
          processedTexts.add(
              'docx:\n${await _extractTextFromDOCX(input['file'] as File)}');
          break;
        case 'txt':
          processedTexts
              .add('txt:\n${await _extractTextFromTXT(input['file'] as File)}');
          break;
        case 'png':
        case 'jpg':
        case 'jpeg':
          processedTexts.add(
              'image:\n${await _extractTextFromImage(input['file'] as File)}');
          break;
        case 'url':
          processedTexts.add(
              'url:\n${await _extractTextFromWebsite(input['url'] as String)}');
          break;
        case 'text':
          processedTexts.add('text:\n${input['text'] as String}');
          break;
        case 'pptx':
          processedTexts.add(
              'pptx:\n${await _extractTextFromPPTX(input['file'] as File)}');
          break;
      }
    }

    return processedTexts.join('\n\n');
  }

  static Future<String> _extractTextFromPDF(File file) async {
    PdfDocument document = PdfDocument(inputBytes: file.readAsBytesSync());
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }

  static Future<String> _extractTextFromDOCX(File file) async {
    return docxToText(await file.readAsBytes());
  }

  static Future<String> _extractTextFromTXT(File file) async {
    return await file.readAsString();
  }

  static Future<String> _extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close(); // Close the recognizer to release resources
    return recognizedText.text;
  }

  static Future<String> _extractTextFromWebsite(String url) async {
    try {
      // Fetch the webpage content
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load webpage: ${response.statusCode}');
      }

      // Parse the HTML content
      final document = parser.parse(response.body);

      // Identify relevant content elements (adjust selectors as needed)
      final contentElements = document.querySelectorAll(
          'p, h1, h2, h3, li, div'); // Include more common content elements

      // Extract and clean text from content elements
      final extractedText = contentElements
          .map((element) => element.text.trim()) // Trim whitespace
          .where((text) => text.isNotEmpty) // Remove empty strings
          .join('\n');

      // Additional text cleaning and filtering (optional)
      // - Remove stop words
      // - Remove irrelevant sections
      // - Normalize text

      return extractedText;
    } catch (e) {
      print('Error extracting text: $e');
      return ''; // Or throw a custom exception
    }
  }

  static Future<String> _extractTextFromPPTX(File file) async {
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    final slideTexts = <String>[];

    for (final file in archive) {
      if (file.name.startsWith('ppt/slides/slide') &&
          file.name.endsWith('.xml')) {
        final content = utf8.decode(file.content as List<int>);
        final document = XmlDocument.parse(content);
        final textElements = document.findAllElements('a:t');
        final slideText = textElements.map((e) => e.text).join(' ');
        slideTexts.add(slideText);
      }
    }

    return slideTexts.join('\n\n');
  }

  static Future<List<Map<String, dynamic>>> generateQuiz(String text) async {
    // TODO: Implement actual quiz generation logic
    // This is a placeholder implementation
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating network delay

    return [
      {
        'question': 'What is the capital of France?',
        'options': ['London', 'Berlin', 'Paris', 'Madrid'],
        'correctAnswer': 'Paris'
      },
      {
        'question': 'Who wrote "To Kill a Mockingbird"?',
        'options': [
          'Mark Twain',
          'Harper Lee',
          'John Steinbeck',
          'F. Scott Fitzgerald'
        ],
        'correctAnswer': 'Harper Lee'
      }
    ];
  }
}
