import 'dart:typed_data';

/// Abstract contract for heavy file storage.
///
/// NOTE: Firebase only handles user identity and metadata documents.
/// Supabase Storage will implement this contract to handle large course files,
/// assignment submission attachments, and media blobs.
abstract class FileStorageService {
  /// Upload a course material file (e.g. syllabus, lecture slides, PDF).
  Future<String> uploadCourseFile({
    required String courseId,
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  });

  /// Upload a student assignment submission file (e.g. PDF, ZIP, code file).
  Future<String> uploadSubmission({
    required String courseId,
    required String assignmentId,
    required String studentUid,
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  });

  /// Generate a download or streaming URL for a stored file.
  Future<String> getDownloadUrl(String filePath);

  /// Delete a file by its storage path.
  Future<void> deleteFile(String filePath);
}
