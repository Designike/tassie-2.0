import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/themePreferences.dart';

class ChangeTheme extends StatefulWidget with ChangeNotifier {
  ChangeTheme({Key? key}) : super(key: key);

  @override
  ChangeThemeState createState() => ChangeThemeState();
}

class ChangeThemeState extends State<ChangeTheme> {
  // bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  int selectedTheme = 0;
  String theme = "";
  var th = ThemeController();

  Future<void> getThemeIndex() async {
    var theme = await storage.read(key: 'theme');
    if (theme != null) {
      setState(() {
        if (theme == "dark") {
          selectedTheme = 1;
        }
        if (theme == "light") {
          selectedTheme = 2;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // ThemePreferences tp = ThemePreferences();
    // tp.getTheme();
    getThemeIndex();
  }

  @override
  void dispose() {
    super.dispose();
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
        title: const Text("Change Theme"),
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
    if (mounted) {
      setState(() {
        theme = thme;
        selectedTheme = index;
        if (theme == "System") {
          // if (themeNotifier.isDark['system'] == "false") {
          // themeNotifier.isDark = {
          //   "system": "true",
          //   "light": "false"
          // };
          th.setThemeMode(ThemeMode.system);
          // Get.changeThemeMode(ThemeMode.system);
          // }
        } else if (theme == "Light") {
          // themeNotifier.isDark = {
          //   "system": "false",
          //   "light": "true"
          // };
          th.setThemeMode(ThemeMode.light);
          // Get.changeThemeMode(ThemeMode.light);
        } else {
          // themeNotifier.isDark = {
          //   "system": "false",
          //   "light": "false"
          // };
          th.setThemeMode(ThemeMode.dark);
          // Get.changeThemeMode(ThemeMode.dark);
        }
      });
    }
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
