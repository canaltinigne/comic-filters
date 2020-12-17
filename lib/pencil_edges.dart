import 'package:image/image.dart';
import 'package:filters/filter.dart';

class PencilEdges extends Filter {
  PencilEdges(String path) : super(path);

  @override
  void apply({int sigma = 9}) {
    var edges = sobel(grayscale(image.clone()));
    var inverseEdges = invert(edges.clone());
    output = threshold(inverseEdges, 210);
  }
}
