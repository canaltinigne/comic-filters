import 'package:filters/detail_enhancement_filter.dart';
import 'package:filters/pencil_sketch_filter.dart';

void main(List<String> arguments) {
  var de_filter = DetailEnhancement('static/img.jpg');
  de_filter.apply();
  de_filter.save('static/de_filter.png');

  var ps_filter = PencilSketch('static/img.jpg');
  ps_filter.apply(sigma: 9);
  ps_filter.save('static/ps_filter.png');
}
