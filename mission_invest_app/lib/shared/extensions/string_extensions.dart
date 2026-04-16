extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((word) => word.capitalize).join(' ');

  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';
}
