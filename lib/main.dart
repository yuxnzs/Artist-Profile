import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:artist_profile/services/api_service.dart';
import 'package:artist_profile/managers/display_manager.dart';
import 'package:artist_profile/managers/wiki_language_manager.dart';
import 'package:artist_profile/pages/main_navigation.dart';
import 'package:artist_profile/managers/search_history_manager.dart';
import 'package:artist_profile/models/artist_hive.dart';
import 'package:artist_profile/models/artist_bio_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(ArtistBioHiveAdapter());
  Hive.registerAdapter(ArtistHiveAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DisplayManager()),
        ChangeNotifierProvider(create: (context) => WikiLanguageManager()),
        ChangeNotifierProvider(
            create: (context) =>
                APIService(context.read<WikiLanguageManager>())),
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
