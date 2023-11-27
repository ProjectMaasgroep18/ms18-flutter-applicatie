import 'package:file_picker/file_picker.dart';

class EditableFile {
  PlatformFile file;
  String editableName;

  EditableFile({required this.file, String? name})
      : editableName = name ?? file.name;
}
