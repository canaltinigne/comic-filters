import 'package:filters/filters.dart';

void main(List<String> arguments) {
  var filter = PencilSketch('static/img.jpg');
  filter.apply(9);
  filter.save();
}
