import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tassie/screens/home/main/add/uploadPostImage.dart';
import 'package:tassie/utils/imgLoader.dart';
import '../../../../../constants.dart';
import '../../../../../utils/hashtagSuggestions.dart';

class EditPost extends StatefulWidget {
  const EditPost({required this.uuid, Key? key}): super(key: key);
  final String uuid;
  @override
  EditPostState createState() => EditPostState();
}

class EditPostState extends State<EditPost> {
  // File? _imageFile;
  static String desc = "";
  TextEditingController _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  Map post = {};
  late Future storedFuture;

  AsyncMemoizer memoizer = AsyncMemoizer();

  Future<void> getPost() async {
    var dio = Dio();
    var token = await storage.read(key: "token");
    Response response = await dio.get(
      // "https://api-tassie.herokuapp.com/user/",
      "https://api-tassie.herokuapp.com/profile/getPost/${widget.uuid}",
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${token!}",
      }),
    );
    setState(() {
      post = response.data['data'];
      _tagController = TextEditingController(text: post['description']);
      isLoading = false;
    });
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String _appendHashtag(desc1, tag) {
    String last = desc1.substring(desc1.length - 1);
    while (last != '#') {
      desc1 = desc1.substring(0, desc1.length - 1);
      last = desc1.substring(desc1.length - 1);
    }
    return desc1 + tag.substring(1, tag.length);
  }

  @override
  void initState() {
    desc = '';
    super.initState();
    getPost();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(post['postID'], memoizer);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return isLoading
        ? Scaffold(
            body: Container(),
          )
        : Scaffold(
            body: ListView(
              children: <Widget>[
                const SizedBox(height: 15.0),
                const Text(
                  'Some toppings ...',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontFamily: 'LobsterTwo',
                    fontSize: 35.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * 1.5),
                  child: FutureBuilder(
                      future: storedFuture,
                      builder: (BuildContext context, AsyncSnapshot text) {
                        if (text.connectionState == ConnectionState.waiting) {
                          return const Image(
                            image: AssetImage('assets/images/broken.png'),
                            fit: BoxFit.cover,
                          );
                        } else if (text.hasError) {
                          return const Image(
                            image: AssetImage('assets/images/broken.png'),
                            fit: BoxFit.cover,
                          );
                        } else {
                          if (!text.hasData) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: const Center(
                                  child: Icon(
                                Icons.refresh,
                                size: 50.0,
                                color: kDark,
                                  ),
                                ));
                          }
                          return Image(
                            image: NetworkImage(
                              text.data.toString(),
                            ),
                            fit: BoxFit.cover,
                          );
                        }
                      }),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * 1.5),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TypeAheadFormField<String?>(
                            hideOnEmpty: true,
                            debounceDuration: const Duration(seconds: 1),
                            direction: AxisDirection.up,
                            suggestionsCallback: Hashtags.getSuggestions,
                            textFieldConfiguration: TextFieldConfiguration(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _tagController,
                              onChanged: (v) {
                                desc = v;
                              },
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  // fontFamily: 'Raleway',
                                  fontSize: 16.0,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? kPrimaryColor
                                      : kDark[900],
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                    vertical: kDefaultPadding),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? kPrimaryColor
                                          : kDark[900]!),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            itemBuilder: (context, String? suggestion) =>
                                ListTile(
                              title: Text(suggestion!),
                            ),
                            onSuggestionSelected: (v) {
                              // setState(() {
                              _tagController.text = _appendHashtag(desc, v);
                              // });
                            },
                            validator: (val) => val!.isEmpty || val.length > 500
                                ? 'Description should be within 500 characters'
                                : null,
                          ),
                        ],
                      )),
                ),
                Uploader(
                    desc: desc,
                    formKey: _formKey,
                    edit: true,
                    postUuid: widget.uuid)
              ],
            ),
          );
  }
}
