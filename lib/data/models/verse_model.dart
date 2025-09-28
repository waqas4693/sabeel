import 'dart:convert';

class Verse {
  final int id;
  final int verseNumber;
  final String textUthmani;
  final String verseKey;

  Verse({
    required this.id,
    required this.verseNumber,
    required this.textUthmani,
    required this.verseKey,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      verseNumber: json['verse_number'],
      textUthmani: json['text_uthmani'],
      verseKey: json['verse_key'],
    );
  }
}

List<Verse> parseVerses(String responseBody) {
  final parsed = json.decode(responseBody)['verses'];
  return parsed.map<Verse>((json) => Verse.fromJson(json)).toList();
}
 