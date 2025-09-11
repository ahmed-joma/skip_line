import 'package:equatable/equatable.dart';

abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final String result;

  const ScanSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class ScanError extends ScanState {
  final String message;

  const ScanError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductScanned extends ScanState {
  final String productName;
  final String productCategory;
  final String productImage;

  const ProductScanned({
    required this.productName,
    required this.productCategory,
    required this.productImage,
  });

  @override
  List<Object?> get props => [productName, productCategory, productImage];
}
