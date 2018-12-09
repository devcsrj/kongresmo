import 'dart:math';

import 'package:html/dom.dart';

class Utils {
  Utils() {
    throw new AssertionError("Intentionally unimplemented");
  }

  /// Converts the provided {@code number} into its word equivalent.
  /// e.g.: 17 becomes 'seventeenth'
  static String ordinalOf(int number) {
    // log10(number)
    int places = (log(number) ~/ log(10));
    if (places + 1 >= 3) {
      throw new AssertionError(
          "Oh wow, we're now on to $number Congress? Congrats PH!");
    }

    const singleDigitOrdinals = [
      'first',
      'second',
      'third',
      'fourth',
      'fifth',
      'sixth',
      'seventh',
      'eighth',
      'ninth',
      'tenth'
    ];
    if (number <= 10) return singleDigitOrdinals[number - 1];
    const oneToTwentyOrdinals = [
      'eleventh',
      'twelfth',
      'thirteenth',
      'fourteenth',
      'fifteenth',
      'sixteenth',
      'seventeenth',
      'eighteenth',
      'nineteenth',
      'twentieth'
    ];
    if (number <= 20) return oneToTwentyOrdinals[number - 11];

    const byTenOrdinals = [
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];
    int tens = number ~/ 10;
    String firstWord = byTenOrdinals[tens - 1];
    int ones = number - (tens * 10);
    if (ones == 0) return firstWord;

    String secondWord = singleDigitOrdinals[ones - 1];
    return firstWord + secondWord;
  }

  /// Returns the 'own text' (without the text of children) of the element
  static String innerText(Element element) {
    var copy = element.clone(true);
    var children = copy.children;
    for (var e in children) e.remove();
    return copy.text.replaceAll(new RegExp('(\r\n|\r|\n)'), '');
  }
}
