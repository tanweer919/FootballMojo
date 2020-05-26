import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/News.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticleScreen extends StatelessWidget {
  final int index;
  final News news;
  NewsArticleScreen({this.index, this.news});
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: LayoutBuilder(builder: (context, constraint) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            child: Hero(
                              tag: 'hero${index}',
                              child: CachedNetworkImage(
                                imageUrl: news.imageUrl,
                                fit: BoxFit.cover,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            news.source,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            news.publishedAt,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          news.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22,
                                              wordSpacing: 1.1,
                                              height: 1.3),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${news.content}${news.content}${news.content}${news.content}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          wordSpacing: 1.1,
                                          height: 1.3,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      launchUrl(news.url);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0), //(x,y)
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Tap here to read full article',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          })),
    );
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
