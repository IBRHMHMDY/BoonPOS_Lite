import 'package:equatable/equatable.dart';

// واجهة أساسية لجميع حالات الاستخدام
// Type: هو نوع البيانات المرجعة (مثلاً UserEntity)
// Params: هي المتغيرات المرسلة (مثلاً رقم الـ PIN)
abstract class UseCase<DataType, Params> {
  Future<DataType> call(Params params);
}

// كلاس يُستخدم عندما لا تتطلب حالة الاستخدام أي متغيرات
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}