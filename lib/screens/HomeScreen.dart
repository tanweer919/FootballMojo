import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../commons/BottomNavbar.dart';
import '../commons/NewsCard.dart';
import '../helper/NewsService.dart';
import '../models/News.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import '../helper/FlushbarHelper.dart';

class HomeScreen extends StatefulWidget {
  @override
  final Map<String, dynamic> message;
  HomeScreen({this.message});
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _pageController = PageController(initialPage: 0);
  Future<List<News>> futureNewsList;
  Future<List<News>> futureFavouriteNewsList;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showAlert());
    setState(() {
      futureFavouriteNewsList = NewsService().fetchNews('Real madrid');
      futureNewsList = NewsService().fetchNews('Football');
    });
  }

  int carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavbar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(fit: FlexFit.loose, child: carousel()),
                  UpcomingMatchesSection(),
                  NewsSection()
                ],
              ),
            ),
          ),
        ));
  }

  Widget UpcomingMatchesSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Upcoming/Live Matches',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('La Liga'),
                        Spacer(),
                        Container(
                          width: 20.0,
                          child: Text(
                            "73'",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(
                                    height: 60,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'https://icons.iconarchive.com/icons/giannis-zographos/spanish-football-club/256/Real-Madrid-icon.png')),
                              ),
                              Text('Real Madrid')
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '5 - 4',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    height: 60,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'https://icons.iconarchive.com/icons/giannis-zographos/spanish-football-club/256/FC-Barcelona-icon.png')),
                              ),
                              Text('FC Barcelona')
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  Widget NewsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Latest News',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            FutureBuilder<List<News>>(
              future: futureNewsList,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return PKCardSkeleton(
                          isCircularImage: true,
                          isBottomLinesActive: true,
                        );
                      });
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return NewsCard(
                          index: index,
                          news: snapshot.data[index],
                        );
                      });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget carousel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: FutureBuilder(
        future: futureFavouriteNewsList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PageView(
              controller: _pageController,
              children: <Widget>[
                for (int i = 0; i < 5; i++)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Image.asset(
                      'assets/images/news_default.png',
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
              onPageChanged: (int index) {
                setState(() {
                  carouselIndex = index;
                });
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            List<News> data = snapshot.data;
            return Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                PageView(
                  controller: _pageController,
                  children: <Widget>[
                    for (int i = 0; i < 5; i++)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/newsarticle',
                              arguments: {'index': i + 100, 'news': data[i]});
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Container(
                              child: CachedNetworkImage(
                                height: MediaQuery.of(context).size.height * 0.35,
                                imageUrl: data[i].imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (BuildContext context, String url) =>
                                    Image.asset(
                                  'assets/images/news_default.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black.withOpacity(0.4),
                              padding:
                              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02, left: 12.0, right: 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      data[i].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 4.0),
                                        child: Text(
                                          data[i].source,
                                          style: TextStyle(fontSize: 14, color: Colors.amberAccent),
                                        ),
                                      ),
                                      Text(
                                        '1hr',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.amberAccent),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                  onPageChanged: (int index) {
                    setState(() {
                      carouselIndex = index;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                    color: Colors.black.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < 5; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: InkWell(
                              onTap: () {
                                _pageController.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                              },
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: carouselIndex == i
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  void showAlert() {
    if (widget.message != null) {
      FlushHelper.flushbarAlert(
          context: context,
          title: widget.message['title'],
          message: widget.message['content'],
          seconds: 3);
    }
  }
}
