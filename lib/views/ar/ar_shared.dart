// import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

// class ARShared extends StatefulWidget {
//   const ARShared({super.key});
//   @override
//   State<ARShared> createState() => _ARSharedState();
// }

// class _ARSharedState extends State<ARShared> {
//   String _platformVersion = 'Unknown';
//   static const String _title = 'AR Plugin Demo';

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await ArFlutterPlugin.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(_title),
//         ),
//         body: Column(children: [
//           Text('Running on: $_platformVersion\n'),
//           const Expanded(
//             child: ExampleList(),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class ExampleList extends StatelessWidget {
//   const ExampleList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final examples = [
//       Example(
//           'Debug Options',
//           'Visualize feature points, planes and world coordinate system',
//           () => Navigator.push(context,
//               MaterialPageRoute(builder: (context) => DebugOptionsWidget()))),
//       // Example(
//       //     'Local & Online Objects',
//       //     'Place 3D objects from Flutter assets and the web into the scene',
//       //     () => Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //             builder: (context) => LocalAndWebObjectsWidget()))),
//       // Example(
//       //     'Anchors & Objects on Planes',
//       //     'Place 3D objects on detected planes using anchors',
//       //     () => Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //             builder: (context) => ObjectsOnPlanesWidget()))),
//       // Example(
//       //     'Object Transformation Gestures',
//       //     'Rotate and Pan Objects',
//       //     () => Navigator.push(context,
//       //         MaterialPageRoute(builder: (context) => ObjectGesturesWidget()))),
//       // Example(
//       //     'Screenshots',
//       //     'Place 3D objects on planes and take screenshots',
//       //     () => Navigator.push(context,
//       //         MaterialPageRoute(builder: (context) => ScreenshotWidget()))),
//       // Example(
//       //     'Cloud Anchors',
//       //     'Place and retrieve 3D objects using the Google Cloud Anchor API',
//       //     () => Navigator.push(context,
//       //         MaterialPageRoute(builder: (context) => CloudAnchorWidget()))),
//       // Example(
//       //     'External Model Management',
//       //     'Similar to Cloud Anchors example, but uses external database to choose from available 3D models',
//       //     () => Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //             builder: (context) => ExternalModelManagementWidget())))
//     ];
//     return ListView(
//       children:
//           examples.map((example) => ExampleCard(example: example)).toList(),
//     );
//   }
// }

// class ExampleCard extends StatelessWidget {
//   const ExampleCard({super.key, required this.example});
//   final Example example;

//   @override
//   build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         splashColor: Colors.blue.withAlpha(30),
//         onTap: () {
//           example.onTap();
//         },
//         child: ListTile(
//           title: Text(example.name),
//           subtitle: Text(example.description),
//         ),
//       ),
//     );
//   }
// }

// class Example {
//   const Example(this.name, this.description, this.onTap);
//   final String name;
//   final String description;
//   final Function onTap;
// }

// class DebugOptionsWidget extends StatefulWidget {
//   DebugOptionsWidget({Key? key}) : super(key: key);
//   @override
//   _DebugOptionsWidgetState createState() => _DebugOptionsWidgetState();
// }

// class _DebugOptionsWidgetState extends State<DebugOptionsWidget> {
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;
//   bool _showFeaturePoints = false;
//   bool _showPlanes = false;
//   bool _showWorldOrigin = false;
//   bool _showAnimatedGuide = true;
//   String _planeTexturePath = "Images/triangle.png";
//   bool _handleTaps = false;

//   @override
//   void dispose() {
//     super.dispose();
//     arSessionManager!.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Debug Options'),
//         ),
//         body: Container(
//             child: Stack(children: [
//           ARView(
//             onARViewCreated: onARViewCreated,
//             planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//             showPlatformType: true,
//           ),
//           Align(
//             alignment: FractionalOffset.bottomRight,
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.5,
//               color: Color(0xFFFFFFF).withOpacity(0.5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SwitchListTile(
//                     title: const Text('Feature Points'),
//                     value: _showFeaturePoints,
//                     onChanged: (bool value) {
//                       setState(() {
//                         _showFeaturePoints = value;
//                         updateSessionSettings();
//                       });
//                     },
//                   ),
//                   SwitchListTile(
//                     title: const Text('Planes'),
//                     value: _showPlanes,
//                     onChanged: (bool value) {
//                       setState(() {
//                         _showPlanes = value;
//                         updateSessionSettings();
//                       });
//                     },
//                   ),
//                   SwitchListTile(
//                     title: const Text('World Origin'),
//                     value: _showWorldOrigin,
//                     onChanged: (bool value) {
//                       setState(() {
//                         _showWorldOrigin = value;
//                         updateSessionSettings();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ])));
//   }

//   void onARViewCreated(
//       ARSessionManager arSessionManager,
//       ARObjectManager arObjectManager,
//       ARAnchorManager arAnchorManager,
//       ARLocationManager arLocationManager) {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;

//     this.arSessionManager!.onInitialize(
//           showFeaturePoints: _showFeaturePoints,
//           showPlanes: _showPlanes,
//           customPlaneTexturePath: _planeTexturePath,
//           showWorldOrigin: _showWorldOrigin,
//           showAnimatedGuide: _showAnimatedGuide,
//           handleTaps: _handleTaps,
//         );
//     this.arObjectManager!.onInitialize();
//   }

//   void updateSessionSettings() {
//     this.arSessionManager!.onInitialize(
//           showFeaturePoints: _showFeaturePoints,
//           showPlanes: _showPlanes,
//           customPlaneTexturePath: _planeTexturePath,
//           showWorldOrigin: _showWorldOrigin,
//         );
//   }
// }
