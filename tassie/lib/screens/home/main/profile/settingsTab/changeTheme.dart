import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tassie/constants.dart';

class ChangeTheme extends StatefulWidget with ChangeNotifier {
  ChangeTheme({Key? key}) : super(key: key);

  @override
  ChangeThemeState createState() => ChangeThemeState();
}

class ChangeThemeState extends State<ChangeTheme> {
  // bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  int selectedTheme = 0;
  String theme = "";

  // Future<void> checkUsername(username) async {
  //   var dio = Dio();
  //   // print(username);
  //   try {
  //     // print('');
  //     Response response =
  //         await dio.get("https://api-tassie.herokuapp.com/user/username/" + username);
  //     // var res = jsonDecode(response.toString());

  //     // if(response)
  //     // return res.status;
  //     // print(response);
  //     setState(() {
  //       uniqueUsername = response.data['status'];
  //     });
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       setState(() {
  //         uniqueUsername = e.response!.data['status'];
  //       });
  //     }
  //   }
  //   print(uniqueUsername);
  // }

  @override
  void initState() {
    super.initState();
    // ThemePreferences tp = ThemePreferences();
    // tp.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? kLight
            : kDark[900],
        // elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: const Text( "Change Email"),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.done_rounded,
                // color: Colors.green,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                Navigator.pop(context);
               
              })
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                themeRadio(0, "System"),
                const SizedBox(
                  height: 15.0,
                ),
                themeRadio(1, "Dark"),
                const SizedBox(
                  height: 15.0,
                ),
                themeRadio(2, "Light"),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeTheme(int index, String thme) {
    setState(() {
      theme = thme;
      selectedTheme = index;
      if (theme == "System") {
        // if (themeNotifier.isDark['system'] == "false") {
        // themeNotifier.isDark = {
        //   "system": "true",
        //   "light": "false"
        // };
        Get.changeThemeMode(ThemeMode.system);
        // }
      } else if (theme == "Light") {
        // themeNotifier.isDark = {
        //   "system": "false",
        //   "light": "true"
        // };
        Get.changeThemeMode(ThemeMode.light);
      } else {
        // themeNotifier.isDark = {
        //   "system": "false",
        //   "light": "false"
        // };
        Get.changeThemeMode(ThemeMode.dark);
      }
    });
    // print(flavour);
  }

  Widget themeRadio(int index, String flav) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding),
      child: OutlinedButton(
        onPressed: () => changeTheme(index, flav),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: const EdgeInsets.all(15.0),
          side: BorderSide(
            color: selectedTheme == index ? kPrimaryColor : kDark,
            width: selectedTheme == index ? 2 : 1,
          ),
          backgroundColor: selectedTheme == index
              ? kPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(flav),
      ),
    );
  }
}
