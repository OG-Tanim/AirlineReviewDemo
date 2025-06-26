class Airport {
  final String name;
  final String iata; // 3-letter code, or "\N" if missing

  Airport({required this.name, required this.iata});

  factory Airport.fromCsv(List<dynamic> row) {
    // OpenFlights columns: 0=id,1=name,2=city,3=country,4=IATA, ...
    return Airport(name: row[1] as String, iata: row[2] as String);
  }

  /// Display as "Name (IATA)" if available, else just name
  String get displayName =>
      iata != '\\N' && iata.isNotEmpty ? '$name ($iata)' : name;
}
