import 'package:bloc/bloc.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:coffe_app/view_model/products/product_detail/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required Product product,
    required CartCubit cartCubit,
  })  : _cartCubit = cartCubit,
        super(ProductDetailLoaded(product: product));

  final CartCubit _cartCubit;

  ProductDetailLoaded get _loaded => state as ProductDetailLoaded;

  void incrementQuantity() {
    emit(_loaded.copyWith(quantity: _loaded.quantity + 1));
  }

  void decrementQuantity() {
    if (_loaded.quantity > 1) {
      emit(_loaded.copyWith(quantity: _loaded.quantity - 1));
    }
  }

  Future<void> addToCart() async {
    final current = _loaded;
    emit(current.copyWith(isAddingToCart: true));

    await _cartCubit.addToCart(
      current.product,
      quantity: current.quantity,
    );

    emit(
      current.copyWith(
        isAddingToCart: false,
        showAddedDialog: true,
      ),
    );
  }

  void clearAddedDialog() {
    emit(_loaded.copyWith(showAddedDialog: false));
  }
}
