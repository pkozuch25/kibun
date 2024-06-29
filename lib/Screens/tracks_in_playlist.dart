// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kibun/Logic/API/Playlists/fetch_songs_in_playlist_query.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Widgets/Screens/general_tab_widget.dart';
import 'package:kibun/Widgets/background_widget.dart';
import 'package:kibun/Widgets/paged_sliver_masonry.dart';

class TracksInPlaylist extends StatefulWidget{
  final int playlistId;

  const TracksInPlaylist({super.key, required this.playlistId});

  @override
  State<TracksInPlaylist> createState() => _TracksInPlaylistState();
}

class _TracksInPlaylistState extends State<TracksInPlaylist> {
  final PagingController<int, Map<String, dynamic>> _pagingController = PagingController(firstPageKey: 1);
  final storage = const FlutterSecureStorage();
  String? token = '';
  String? link = '';
  bool _isLoading = true;
  String total = '';
  bool showSearchBar = false;
  List<Map<String, dynamic>> newDataList = [];
  Color? color;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    color = ColorPalette().getRandomColor();
    link = ServerAddressEnum.PUBLIC1.ipAddress;
    readToken();
    if (mounted == true) {
      setState(() {});
    }
  }

  Future<void> readToken() async {
    token = await StorageService().readToken();
    _pagingController.addPageRequestListener((pageKey) async {
      await fetchPage(pageKey);
    });
          setState(() {
      _isLoading = false;
    });
  } 

  Future<void> fetchPage(int pageKey) async {
    print('asdf');
    try {
      newDataList = await FetchSongsInPlaylistQuery().fetchData(pageKey, widget.playlistId, link, token);
      print(newDataList);
      final isLastPage = newDataList.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newDataList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newDataList, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
      log(_pagingController.error);
    }
  }

  Future<void> refresh() async {
    setState(() {
      newDataList = [];
    });
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final Widget svgSearchBar = SvgPicture.asset(
      width: 40,
      height: 40,
      'assets/kibun_logo.svg',
    );
    final Widget svgLoading = SvgPicture.asset(
      width: 150,
      height: 150,
      'assets/kibun_logo.svg',
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
        onRefresh: () => refresh(),
          child: CustomScrollView(
            slivers: [
               SliverAppBar(
                toolbarHeight: 45,
                elevation: 4,
                expandedHeight: 10,
                floating: true,
                 actions: [
                  Padding(    
                    padding: EdgeInsets.only(right: 5),
                    child: Text('Songs in a playlist', style: TextStyle(color: ColorPalette.neutralsWhite),)
                  ),
                  SizedBox(width: 5,), 
                  svgSearchBar,
                 ],
                surfaceTintColor: ColorPalette.black500,
                backgroundColor: ColorPalette.black500,
                foregroundColor: ColorPalette.black500,
                ),
                PagedSliverMasonry<int, Map<String, dynamic>>(  
                  showNewPageProgressIndicatorAsGridChild: false,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                  ),
                  pagingController: _pagingController,
                  builderDelegate:
                    PagedChildBuilderDelegate<Map<String, dynamic>>(
                    animateTransitions: true,
                    itemBuilder: (context, item, index) {
                      print(newDataList);
                      return GeneralTabWidget(
                          color: color!,
                          artist: item['artistName'],
                          trackImageUrl: item['trackImageUrl'],
                          songName: item['trackName'],
                          albumName: item['artistAlbumName'],
                          durationMs: item['durationMs'],
                          token: token.toString(),
                          canAddToPlaylist: false
                        );
                      },
                    noItemsFoundIndicatorBuilder: (context) {
                      return Scaffold(
                        body: BackgroundWidget(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("This playlist is currently empty!", style: TextStyle(color: ColorPalette.teal500),),
                            ],
                          ),
                        )
                      );
                    },
                    firstPageErrorIndicatorBuilder: (context) {
                      return Scaffold(
                        body: BackgroundWidget(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              svgLoading,
                              Text('Error loading first page', style: TextStyle(color: ColorPalette.teal500),),
                            ],
                          ),
                        )
                      );
                    },
                    newPageErrorIndicatorBuilder: (context) {
                      return Align(
                          alignment: Alignment.center,
                          child: Text('Error while fetching next page',
                              style: TextStyle(fontSize: 18)));
                    },
                    firstPageProgressIndicatorBuilder: (context) {
                      return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(color: ColorPalette.teal500));
                    },
                    newPageProgressIndicatorBuilder: (context) {
                      return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(color: ColorPalette.teal500));
                    },
                  ),
                ),
              ],
            ),
          )
        )
      );
    }
  }
}
