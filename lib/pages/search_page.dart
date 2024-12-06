import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:artist_profile/pages/artist_bio_page.dart';
import 'package:artist_profile/components/search_page/keyboard_dismissible_scrollview.dart';
import 'package:artist_profile/components/search_page/search_text_field.dart';
import 'package:artist_profile/components/search_page/search_history_tile.dart';
import 'package:artist_profile/managers/search_history_manager.dart';
import 'package:artist_profile/managers/notification_manager.dart';

class SearchPage extends StatefulWidget {
  final bool isKeyboardVisible;

  const SearchPage({super.key, required this.isKeyboardVisible});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  final NotificationManager _notificationManager = NotificationManager();
  final TextEditingController _searchController = TextEditingController();

  bool canFetchBio = true; // To prevent the user from searching too frequently
  int waitTime = 5000;

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

  void setCanFetchTimeout() {
    setState(() {
      canFetchBio = false;
    });

    Future.delayed(Duration(milliseconds: waitTime), () {
      if (mounted) {
        setState(() {
          canFetchBio = true;
        });
      }
    });
  }

  void _showNotification() {
    _notificationManager.showNotification(
      context: context,
      message: "Please wait ${waitTime ~/ 1000} seconds to search again",
      duration: 5,
      isSlideHorizontal: true,
    );
  }

  void _hideNotification() {
    // Animate the notification bar to hide and remove it
    _notificationManager.hideNotificationBar();
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
                            if (canFetchBio) {
                              // If there is a notification showing, remove it first before navigating to the ArtistBioPage
                              _hideNotification();

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

                              setCanFetchTimeout();
                            } else {
                              // Close the keyboard first
                              FocusScope.of(context).unfocus();

                              // If the keyboard is visible, wait for 500ms to close the keyboard before showing notification
                              Future.delayed(
                                  Duration(
                                      milliseconds: widget.isKeyboardVisible
                                          ? 400
                                          : 0), () {
                                _showNotification();
                              });
                            }
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
                  if (canFetchBio) {
                    // If there is a notification showing, remove it first before navigating to the ArtistBioPage
                    _hideNotification();

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

                    setCanFetchTimeout();
                  } else {
                    // Close the keyboard first
                    FocusScope.of(context).unfocus();

                    // If the keyboard is visible, wait for 500ms to close the keyboard before showing notification
                    Future.delayed(
                        Duration(
                            milliseconds: widget.isKeyboardVisible ? 400 : 0),
                        () {
                      _showNotification();
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
