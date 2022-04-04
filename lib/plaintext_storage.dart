import 'package:flutter/material.dart';


String newsapi_api_url = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=ae68c02ebb7544649cb91b8b6fa6effe";

// flutter run -d edge --web-renderer html // to run the app
//
// flutter build web --web-renderer html --release --base-href '/3301409_173301036/'     // to generate a production build


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'KDB',
//       theme: ThemeData(
//         primarySwatch: Colors.blueGrey,
//       ),
//       home: Beslemeler(title: 'Beslemeler'),
//     );
//   }
// }

class Beslemeler extends StatefulWidget {
  Beslemeler({Key? key, required this.title}) : super(key: key);

  final String title;
  static String? kadi = "admin";
  static String? anaparola = "demo";
  static var beslemeler = <String>[
  //"https://newsapi.org/v2/top-headlines?country=tr&apiKey=ae68c02ebb7544649cb91b8b6fa6effe",
  //"http://api.mediastack.com/v1/news?access_key=96538f0354fc0dfcd1fae5a5969ab881&countries=tr",

  ];

  @override
  _BeslemelerState createState() => _BeslemelerState();
}

class _BeslemelerState extends State<Beslemeler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}