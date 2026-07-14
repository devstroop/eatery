import 'package:eatery_core/data/models/eatery_db.dart';

abstract class ModifierRepository {
  List<ModifierGroup> getAllGroups();
  ModifierGroup? getGroupById(int id);
  Future<int> saveGroup(ModifierGroup group);
  Future<void> deleteGroup(int id);
  List<Modifier> getModifiers(int groupId);
  Modifier? getModifierById(int id);
  Future<int> saveModifier(Modifier modifier);
  Future<void> deleteModifier(int id);
  List<ModifierGroup> getGroupsForProduct(int productId);
  Future<void> setProductGroups(int productId, List<int> groupIds);
}
