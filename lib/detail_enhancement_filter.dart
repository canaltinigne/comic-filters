import 'package:image/image.dart';
import 'package:filters/filter.dart';

class DetailEnhancement extends Filter {
  DetailEnhancement(String path) : super(path);

  @override
  void apply({int sigma = 9}) {
    var grayEdges = edgeDetection(image);
    var laplacianFilter = List<num>.from([-1, -1, -1, -1, 9, -1, -1, -1, -1]);
    var colorSharpened = convolution(image.clone(), laplacianFilter);

    output = bitwise_and(colorSharpened, colorSharpened, grayEdges);
  }
}
