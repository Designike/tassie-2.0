extension StringExtension on String {
    String capitaliz() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}