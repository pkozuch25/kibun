import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kibun/Logic/API/spotify_API.dart';
import 'package:kibun/Logic/Services/genres_list.dart';
import 'package:kibun/Logic/Services/spotify_auth_service.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Widgets/Screens/general_tab_widget.dart';
import 'package:kibun/Widgets/background_widget.dart';


class RecommendedTab extends StatefulWidget {
  const RecommendedTab({super.key});

  @override
  State<RecommendedTab> createState() => _RecommendedTabState();
}

class _RecommendedTabState extends State<RecommendedTab> {
  List<Map<String, dynamic>> result = [];
  bool _isLoading = true;
  bool _shouldRefresh = false;
  bool showSearchBar = false;
  String? accessToken;
  final TextEditingController _searchController = TextEditingController();
  String? searchText, token;
  Color? color;
  final String assetName = 'assets/kibun_logo.svg';

  @override
  void initState(){
    init();
    super.initState();
  }

  Future<void> init() async {
    color = ColorPalette().getRandomColor();
    await readToken();
    await refreshAccessToken();
    await fetchPage();
  }

  Future<void> refreshAccessToken() async {
    accessToken = await SpotifyAuthService().getAccessToken();
  }

  Future<void> readToken() async {
    token = await StorageService().readToken();
  }

  Future<void> fetchPage() async {
    try {
      result = await SpotifyApi().getSpotifyRecommendations(accessToken!, GenresList().getRandomElements(), 50);
      if(!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _shouldRefresh = false;
      });
    } catch (error) {
      log(error.toString());
    }
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget svgSearchBar = SvgPicture.asset(
      width: 20,
      height: 20,
      assetName,
    );
    final Widget svgLoading = SvgPicture.asset(
      width: 150,
      height: 150,
      assetName,
    );
    if (_isLoading) {
      return Scaffold(
        body: BackgroundWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              svgLoading,
              const CircularProgressIndicator(color: ColorPalette.teal500),
            ],
          ),
        )
      );
    } else {
    return Scaffold(
      body: BackgroundWidget(
        child: RefreshIndicator(
        onRefresh: () => fetchPage(),
          child: CustomScrollView(
            slivers: [
               SliverAppBar(
                toolbarHeight: 45,
                elevation: 4,
                expandedHeight: 10,
                floating: true,
                 leading: showSearchBar
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              if(!mounted) {
                                return;
                              }
                              setState(() {
                                showSearchBar = false;
                              });
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: svgSearchBar
                          ),
                    title: showSearchBar
                        ? TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _searchController,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  _shouldRefresh = true;
                                });
                              }
                              EasyDebounce.debounce(
                                'debouncer',
                                const Duration(milliseconds: 600),
                                () {
                                  if (_searchController.text != '') {
                                    () async {
                                      color = ColorPalette().getRandomColor();
                                      result = await SpotifyApi().searchForTrack(accessToken!, _searchController.text, 50);
                                      if(!mounted) {
                                        return;
                                      }
                                      setState(() {
                                        _shouldRefresh = false;
                                      });
                                    }();
                                  }
                                },
                              );
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'search...',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(),
                        actions: [
                      IconButton(
                          onPressed: () {
                            if(!mounted) {
                              return;
                            }
                            setState(() {
                              color = ColorPalette().getRandomColor();
                              _shouldRefresh = true;
                            });
                            fetchPage();
                            if(!mounted) {
                              return;
                            }
                            setState(() {
                            _searchController.text = '';
                            searchText = '';
                            });
                          },
                          icon: showSearchBar || _searchController.text == ''
                              ? const Icon(null)
                              : const Icon(Icons.clear)),
                      IconButton(
                        icon: Icon(showSearchBar ? Icons.clear : Icons.search),
                        onPressed: () {
                          if (showSearchBar == false) {
                            if(!mounted) {
                              return;
                            }
                            setState(() {
                              showSearchBar = !showSearchBar;
                            });
                          } else if (showSearchBar != false) {
                            if(!mounted) {
                              return;
                            }
                            setState(() {
                              color = ColorPalette().getRandomColor();
                              _shouldRefresh = true;
                            });
                            fetchPage();
                            if(!mounted) {
                              return;
                            }
                            setState(() {
                              _searchController.text = '';
                              searchText = '';
                            });
                          }
                        },
                      ),
                    ],
                surfaceTintColor: ColorPalette.black500,
                backgroundColor: ColorPalette.black500,
                foregroundColor: ColorPalette.black500,
                ),
                 _shouldRefresh == false ? SliverPadding(
                    padding: const EdgeInsets.only(bottom: 55),
                    sliver: SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: result.length,
                      itemBuilder: (context, index) {
                        return GeneralTabWidget(
                          color: color!,
                          artist: result[index]['artist'],
                          trackImageUrl: result[index]['trackImageUrl'],
                          songName: result[index]['songName'],
                          albumName: result[index]['albumName'],
                          durationMs: result[index]['durationMs'],
                          token: token.toString(),
                        );
                      },
                    ),
                  ) : SliverToBoxAdapter(
                    child: Column(
                      children: [
                        svgLoading,
                        const CircularProgressIndicator(color: ColorPalette.teal500),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

