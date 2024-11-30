import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

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

  // Use Google ML Kit to extract text from the image
  Future<void> _scanText() async {
    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _scannedText =
            recognizedText.text.isEmpty ? "No text found" : recognizedText.text;
      });
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
