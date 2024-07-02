import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Screens/Tabs/recommended_tab.dart';
import 'package:kibun/Screens/Tabs/playlists_tab.dart';
import 'package:kibun/Screens/Tabs/user_tab.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavbarScaffoldingScreen extends StatefulWidget{

  const NavbarScaffoldingScreen({super.key});

  @override
  State<NavbarScaffoldingScreen> createState() => _NavbarScaffoldingScreenState();
  
}

class _NavbarScaffoldingScreenState extends State<NavbarScaffoldingScreen> {
  String? tokenRead = '';
  String? link = '';
  String name = '';
  String email = '';
  bool _isLoading = true;
  final List<PersistentTabConfig> _pages = [];
  final storage = const FlutterSecureStorage(); 
  late PersistentTabController _controller;

@override
  void initState() {
    super.initState();
     _controller = PersistentTabController(initialIndex: 1);
    _isLoading = true;

    () async {
      WidgetsFlutterBinding.ensureInitialized();
      _pages.addAll([
         PersistentTabConfig(screen: const RecommendedTab(), item:  ItemConfig(
          icon: const Icon(Icons.recommend_outlined),
          title: "Recommended",
          activeForegroundColor : ColorPalette.teal800,
          activeColorSecondary: ColorPalette.teal800
        ),),
        PersistentTabConfig(screen: 
          const PlaylistsTab(
          ),
          item: ItemConfig(
            icon: const Icon(Icons.playlist_play),
            title: "Playlists",
            activeForegroundColor: ColorPalette.teal800,
            activeColorSecondary: ColorPalette.teal800
          ),
        ),
        PersistentTabConfig(screen: const UserTab(),
          item: ItemConfig(
            icon: const Icon(Icons.menu),
            title: "Ustawienia",
            activeForegroundColor: ColorPalette.teal800,
            activeColorSecondary: ColorPalette.teal800
          ),
        ),
      ]);
    }();
    
    loadData();

    if(mounted == true){
      setState(() {});
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

Future<void> loadData() async {
  try {
    await readToken();
    if (tokenRead != null && tokenRead!.isNotEmpty) {
      await getUserCredentials();
      setState(() {
        _isLoading = false;
      });
    } else {

      setState(() {
        _isLoading = false;
      });
      log("Token jest pusty bądź niedostepny!");
    }
  } catch (e) {
    log("Błąd podczas wczytywania danych: $e");
    setState(() {
      _isLoading = false;
    });
  }
}

Future<void> getUserCredentials() async {
  try {
    Map<String, dynamic> credentials = await getCredentials(tokenRead.toString());
    name = credentials['name'];
    email = credentials['email'];
    log("Dane zostały wczytane poprawnie:");
  } catch (e) {
    log("Wystąpił błąd podczas wczytywania danych: $e");
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> readToken() async{
    tokenRead = await StorageService().readToken();
  }

  String credentialsQuery() {
    return '''query{
      me{
        id
        email
        name
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getCredentials(String token) async {
  try {
    final HttpLink httpLink = HttpLink(ServerAddressEnum.PUBLIC1.ipAddress);
    final authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    Link valueNotifierLink = authLink.concat(httpLink);

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: valueNotifierLink,
        cache: GraphQLCache(),
      ),
    );

    String query = credentialsQuery();
    final QueryOptions options = QueryOptions(
      document: gql(query)
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      throw Exception("Błąd GraphQL: ${result.exception}");
    }

    final data = result.data?['me'];

    if (data == null) {
      return <String, dynamic>{};
    }

    final Map<String, dynamic> dataList = Map<String, dynamic>.from(data);

    return dataList;
  } catch (e) {
    throw Exception("Błąd podczas fetchowania danych: $e");
  }
}

@override
  Widget build(BuildContext context){
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: ColorPalette.black600,
          statusBarColor: ColorPalette.black500,
        )
      );
    });
    if (_isLoading == true){
      return const Scaffold(
        backgroundColor: ColorPalette.black500,
        body: Align(alignment: Alignment.center, child: CircularProgressIndicator(color: ColorPalette.black500),),
        );
    } else {
      return
            SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: PersistentTabView(
                  controller: _controller,
                  tabs: _pages,
                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset: false,
                  stateManagement: false,
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 250),
                  ),
                  navBarBuilder: (navBarConfig) => Style5BottomNavBar(
                    navBarDecoration: NavBarDecoration(
                      color: ColorPalette.black600,
                      boxShadow: [ 
                        BoxShadow(
                          color: ColorPalette.black100.withOpacity(0.33),
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ) 
                      ], 
                    ),
                    navBarConfig: navBarConfig,
                  ),
                ),
              ),
            );
    }
    }
}
