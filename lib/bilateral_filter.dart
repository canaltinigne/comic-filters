import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:filters/detail_enhancement_filter.dart';

class Bilateral extends DetailEnhancement {
  Bilateral(String path) : super(path);

  double distance(int x, int y, int i, int j) {
    return sqrt(pow(x - i, 2) + pow(y - j, 2));
  }

  double gaussian(double x, double sigma) {
    return (1.0 / (2 * pi * pow(sigma, 2))) *
        exp(-pow(x, 2) / (2 * pow(sigma, 2)));
  }

  Uint8List getPixelAsList(Image img, int x, int y) {
    var list = Uint32List.fromList([img.getPixel(x, y)]);
    var byte_data = list.buffer.asUint8List();

    return byte_data;
  }

  void apply_bilateral_filter(Image source, Image filtered_image, int x, int y,
      double diameter, double sigma_i, double sigma_s) {
    var hl = diameter / 2;
    var new_rgb = List.from([]);

    for (var ch = 0; ch < 3; ch++) {
      var i_filtered = 0.0;
      var wp = 0.0;
      var i = 0;

      while (i < diameter) {
        var j = 0;

        while (j < diameter) {
          var neighbour_x = (x - (hl - i)).toInt();
          var neighbour_y = (y - (hl - j)).toInt();

          if (neighbour_x >= source.height) {
            neighbour_x -= source.height;
          }

          if (neighbour_y >= source.width) {
            neighbour_y -= source.width;
          }

          if (neighbour_x > 0 && neighbour_y > 0) {
            var gi = gaussian(
                getPixelAsList(source, neighbour_x, neighbour_y)[ch]
                        .toDouble() -
                    getPixelAsList(source, x, y)[ch].toDouble(),
                sigma_i);

            var gs =
                gaussian(distance(neighbour_x, neighbour_y, x, y), sigma_s);
            var w = gi * gs;

            i_filtered += getPixelAsList(source, neighbour_x, neighbour_y)[ch]
                    .toDouble() *
                w;
            wp += w;
          }

          j += 1;
        }

        i += 1;
      }

      i_filtered = i_filtered / wp;
      new_rgb.add(i_filtered.round().toInt());
    }

    filtered_image.setPixelRgba(x, y, new_rgb[0], new_rgb[1], new_rgb[2]);
  }

  Image bilateral_filter(
      Image source, double filter_diameter, double sigma_i, double sigma_s) {
    var filtered_image = source.clone();

    for (var i = 0; i < source.height; i++) {
      for (var j = 0; j < source.width; j++) {
        apply_bilateral_filter(
            source, filtered_image, i, j, filter_diameter, sigma_i, sigma_s);
      }
    }

    return filtered_image;
  }

  @override
  void apply({int sigma = 9}) {
    var grayEdges = edgeDetection(image);
    var colorImg = bilateral_filter(image, 5, 50, 5);

    output = bitwise_and(colorImg, colorImg, grayEdges);
  }
}
