import 'package:flutter/material.dart';
import 'package:ms18_applicatie/menu.dart';

class StockReport extends StatefulWidget {
  const StockReport({Key? key}) : super(key: key);

  @override
  State<StockReport> createState() => StockReportState();
}

class StockReportState extends State<StockReport> {
  @override
  Widget build(BuildContext context) {
    return Menu(child: Text("TEst"));
  }
}