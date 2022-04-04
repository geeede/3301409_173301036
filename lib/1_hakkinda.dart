import 'package:flutter/material.dart';
import 'package:kulaktan_dolma_bilgiler/0_karsilama.dart';
import 'package:kulaktan_dolma_bilgiler/2_giris.dart';
import 'package:kulaktan_dolma_bilgiler/4_dashboard.dart';

// void main() {
//   runApp(HakkindaEkran());
// }

class HakkindaEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: HakkindaEkrani(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/hakkindaekran',
        routes: {
          '/': (context) => IlkEkran(),
          '/hakkindaekran': (context) => HakkindaEkrani(),
        },
      theme: ThemeData(

        primarySwatch: Colors.grey,
      ),);
  }
}

class HakkindaEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset('assets/images/hakkinda.png')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Geri"))
            ],
          )),
    );
  }
}