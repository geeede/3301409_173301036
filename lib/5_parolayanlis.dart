import 'package:flutter/material.dart';

class ParolaYanlisEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParolaYanlisEkrani(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ParolaYanlisEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '''Kullanıcı adı veya parola yanlış.\n
                Lütfen bilgileri doğru girdiğinizden emin olunuz''',
                style: TextStyle(fontSize: 20),
              ),
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