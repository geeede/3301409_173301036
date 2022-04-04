import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulaktan_dolma_bilgiler/1_hakkinda.dart';
import 'package:kulaktan_dolma_bilgiler/2_giris.dart';

class IlkEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ciz(context),
    );
  }

  Widget _ciz(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('''Kulaktan Dolma Bilgiler'e\n   hoş geldiniz.\n''',
                style: TextStyle(fontSize: 30)),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GirisEkran()),
                  );
                },
                child: Text(
                  "Giriş",
                  style: TextStyle(fontSize: 50),
                )),
            Text("\n"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HakkindaEkran()),
                  );
                },
                child: Text(
                  "Hakkında",
                  style: TextStyle(fontSize: 50),
                )),
            Text("\n"),
            ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Çıkış",
                  style: TextStyle(fontSize: 50),
                ))
          ],
        ),
      ),
    );
  }
}