import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class DeltaToPDF {
  List<Widget> _toPDFWidgets(Delta delta) {
    List<Widget> colWidgets = [];
    List<InlineSpan> inlineSpanList = [];

    for (Operation deltaOp in delta.toList()) {
      if (deltaOp.isInsert) {
        String textData = deltaOp.data.toString();

        // Check if textData is multiString
        if (kDebugMode) {
          print('==============');
        }

        if (kDebugMode) {
          print('Data: ${deltaOp.data}');
        }
        List<String> lines = textData.split("\n");
        if (kDebugMode) {
          print("number of lines: ${lines.length}");
        }

        if (textData != "\n") {
          for (int idx = 0; idx < lines.length; idx++) {
            String line = lines[idx];
            textData = line;

            if (kDebugMode) {
              print("Line $idx: $textData");
            }

            // The last line will be processed outside.
            if (idx < (lines.length - 1)) {
              // If it's empty, it's just a newline
              if (textData.isEmpty) {
                colWidgets.add(SizedBox(height: 12));
              } else {
                colWidgets.add(RichText(text: TextSpan(text: textData)));
              }
            }
          }
        }

        PdfColor fontColor = _from8DigitHexColor("#FF000000");
        FontWeight fontWeight = FontWeight.normal;
        FontStyle fontStyle = FontStyle.normal;
        TextDecoration decoration = TextDecoration.none;
        if (deltaOp.attributes != null) {
          for (String attribKey in deltaOp.attributes!.keys) {
            switch (attribKey) {
              case "color":
                fontColor = _from8DigitHexColor(deltaOp.attributes![attribKey]);
                break;
              case 'bold':
                fontWeight = deltaOp.attributes![attribKey]
                    ? FontWeight.bold
                    : FontWeight.normal;
                break;
              case 'underline':
                decoration = deltaOp.attributes![attribKey]
                    ? TextDecoration.underline
                    : TextDecoration.none;
                break;
              case 'italic':
                fontStyle = deltaOp.attributes![attribKey]
                    ? FontStyle.italic
                    : FontStyle.normal;
                break;
            }
          }
        }

        inlineSpanList.add(TextSpan(
            text: textData,
            style: TextStyle(
                color: fontColor,
                fontWeight: fontWeight,
                fontStyle: fontStyle,
                decoration: decoration)));

        if (textData == "\n" || (deltaOp == delta.toList().last)) {
          TextAlign textAlign = TextAlign.left;
          Alignment alignment = Alignment.centerLeft;
          if (deltaOp.hasAttribute('align')) {
            switch (deltaOp.attributes!['align']) {
              case 'center':
                alignment = Alignment.center;
                textAlign = TextAlign.center;
                break;
              case 'right':
                alignment = Alignment.centerRight;
                textAlign = TextAlign.right;
                break;
              case 'justify':
                textAlign = TextAlign.justify;
                break;
            }
          }

          if (deltaOp.hasAttribute('list')) {
            inlineSpanList.insert(0, const TextSpan(text: "\t\t\t\u2022 "));
          }

          colWidgets.add(Align(
              alignment: alignment,
              child: RichText(
                  text: TextSpan(
                    children: inlineSpanList,
                  ),
                  textAlign: textAlign)));
          // Reset the list
          inlineSpanList = [];
        }
      } else {
        if (kDebugMode) {
          print("Unsuppored operation: ${deltaOp.key}");
        }
      }
    }
    if (kDebugMode) {
      print('Column Items: ${colWidgets.length}');
    }

    return colWidgets;
  }

  PdfColor _from8DigitHexColor(String color) {
    if (color.startsWith('#')) {
      color = color.substring(1);
    }

    var alpha = 1.0;
    double red;
    double green;
    double blue;
    alpha = int.parse(color.substring(0, 2), radix: 16) / 255;
    red = int.parse(color.substring(2, 4), radix: 16) / 255;
    green = int.parse(color.substring(4, 6), radix: 16) / 255;
    blue = int.parse(color.substring(6, 8), radix: 16) / 255;
    return PdfColor(red, green, blue, alpha);
  }

  Widget toPDFWidget(Delta delta) {
    final List<Widget> widgets = _toPDFWidgets(delta);
    return Column(crossAxisAlignment: CrossAxisAlignment.start,children: widgets);
  }
}
