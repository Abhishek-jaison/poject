import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/widgets/shimmer.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/voice_recorder_widget.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? imagePath;
  String? voicePath;
  final TextEditingController descriptionController = TextEditingController();

  void uploadPost() async {
    if (imagePath == null ||
        voicePath == null ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please provide all inputs")));
      return;
    }

    // Show a loading indicator
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Uploading...")));

    // Simulate an upload process (replace this with your actual backend call)
    await Future.delayed(Duration(seconds: 2)); // Simulate a 2-second delay

    // Show success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Uploaded Successfully!")));

    // Navigate back only if there is a previous screen
    // if (Navigator.of(context).canPop()) {
    //   Navigator.pop(context);
    // } else {
    //   // If there is no previous screen, show a message or handle it differently
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("No previous screen to return to")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints
                          .maxHeight, // Ensure the Column takes the full height
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround, // Space between widgets
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ImagePickerWidget(
                                onImagePicked:
                                    (path) => setState(() => imagePath = path),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Placeholder or Image Container
                        Container(
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                imagePath == null
                                    ? Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1,
                                    )
                                    : null,
                            boxShadow:
                                imagePath != null
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                    : null,
                          ),
                          child:
                              imagePath != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(
                                        imagePath!,
                                      ), // Display the selected image
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  )
                                  : ShimmerPlaceholder(),
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.2,
                                ), // Shadow color
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ), // Inner padding
                          child: TextField(
                            style: TextStyle(color: Colors.grey[500]),
                            controller: descriptionController,
                            maxLines: null, // Allows multiple lines
                            minLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: "Enter Description...",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none, // Removes the border
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Center(
                          child: VoiceRecorderWidget(
                            onRecordingDone:
                                (path) => setState(() => voicePath = path),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: uploadPost,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                    0xFFE6BFFF,
                                  ), // Change this to your preferred color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // Smaller radius
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ), // Adjust padding
                                ),
                                child: Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ), // Adjust text color
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
