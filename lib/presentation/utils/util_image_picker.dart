  import 'package:file_picker/file_picker.dart';

Future<PlatformFile> openSingleImagePickerAsync() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['jpg, jpeg, png'],
      allowMultiple: false,
    );
    return result.files[0];
  }