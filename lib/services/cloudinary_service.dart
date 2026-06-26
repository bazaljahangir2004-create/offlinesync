import 'dart:convert';
import 'package:http/http.dart' as http;

/// Uploads images to Cloudinary using an unsigned upload preset.
/// No API secret is ever stored in the app - that's the whole point
/// of using an unsigned preset for a mobile client.
class CloudinaryService {
  CloudinaryService({
    required this.cloudName,
    required this.uploadPreset,
  });

  final String cloudName;
  final String uploadPreset;

  Uri get _uploadUrl => Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

  /// Uploads a single local image file and returns its hosted URL.
  /// Throws an exception on failure - caller is expected to catch it
  /// and mark the report as 'failed' so it can be retried later.
  Future<String> uploadImage(String localFilePath) async {
    final request = http.MultipartRequest('POST', _uploadUrl)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', localFilePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['secure_url'] as String;
  }

  /// Uploads multiple images sequentially and returns their URLs in order.
  /// Sequential (not parallel) on purpose - keeps mobile data usage and
  /// memory predictable, and makes partial-failure handling simpler.
  Future<List<String>> uploadImages(List<String> localFilePaths) async {
    final urls = <String>[];
    for (final path in localFilePaths) {
      final url = await uploadImage(path);
      urls.add(url);
    }
    return urls;
  }
}
