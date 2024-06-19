import 'dart:developer'; // Import for logging
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'response.dart'; // Import the ResponseScreen

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  XFile? _image;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      ImageCropper cropper = ImageCropper();
      final croppedImage = await cropper.cropImage(
        sourcePath: image.path,
      );
      setState(() {
        _image = croppedImage != null ? XFile(croppedImage.path) : null;
      });
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    try {
      final imageBytes = await _image!.readAsBytes();
      final gemini = Gemini.instance;

      final response = await gemini.textAndImage(
        text:
            "analyze the ingredients from this image and find how healthy the food item is and give a score for it out of 10 and also the approximate % of ingredients used and its common name.Structure the response as Name: Score: Ingredients:(% of ingredients)  Additional Info:(all other information).There should be subheading, and should leave one line",
        images: [imageBytes],
      );

      // Concatenate all parts of the response to form a complete output
      final responseText =
          response?.content?.parts?.map((part) => part.text).join('\n') ??
              'No response content';

      // Navigate to ResponseScreen with the responseText
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResponseScreen(responseText: responseText),
        ),
      );
    } catch (e) {
      log('Error during image upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Capture Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _image != null ? uploadImage : null,
              child: const Text('Upload Image'),
            ),
            if (_image != null)
              Image.file(File(_image!.path)), // Display the image if it exists
          ],
        ),
      ),
    );
  }
}
