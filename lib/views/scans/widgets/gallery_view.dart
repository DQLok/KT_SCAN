// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kt_scan_text/views/home/home.dart';
import 'package:kt_scan_text/views/result_filter/result_filter.dart';
import 'package:kt_scan_text/views/result_filter/widgets/camera_customer.dart';

class GalleryView extends StatefulWidget {
  GalleryView({
    Key? key,
    required this.title,
    this.text,
    this.blocks,
    required this.onImage,
    required this.onDetectorViewModeChanged,
    required this.fileImage,
    required this.saveData,
    required this.viewDetail,
  }) : super(key: key);

  final String title;
  final String? text;
  final Widget? blocks;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;
  final XFile fileImage;
  final Function() saveData;
  final Function() viewDetail;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;

  @override
  void initState() {
    super.initState();

    // _imagePicker = ImagePicker();
    // _getImage(ImageSource.camera);

    processFilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: _galleryBody());
  }

  Widget _galleryBody() {
    double paddingV = MediaQuery.viewPaddingOf(context).vertical;
    double paddingH = MediaQuery.viewPaddingOf(context).horizontal;
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                          alignment: Alignment.topLeft,
                          onPressed: () => _getImage(ImageSource.camera),
                          icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                              ))),
                    ),
                    Expanded(
                      child: Text(
                        "Bill xử lý",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                
                _image != null
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.amber),
                                  image: DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.fill)),
                              height:
                                  MediaQuery.of(context).size.height / 1.5,
                              width: MediaQuery.of(context).size.width / 1.3,
                              alignment: Alignment.center,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  // Image.file(_image!),
                                  widget.blocks == null ? SizedBox(): widget.blocks!
                                ],
                              ),
                            ) ,
                            TextButton(
                                onPressed: () {
                                  widget.viewDetail();
                                },
                                child: Text(
                                  "Xem thông tin tạm thời",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic),
                                ))
                          ],
                        ),
                      )
                    : const Icon(
                        Icons.image,
                        size: 200,
                      ) 
                      
              ],
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraCustomer()));
                      },
                      child: Text(
                        "Trở về Camera",
                        style: TextStyle(
                            color: Colors.black, fontStyle: FontStyle.normal),
                      ))),
              Expanded(child: SizedBox()),
              Expanded(
                flex: 2,
                  child: ElevatedButton(
                onPressed: () {
                  widget.saveData();
                },
                child: Text(
                  "Hoàn thành",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.normal),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent)),
              ))
            ],
          )
        ],
      ),
    );
  }

  processFilePicture() {
    if (widget.fileImage.path.isNotEmpty) {
      _processFile(widget.fileImage.path);
    }
  }

  Future _getImage(ImageSource source) async {
    // setState(() {
    _image = null;
    _path = null;
    // });
    final pickedFile = await _imagePicker?.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    _path = path;
    var inputImage = InputImage.fromFilePath(path);
    //cropper img-------
    CroppedFile? croppedFile;
    if (inputImage.filePath != null && inputImage.filePath != "") {
      croppedFile = await ImageCropper().cropImage(
          sourcePath: inputImage.filePath!,
          // maxHeight: MediaQuery.of(context).size.height ~/ 1.5,
          // maxWidth: MediaQuery.of(context).size.width ~/ 1.3,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Chọn vùng dữ liệu',
              toolbarColor: Colors.redAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
          ]);
    }
    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile!.path);
      });
      _path = path;
      inputImage = InputImage.fromFilePath(croppedFile.path);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CameraCustomer()));
    }
    widget.onImage(inputImage);
  }
}
