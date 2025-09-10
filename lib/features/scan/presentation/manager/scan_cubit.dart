import 'package:flutter_bloc/flutter_bloc.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanInitial());

  void processScanResult(String result) {
    emit(ScanLoading());

    // محاكاة معالجة النتيجة
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        // التحقق من صحة النتيجة
        if (result.isNotEmpty) {
          emit(ScanSuccess(result: result));
        } else {
          emit(ScanError(message: 'Invalid scan result'));
        }
      } catch (e) {
        emit(ScanError(message: 'Error processing scan result'));
      }
    });
  }

  void resetScan() {
    emit(ScanInitial());
  }

  void setLoading() {
    emit(ScanLoading());
  }

  void setError(String message) {
    emit(ScanError(message: message));
  }
}
