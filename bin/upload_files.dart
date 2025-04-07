import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final projectDirectory = Directory.current.path;

  final videoDirectoryPath = '$projectDirectory/videos';
  final serverUrl = 'https://myrevioapp.com/api-files-upload';

  final videoDirectory = Directory(videoDirectoryPath);

  if (!await videoDirectory.exists()) {
    print('Error: The "video" folder does not exist in the project directory.');
    return;
  }

  print('Uploading files from: $videoDirectoryPath\n');

  final files =
      videoDirectory.listSync(); // List all files in the 'video' directory
  int successCount = 0;
  int failCount = 0;
  int filesCounts = files.length;
  List<String> names = [
    "Loryth",
    "Thyric",
    "Nerith",
    "Cylen",
    "Rynor",
    "Zypher",
    "Kairith",
    "Loryn",
    "Varis",
    "Talyth",
    "Fenric",
    "Erylis",
    "Velryn",
    "Avaris",
    "Therin",
    "Drynth",
    "Kyven",
    "Xarin",
    "Lyric",
    "Zyndon",
    // Multicultural Seychelles names
    "Akira", "Basil", "Cleo", "Dior", "Eli", "Flor", "Gio", "Hari", "Indy",
    "Kai", "Luca", "Milo", "Nico", "Ravi", "Sami", "Tari", "Uma", "Veda",
    "Zane", "Zion"
  ];

  for (var i = 0; i < files.length; i++) {
    print(filesCounts);
    var file = files[i];

    if (file is File) {
      final fileName = names[i];
      print('Starting upload for: $fileName');

      try {
        final response = await uploadFile(
          file,
          serverUrl,
          name: fileName,
          cate: 'Animation Singing',
        );

        if (response.statusCode == 302) {
          print('✅ Upload successful: $fileName');
          successCount++;
        } else {
          print(
              '❌ Failed to upload $fileName. Status code: ${response.statusCode}');
          failCount++;
        }
        filesCounts--;
      } catch (e) {
        print('❌ Error uploading $fileName: $e');
        failCount++;
      }
    } else {
      print('Skipping: ${file.path} (not a file)');
    }
  }

  print('\nUpload Summary:');
  print('Total files: ${files.whereType<File>().length}');
  print('Successful uploads: $successCount');
  print('Failed uploads: $failCount');
}

Future<http.Response> uploadFile(File file, String serverUrl,
    {required String name, required String cate}) async {
  final request = http.MultipartRequest('POST', Uri.parse(serverUrl));

  request.fields['name'] = name;
  request.fields['cate'] = cate;

  request.files.add(
    await http.MultipartFile.fromPath('img', file.path),
  );

  print('Uploading ${file.path}...');
  final response = await http.Response.fromStream(await request.send());
  return response;
}
