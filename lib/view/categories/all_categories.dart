import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_size.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/view/categories/mixin/all_categories_page_mixin.dart';
import 'package:coffe_app/view/widgets/category_card_grid.dart';
import 'package:coffe_app/view_model/categories/categories_cubit.dart';
import 'package:coffe_app/view_model/categories/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories>
    with AllCategoriesPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: categoriesCubit,
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: _buildAppBar,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s12),
              Padding(padding: AppSpacing.paddingH20, child: _buildSearchBar()),
              const SizedBox(height: AppSpacing.s12),
              Expanded(
                child: BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesInitial ||
                        state is CategoriesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CategoriesError) {
                      return Center(
                        child: Padding(
                          padding: AppSpacing.padding20,
                          child: Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      );
                    }

                    if (state is CategoriesLoaded) {
                      if (state.categories.isEmpty) {
                        return const Center(child: Text("Kategori bulunamadı"));
                      }
                      return _gridView(state);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: closePage,
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        "Categories",
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: AppSizes.searchBarHeight,
      padding: AppSpacing.paddingH16,
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: AppRadius.border(AppRadius.size30),
        border: Border.all(color: context.appTextPrimary, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search categories",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: AppTypography.size16,
                  color: context.appTextMuted,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: false,
              ),
            ),
          ),
          Icon(Icons.search, color: context.appTextPrimary, size: 30),
        ],
      ),
    );
  }

  Widget _gridView(CategoriesLoaded state) {
    return GridView.builder(
      padding: AppSpacing.paddingH20,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];

        return CategoryGridCard(
          category: category,
          onTap: () => openCategory(category),
        );
      },
    );
  }
}
