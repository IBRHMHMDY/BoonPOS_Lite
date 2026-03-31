import '../../../../core/database/database_service.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/shift_model.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final DatabaseService databaseService;

  ShiftRepositoryImpl({required this.databaseService});

  @override
  Future<ShiftEntity?> getActiveShift() async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'shifts',
      where: 'status = ?',
      whereArgs: ['open'],
      orderBy: 'id DESC', // لجلب أحدث وردية مفتوحة في حال حدث خطأ ما وتعددت الورديات
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ShiftModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<ShiftEntity> openShift(int userId, double startingCash) async {
    final db = await databaseService.database;
    final String now = DateTime.now().toIso8601String();

    final Map<String, dynamic> shiftData = {
      'user_id': userId,
      'opened_at': now,
      'starting_cash': startingCash,
      'status': 'open',
    };

    final int id = await db.insert('shifts', shiftData);
    
    return ShiftModel(
      id: id,
      userId: userId,
      openedAt: now,
      startingCash: startingCash,
      status: 'open',
    );
  }
}