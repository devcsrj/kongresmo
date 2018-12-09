import 'package:html/dom.dart';
import 'package:kongresmo_project/legislation/utils.dart';
import 'package:test_api/test_api.dart';

void main() {
  test('ordinalOf(..)', () {
    expect(Utils.ordinalOf(1), "first");
    expect(Utils.ordinalOf(2), "second");
    expect(Utils.ordinalOf(3), "third");
    expect(Utils.ordinalOf(4), "fourth");
    expect(Utils.ordinalOf(5), "fifth");
    expect(Utils.ordinalOf(6), "sixth");
    expect(Utils.ordinalOf(7), "seventh");
    expect(Utils.ordinalOf(8), "eighth");
    expect(Utils.ordinalOf(9), "ninth");
    expect(Utils.ordinalOf(10), "tenth");
    expect(Utils.ordinalOf(11), "eleventh");
    expect(Utils.ordinalOf(12), "twelfth");
    expect(Utils.ordinalOf(13), "thirteenth");
    expect(Utils.ordinalOf(14), "fourteenth");
    expect(Utils.ordinalOf(15), "fifteenth");
    expect(Utils.ordinalOf(16), "sixteenth");
    expect(Utils.ordinalOf(17), "seventeenth");
    expect(Utils.ordinalOf(18), "eighteenth");
    expect(Utils.ordinalOf(19), "nineteenth");
    expect(Utils.ordinalOf(20), "twentieth");
    expect(Utils.ordinalOf(21), "twentyfirst");

    expect(Utils.ordinalOf(50), "fifty");
    expect(Utils.ordinalOf(54), "fiftyfourth");
  });

  test('ordinalOf(100++) is so much wow', () {
    try {
      Utils.ordinalOf(100);
      fail("Oops");
    } on AssertionError catch (ex) {
      expect(ex.message, "Oh wow, we're now on to 100 Congress? Congrats PH!");
    }
  });

  test("can get element's own text", () {
    var span = Element.tag('span');
    span.text = "World";

    var p = Element.tag('p');
    p.text = "Hello";
    p.append(span);

    expect(p.text, "HelloWorld");
    var actual = Utils.innerText(p);
    expect(p.text, "HelloWorld"); // should retain original element
    expect(actual, "Hello");
  });

  test("can get element's own text even with new lines", () {
    var p = Element.tag('p');
    p.text = "Hello\nWorld";

    expect(p.text, "Hello\nWorld");
    var actual = Utils.innerText(p);
    expect(p.text, "Hello\nWorld"); // should retain original element
    expect(actual, "HelloWorld");
  });
}
