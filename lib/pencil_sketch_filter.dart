import 'package:image/image.dart';
import 'package:filters/filter.dart';

class PencilSketch extends Filter {
  PencilSketch(String path) : super(path);

  Image ImageDodge(Image img1, Image img2) {
    return divide(img1, invert(img2.clone()), 255.0);
  }

  Image ImageBurn(Image img1, Image img2) {
    var img1diff = invert(img1);
    var msk = invert(img2);
    var divided = divide(img1diff, msk, 255.0);

    return invert(divided);
  }

  @override
  void apply({int sigma = 9}) {
    var grayScale = grayscale(image);
    var grayNegative = invert(grayScale.clone());
    var grayNegBlurred = gaussianBlur(grayNegative.clone(), sigma);

    var dodgedImage = ImageDodge(grayScale.clone(), grayNegBlurred.clone());
    var burnedImage = ImageBurn(dodgedImage.clone(), grayNegBlurred.clone());

    output = burnedImage;
  }
}
