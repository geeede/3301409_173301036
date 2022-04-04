import 'package:flutter/material.dart';
import 'package:kulaktan_dolma_bilgiler/main.dart';
import 'package:kulaktan_dolma_bilgiler/0_karsilama.dart';
import 'package:kulaktan_dolma_bilgiler/4_dashboard.dart';
import 'package:kulaktan_dolma_bilgiler/5_parolayanlis.dart';
import 'package:kulaktan_dolma_bilgiler/plaintext_storage.dart' as plaindb;
import 'package:fluttertoast/fluttertoast.dart';

class GirisEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GirisEkrani(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
    );
  }
}

class GirisEkrani extends StatelessWidget {
  // String kadi = "admin";
  // String anaparola = "demo";
  String kadi = plaindb.Beslemeler.kadi!;
  String anaparola = plaindb.Beslemeler.anaparola!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Varsayılan kullanıcı adı ',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                  children: <TextSpan>[
                    TextSpan(
                        text: plaindb.Beslemeler.kadi,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' ve varsayılan ana parola '),
                    TextSpan(
                        text: plaindb.Beslemeler.anaparola,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "'dur. "),
                    TextSpan(
                        text: "Lütfen giriş yapınız\n",
                        style: TextStyle(color: Colors.deepPurpleAccent))
                  ],
                ),
              ),
              Text(
                "Kullanıcı adı:",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: "admin",
                  onChanged: (text) {
                    kadi = text;
                  },
                ),
              ),
              Text(
                "\nAna parola:",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: "demo",
                  onChanged: (text) {
                    anaparola = text;
                  },
                ),
              ),
              Text("\n"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            girisYap(context);
                          },
                          child: Text("Giriş Yap")),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IlkEkran()),
                            );
                          },
                          child: Text("Geri"))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void girisYap(context) {
    if ((kadi == plaindb.Beslemeler.kadi!) && (anaparola == plaindb.Beslemeler.anaparola!)) {
      var veri = [];
      veri.add(kadi);
      veri.add(anaparola);
      toast_mesaj("Hoş geldiniz, " + plaindb.Beslemeler.kadi!);


      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardClass(
              title: "KDB",
            ),
            settings: RouteSettings(
              arguments: veri,
            ),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParolaYanlisEkrani(),
          ));
    }
  }

  toast_mesaj(mesaj) {
    Fluttertoast.showToast(
        msg: mesaj,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}