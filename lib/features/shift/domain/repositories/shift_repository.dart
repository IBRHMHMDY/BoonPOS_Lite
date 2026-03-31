import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  /// جلب الوردية المفتوحة حالياً (إن وجدت)
  /// يرجع [ShiftEntity] إذا كان هناك وردية مفتوحة، وإلا يرجع null
  Future<ShiftEntity?> getActiveShift();

  /// فتح وردية جديدة للكاشير الحالي بعهدة محددة
  /// يرجع [ShiftEntity] للوردية التي تم إنشاؤها للتو
  Future<ShiftEntity> openShift(int userId, double startingCash);
}