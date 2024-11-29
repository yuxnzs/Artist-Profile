import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/pages/artist_bio_page.dart';
import 'package:artist_profile/components/search_page/keyboard_dismissible_scrollview.dart';
import 'package:artist_profile/components/search_page/search_text_field.dart';
import 'package:artist_profile/components/search_page/search_history_tile.dart';
import 'package:artist_profile/managers/search_history_manager.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchHistoryManager = context.watch<SearchHistoryManager>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            // Make the entire screen scrollable, even with only a few items
            SizedBox(
              height: screenHeight,
              child: KeyboardDismissibleScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    ListView.builder(
                      // Height is determined by the content
                      shrinkWrap: true,
                      // Disable internal scrolling
                      physics: const NeverScrollableScrollPhysics(),
                      // Only render 20 items
                      itemCount: searchHistoryManager.history.length > 20
                          ? 20
                          : searchHistoryManager.history.length,
                      itemBuilder: (context, index) {
                        final historyItem = searchHistoryManager.history[index];

                        return SearchHistoryTile(
                          height: 50,
                          historyItem: historyItem,
                          index: index,
                          onDelete: (index) {
                            searchHistoryManager.deleteHistory(index);
                          },
                          onTap: (searchText) {
                            // Close the keyboard
                            FocusScope.of(context).unfocus();

                            // Navigate to the artist bio page
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ArtistBioPage(
                                  artistName: searchText,
                                  apiIncludeSpotifyInfo: true,
                                  passedArtist: null,
                                  category: null,
                                ),
                              ),
                            );

                            // Update the timestamp of the search history to display it at the top
                            // Delay 1 second to navigate to the ArtistBioPage first, then update the timestamp for UX
                            Future.delayed(const Duration(seconds: 1), () {
                              searchHistoryManager.updateTimestamp(
                                index: index,
                                timestamp:
                                    DateTime.now().millisecondsSinceEpoch,
                              );
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Text field container
            SearchTextField(
              controller: _searchController,
              width: screenWidth,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // Navigate to the artist bio page first
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ArtistBioPage(
                        artistName: value,
                        apiIncludeSpotifyInfo: true,
                        passedArtist: null,
                        category: null,
                      ),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    // Then add the search history to the database
                    searchHistoryManager.addHistory(value);
                    // Clear the search text field
                    _searchController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
