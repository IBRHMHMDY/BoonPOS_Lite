import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/license_bloc.dart';
import '../bloc/license_event.dart';
import '../bloc/license_state.dart';
import '../../../../core/di/service_locator.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LicenseBloc>()..add(CheckLicenseEvent()),
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        body: Center(
          child: BlocConsumer<LicenseBloc, LicenseState>(
            listener: (context, state) {
              if (state is LicenseValid) {
                // الانتقال إلى الشاشة الرئيسية عند نجاح التفعيل
                context.go('/home');
              } else if (state is LicenseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message), 
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LicenseLoading || state is LicenseInitial) {
                return const CircularProgressIndicator();
              } else if (state is LicenseInvalid || state is LicenseError) {
                final String deviceId = (state is LicenseInvalid) 
                    ? state.deviceId 
                    : (state as LicenseError).deviceId ?? 'غير معروف';

                return _buildActivationForm(context, deviceId);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivationForm(BuildContext context, String deviceId) {
    final TextEditingController keyController = TextEditingController();

    return Container(
      width: 600,
      padding: const EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.security, size: 80, color: Color(0xFF1E88E5)),
          const SizedBox(height: 20),
          const Text(
            'تفعيل نظام نقطة البيع',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'التطبيق غير مفعل حالياً. يرجى تزويدنا بالمعرف التالي لإصدار رخصة التشغيل.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    'Device ID: $deviceId',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Color(0xFF1E88E5)),
                  tooltip: 'نسخ المعرف',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: deviceId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ معرف الجهاز بنجاح!')),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: keyController,
            decoration: const InputDecoration(
              labelText: 'مفتاح الترخيص (License Key)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vpn_key),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final String key = keyController.text.trim();
                if (key.isNotEmpty) {
                  context.read<LicenseBloc>().add(ActivateLicenseEvent(licenseKey: key));
                }
              },
              child: const Text('تفعيل النظام الآن', style: TextStyle(fontSize: 20)),
            ),
          )
        ],
      ),
    );
  }
}