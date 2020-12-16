import 'package:image/image.dart';
import 'package:filters/filter.dart';

class PencilEdges extends Filter {
  PencilEdges(String path) : super(path);

  Image threshold(Image img, double threshold) {
    var img_b = img.getBytes();

    for (var i = 0, len = img_b.length; i < len; i += 4) {
      for (var j = 0; j < 3; j += 1) {
        if (img_b[i + j] > threshold) {
          img_b[i + j] = 255;
        } else {
          img_b[i + j] = 0;
        }
      }
    }

    return img;
  }

  @override
  void apply({int sigma = 9}) {
    var edges = sobel(grayscale(image.clone()));
    var inverseEdges = invert(edges.clone());
    output = threshold(inverseEdges, 210);
  }
}
