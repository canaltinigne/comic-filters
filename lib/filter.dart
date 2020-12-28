import 'dart:io' as io;
import 'dart:typed_data';
import 'package:image/image.dart';

class Filter {
  Image image, output;
  String path;

  Filter(this.path) {
    image = decodeImage(io.File(path).readAsBytesSync());
  }

  void apply({int sigma = 9}) {}

  void save(path) {
    io.File(path)..writeAsBytesSync(encodePng(output));
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

  Uint8List getPixelAsList(Image img, int x, int y) {
    var list = Uint32List.fromList([img.getPixel(x, y)]);
    var byte_data = list.buffer.asUint8List();

    return byte_data;
  }

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

  Image edgeDetection(Image img) {
    return threshold(
        invert(sobel(gaussianBlur(grayscale(img.clone()), 3))), 200);
  }

  Image bitwise_and(Image img1, Image img2, Image msk) {
    var img_b = img1.getBytes();
    var img2_b = img2.getBytes();
    var msk_b = msk.getBytes();

    for (var i = 0, len = img_b.length; i < len; i += 4) {
      for (var j = 0; j < 3; j += 1) {
        if (msk_b[i + j] != 0) {
          img_b[i + j] = img_b[i + j] & img2_b[i + j];
        } else {
          img_b[i + j] = 0;
        }
      }
    }

    return img1;
  }

  Image addWeighted(Image img1, double alpha, Image img2) {
    var img1_b = img1.getBytes();
    var img2_b = img2.getBytes();

    for (var i = 0, len = img1_b.length; i < len; i += 4) {
      for (var j = 0; j < 3; j += 1) {
        img1_b[i + j] = (alpha * img1_b[i + j].toDouble() +
                (1 - alpha) * img2_b[i + j].toDouble())
            .toInt();
      }
    }

    return img1;
  }
}
