// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// // ...
//
// GestureDetector(
// onTap: () async {
// // Generate PDF content
// final pdf = pw.Document();
// pdf.addPage(pw.Page(
// build: (pw.Context context) {
// return pw.Center(
// child: pw.Text('Your PDF Content Here'),
// );
// },
// ));
//
// // Save the PDF to a temporary file
// final output = await getTemporaryDirectory();
// final file = File('${output.path}/receipt.pdf');
// await file.writeAsBytes(await pdf.save());
//
// // Open share dialog
// Share.shareFiles(['${file.path}'],
// text: 'Share Receipt PDF',
// subject: 'Receipt PDF');
// },
// child: Container(
// padding: EdgeInsets.only(right: 25),
// child: Icon(
// Icons.share,
// color: Colors.black,
// ),
// ),
// ),
