import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kulaktan_dolma_bilgiler/plaintext_storage.dart' as plaindb;
import 'modeller/jsonmodel.dart' as jm;

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
  //var _json;
  String? _title;

  static const String feedLoadingStr = "Besleme yükleniyor...";
  static const String feedLoadErrStr = "Besleme yüklenirken hata.";
  static const String feedOpenErrStr = "Beslemeyi açarken hata.";
  static const String placeHolderImg = 'images/404.png';
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
      _json = jm.json_model.fromJson(json.decode(jsonn));
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
    updateTitle(feedLoadingStr);
    loadFeed()!.then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrStr);
        return;
      }
      updateFeed(result);
      updateTitle("Güncellendi");
    });
  }
  loadRSS() async {
    updateTitle(feedLoadingStr);
    loadFeed()!.then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrStr);
        return;
      }
      updateFeed(result);
      updateTitle(_feed?.title ?? "Yükleniyor...");
    });
  }

  Future? loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(plaindb.newsapi_api_url));

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
        placeholder: (context, url) =>  CircularProgressIndicator(), //Container(child: CircularProgressIndicator()), //Image.asset(placeHolderImg),
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

  list() {
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

  isFeedEmpty() {
    return null == _json || null == _json!.articles;
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
    );
  }


}

