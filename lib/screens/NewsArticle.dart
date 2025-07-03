import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/News.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import '../Provider/ThemeProvider.dart';
import 'package:provider/provider.dart';

class NewsArticleScreen extends StatelessWidget {
  final int index;
  final News news;
  const NewsArticleScreen({Key? key, required this.index, required this.news})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeModel, child) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: const Color(0x04000000),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: const Icon(Icons.share),
                  onTap: () {
                    Share.share('${news.title}\n${news.url}');
                  },
                ),
              )
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraint) {
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
                                tag: 'hero$index',
                                child: CachedNetworkImage(
                                  imageUrl: news.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Image.asset(
                                              'assets/images/news_default.png',
                                              width: 50,
                                              fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Container(
                                                width: 50,
                                                child: (news.sourceLogo != null)
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            news.sourceLogo!,
                                                        fit: BoxFit.cover,
                                                        placeholder: (BuildContext
                                                                    context,
                                                                String url) =>
                                                            Image.asset(
                                                                'assets/images/news_source_default.png',
                                                                width: 50,
                                                                fit: BoxFit
                                                                    .cover),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/news_source_default.png',
                                                        width: 50,
                                                        fit: BoxFit.cover),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(news.source,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                                Text(
                                                  DateFormat(
                                                          'E, d MMMM, hh:mm aaa')
                                                      .format(news.publishedAt),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            news.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22,
                                              wordSpacing: 1.1,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          news.content,
                                          style: TextStyle(
                                            color: themeModel.appTheme ==
                                                    AppTheme.Light
                                                ? Colors.black
                                                : const Color(0xffdfdfdf),
                                            fontSize: 18,
                                            wordSpacing: 1.1,
                                            height: 1.1,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {
                        launchUrl(Uri.parse(news.url));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            if (themeModel.appTheme == AppTheme.Light)
                              const BoxShadow(
                                color: Colors.white54,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 12.0,
                              ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              'Read Full Article',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.open_in_new, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }
}
