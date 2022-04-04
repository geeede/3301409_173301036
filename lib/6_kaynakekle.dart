import 'package:flutter/material.dart';
import 'package:kulaktan_dolma_bilgiler/4_dashboard.dart';
import 'package:kulaktan_dolma_bilgiler/plaintext_storage.dart' as plaindb;
import 'package:fluttertoast/fluttertoast.dart';

class KaynakEkle extends StatefulWidget {
  @override
  _KaynakEkleState createState() => _KaynakEkleState();
}

class _KaynakEkleState extends State<KaynakEkle> {
  var password = <String>[];
  String? eklenecekKaynak;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Eklenecek kaynak:",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: "",
                  onChanged: (text) {
                    eklenecekKaynak = text;
                  },
                ),
              ),
              Text("\n"),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      ekle(context);
                    },
                    child: Text("Kaynağı ekle")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ekle(context) {
    if (
        (eklenecekKaynak != "") &&
        (eklenecekKaynak != null)) {
      //veri.add(eklenecekparola);
      plaindb.Beslemeler.beslemeler.add(eklenecekKaynak!);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardClass(title: "Kaynak eklendi."),
            //settings: RouteSettings(arguments: veri)));
    ));
  }


}