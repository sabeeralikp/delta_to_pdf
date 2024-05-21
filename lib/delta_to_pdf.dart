import 'package:flutter_quill/quill_delta.dart';
import 'package:pdf/widgets.dart';

class DeltaToPDF {
  List<Widget> toPDFWidgets(Delta delta) {
    List<Widget> colWidgets = [];
    List<InlineSpan> inlineSpanList = [];

    for (Operation deltaOp in delta.toList()) {
      if (deltaOp.isInsert) {
        String textData = deltaOp.data.toString();

        // Check if textData is multiString
        print('==============');

        print('Data: ${deltaOp.data}');
        List<String> lines = textData.split("\n");
        print("number of lines: ${lines.length}");

        if (textData != "\n") {
          for (int idx = 0; idx < lines.length; idx++) {
            String line = lines[idx];
            textData = line;

            print("Line $idx: $textData");

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

        FontWeight fontWeight = FontWeight.normal;
        FontStyle fontStyle = FontStyle.normal;
        TextDecoration decoration = TextDecoration.none;
        if (deltaOp.attributes != null) {
          for (String attribKey in deltaOp.attributes!.keys) {
            switch (attribKey) {
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
        print("Unsuppored operation: ${deltaOp.key}");
      }
    }
    print('Column Items: ${colWidgets.length}');

    return colWidgets;
  }

  Widget toPDFWidget(Delta delta) {
    final List<Widget> widgets = toPDFWidgets(delta);
    return Column(children: widgets);
  }
}
