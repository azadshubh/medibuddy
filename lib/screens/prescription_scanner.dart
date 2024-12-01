import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrescriptionScanner extends StatefulWidget {
  @override
  _OcrAppState createState() => _OcrAppState();
}

class _OcrAppState extends State<PrescriptionScanner> {
  File? _imageFile;
  String _scannedText = "No text detected yet";

  final picker = ImagePicker();

  // Pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _scannedText = "Processing...";
      });
      await _scanText();
    }
  }


 //this function used to send the ocr to the backend 

Future<void> _sendToBackend(String ocrText) async {
  final url = Uri.parse('http://<your-backend-url>/process-prescription');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ocr_text': ocrText}),
    );

    if (response.statusCode == 200) {
      print("Response from backend: ${response.body}");
      setState(() {
        _scannedText = "Data successfully processed by backend!";
      });
    } else {
      print("Error: ${response.body}");
      setState(() {
        _scannedText = "Error: Failed to process data.";
      });
    }
  } catch (e) {
    print("Error sending to backend: $e");
    setState(() {
      _scannedText = "Error: Unable to connect to backend.";
    });
  }
}

  // Use Google ML Kit to extract text from the image
  Future<void> _scanText() async {
  final inputImage = InputImage.fromFilePath(_imageFile!.path);
  final textRecognizer = GoogleMlKit.vision.textRecognizer();

  try {
    final recognizedText = await textRecognizer.processImage(inputImage);
    final extractedText = recognizedText.text;

    setState(() {
      _scannedText = extractedText.isEmpty ? "No text found" : extractedText;
    });

    // Send to backend if text is recognized
    if (extractedText.isNotEmpty) {
      await _sendToBackend(extractedText);
    }
  } catch (e) {
    print("Error during text recognition: $e");
    setState(() {
      _scannedText = "Error: Unable to process the image.";
    });
  } finally {
    textRecognizer.close();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("scan your prescription here "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(child: Text("No image selected")),
                  ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _scannedText,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text("Camera"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  label: Text("Gallery"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
