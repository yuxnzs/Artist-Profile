import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/pages/main_navigation.dart';
import 'package:artist_profile/managers/search_history_manager.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => APIService()),
        ChangeNotifierProvider(create: (context) => DisplayManager()),
        ChangeNotifierProvider(
            // Fetch history when the app starts
            create: (context) => SearchHistoryManager()..fetchHistory()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}
