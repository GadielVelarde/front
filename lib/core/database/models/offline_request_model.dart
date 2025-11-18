import 'dart:convert';

/// Modelo para almacenar solicitudes de red que fallan cuando no hay conexión
/// Permite reintentarlas cuando la conexión se restaure
class OfflineRequestModel {
  final int? id;
  final String method; // GET, POST, PUT, DELETE
  final String url;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final String entityType; // 'ruta', 'seguimiento', etc.
  final String entityId;
  final String status; // 'waiting', 'success', 'failed'
  final String? errorMessage;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfflineRequestModel({
    this.id,
    required this.method,
    required this.url,
    this.body,
    this.headers,
    required this.entityType,
    required this.entityId,
    this.status = 'waiting',
    this.errorMessage,
    this.retryCount = 0,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Convierte el modelo a un Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'method': method,
      'url': url,
      'body': body != null ? jsonEncode(body) : null,
      'headers': headers != null ? jsonEncode(headers) : null,
      'entity_type': entityType,
      'entity_id': entityId,
      'status': status,
      'error_message': errorMessage,
      'retry_count': retryCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea una instancia desde un Map de SQLite
  factory OfflineRequestModel.fromMap(final Map<String, dynamic> map) {
    return OfflineRequestModel(
      id: map['id'] as int?,
      method: map['method'] as String,
      url: map['url'] as String,
      body: map['body'] != null 
          ? jsonDecode(map['body'] as String) as Map<String, dynamic>
          : null,
      headers: map['headers'] != null
          ? Map<String, String>.from(jsonDecode(map['headers'] as String) as Map)
          : null,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      status: map['status'] as String,
      errorMessage: map['error_message'] as String?,
      retryCount: map['retry_count'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Crea una copia con campos actualizados
  OfflineRequestModel copyWith({
    final int? id,
    final String? method,
    final String? url,
    final Map<String, dynamic>? body,
    final Map<String, String>? headers,
    final String? entityType,
    final String? entityId,
    final String? status,
    final String? errorMessage,
    final int? retryCount,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) {
    return OfflineRequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'OfflineRequestModel(id: $id, method: $method, url: $url, status: $status)';
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
  
    return other is OfflineRequestModel &&
      other.id == id &&
      other.method == method &&
      other.url == url &&
      other.entityType == entityType &&
      other.entityId == entityId &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      method.hashCode ^
      url.hashCode ^
      entityType.hashCode ^
      entityId.hashCode ^
      status.hashCode;
  }
}
