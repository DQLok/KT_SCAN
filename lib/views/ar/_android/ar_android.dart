// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
//     show ArCoreController;

// class ARAndroid extends StatefulWidget {
//   const ARAndroid({super.key});

//   @override
//   _ARAndroidState createState() => _ARAndroidState();
// }

// class _ARAndroidState extends State<ARAndroid> {
//   ArCoreController? arCoreController;

//   @override
//   void initState() {
//     super.initState();
//     getI();
//   }

//   getI() async {
//     print('ARCORE IS AVAILABLE?');
//     print(await ArCoreController.checkArCoreAvailability());
//     print('\nAR SERVICES INSTALLED?');
//     print(await ArCoreController.checkIsArCoreInstalled());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: ArCoreView(
//           key: Key("value"),
//           onArCoreViewCreated: _onArCoreViewCreated,
//         ),
//       ),
//     );
//   }

//   void _onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;

//     _addSphere(arCoreController!);
//     _addCylindre(arCoreController!);
//     _addCube(arCoreController!);
//   }

//   void _addSphere(ArCoreController controller) {
//     final material = ArCoreMaterial(color: Color.fromARGB(120, 66, 134, 244));
//     final sphere = ArCoreSphere(
//       materials: [material],
//       radius: 0.1,
//     );
//     final node = ArCoreNode(
//       shape: sphere,
//       position: vector.Vector3(0, 0, -1.5),
//     );
//     controller.addArCoreNode(node);
//   }

//   void _addCylindre(ArCoreController controller) {
//     final material = ArCoreMaterial(
//       color: Colors.red,
//       reflectance: 1.0,
//     );
//     final cylindre = ArCoreCylinder(
//       materials: [material],
//       radius: 0.5,
//       height: 0.3,
//     );
//     final node = ArCoreNode(
//       shape: cylindre,
//       position: vector.Vector3(0.0, -0.5, -2.0),
//     );
//     controller.addArCoreNode(node);
//   }

//   void _addCube(ArCoreController controller) {
//     final material = ArCoreMaterial(
//       color: Color.fromARGB(120, 66, 134, 244),
//       metallic: 1.0,
//     );
//     final cube = ArCoreCube(
//       materials: [material],
//       size: vector.Vector3(0.5, 0.5, 0.5),
//     );
//     final node = ArCoreNode(
//       shape: cube,
//       position: vector.Vector3(-0.5, 0.5, -3.5),
//     );
//     controller.addArCoreNode(node);
//   }

//   @override
//   void dispose() {
//     arCoreController!.dispose();
//     super.dispose();
//   }
// }
