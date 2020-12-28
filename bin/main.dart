import 'package:filters/bilateral_filter.dart';
import 'package:filters/detail_enhancement_filter.dart';
import 'package:filters/pencil_sketch_filter.dart';
import 'package:filters/pencil_edges.dart';
import 'package:filters/quantization_filter.dart';
import 'package:filters/popart.dart';

void main(List<String> arguments) {
  /*
  var de_filter = DetailEnhancement('static/img.jpg');
  de_filter.apply();
  de_filter.save('static/digitalEnhancement_filter.png');

  var ps_filter = PencilSketch('static/img.jpg');
  ps_filter.apply(sigma: 9);
  ps_filter.save('static/pencilSketch_filter.png');

  var pe_filter = PencilEdges('static/img.jpg');
  pe_filter.apply();
  pe_filter.save('static/pencilEdges_filter.png');

  var bl_filter = Bilateral('static/img.jpg');
  bl_filter.apply();
  bl_filter.save('static/bilateral_filter.png');

  var qt_filter = Quantization('static/img.jpg');
  qt_filter.apply();
  qt_filter.save('static/quantization_filter.png');
  */

  var popart = PopArt('static/img.jpg');
  popart.apply();
  popart.save('static/popart_filter.png');
}
