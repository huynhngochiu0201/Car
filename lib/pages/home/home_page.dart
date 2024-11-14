import 'dart:async';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/pages/home/widget/new_product.dart';
import 'package:app_car_rescue/pages/home/service/service.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../components/app_bar/cr_app_bar.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/promotion_model.dart';
import '../../services/remote/category_service.dart';
import '../../services/remote/product_service.dart';
import 'product/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final zoomDrawerController = ZoomDrawerController();
  final PageController _pageController = PageController();
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();
  late Future<List<CategoryModel>> _categories;
  late Future<List<ProductModel>> _products;
  String? _selectedCategoryId; // Biến để lưu trữ id category được chọn
  bool isGridView = false;
  bool isRecommended = false;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentIndex + 1) % promotions.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  toggleDrawer() {
    zoomDrawerController.toggle?.call();
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _fetchData() {
    _categories = _categoryService.fetchCategories().then((categories) {
      return [CategoryModel(id: 'all', name: 'All', image: '')] + categories;
    });
    _products = _productService.fetchProducts();
    _selectedCategoryId = 'all';
  }

  Future<void> _refresh() async {
    setState(() {
      _fetchData();
    });
    // Chờ cho cả hai Future hoàn thành
    await Future.wait([_categories, _products]);
  }

  // Hàm để tải sản phẩm theo categoryId
  void _loadProductsByCategory(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      if (categoryId == 'all') {
        _products = _productService.fetchProducts();
      } else {
        _products = _productService.fetchProductsByCategory(categoryId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CrAppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _futureCategory()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0)
                    .copyWith(top: 20.0),
                child: _buildSlider(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Products',
                      style: AppStyle.bold_20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                      child: Text(
                        isGridView ? 'Show list' : 'Show all',
                        style: AppStyle.regular_12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isGridView ? _buildGridProducts() : _buildListProducts(),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                  decoration: BoxDecoration(color: AppColor.F8F8FA),
                  height: 158.0,
                  child: Image.asset(
                    Assets.images.bannerVn.path,
                    fit: BoxFit.cover,
                  )),
            )),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0)
                    .copyWith(bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      'New Product',
                      style: AppStyle.bold_20,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: NewProduct()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0)
                    .copyWith(bottom: 10.0, top: 10.0),
                child: Text(
                  'Service',
                  style: AppStyle.bold_20
                      .copyWith(fontFamily: 'Product Sans Medium'),
                ),
              ),
            ),
            SliverToBoxAdapter(child: Service()),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      height: 168.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              return Image.asset(
                promotions[index].path ?? '-',
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            bottom: 5.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                promotions.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? AppColor.E3A2C27
                          : AppColor.grey400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  FutureBuilder<List<CategoryModel>> _futureCategory() {
    return FutureBuilder<List<CategoryModel>>(
      future: _categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        final categories = snapshot.data!;

        return SizedBox(
          height: 85,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 40.0),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => _loadProductsByCategory(category.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: category.image != null &&
                                  category.image!.isNotEmpty
                              ? NetworkImage(category.image!)
                              : AssetImage(Assets.images.dummyCategory.path)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: _selectedCategoryId == category.id
                              ? AppColor.E3A2C27
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    spaceH6,
                    SizedBox(
                      width: 42,
                      child: Center(
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          category.name ?? 'Unknown Category',
                          style: AppStyle.regular_12
                              .copyWith(color: AppColor.black),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildListProducts() {
    return FutureBuilder<List<ProductModel>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
              child: Center(child: Text('Error: ${snapshot.error}')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
              child: Center(child: Text('No products found')));
        }

        final products = snapshot.data!;

        return SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  productId: product.id,
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 172.0,
                            width: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        spaceH12,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            product.name,
                            style: AppStyle.regular_12
                                .copyWith(fontFamily: 'Product Sans Medium'),
                          ),
                        ),
                        spaceH2,
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            product.price.toVND(),
                            style: AppStyle.bold_16.copyWith(
                              fontFamily: 'Product Sans',
                            ),
                          ),
                        ),
                        spaceH12,
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridProducts() {
    return FutureBuilder<List<ProductModel>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
              child: Center(child: Text('Error: ${snapshot.error}')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
              child: Center(child: Text('No products found')));
        }

        final products = snapshot.data!;

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 263,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30, // khoảng cách giữa các hàng
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  productId: product.id,
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                height: 186.0,
                                width: double.infinity,
                                product.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    spaceH8,
                    Text(
                      product.name,
                      style: AppStyle.regular_12,
                    ),
                    spaceH2,
                    Text(
                      product.price.toVND(),
                      style: AppStyle.bold_16,
                    ),
                    // RatingBar.readOnly(
                    //   filledColor: AppColor.E508A7B,
                    //   size: 19.0,
                    //   filledIcon: Icons.star,
                    //   emptyIcon: Icons.star_border,
                    //   initialRating: 4,
                    //   maxRating: 5,
                    // )
                  ],
                );
              },
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }
}
