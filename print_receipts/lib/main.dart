import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

void main() => runApp(Home());
class Home extends StatelessWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: InkWell(
              onTap: () async {
                await SunmiPrinter.initPrinter();
                await SunmiPrinter.bindingPrinter();
                await SunmiPrinter.startTransactionPrint(true);
                await SunmiPrinter.printText('Tax Invoice', style: SunmiStyle(
                  fontSize: SunmiFontSize.MD,
                  bold: true,
                  align: SunmiPrintAlign.CENTER,
                ));
              },
              child: Text("Print"),
            ),
          ),
        ),
      ),
    );
  }
}
