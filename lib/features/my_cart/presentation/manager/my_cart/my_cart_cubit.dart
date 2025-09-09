import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'my_cart_state.dart';

class MyCartCubit extends Cubit<MyCartState> {
  MyCartCubit() : super(MyCartInitial());
}
