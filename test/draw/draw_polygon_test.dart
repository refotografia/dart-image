import 'dart:io';
import 'package:image/image.dart';
import 'package:test/test.dart';

import '../_test_util.dart';

void main() {
  group('Draw', () {
    test('drawPolygon', () {
      final i0 = Image(width: 256, height: 256);

      final vertices = <Point>[Point(50, 50), Point(200, 20),
        Point(120, 70), Point(30, 150)];

      drawPolygon(i0, vertices: vertices, color: ColorRgb8(255, 0, 0));

      File('$testOutputPath/draw/drawPolygon.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(encodePng(i0));
    });
  });
}
