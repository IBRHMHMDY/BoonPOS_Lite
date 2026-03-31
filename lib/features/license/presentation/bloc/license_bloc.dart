import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/device_helper.dart';
import '../../domain/usecases/activate_license.dart';
import '../../domain/usecases/check_license.dart';
import 'license_event.dart';
import 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  final CheckLicenseUseCase checkLicense;
  final ActivateLicenseUseCase activateLicense;

  LicenseBloc({
    required this.checkLicense,
    required this.activateLicense,
  }) : super(LicenseInitial()) {
    on<CheckLicenseEvent>(_onCheckLicense);
    on<ActivateLicenseEvent>(_onActivateLicense);
  }

  Future<void> _onCheckLicense(CheckLicenseEvent event, Emitter<LicenseState> emit) async {
    emit(LicenseLoading());
    try {
      // استخدام الـ UseCase بدلاً من الـ Repository
      final bool isValid = await checkLicense(NoParams());
      if (isValid) {
        emit(LicenseValid());
      } else {
        final String deviceId = await DeviceHelper.getDeviceId();
        emit(LicenseInvalid(deviceId: deviceId));
      }
    } catch (e) {
      emit(const LicenseError(message: 'حدث خطأ غير متوقع أثناء فحص الترخيص.'));
    }
  }

  Future<void> _onActivateLicense(ActivateLicenseEvent event, Emitter<LicenseState> emit) async {
    emit(LicenseLoading());
    try {
      // استخدام الـ UseCase
      final bool success = await activateLicense(event.licenseKey);
      if (success) {
        emit(LicenseValid());
      } else {
        final String deviceId = await DeviceHelper.getDeviceId();
        emit(LicenseError(
          message: 'مفتاح الترخيص غير صالح أو منتهي الصلاحية.', 
          deviceId: deviceId
        ));
      }
    } catch (e) {
      emit(const LicenseError(message: 'حدث خطأ أثناء محاولة التفعيل.'));
    }
  }
}