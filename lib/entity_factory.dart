import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/entity/poetry_entity.dart';
import 'package:my_todo/entity/todo_group_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "MatterData") {
      return MatterData.fromJson(json) as T;
    } else if (T.toString() == "PoetryEntity") {
      return PoetryEntity.fromJson(json) as T;
    } else if (T.toString() == "TodoGroupEntity") {
      return TodoGroupEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}