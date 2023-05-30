library delta_to_pdf;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_quill/flutter_quill.dart' as fq;

class DeltaToPDF {
  getPDFHeaderStyle(key, value) {
    pw.FontWeight fontWeight = pw.FontWeight.normal;
    double fontSize = 14;
    if (value == 1) {
      fontWeight = pw.FontWeight.bold;
      fontSize = 24;
    } else if (value == 2) {
      fontWeight = pw.FontWeight.bold;
      fontSize = 20;
    } else {
      fontWeight = pw.FontWeight.bold;
      fontSize = 16;
    }
    return [fontWeight, fontSize];
  }

  getHeaderAttributedText(
      Map<String, dynamic>? attribute, String text, bool hasAttribute) {
    pw.FontWeight fontWeight = pw.FontWeight.normal;
    double fontSize = 14;
    if (hasAttribute) {
      attribute!.forEach((key, value) {
        switch (key) {
          case "header":
            if (value == 1) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 18;
            } else if (value == 2) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 16;
            } else {
              fontWeight = pw.FontWeight.bold;
              fontSize = 12;
            }
            break;
        }
      });
    }
    return [fontWeight, fontSize];
  }

  getAttributedText(Map<String, dynamic>? attribute, String text,
      bool hasAttribute, pw.FontWeight fontWeight, double fontSize) {
    PdfColor fontColor = PdfColor.fromHex("#000");
    pw.FontStyle fontStyle = pw.FontStyle.normal;
    pw.TextDecoration decoration = pw.TextDecoration.none;
    pw.BoxDecoration boxDecoration = const pw.BoxDecoration();
    if (hasAttribute) {
      attribute!.forEach((key, value) {
        switch (key) {
          case "color":
            fontColor = PdfColor.fromHex(value);
            break;
          case "bold":
            fontWeight = pw.FontWeight.bold;
            break;
          case "italic":
            fontStyle = pw.FontStyle.italic;
            break;
          case "underline":
            decoration = pw.TextDecoration.underline;
            break;
          case "strike":
            decoration = pw.TextDecoration.lineThrough;
            break;
          case "background":
            boxDecoration = pw.BoxDecoration(color: PdfColor.fromHex(value));
        }
      });
    }
    return pw.Text(text,
        style: pw.TextStyle(
            color: fontColor,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            fontSize: fontSize,
            decoration: decoration,
            background: boxDecoration,
            fontFallback: [pw.Font.symbol()]));
  }

  deltaToPDF(List<fq.Operation> deltaList) {
    List header = [null, null];
    List texts = [];
    List pdfColumnWidget = [];
    for (var element in deltaList.reversed) {
      if (element.data == '\n') {
        if (header != [] && texts != []) {
          pdfColumnWidget = pdfColumnWidget +
              [
                pw.Row(
                    children: [...texts.reversed],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start)
              ];
        }
        texts = [];
        header = getHeaderAttributedText(element.attributes,
            element.data.toString(), element.attributes != null);
      } else {
        texts.add(getAttributedText(
            element.attributes,
            element.data.toString(),
            element.attributes != null,
            header[0] ?? pw.FontWeight.normal,
            header[1] ?? 14));
      }
    }
    pdfColumnWidget = pdfColumnWidget +
        [
          pw.Row(children: [...texts.reversed])
        ];
    return pw.Column(
        children: [...pdfColumnWidget.reversed],
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start);
  }
}
