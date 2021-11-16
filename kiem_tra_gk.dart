import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Tin_tuc_demo extends StatelessWidget {
  const Tin_tuc_demo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tin_tuc(),
    );
  }
}

class Tin_tuc extends StatefulWidget {
  const Tin_tuc({Key? key}) : super(key: key);

  @override
  _Tin_tucState createState() => _Tin_tucState();
}

class _Tin_tucState extends State<Tin_tuc> {
  late Future<List<Article>> lsArticle;

  @override
  void initState() {
    lsArticle = Article.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tin tức Flutter"),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: lsArticle,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              //print(snapshot);
              if (snapshot.hasData) {
                var data = snapshot.data as List<Article>;
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: CarouselSlider(
                            items: [
                              Text("Bóng đá",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center),
                              Text("Tin trong nước",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center),
                              Text("Tin nước ngoài",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center),
                              Text("Công nghệ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                            options: CarouselOptions(
                              height: 30,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                            )),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            Article article = data[index];
                            return InkWell(
                              child: Column(
                                children: [
                                  Image.network(
                                    article.urlToImage,
                                    height: 200,
                                    width: 500,
                                  ),
                                  Text(
                                    article.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.blue,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    article.description,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => launch(article.url),
                            );
                          },
                        ),
                      ))
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ) /**/

        );
  }
}

class Source {
  final String id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });
}

class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
  });

  static Future<List<Article>> fetchData() async {
    String url =
        "https://newsapi.org/v2/everything?q=apple&from=2021-11-15&to=2021-11-15&sortBy=popularity&apiKey=6852d3284bed4cf3a72e410d42dbbfae";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = response.body;
      var jsonData = jsonDecode(result);
      List<Article> list = [];
      for (var item in jsonData['articles']) {
        Source source = Source(
            id: item['source']['id'].toString(),
            name: item['source']['name'].toString());
        Article article = Article(
            source: source,
            author: item['author'].toString(),
            title: item['title'],
            description: item['description'],
            url: item['url'],
            urlToImage: item['urlToImage'],
            content: item['content']);
        list.add(article);
      }

      return list;
    } else {
      throw Exception("Lỗi lấy dữ liệu. Chi tiết: ${response.statusCode}");
    }
  }
}
