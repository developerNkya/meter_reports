class CategoryItem {
  final int? id;
  final String name;
  final String imagePath;

  CategoryItem({this.id, required this.name, required this.imagePath});
}

var categoryItemsDemo = [
  CategoryItem(
    name: "Receipts Reports",
    imagePath: "assets/images/grocery_images/receipts1.png",
  ),
  CategoryItem(
    name: "Z Report",
    imagePath: "assets/images/grocery_images/report_z.jpg",
  ),
  CategoryItem(
    name: "Change Price",
    imagePath: "assets/images/grocery_images/receipts1.png",
  ),
  CategoryItem(
    name: "Summary",
    imagePath: "assets/images/grocery_images/receipts1.png",
  ),
];
