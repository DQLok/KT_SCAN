import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:techable/objects/text_group.dart';
import 'package:techable/views/scans/widgets/camera_view.dart';
import 'package:techable/views/scans/widgets/gallery_view.dart';

enum DetectorViewMode { liveFeed, gallery }

class DetectorView extends StatefulWidget {
  const DetectorView(
      {super.key,
      required this.title,
      required this.onImage,
      this.customPaint,
      this.text,
      this.blocks,
      this.initialDetectionMode = DetectorViewMode.liveFeed,
      this.initialCameraLensDirection = CameraLensDirection.back,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      required this.fileImage,
      required this.saveData,
      required this.viewDetail,
      required this.listTextGroup,
      required this.listKeyValues,
      required this.listStandardAngle});

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Widget? blocks;
  final DetectorViewMode initialDetectionMode;
  final Function(InputImage inputImage) onImage;
  final Function()? onCameraFeedReady;
  final Function(DetectorViewMode mode)? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final XFile fileImage;
  final Function() saveData;
  final Function() viewDetail;
  //----
  final List<TextGroup> listTextGroup;
  final List<KeyValueFilter> listKeyValues;
  final List<TextGroup> listStandardAngle;

  @override
  State<DetectorView> createState() => _DetectorViewState();
}

class _DetectorViewState extends State<DetectorView> {
  late DetectorViewMode _mode;

  @override
  void initState() {
    _mode = widget.initialDetectionMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _mode == DetectorViewMode.gallery
        ? CameraView(
            customPaint: widget.customPaint,
            onImage: widget.onImage,
            onCameraFeedReady: widget.onCameraFeedReady,
            onDetectorViewModeChanged: _onDetectorViewModeChanged,
            initialCameraLensDirection: widget.initialCameraLensDirection,
            onCameraLensDirectionChanged: widget.onCameraLensDirectionChanged,
          )
        : GalleryView(
            title: widget.title,
            text: widget.text,
            onImage: widget.onImage,
            onDetectorViewModeChanged: _onDetectorViewModeChanged,
            blocks: widget.blocks,
            fileImage: widget.fileImage,
            saveData: widget.saveData,
            viewDetail: widget.viewDetail,
            listTextGroup: widget.listTextGroup,
            listKeyValues: widget.listKeyValues,
            listStandardAngle: widget.listStandardAngle,
          );
  }

  void _onDetectorViewModeChanged() {
    if (_mode == DetectorViewMode.liveFeed) {
      _mode = DetectorViewMode.gallery;
    } else {
      _mode = DetectorViewMode.liveFeed;
    }
    if (widget.onDetectorViewModeChanged != null) {
      widget.onDetectorViewModeChanged!(_mode);
    }
    setState(() {});
  }
}
