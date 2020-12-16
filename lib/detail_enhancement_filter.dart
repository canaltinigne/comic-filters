import 'package:image/image.dart';
import 'package:filters/filter.dart';

class DetailEnhancement extends Filter {
  DetailEnhancement(String path) : super(path);

  Image bitwise_and(Image img1, Image img2, Image msk) {
    var img_b = img1.getBytes();
    var img2_b = img2.getBytes();
    var msk_b = msk.getBytes();

    for (var i = 0, len = img_b.length; i < len; i += 4) {
      for (var j = 0; j < 3; j += 1) {
        if (msk_b[i + j] != 0) {
          img_b[i + j] = img_b[i + j] & img2_b[i + j];
        }
      }
    }

    return img1;
  }

  @override
  void apply({int sigma = 9}) {
    var grayEdges = sobel(grayscale(image.clone()));
    var laplacianFilter = List<num>.from([-1, -1, -1, -1, 9, -1, -1, -1, -1]);
    var colorSharpened = convolution(image.clone(), laplacianFilter);

    output = bitwise_and(colorSharpened, colorSharpened, grayEdges);
  }
}
