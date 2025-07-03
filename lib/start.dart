import 'package:flutter/material.dart';
import 'services/LocalStorage.dart';
import 'dart:async';
import 'Provider/ThemeProvider.dart';
import 'package:provider/provider.dart';

///Class to handle the screen that needs to shown on startup
class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  StartState createState() => StartState();
}

class StartState extends State<Start> {
  bool _isLoading = true;
  String? _error;
  Timer? _loadingTimer;

  ///Function to check if favourite team is set or not
  Future<void> checkTeam() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      //Variable to check if the app is opened for first time
      final String? firstOpen = await LocalStorage.getString('firstOpen');

      //Get favourite team name from local storage
      final String? teamName = await LocalStorage.getString('teamName');

      //If not opened for first time
      if (firstOpen == "no") {
        //If favourite team name is not set
        //Navigate to home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        //Setup default preference during app first startup
        await Future.wait([
          LocalStorage.setString('appTheme', "light"),
          LocalStorage.setString("notificationEnabled", "yes"),
          LocalStorage.setString('lastTopic', ""),
          LocalStorage.setString('firstOpen', 'no'),
        ]);

        //During first startup navigate to introduction screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/introduction');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error initializing app: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Add a minimum loading time to prevent flickering
    _loadingTimer = Timer(const Duration(milliseconds: 500), () {
      checkTeam();
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.appTheme == AppTheme.Dark;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: isDarkMode ? const Color(0XFF1D1D1D) : Colors.white,
      child: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : _error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: checkTeam,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}
