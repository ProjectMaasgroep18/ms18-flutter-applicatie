int stringToColor(String? stringColor, [int defaultColor = 0xFFFFFFFF]) {
  if (stringColor == null) return defaultColor;

  final String hexColor = "FF${stringColor.replaceAll('#', '')}";
  final int color = int.tryParse(hexColor, radix: 16) ?? defaultColor;
  return color;
}