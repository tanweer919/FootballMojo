import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/News.dart';
class NewsCard extends StatelessWidget {
  final int index;
  final News news;
  NewsCard({this.index, this.news});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/newsarticle', arguments: {'index': index, 'news': news});
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 80,
              width: 140,
              child: Hero(
                tag: 'hero${index}',
                child: CachedNetworkImage(
                  imageUrl:
                  news.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Image.asset('assets/images/news_source_default.png'),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 80,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          news.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(
                                news.source,
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            Text(
                              convertDateTime(dateTime: news.publishedAt),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff808080)),
                            )
                          ],
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
    );
  }

  String convertDateTime({DateTime dateTime}) {
    DateTime now = DateTime.now();
    int diffMin = now.difference(dateTime).inMinutes;
    int diffHr = now.difference(dateTime).inHours;
    int diffDay = now.difference(dateTime).inDays;

    if(diffMin < 60) {
      return '$diffMin mins';
    }
    else if(diffMin < 1440) {
      return '$diffHr hrs';
    }
    else {
      return '$diffDay days';
    }
  }
}