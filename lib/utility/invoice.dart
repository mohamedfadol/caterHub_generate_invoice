import 'package:flutter/services.dart';
import 'package:invoice/utility/pdf_api.dart';
 import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as mat;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'dart:convert';

class PdfMinutesMeetingApi {

  static Future<File> generate(Context) async {
    final pw.Document pdf = pw.Document();
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(
          await rootBundle.load('assets/fonts/Al-Mohanad-Regular.ttf')),
      bold: pw.Font.ttf(
          await rootBundle.load('assets/fonts/Al-Mohanad-Bold.ttf')),
    );
    pdf.addPage(
      pw.MultiPage(
          pageTheme: pw.PageTheme(
            theme: theme,
            pageFormat: PdfPageFormat.a4,
          ),
          build: (pw.Context context) => <pw.Widget>[
            logoWidgetTitle(),
            businessInformationWidgetTitle(Context),
            pw.Divider(
              thickness: 1.0,
            ),
            businessInformation(Context),
            pw.Divider(
              thickness: 1.0,
            ),
            pw.SizedBox(height: 2.0),
            pw.RichText(
                text: pw.TextSpan(
                  text: ' businessId! ',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  children: [
                    pw.TextSpan(
                      text:
                      '  minuteName! ',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                    pw.TextSpan(
                        text:
                        'minuteNumbers!',
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.normal)),
                    pw.TextSpan(
                        text: ' minuteDate ',
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.normal)),
                    pw.TextSpan(
                        text:
                        'minute!.meetingMediaName!',
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.normal)),
                  ],
                ),),
            pw.SizedBox(height: 15.0),

          ],
          footer: (context) {
            final text =
                '  ${context.pageNumber}   ${context.pagesCount}';
            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment:  pw.MainAxisAlignment.end,
                      children: [
                        pwTextExpandedWithIContainerBuildTitle(Context, text,8.0,pw.FontWeight.bold),
                      ])
                ]);
          }),
    );
    return PDFApi.saveDocument(name: 'caterHunInvoice'+'${DateTime.now()}.pdf', pdf: pdf);
  }


  static pw.Widget logoWidgetTitle() => pw.Center(
    child: pw.Container(
        padding: const pw.EdgeInsets.all(10.0),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 2.0, color: PdfColors.grey),
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.PdfLogo()
            ),
  );

  static pw.Widget businessInformationWidgetTitle(Context) =>
      pw.Center(
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.SizedBox(height: 5.0),
              pwTextBuild(Context, 'Company Name CaterHub', 7.0, pw.FontWeight.normal, PdfColors.black),
              pwTextBuild(Context, ' Registration Number 12345678', 7.0, pw.FontWeight.normal, PdfColors.black),
            ]),
      );

  static pw.Widget logoWidget(Context) => pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
    decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(width: 2, color: PdfColors.blue))),
    child: pw.Row(
        children: [
          pw.PdfLogo(),
          pw.SizedBox(width: 0.8 * PdfPageFormat.mm),
          pwTextBuild(Context, "caterHub", 15.0, pw.FontWeight.normal, (PdfColors.blue)!),
        ]
    ),
  );

  static pw.Widget businessInformation(Context) => pw.Container(
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pwTextExpandedBuildTitle(Context, " postCode 1221 ", 7.0, pw.FontWeight.normal,PdfColors.black),
            pw.SizedBox(width: 7.0),
            pwTextExpandedBuildTitle(Context, "sudia arabia", 7.0, pw.FontWeight.normal,PdfColors.black),
            pw.SizedBox(width: 7.0),
            pwTextExpandedBuildTitle(Context, " mobile number 132423142", 7.0, pw.FontWeight.normal,PdfColors.black),
            pw.SizedBox(width: 7.0),
            pwTextExpandedBuildTitle(Context, "fax 23422", 7.0, pw.FontWeight.normal,PdfColors.black),
          ]));


  static pw.Row pwTextBuildTitle(mat.BuildContext context, String title,double fontSize,pw.FontWeight fontWeight) {
    return pw.Row(children: [
      pw.Expanded(
          child: pw.Text(title,
              style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight),)
      )
    ]);
  }

  static pw.Expanded pwTextExpandedWithIContainerBuildTitle(mat.BuildContext context, String title,double fontSize,pw.FontWeight fontWeight) {
    return pw.Expanded(
        child: pw.Container(
          margin: const pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
          child: pw.Text(title, style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight),),
        )
    );
  }

  static pw.Expanded pwTextExpandedBuildTitle(mat.BuildContext context, String title,double fontSize,pw.FontWeight fontWeight,PdfColor? color) {
    return pw.Expanded(
        child: pw.Text(title, style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight,color: color),)
    );
  }

  static pw.Text pwTextBuild(mat.BuildContext context, String title,double fontSize,pw.FontWeight fontWeight,PdfColor? color) {
    return  pw.Text(title, style:
    pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight,color: color),);
  }
}