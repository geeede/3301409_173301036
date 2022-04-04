import 'package:flutter/material.dart';
import 'package:kulaktan_dolma_bilgiler/6_kaynakekle.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kulaktan_dolma_bilgiler/plaintext_storage.dart' as plaindb;
import 'modeller/jsonmodel.dart' as jm;
import 'package:kulaktan_dolma_bilgiler/modeller/MediaStackModel.dart' as msm;
import 'package:fluttertoast/fluttertoast.dart';

class DashboardClass extends StatefulWidget {
  DashboardClass({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _DashboardClassState createState() => _DashboardClassState();
}

class _DashboardClassState extends State<DashboardClass> {
  RssFeed? _feed;
  jm.json_model? _json;
  msm.MediaStack? _jsonMediaStack;
  List<dynamic>? jsonList = [];

  //var _json;
  String? _title;

  static const String feedLoadingStr = "Besleme yükleniyor...";
  static const String feedLoadErrStr = "Besleme yüklenirken hata.";
  static const String feedOpenErrStr = "Beslemeyi açarken hata.";
  static const String placeHolderImg = 'images/404.png';
  var beslemelerList = plaindb.Beslemeler.beslemeler;
  GlobalKey<RefreshIndicatorState>? _refreshKey;

  updateTitle(title) {

    setState(() {
      _title = title;
    });
  }

  updateFeedRSS(feed) {
    setState(() {
      _feed = feed;
    });
  }

  updateFeed(jsonn) {
    setState(() {
      // _json = jm.json_model.fromJson(json.decode(jsonn));
      try {

      jsonList?.add(msm.MediaStack.fromJson(json.decode(jsonn)));
      }
      catch (exception) {


        jsonList?.add(jm.json_model.fromJson(json.decode(jsonn)));
      }
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrStr);
  }

  load() async {
    _json = null;
    jsonList = [];

    updateTitle(feedLoadingStr);

    for (var besleme in beslemelerList) {
      loadFeed(besleme)!.then((result) {
        if (null == result || result.toString().isEmpty) {
          updateTitle(feedLoadErrStr);
          return;
        }
        updateFeed(result);

      });
    }
    updateTitle("Güncellendi");
  }

  loadRSS() async {
    updateTitle(feedLoadingStr);

    for (var besleme in beslemelerList) {
      loadFeed(besleme)!.then((result) {
        if (null == result || result.toString().isEmpty) {
          updateTitle(feedLoadErrStr);
          return;
        }
        updateFeed(result);
        updateTitle(_feed?.title ?? "Yükleniyor...");
      });
    }
  }

  Future? loadFeed(besleme) async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(besleme));

      return response.body;
    } catch (e) {
      //
    }
    return null;
  }

  Future<RssFeed?> loadRSSFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(plaindb.newsapi_api_url));

      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(),
        //Container(child: CircularProgressIndicator()), //Image.asset(placeHolderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list_old() {
    return ListView.builder(
      itemCount: _json!.articles!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _json!.articles![index];
        return ListTile(
          title: title(item.title),
          subtitle: subtitle(item.publishedAt),
          leading: thumbnail(item.urlToImage),
          trailing: rightIcon(),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () => openFeed(item.url!.toString()),
        );
      },
    );
  }

  list() {

    var count = 0;

    List<Flexible> liste = [];

    for (var _jsonimiz in jsonList!) {
      try {
      liste.add(Flexible(
        child: ListView.builder(
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: _jsonimiz!.articles!.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _jsonimiz!.articles![index];

            var newListTile = ListTile(
              title: title(item.title),
              subtitle: subtitle(item.publishedAt),
              leading: thumbnail(item.urlToImage ?? "https://dummyimage.com/600x400/000/fff.jpg&text=HATA"),
              trailing: rightIcon(),
              contentPadding: EdgeInsets.all(5.0),
              //onTap: () => openFeed(item.url!.toString()),
                onTap: () => openFeed("https://texttospeech.responsivevoice.org/v1/text:synthesize?text=" + item.title + "&lang=tr&engine=g1&name=&pitch=0.5&rate=0.5&volume=1&key=0POmS5Y2&gender=female")
            );

            return newListTile;
          },
        ),
      )); }
      catch (exception) {
        liste.add(Flexible(
          child: ListView.builder(
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _jsonimiz!.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _jsonimiz!.data![index];

              var newListTile = ListTile(

                title: title(item.title),
                subtitle: subtitle(item.publishedAt.toString()),
                leading: thumbnail(item.image.split(" ")[0]),
                trailing: rightIcon(),
                contentPadding: EdgeInsets.all(5.0),
                //onTap: () => openFeed(item.url!.toString()),
                  onTap: () => openFeed("https://texttospeech.responsivevoice.org/v1/text:synthesize?text=" + item.title + "&lang=tr&engine=g1&name=&pitch=0.5&rate=0.5&volume=1&key=0POmS5Y2&gender=female")
                // item.content
              );

              return newListTile;
            },
          ),
        ));
      }
      count += 1;

      // return liste;
    }

    return Column(children: _createChildren(liste));

  }

  List<Widget> _createChildren(gelenListe) {
    return new List<Widget>.generate(gelenListe.length, (int index) {
      return (gelenListe[index]);
    });
  }

  _new_source() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KaynakEkle()),
    );
  }

  isFeedEmpty() {
    for (var _json in jsonList!) {
      try {
        if (null == _json || null == _json!.articles) {
          return true;
        }
        return false;
      } catch (exception) {
        if (null == _json || null == _json!.data) {
          return true;
        }
        return false;
      }
      return false;
    }
    return false;
  }

  isFeedEmptyRSS() {
    return null == _feed || null == _feed!.items;
  }

   body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        onPressed: _new_source,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
