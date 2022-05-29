extension StringExtension on String {
    String capitaliz() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}