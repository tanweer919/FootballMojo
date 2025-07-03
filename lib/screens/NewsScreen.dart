import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../commons/BottomNavbar.dart';
import '../commons/NewsCard.dart';
import 'package:shimmer/shimmer.dart';
import '../services/LocalStorage.dart';
import '../Provider/AppProvider.dart';
import '../Provider/ThemeProvider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String teamName = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    LocalStorage.getString('teamName').then((value) {
      setState(() {
        teamName = value ?? '';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, model, child) => Consumer<ThemeProvider>(
        builder: (context, themeModel, child) => Scaffold(
            bottomNavigationBar: BottomNavbar(),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                automaticallyImplyLeading: false,
                title: const Text(
                  'News',
                  style: TextStyle(color: Colors.white),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    tabs: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
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
                          teamName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const UnderlineTabIndicator(
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

  Widget allNews(
      {required AppProvider model, required ThemeProvider themeModel}) {
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
              const Padding(
                padding: EdgeInsets.all(8.0),
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: themeModel.appTheme == AppTheme.Light
                              ? Colors.grey[300]!
                              : Colors.grey[700]!,
                          highlightColor: themeModel.appTheme == AppTheme.Light
                              ? Colors.grey[100]!
                              : Colors.grey[600]!,
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      })
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: model.newsList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
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

  Widget favouriteTeamNews(
      {required AppProvider model, required ThemeProvider themeModel}) {
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
              const Padding(
                padding: EdgeInsets.all(8.0),
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: themeModel.appTheme == AppTheme.Light
                              ? Colors.grey[300]!
                              : Colors.grey[700]!,
                          highlightColor: themeModel.appTheme == AppTheme.Light
                              ? Colors.grey[100]!
                              : Colors.grey[600]!,
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      })
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: model.favouriteNewsList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
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

  Future<void> _handleAllNewsRefresh({required AppProvider appProvider}) async {
    await appProvider.loadAllNews();
  }

  Future<void> _handleFavouriteNewsRefresh(
      {required AppProvider appProvider}) async {
    await appProvider.loadFavouriteNews();
  }
}
