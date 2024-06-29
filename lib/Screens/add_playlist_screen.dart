// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/flushbar_service.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Widgets/background_widget.dart';
import 'package:kibun/Widgets/file_upload_widget.dart';
import 'package:kibun/Widgets/textfield_widget.dart';

class AddPlaylistScreen extends StatefulWidget{

  const AddPlaylistScreen({super.key});

  @override
  State<AddPlaylistScreen> createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  TextEditingController noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();  
  final storage = const FlutterSecureStorage();
  String? tokenRead = '';
  String? link = '';
  String searchText = "";
  String total = '';
  String? terminalId = '';
  String? machineId = '';
  bool showSearchBar = false;
  File? _image;
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    readLink();
    readToken();
    if(mounted == true){
      setState(() {});
    }
  }

  Future getImageFromGallery() async {
  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 60,
    maxHeight: 1920,
    maxWidth: 1080,
  );

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie wybrano niczego')),
      );
    }
  });
}

Future getImageFromCamera() async {
  final pickedFile = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 60,
    maxHeight: 1920,
    maxWidth: 1080,
  );

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  });
}

void deleteImage() {
  setState(() {
    _image = null;
  });
}

  Future<void> readLink() async {
    link = ServerAddressEnum.PUBLIC1.ipAddress;
  }

  Future<void> readToken() async {
    tokenRead = await StorageService().readToken();
  }

  Future<int> createNewUserPlaylist() async {
    final HttpLink _httpLink = HttpLink(link.toString());
    final _authLink = AuthLink(
      getToken: () async => 'Bearer $tokenRead',
    );
    Link _link = _authLink.concat(_httpLink);
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: _link,
        cache: GraphQLCache(),
      ),
    );

    List<int> combinedBytes = await _image!.readAsBytes();
    MultipartFile multipartFile = MultipartFile.fromBytes(
      'file',
      combinedBytes,
      filename: _image!.path.split(Platform.pathSeparator).last,
    );

    try {
      final MutationOptions options = MutationOptions(
        document: gql(createNewUserPlaylistMutation),
        variables: {
          "name": noteController.text,
          "image": multipartFile, 
        },
      );

      final QueryResult queryResult = await client.value.mutate(options);

      if (queryResult.hasException) {
        log(queryResult.exception.toString());
        return 1;
      } 
    } catch (e) {
      log(e.toString());
    }
    return 0;
  }

 static const createNewUserPlaylistMutation =  r'''
  mutation createNewUserPlaylist($name: String!, $image: Upload!){
      createNewUserPlaylist(
        name: $name, image: $image
      )
    }
  ''';

@override
  Widget build(BuildContext context){
      return Form(
          key: _formKey,
          child: Scaffold(
          appBar: AppBar(
            shadowColor: ColorPalette.black500,
            backgroundColor: ColorPalette.black500,
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Container(padding: const EdgeInsets.only(left: 4), child: const Text('Add playlist image')),
            const Align(alignment: Alignment.centerRight, child: Icon(Icons.image, size: 30,))
          ],
        ),
          ),
          body: BackgroundWidget(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children:[
                const SizedBox(height: 10,),
                TextFieldWidget(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required!';
                    }
                    return null;
                  },
                  borderSide: BorderSide.none,
                  controller: noteController,
                  bottomPadding: 0,
                  keyboardType: TextInputType.text,
                  inputColor: ColorPalette.neutralsWhite,
                  labelStyleColor: ColorPalette.neutralsWhite,
                  cursorColor: ColorPalette.neutralsWhite,
                  fillColor: ColorPalette.black100,
                  prefixIconColor: ColorPalette.neutralsWhite,
                  suffixIconColor: ColorPalette.neutralsWhite,
                  borderSideColor: ColorPalette.neutralsWhite,
                  hintText: 'Playlist name',
                  obscureText: false,
                  prefixIconData: Icons.note_outlined,
                  suffixIconData: null,
                  onChanged: (value) {},
                  onTap: () { },
                ),
                const SizedBox(height: 15,),
                FileUploadWidget(
                  context: context,
                  file: _image,
                  getImageFromGallery: getImageFromGallery, 
                  getImageFromCamera: getImageFromCamera, 
                  deleteFile: deleteImage
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: 
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: ColorPalette.teal200,
                      backgroundColor: ColorPalette.teal500,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {          
                      if (_formKey.currentState!.validate() == false || _image == null) {
                        FlushBarService().showCustomSnackBar(context, "Fill all required fields", ColorPalette.errorColor, const Icon(Icons.error, color: Colors.white, size: 18));
                        return;
                      }
                      if (noteController.text != ''){
                          var result = await createNewUserPlaylist();
                          if(result == 0){
                            Navigator.pop(context);
                            FlushBarService().showCustomSnackBar(context, "Added successfully", ColorPalette.successColor, const Icon(Icons.check, color: Colors.white, size: 18));
                          } else if (result == 1) {
                            FlushBarService().showCustomSnackBar(context, "Unknown error", ColorPalette.errorColor, const Icon(Icons.error, color: Colors.white, size: 18));
                          }
                      }
                    }, 
                    child: const Text("Potwierdź",
                      style: TextStyle(
                        fontSize: FontSize.regular,
                        color: ColorPalette.black500,
                      ),
                    ),
                   ),
                  )
                ]
              ),
            ),
          )
        )
      );
   }
}