import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'helper.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _selectedImage;
  Helper helper = Helper();
  List<dynamic> resultBoxes = [];
  List<String> resultNames = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "lib/assets/background.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Image Preview
            if (_selectedImage != null)
              Positioned.fill(
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            // Back Button
            Positioned(
              top: 45,
              left: 15,
              child: GestureDetector(
                onTap: backButtonPress,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            // Other Widgets
            Positioned(
              top: size.height * 2 / 3,
              left: 0,
              right: 0,
              height: size.height / 3,
              child: Center(
                // Fixed typo here
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow),
                  ),
                  child: const Text('Select Image',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            if (resultBoxes.isNotEmpty)
              ...displayBoxesAroundRecognizedObjects(size),
          ],
        ),
      ),
    );
  }

  // Function to open the image picker
  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      uploadImageToApi(File(pickedFile.path));
    }
  }

  void backButtonPress() async {
    final url = Uri.parse('http://9a25-35-237-195-154.ngrok.io/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('HTTP Request Successful');
    } else {
      print('HTTP Request Failed');
    }
    Navigator.of(context).pop();
  }

  void uploadImageToApi(File imageFile) async {
    final url =
        Uri.parse('http://9a25-35-237-195-154.ngrok.io/uploadByGallery');

    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(responseBody);
      print(responseData);
      String speech = responseData['speech'];
      List<dynamic> boxes = responseData['boxes'];
      List<String> names = responseData['names'].cast<String>();
      setState(() {
        resultBoxes = boxes.map((box) {
          return List<double>.from(box.cast<double>());
        }).toList();
        resultNames = names;
      });
      await helper.speak(speech);
    } else {
      // Handle error
      print('Error uploading image');
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (resultNames.isEmpty) return [];

    double widthScaleFactor = 1;
    double heightScaleFactor = 1;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return resultBoxes.map((result) {
      List<double> box = result;
      double x = box[0];
      double y = box[1];
      double width = box[2];
      double height = box[3];

      // Calculate the position and size of the bounding box based on the scaling factors
      double left = (x - width / 2) * widthScaleFactor;
      double top = (y - height / 2) * heightScaleFactor;
      double boxWidth = width * widthScaleFactor;
      double boxHeight = height * heightScaleFactor;
      return Positioned(
        left: left,
        top: top,
        width: boxWidth,
        height: boxHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${resultNames[resultBoxes.indexOf(result)]}",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
