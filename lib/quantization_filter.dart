import 'package:filters/filter.dart';
import 'package:kmeans/kmeans.dart';

class Quantization extends Filter {
  Quantization(String path) : super(path);

  @override
  void apply({int sigma = 9}) {
    var pixels = List<List<double>>.from([]);
    var clusteredImage = image.clone();

    for (var i = 0; i < image.width; i++) {
      for (var j = 0; j < image.height; j++) {
        var rgb = getPixelAsList(image, i, j);
        pixels.add([rgb[0].toDouble(), rgb[1].toDouble(), rgb[2].toDouble()]);
      }
    }

    var kmeans = KMeans(pixels);
    var k = 10;
    var clusters = kmeans.fit(k);
    var predicted = clusters.clusters;
    var centers = clusters.means;

    for (var i = 0; i < image.width; i++) {
      for (var j = 0; j < image.height; j++) {
        var pred_rgb = predicted[image.width * j + i];
        var pred_center = centers[pred_rgb];

        clusteredImage.setPixelRgba(j, i, pred_center[0].toInt(),
            pred_center[1].toInt(), pred_center[2].toInt());
      }
    }

    output = clusteredImage;
  }
}
