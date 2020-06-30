import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/BottomNavbar.dart';
import '../models/News.dart';
import '../services/GetItLocator.dart';
import '../commons/NewsCard.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import '../services/LocalStorage.dart';
import '../Provider/AppProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  TabController _tabController;
  String teamName;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void initState(){
    final initialState = Provider.of<AppProvider>(context, listen: false);
    if(initialState.newsList == null) {
      initialState.loadAllNews();
    }
    if(initialState.favouriteNewsList == null) {
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

  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, model, child) => Scaffold(
          bottomNavigationBar: BottomNavbar(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('News', style: TextStyle(color: Colors.white),),
              bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('All', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('$teamName', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),),
                    )
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: 3.0,
                          color: Colors.white))
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              allNews(model: model),
              favouriteTeamNews(model: model)
            ],
          )
      ),
    );
  }

  Widget allNews({AppProvider model}) {
    return SingleChildScrollView(
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
            model.newsList == null ? ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return PKCardSkeleton(
                          isCircularImage: true,
                          isBottomLinesActive: true,
                        );
                      }) : ListView.separated(
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
    );
  }

  Widget favouriteTeamNews({AppProvider model}) {
    return SingleChildScrollView(
      child: Padding(
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
              model.favouriteNewsList == null ? ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return PKCardSkeleton(
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