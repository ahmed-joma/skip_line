abstract class ScanRepository {
  Future<String> processScanResult(String scanResult);
  Future<bool> validateProductCode(String code);
  Future<Map<String, dynamic>> getProductByCode(String code);
}
