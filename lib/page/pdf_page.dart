import 'package:flutter/material.dart';

import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../main.dart';
import '../models/customer.dart';
import '../models/invoice.dart';
import '../models/supplier.dart';
import '../widget/button_widget.dart';
import '../widget/title_widget.dart';


class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text(MyApp.title),
      centerTitle: true,
    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleWidget(
              icon: Icons.picture_as_pdf,
              text: 'CaterHub Generate Invoice Done',
            ),
            const SizedBox(height: 48),
            ButtonWidget(
              text: 'Generate Invoice ',
              onClicked: () async {
                final date = DateTime.now();
                final dueDate = date.add(Duration(days: 7));

                final invoice = Invoice(
                  supplier: Supplier(
                    name: 'Mohamed  Fadol',
                    address: 'King Fahd Street 9, Al Olaya, Riyadh',
                    paymentInfo: 'https://paypal.me/mohamed-fadol',
                  ),
                  customer: Customer(
                    name: 'Mohmed kitchen.',
                    address: 'Al Olaya, Riyadh, 011 273 3888',
                  ),
                  info: InvoiceInfo(
                    date: date,
                    dueDate: dueDate,
                    description: 'My description...',
                    number: '${DateTime.now().year}-10-27',
                  ),
                  items: [
                    InvoiceItem(
                      description: 'Coffee',
                      date: DateTime.now(),
                      quantity: 3,
                      vat: 0.19,
                      unitPrice: 5.99,
                    ),
                    InvoiceItem(
                      description: 'Water',
                      date: DateTime.now(),
                      quantity: 8,
                      vat: 0.19,
                      unitPrice: 0.99,
                    ),
                    InvoiceItem(
                      description: 'Orange',
                      date: DateTime.now(),
                      quantity: 3,
                      vat: 0.19,
                      unitPrice: 2.99,
                    ),
                    InvoiceItem(
                      description: 'Apple',
                      date: DateTime.now(),
                      quantity: 8,
                      vat: 0.19,
                      unitPrice: 3.99,
                    ),
                    InvoiceItem(
                      description: 'Mango',
                      date: DateTime.now(),
                      quantity: 1,
                      vat: 0.19,
                      unitPrice: 1.59,
                    ),
                  ],
                );

                downloadMinute(invoice);


              },
            ),
          ],
        ),
      ),
    ),
  );


  Future<void> downloadMinute(Invoice invoice) async {
    final pdfFile = await PdfInvoiceApi.generate(invoice);
    if(await PdfApi.requestPermission()){
      await PdfApi.downloadFileToStorage(pdfFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('download_file_is_done '),
          backgroundColor: Colors.greenAccent,
        ),
      );
      Future.delayed(const Duration(seconds: 5), () { Navigator.of(context).pop(); });
    }else{
      print('permission error--------------');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('download_file_is_failed '),
          backgroundColor: Colors.redAccent,
        ),
      );
      Navigator.of(context).pop();
    }
  }

}


