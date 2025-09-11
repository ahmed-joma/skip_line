import 'package:flutter_bloc/flutter_bloc.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanInitial()) {
    // عرض المنتج تلقائياً للاختبار
    _showProductForTesting();
  }

  void _showProductForTesting() {
    Future.delayed(const Duration(seconds: 2), () {
      emit(
        ProductScanned(
          productName: 'Saudi milk',
          productCategory: 'milk',
          productImage: 'assets/images/mike.png',
        ),
      );
    });
  }

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

  void processProductScan(String result) {
    emit(ScanLoading());

    // محاكاة معالجة منتج ممسوح
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        // محاكاة بيانات منتج
        emit(
          ProductScanned(
            productName: 'Saudi milk',
            productCategory: 'milk',
            productImage: 'assets/images/mike.png',
          ),
        );
      } catch (e) {
        emit(ScanError(message: 'Error processing product scan'));
      }
    });
  }

  void clearScannedProduct() {
    emit(ScanInitial());
  }
}
