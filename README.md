<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

delta_to_pdf is a flutter package to convert flutter quill delta object to pdf object from pdf package.
<br>

##### **Note: The package in beta, feel free to raise issues and suggestions 😄.**

<br>

<img src="https://github.com/sabeeralikp/delta_to_pdf/blob/master/assets/convert.gif" height=400> &nbsp;
<img src="https://github.com/sabeeralikp/delta_to_pdf/blob/master/assets/input.jpg" height=400> &nbsp;
<img src="https://github.com/sabeeralikp/delta_to_pdf/blob/master/assets/assets/output.jpg" height=400>

## Features

Use this package in your app to:

- Convert [flutter_quill](https://pub.dev/packages/flutter_quill) delta object to correspond [pdf](https://pub.dev/packages/pdf) object.<br>

### Feature List

| Feature    | Android | linux | iOS | Windows | macOS | Web |
| ---------- | ------- | ----- | --- | ------- | ----- | --- |
| deltaToPDF | ✅      | ✅    | ✅  | ✅      | ✅    | ✅  |

## Getting started

- Add package to your app by running: <br>&nbsp;&nbsp;&nbsp;
  ```bash
  flutter pub add delta_to_pdf
  ```

## Usage

Use the functionality by creating an object and giving parameter as `List<fq.Operation> deltaList`

```dart
var delta = _quillController.document.toDelta().toList();
DeltaToPDF dpdf = DeltaToPDF();
return dpdf.deltaToPDF(delta);
```

## Additional information

This package is still in beta, There is a need for many updates and bug fixes. Feel free to provide issues, suggestions and updates 😄😄😄.

## Authors

<img src="https://avatars.githubusercontent.com/u/44801609?s=400&u=975a44608c86475fb3e05dc996a7b86137303587&v=4" height=80>&nbsp;&nbsp;&nbsp;<img src="https://avatars.githubusercontent.com/u/119028899?v=4" height=80><br>&nbsp;[**Sabeerali**](https://github.com/sabeeralikp) &nbsp;&nbsp;&nbsp;[**Swathy AS**](https://github.com/swathyas96)<br>

## Powered by

<img src="https://icfoss.in/vendor/front/images/logo.svg">
