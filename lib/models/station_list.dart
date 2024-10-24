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
      description: "View receipt Data",
      imagePath: "assets/images/grocery_images/receipts1.png"),
  station_cartegory(
      id: 2,
      name: "Z Report",
      description: "View z-report Data",
      imagePath: "assets/images/grocery_images/report_z.jpg"),
  station_cartegory(
      id: 3,
      name: "Change Price",
      description: "Change Prices easily",
      imagePath: "assets/images/grocery_images/receipts1.png"),
  station_cartegory(
      id: 4,
      name: "Summary",
      description: "view Total Summary",
      imagePath: "assets/images/grocery_images/receipts1.png"),
  station_cartegory(
      id: 5,
      name: "Shift Management",
      description: "View Shift report",
      imagePath: "assets/images/grocery_images/receipts1.png"),
  station_cartegory(
      id: 6,
      name: "Volume Reports",
      description: "View reports",
      imagePath: "assets/images/grocery_images/receipts1.png"),
];

var station_cartegory1= [demoItems[0],demoItems[1]];
var station_cartegory2 = [demoItems[2],demoItems[3]];
var station_cartegory3 = [demoItems[4],demoItems[5]];





