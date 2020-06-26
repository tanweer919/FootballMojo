import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/BottomNavbar.dart';
import '../commons/NewsCard.dart';
import '../models/News.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import '../services/FlushbarHelper.dart';
import '../Provider/HomeViewModel.dart';
import '../services/GetItLocator.dart';
import '../Provider/AppProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  final Map<String, dynamic> message;
  HomeScreen({this.message});
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _pageController = PageController(initialPage: 0);
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  String teamName;
  @override
  void initState() {
    final initialState = Provider.of<AppProvider>(context, listen: false);
    if(initialState.newsList == null) {
      initialState.loadAllNews();
    }
    if(initialState.loadFavouriteNews() == null) {
      initialState.loadFavouriteNews();
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showAlert());
  }


  HomeViewModel _viewModel = locator<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomNavbar(),
        body: ChangeNotifierProvider<HomeViewModel>(
          create: (context) => _viewModel,
          child: Consumer<HomeViewModel>(
            builder: (context, model, child) => SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onLoading: () async{
                _onLoading(appProvider: appProvider);
              },
              onRefresh: () async{
                _onRefresh(appProvider: appProvider);
              },
              header: WaterDropHeader(),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(fit: FlexFit.loose, child: carousel(model: model, appProvider: appProvider)),
                        UpcomingMatchesSection(),
                        NewsSection(model: model, appProvider: appProvider)
                      ],
                    ),
                  ),
                ),
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

  Widget NewsSection({HomeViewModel model, AppProvider appProvider}) {
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
            appProvider.newsList != null ? ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appProvider.newsList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return NewsCard(
                    index: index,
                    news: appProvider.newsList[index],
                  );
                }) : ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return PKCardSkeleton(
                          isCircularImage: true,
                          isBottomLinesActive: true,
                        );
                      })
          ],
        ),
      ),
    );
  }

  Widget carousel({HomeViewModel model, AppProvider appProvider}) {
    List<News> favouriteNewsList = appProvider.favouriteNewsList;
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: favouriteNewsList != null ? Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                PageView(
                  controller: _pageController,
                  children: <Widget>[
                    for (int i = 0; i < 5; i++)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/newsarticle',
                              arguments: {'index': i + 100, 'news': favouriteNewsList[i]});
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Container(
                              child: CachedNetworkImage(
                                height: MediaQuery.of(context).size.height * 0.35,
                                imageUrl: favouriteNewsList[i].imageUrl,
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
                                      favouriteNewsList[i].title,
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
                                          favouriteNewsList[i].source,
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
                    model.carouselIndex = index;
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
                                    color: model.carouselIndex == i
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
            ) : PageView(
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
          model.carouselIndex = index;
        },
      )
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

  Future<void> _onLoading({AppProvider appProvider}) async {
    appProvider.newsList = null;
    appProvider.favouriteNewsList = null;
    _refreshController.loadComplete();
  }

  Future<void> _onRefresh({AppProvider appProvider}) async {
    await appProvider.loadFavouriteNews();
    await appProvider.loadAllNews();
    _refreshController.refreshCompleted();
  }
}
