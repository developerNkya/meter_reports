class CategoryItem {
  final int? id;
  final String name;
  final String imagePath;

  CategoryItem({this.id, required this.name, required this.imagePath});
}

var categoryItemsDemo = [
  CategoryItem(
    name: "Receipts Reports",
    imagePath: "assets/images/categories_images/fruit.png",
  ),
  CategoryItem(
    name: "Z Report",
    imagePath: "assets/images/categories_images/meat.png",
  ),
  CategoryItem(
    name: "Change Price",
    imagePath: "assets/images/categories_images/bakery.png",
  ),
  CategoryItem(
    name: "Summary",
    imagePath: "assets/images/categories_images/dairy.png",
  ),
];
