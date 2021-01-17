import 'package:filters/filter.dart';
import 'package:image/image.dart';

class Pixelate extends Filter {
  Pixelate(String path) : super(path);

  @override
  void apply({int sigma = 9}) {
    final org_w = image.width;
    final org_h = image.height;

    var shrinked_img = copyResize(image,
        width: org_w ~/ 8,
        height: org_h ~/ 8,
        interpolation: Interpolation.linear);

    var enlarged_img = copyResize(shrinked_img,
        width: org_w, height: org_h, interpolation: Interpolation.nearest);

    output = enlarged_img;
  }
}
