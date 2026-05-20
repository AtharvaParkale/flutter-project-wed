import 'package:flutter_project/practice/features/products/domain/entities/dimensions.dart';

class DimensionsModel extends Dimensions {
  const DimensionsModel({super.width, super.height, super.depth});

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: (json['width'] as num?)?.toDouble(),

      height: (json['height'] as num?)?.toDouble(),

      depth: (json['depth'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height, 'depth': depth};
  }
}
