class Dette {
  final int id;
  final double montant;
  final String date;

  Dette({
    required this.id,
    required this.montant,
    required this.date,
  });

  factory Dette.fromJson(Map<String, dynamic> json) {
    return Dette(
      id: json['id'],
      montant: (json['montant'] as num).toDouble(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'date': date,
    };
  }
}
