import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../commons/ScoreCard.dart';
import '../models/Score.dart';
import '../commons/BottomNavbar.dart';
import '../commons/NewsCard.dart';
import '../models/News.dart';
import 'package:shimmer/shimmer.dart';
import '../services/FlushbarHelper.dart';
import '../Provider/HomeViewModel.dart';
import '../services/GetItLocator.dart';
import '../Provider/AppProvider.dart';
import '../Provider/ThemeProvider.dart';
import '../commons/GlobalKeys.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? message;
  final bool showTutorial;

  const HomeScreen({
    Key? key,
    this.message,
    this.showTutorial = false,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _pageController = PageController(initialPage: 0);
  String? teamName;
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<HomeViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message != null) {
        showAlert();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: Consumer<ThemeProvider>(
        builder: (context, themeModel, child) =>
            ChangeNotifierProvider<HomeViewModel>(
          create: (context) => _viewModel,
          child: Consumer<HomeViewModel>(
            builder: (context, model, child) => SafeArea(
              child: RefreshIndicator(
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
                  EasyLoading.show(status: 'Fetching latest content');
                  await _handleRefresh(appProvider: appProvider);
                  EasyLoading.dismiss();
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: carousel(
                          model: model,
                          appProvider: appProvider,
                        ),
                      ),
                      if (appProvider.favouriteTeamScores != null)
                        UpcomingMatchesSection(appProvider: appProvider)
                      else
                        _buildShimmerLoading(themeModel),
                      NewsSection(
                        model: model,
                        themeModel: themeModel,
                        appProvider: appProvider,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeProvider themeModel) {
    return themeModel.appTheme == AppTheme.Light
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: Colors.grey[700]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
  }

  Widget UpcomingMatchesSection({required AppProvider appProvider}) {
    final List<Score> matches = appProvider.favouriteTeamScores;
    final Score? liveMatch = matches.firstWhere(
      (score) => score.status == "LV",
      orElse: () => Score(
        id: 0,
        competition: '',
        date_time: DateTime.now(),
        status: '',
        homeTeam: '',
        awayTeam: '',
      ),
    );

    if (liveMatch == null) return const SizedBox.shrink();

    return Padding(
      key: widget.showTutorial ? GlobalKeys.matchCardKey : null,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Live Match',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          ScoreCard(score: liveMatch),
        ],
      ),
    );
  }

  Widget NewsSection({
    required HomeViewModel model,
    required ThemeProvider themeModel,
    required AppProvider appProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        key: widget.showTutorial ? GlobalKeys.allNewsCardKey : null,
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
            if (appProvider.newsList != null)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appProvider.newsList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) => NewsCard(
                  index: index,
                  news: appProvider.newsList[index],
                ),
              )
            else
              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    _buildShimmerLoading(themeModel),
              ),
          ],
        ),
      ),
    );
  }

  Widget carousel(
      {required HomeViewModel model, required AppProvider appProvider}) {
    final List<News> favouriteNewsList = appProvider.favouriteNewsList;
    final List<News> allNewsList = appProvider.newsList;
    final int totalCount =
        favouriteNewsList.length > 5 ? 5 : favouriteNewsList.length;
    final int circleCount = totalCount == 0 ? 5 : totalCount;

    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      key: widget.showTutorial ? GlobalKeys.carouselKey : null,
      child: favouriteNewsList.isNotEmpty
          ? Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                PageView(
                  controller: _pageController,
                  children: totalCount != 0
                      ? List.generate(
                          totalCount,
                          (i) => _buildNewsItem(
                            context,
                            favouriteNewsList[i],
                            i + 100,
                            true,
                          ),
                        )
                      : List.generate(
                          5,
                          (i) => _buildNewsItem(
                            context,
                            allNewsList[i],
                            i + 100,
                            false,
                          ),
                        ),
                  onPageChanged: (int index) {
                    model.carouselIndex = index;
                  },
                ),
                _buildPageIndicator(circleCount, model),
              ],
            )
          : PageView(
              controller: _pageController,
              children: List.generate(
                5,
                (i) => Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.asset(
                    'assets/images/news_default.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onPageChanged: (int index) {
                model.carouselIndex = index;
              },
            ),
    );
  }

  Widget _buildNewsItem(
    BuildContext context,
    News news,
    int index,
    bool isFavourite,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/newsarticle',
          arguments: {
            'index': index,
            'news': news,
          },
        );
      },
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          CachedNetworkImage(
            height: MediaQuery.of(context).size.height * 0.35,
            imageUrl: news.imageUrl,
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url) => Image.asset(
              'assets/images/news_default.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.02,
              left: 12.0,
              right: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Text(
                    news.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        news.source,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ),
                    Text(
                      convertDateTime(dateTime: news.publishedAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int circleCount, HomeViewModel model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.02,
        color: Colors.black.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            circleCount,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () {
                  _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: model.carouselIndex == i
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertDateTime({required DateTime dateTime}) {
    final DateTime now = DateTime.now();
    final int diffMin = now.difference(dateTime).inMinutes;
    final int diffHr = now.difference(dateTime).inHours;
    final int diffDay = now.difference(dateTime).inDays;

    if (diffMin < 60) {
      return '$diffMin mins';
    } else if (diffMin < 1440) {
      return '$diffHr hrs';
    } else {
      return '$diffDay days';
    }
  }

  void showAlert() {
    if (widget.message != null) {
      FlushHelper.flushbarAlert(
        context: context,
        title: widget.message!['title'],
        message: widget.message!['content'],
        seconds: 3,
      );
    }
  }

  Future<void> _handleRefresh({required AppProvider appProvider}) async {
    await appProvider.loadAllNews();
    await appProvider.loadFavouriteNews();
    await appProvider.loadFavouriteScores();
    await appProvider.loadLeagueWiseScores();
  }
}
