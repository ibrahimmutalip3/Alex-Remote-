
class SavedDevice {
  final String id;
  final String name;
  final String host;
  final int port;
  final int? lastConnectedAt;

  const SavedDevice({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    this.lastConnectedAt,
  });

  SavedDevice copyWith({
    String? name,
    String? host,
    int? port,
    int? lastConnectedAt,
  }) {
    return SavedDevice(
      id: id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'host': host,
    'port': port,
    'lastConnectedAt': lastConnectedAt,
  };

  factory SavedDevice.fromJson(Map<String, dynamic> json) {
    return SavedDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      host: json['host'] as String,
      port: json['port'] as int,
      lastConnectedAt: json['lastConnectedAt'] as int?,
    );
  }
}
