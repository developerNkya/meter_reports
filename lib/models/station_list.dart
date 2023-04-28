class station_cartegory {
  final int? id;
  final String name;
  final String description;

  final String imagePath;

 station_cartegory({
    this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });
}

var demoItems = [
  station_cartegory(
      id: 1,
      name: "Receipts Reports",
      description: "View Stations",
      imagePath: "assets/images/grocery_images/receipts1.png"),
  station_cartegory(
      id: 2,
      name: "Z Report",
      description: "All receipts",
      imagePath: "assets/images/grocery_images/report_z.jpg"),
  station_cartegory(
      id: 3,
      name: "Change Price",
      description: "view Z report summary",
      imagePath: "assets/images/grocery_images/receipts1.png"),
  station_cartegory(
      id: 4,
      name: "Summary",
      description: "Manage profile settings",
      imagePath: "assets/images/grocery_images/receipts1.png"),
];

var station_cartegory1= [demoItems[0],demoItems[1]];
var station_cartegory2 = [demoItems[2],demoItems[3]];





