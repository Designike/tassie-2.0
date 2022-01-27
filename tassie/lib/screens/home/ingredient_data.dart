import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';

class IngredientData {
  static final storage = FlutterSecureStorage();
  static final LocalStorage lstorage = LocalStorage('tassie');

  static String? ing = "";
  static List<dynamic> ingred = [];
  static List<String> ingreds = [];

  static Future<void> getIng() async {
    ingred = json.decode(await lstorage.getItem('ingreds'))['ingredients'];
    ingreds = List<String>.from(ingred);
    // print(ingreds);
  }

  // static final List<String> ingreds = [
  //   'paneer',
  //   'rice',
  //   'wheat',
  //   'salt',
  //   'sugar'
  // ];
  // static Future<void> getIng() async {
  //   ing = await storage.read(key: 'ingreds');
  //   print(json.decode(ing!));
  // }

  static List<String> getSuggestions(String query) {
    getIng();
    print(ingreds);
    return query.isEmpty
        ? []
        : List.of(ingreds).where((ing) {
            final ingLower = ing.toLowerCase();
            final queryLower = query.toLowerCase();

            return ingLower.contains(queryLower);
          }).toList();
  }
}
