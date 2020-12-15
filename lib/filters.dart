import 'dart:io' as io;
import 'package:image/image.dart';

class Filter {
  Image image, output;
  String path;

  Filter(this.path) {
    image = decodeImage(io.File(path).readAsBytesSync());
  }

  void apply(int sigma) {}

  void save() {
    io.File('static/filtered_img.png')..writeAsBytesSync(encodePng(output));
  }

  int clip(double val) {
    return (val > 255) ? 255 : val.toInt();
  }

  Image divide(Image img1, Image img2, double scalar) {
    var img1_b = img1.getBytes();
    var img2_b = img2.getBytes();

    for (var i = 0, len = img1_b.length; i < len; i += 4) {
      for (var j = 0; j < 3; j += 1) {
        if (img2_b[i + j] != 0) {
          img1_b[i + j] = clip(
              img1_b[i + j].toDouble() / img2_b[i + j].toDouble() * scalar);
        }
      }
    }

    return img1;
  }
}

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
  void apply(int sigma) {
    var grayScale = grayscale(image);
    var grayNegative = invert(grayScale.clone());
    var grayNegBlurred = gaussianBlur(grayNegative.clone(), sigma);

    var dodgedImage = ImageDodge(grayScale.clone(), grayNegBlurred.clone());
    var burnedImage = ImageBurn(dodgedImage.clone(), grayNegBlurred.clone());

    output = burnedImage;
  }
}
