// lib/models/competition_model.dart
class CompetitionModel {
  final int? id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String niveau;
  final int maxParticipants;
  final int? currentParticipants;
  final String status; // UPCOMING, ONGOING, COMPLETED

  CompetitionModel({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.niveau,
    this.maxParticipants = 100,
    this.currentParticipants = 0,
    this.status = 'UPCOMING',
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      niveau: json['niveau'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 100,
      currentParticipants: json['currentParticipants'] ?? 0,
      status: json['status'] ?? 'UPCOMING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'niveau': niveau,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'status': status,
    };
  }
}
