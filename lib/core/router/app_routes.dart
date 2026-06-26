enum AppRoutes {
  splash('/splash'),
  onboarding('/onboarding'),
  auth('/auth'),
  signIn('/sign-in'),
  signUp('/sign-up'),
  resetPassword('/reset-password'),
  home('/home'),
  categories('/categories'),
  orders('/orders'),
  profile('/profile'),
  profileEdit('/profile/edit'),
  storeLocation('/store-location'),
  productsByCategory('/categories/:categoryId/products'),
  productDetail('/products/:id'),
  productDetailLocal('/product/local');

  const AppRoutes(this.path);

  final String path;

  static String productDetailPath({required int id}) => '/products/$id';

  static String productsByCategoryPath({
    required int categoryId,
    String? categoryName,
  }) {
    final base = '/categories/$categoryId/products';
    if (categoryName == null || categoryName.isEmpty) return base;
    return '$base?name=${Uri.encodeComponent(categoryName)}';
  }
}