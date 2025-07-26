import 'dart:html' as html;

void openCameraInput(Function(html.File file) onImageSelected) {
  final input = html.FileUploadInputElement();
  input.accept = 'image/*';
  // input.capture = 'environment'; // 'capture' is not supported in dart:html
  input.click();

  input.onChange.listen((e) {
    final files = input.files;
    if (files != null && files.isNotEmpty) {
      onImageSelected(files.first);
    }
  });
}
