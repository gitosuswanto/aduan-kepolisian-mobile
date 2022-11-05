import 'dart:convert';

class AduanData {
  AduanData({
    this.code,
    this.success,
    this.message,
    this.data,
  });

  int? code;
  bool? success;
  String? message;
  List<Data>? data;

  factory AduanData.fromRawJson(String str) => AduanData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AduanData.fromJson(Map<String, dynamic> json) => AduanData(
    code: json["code"] == null ? null : json["code"],
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.nomor,
    this.status,
    this.tanggal,
    this.jenis,
    this.judul,
    this.lokasi,
    this.keterangan,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  String? id;
  String? userId;
  String? nomor;
  String? status;
  String? tanggal;
  String? jenis;
  String? judul;
  String? lokasi;
  String? keterangan;
  String? foto;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic? deletedAt;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    nomor: json["nomor"] == null ? null : json["nomor"],
    status: json["status"] == null ? null : json["status"],
    tanggal: json["tanggal"] == null ? null : json["tanggal"],
    jenis: json["jenis"] == null ? null : json["jenis"],
    judul: json["judul"] == null ? null : json["judul"],
    lokasi: json["lokasi"] == null ? null : json["lokasi"],
    keterangan: json["keterangan"] == null ? null : json["keterangan"],
    foto: json["foto"] == null ? null : json["foto"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "nomor": nomor == null ? null : nomor,
    "status": status == null ? null : status,
    "tanggal": tanggal == null ? null : tanggal,
    "jenis": jenis == null ? null : jenis,
    "judul": judul == null ? null : judul,
    "lokasi": lokasi == null ? null : lokasi,
    "keterangan": keterangan == null ? null : keterangan,
    "foto": foto == null ? null : foto,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
