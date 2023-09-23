import 'dart:io';
import 'package:codefury/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MLModel extends StatefulWidget {
  const MLModel({super.key});

  @override
  State<MLModel> createState() => _MLModelState();
}

class _MLModelState extends State<MLModel> {
  bool _loading = false; // Changed initial loading state to false
  bool _imageSelected = false; // Added image selection state
  File? _image;
  List? _output;
  final picker = ImagePicker();
  List<String> _topClasses = [];
  List<double> _topClassProbabilities = [];

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  // Add a method to reset image selection
  void resetImageSelection() {
    setState(() {
      _imageSelected = false;
      _image = null;
      _output = null;
      _topClasses.clear();
      _topClassProbabilities.clear();
    });
  }

  classfiyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      asynch: true,
    );
    output!.sort((a, b) => b['confidence'].compareTo(a['confidence']));

    setState(() {
      _output = output;
      _loading = false;
      _topClasses = output!
          .map<String>((result) => result['label'] as String)
          .take(2) // Get the top two classes
          .toList();
      _topClassProbabilities = output!
          .map<double>((result) => (result['confidence'] as double) * 100)
          .take(2) // Get the top two probabilities
          .toList();
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  closeModel() async {
    await Tflite.close();
  }

  @override
  void dispose() {
    super.dispose();
    closeModel();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
      _imageSelected = true; // Set image selection to true
    });

    classfiyImage(_image!);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
      _imageSelected = true; // Set image selection to true
    });

    classfiyImage(_image!);
  }

  reset() {
    setState(() {
      _loading = true;
      _image = null;
      _output = null;
      _topClasses.clear();
      _topClassProbabilities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = 200.0.w; // Define button width
    final double buttonHeight = 50.0.h; // Define button height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        title: Text('Facial Health Detector'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0.w,
              vertical: 16.0.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'How is your facial health now ???',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 70.0.h),

                // Conditionally display a prompt to select an image
                if (!_imageSelected)
                  Text(
                    'Please select an image to classify:',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 40.0.h),

                // Display the selected image and classification results
                if (_imageSelected)
                  _image == null
                      ? Placeholder(
                    fallbackHeight: 200.h,
                    fallbackWidth: 200.h,
                  )
                      : Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.file(_image!),
                  ),
                SizedBox(height: 16.0.h),

                // Display loading indicator or classification results
                if (_loading)
                  CircularProgressIndicator()
                else if (_output != null)
                  Column(
                    children: [
                      Text(
                        "Top Classes:",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8.0.h),
                      for (int i = 0; i < _topClasses.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${_topClasses[i]} - ",
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                            Text(
                              "Probability: ${_topClassProbabilities[i].toStringAsFixed(2)}%",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 20.0.w),
                          ],
                        ),
                    ],
                  ),
                SizedBox(height: 16.0.h),

                // Display buttons to take a photo, select from gallery, and reset
                ElevatedButton(
                  onPressed: () {
                    if (!_loading) {
                      resetImageSelection(); // Reset image selection
                      pickImage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    minimumSize: Size(buttonWidth, buttonHeight), // Set button size
                    elevation: 3.0,
                  ),
                  child: Text('Take a Photo'),
                ),
                SizedBox(height: 16.0.h),
                ElevatedButton(
                  onPressed: () {
                    if (!_loading) {
                      resetImageSelection(); // Reset image selection
                      pickGalleryImage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    minimumSize: Size(buttonWidth, buttonHeight), // Set button size
                    elevation: 3.0,
                  ),
                  child: Text('Gallery'),
                ),
                SizedBox(height: 16.0.h),
                ElevatedButton(
                  onPressed: () {
                    resetImageSelection(); // Reset image selection
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    minimumSize: Size(buttonWidth, buttonHeight), // Set button size
                    elevation: 3.0,
                  ),
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
