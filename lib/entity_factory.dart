import 'package:my_todo/entity/matter_data_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "MatterData") {
      return MatterData.fromJson(json) as T;
    } else {
      return null;
    }
  }
}