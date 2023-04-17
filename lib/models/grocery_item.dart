class GroceryItem {
  final int? id;
  final String name;
  final String description;

  final String imagePath;

  GroceryItem({
    this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });
}

var demoItems = [
  GroceryItem(
      id: 1,
      name: "Stations",
      description: "View Stations",
      imagePath: "assets/images/grocery_images/banana.png"),
  GroceryItem(
      id: 2,
      name: "Receipt Reports",
      description: "All receipts",
      imagePath: "assets/images/grocery_images/apple.png"),
  GroceryItem(
      id: 3,
      name: "Z Report",
      description: "view Z report summary",
      imagePath: "assets/images/grocery_images/pepper.png"),
  GroceryItem(
      id: 4,
      name: "Settings",
      description: "Manage profile settings",
      imagePath: "assets/images/grocery_images/pepper.png"),
];

var exclusiveOffers = [demoItems[0],demoItems[1]];
var exclusiveOffers2 = [demoItems[2],demoItems[3]];





