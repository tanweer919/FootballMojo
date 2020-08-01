import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../commons/BottomNavbar.dart';
import '../commons/NewsCard.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import '../services/LocalStorage.dart';
import '../Provider/AppProvider.dart';
import '../Provider/ThemeProvider.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  TabController _tabController;
  String teamName;
  void initState() {
    final initialState = Provider.of<AppProvider>(context, listen: false);
    if (initialState.newsList == null) {
      initialState.loadAllNews();
    }
    if (initialState.favouriteNewsList == null) {
      initialState.loadFavouriteNews();
    }
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    LocalStorage.getString('teamName').then((value) {
      setState(() {
        teamName = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, model, child) => Consumer<ThemeProvider>(
        builder: (context, themeModel, child) => Scaffold(
            bottomNavigationBar: BottomNavbar(),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: AppBar(
                leading: Container(),
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  'News',
                  style: TextStyle(color: Colors.white),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    tabs: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'All',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '$teamName',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(width: 3.0, color: Colors.white))),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                allNews(model: model, themeModel: themeModel),
                favouriteTeamNews(model: model, themeModel: themeModel)
              ],
            )),
      ),
    );
  }

  Widget allNews({AppProvider model, ThemeProvider themeModel}) {
    return RefreshIndicator(
      onRefresh: () async {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.chasingDots
          ..loadingStyle = EasyLoadingStyle.custom
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Theme.of(context).primaryColor
          ..indicatorColor = Colors.white
          ..maskColor = Colors.blue.withOpacity(0.5)
          ..progressColor = Theme.of(context).primaryColor
          ..textColor = Colors.white;
        EasyLoading.show(status: 'Fetching latest news');
        await _handleAllNewsRefresh(appProvider: model);
        EasyLoading.dismiss();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              model.newsList == null
                  ? ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return themeModel.appTheme == AppTheme.Light
                            ? PKCardSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                              )
                            : PKDarkCardSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                              );
                      })
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model.newsList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return NewsCard(
                          index: index,
                          news: model.newsList[index],
                        );
                      })
            ],
          ),
        ),
      ),
    );
  }

  Widget favouriteTeamNews({AppProvider model, ThemeProvider themeModel}) {
    return RefreshIndicator(
      onRefresh: () async {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.chasingDots
          ..loadingStyle = EasyLoadingStyle.custom
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..backgroundColor = Theme.of(context).primaryColor
          ..indicatorColor = Colors.white
          ..maskColor = Colors.blue.withOpacity(0.5)
          ..progressColor = Theme.of(context).primaryColor
          ..textColor = Colors.white;
        EasyLoading.show(status: 'Fetching latest news');
        await _handleFavouriteNewsRefresh(appProvider: model);
        EasyLoading.dismiss();

      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              model.favouriteNewsList == null
                  ? ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return themeModel.appTheme == AppTheme.Light
                            ? PKCardSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                              )
                            : PKDarkCardSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                              );
                      })
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model.favouriteNewsList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return NewsCard(
                          index: index,
                          news: model.favouriteNewsList[index],
                        );
                      })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAllNewsRefresh({AppProvider appProvider}) async {
    await appProvider.loadAllNews();
  }

  Future<void> _handleFavouriteNewsRefresh({AppProvider appProvider}) async {
    await appProvider.loadFavouriteNews();
  }
}
