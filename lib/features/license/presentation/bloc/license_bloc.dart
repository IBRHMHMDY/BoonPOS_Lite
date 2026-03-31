import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/license_repository.dart';
import '../../../../core/utils/device_helper.dart';
import 'license_event.dart';
import 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  final LicenseRepository repository;

  LicenseBloc({required this.repository}) : super(LicenseInitial()) {
    on<CheckLicenseEvent>(_onCheckLicense);
    on<ActivateLicenseEvent>(_onActivateLicense);
  }

  Future<void> _onCheckLicense(CheckLicenseEvent event, Emitter<LicenseState> emit) async {
    emit(LicenseLoading());
    try {
      final bool isValid = await repository.isLicenseValid();
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
      final bool success = await repository.activateLicense(event.licenseKey);
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