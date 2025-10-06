import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/search_repo_imple.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepoImpl _searchRepo;

  SearchCubit(this._searchRepo) : super(SearchInitial());

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      // إذا كان البحث فارغ، اعرض جميع المنتجات
      await getAllProducts();
      return;
    }

    emit(SearchLoading());

    try {
      final results = await _searchRepo.searchProducts(query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> getAllProducts() async {
    emit(SearchLoading());

    try {
      final products = await _searchRepo.getAllProducts();
      emit(SearchLoaded(products));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
