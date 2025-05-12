import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/repository/menu_repository.dart';
import 'package:quick_bite/presentation/view_models/stats/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _repository;

  MenuCubit(this._repository) : super(const MenuState());

  Future<void> loadCategoriesAndItems([String? selectedCategory]) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await _repository.getCategories();
      final categoryToFetch = selectedCategory ?? categories.first;
      final items = await _repository.getItemsByCategory(categoryToFetch);

      emit(state.copyWith(
        isLoading: false,
        categories: categories,
        selectedCategory: categoryToFetch,
        items: items,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> changeCategory(String category) async {
    emit(state.copyWith(isLoading: true, selectedCategory: category));
    try {
      final items = await _repository.getItemsByCategory(category);
      emit(state.copyWith(isLoading: false, items: items));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
