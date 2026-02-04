// Tương đương Command trong MediatR
class CreateNoteCommand {
  final String title;
  final String imagePath;
  // Dùng camelCase cho biến
  CreateNoteCommand({required this.title, required this.imagePath});
}