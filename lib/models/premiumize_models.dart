class PremiumizeAccountInfo {
  final int limit_used;
  final String type;
  final double price;
  final String customer_id;
  final int limit_total;
  final int space_used;
  final int space_total;

  PremiumizeAccountInfo({
    required this.limit_used,
    required this.type,
    required this.price,
    required this.customer_id,
    required this.limit_total,
    required this.space_used,
    required this.space_total,
  });

  factory PremiumizeAccountInfo.fromJson(Map<String, dynamic> json) {
    return PremiumizeAccountInfo(
      limit_used: json['limit_used'],
      type: json['type'],
      price: json['price'].toDouble(),
      customer_id: json['customer_id'],
      limit_total: json['limit_total'],
      space_used: json['space_used'] ?? 0,
      space_total: json['space_total'] ?? 0,
    );
  }

  double get spaceUsedGB => space_used / (1024 * 1024 * 1024);
  double get spaceTotalGB => space_total / (1024 * 1024 * 1024);
  double get spaceUsedPercentage => (space_used / space_total) * 100;
}

class PremiumizeTransfer {
  final String id;
  final String name;
  final String status;
  final String message;
  final double progress;
  final String folder_id;
  final String? file_id;
  final int? size;
  final String? source;

  PremiumizeTransfer({
    required this.id,
    required this.name,
    required this.status,
    required this.message,
    required this.progress,
    required this.folder_id,
    this.file_id,
    this.size,
    this.source,
  });

  factory PremiumizeTransfer.fromJson(Map<String, dynamic> json) {
    return PremiumizeTransfer(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      message: json['message'] ?? '',
      progress: json['progress'].toDouble(),
      folder_id: json['folder_id'] ?? '',
      file_id: json['file_id'],
      size: json['size'],
      source: json['src'],
    );
  }

  bool get isFinished => status == 'finished';
  bool get isError => status == 'error';
  String get formattedSize => size != null 
    ? '${(size! / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB'
    : 'Unknown size';
} 