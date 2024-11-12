/// Represents a single lesson with basic details.
/// This class is used to store and manage lesson information,
/// including the name, description, and video URL.
class LessonTile {
  final String lessonId;

  /// The name of the lesson.
  final String lessonName;

  /// A brief description of what the lesson covers.
  final String description;

  /// The URL of the video associated with the lesson.
  final String videoUrl;

  final String createdAt;

  /// Constructs a [LessonTile] instance with the given name, description, and video URL.
  ///
  /// All fields are required and must be provided when creating a [LessonTile].
  LessonTile({
    required this.lessonId,
    required this.lessonName,
    required this.description,
    required this.videoUrl,
    required this.createdAt,
  });

  /// Converts this [LessonTile] instance into a JSON-compatible map.
  ///
  /// This can be used to serialize the lesson data for storage or transmission.
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'lessonName': lessonName,
      'description': description,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
    };
  }

  /// Creates a new [LessonTile] instance from a JSON map.
  ///
  /// Useful for deserializing data from external sources, such as a database
  /// or API response. Expects [json] to contain 'lessonName', 'description',
  /// and 'videoUrl' keys with valid values.
  factory LessonTile.fromJson(Map<String, dynamic> json) {
    return LessonTile(
      lessonId: json['lessonId'],
      lessonName: json['lessonName'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      createdAt: json['createdAt'],
    );
  }
}
