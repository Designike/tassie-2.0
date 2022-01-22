class IngredientData {
  
  static final List<String> ingreds = ['paneer', 'rice', 'wheat', 'salt', 'sugar'];

  static List<String> getSuggestions(String query) => query.isEmpty ? [] :
    List.of(ingreds).where((ing) {
      final ingLower = ing.toLowerCase();
      final queryLower = query.toLowerCase();

      return ingLower.contains(queryLower);
    }).toList();
  
}