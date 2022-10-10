class AduanData {
  int? _code;
  bool? _success;
  List<Data>? _data;

  AduanData({int? code, bool? success, List<Data>? data}) {
    if (code != null) {
      this._code = code;
    }
    if (success != null) {
      this._success = success;
    }
    if (data != null) {
      this._data = data;
    }
  }

  int? get code => _code;
  set code(int? code) => _code = code;
  bool? get success => _success;
  set success(bool? success) => _success = success;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;

  AduanData.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _success = json['success'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['success'] = this._success;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? _userId;
  String? _nomor;
  String? _status;
  String? _tanggal;
  String? _jenis;
  String? _judul;
  String? _lokasi;
  String? _keterangan;
  String? _foto;
  String? _createdAt;
  String? _deletedAt;

  Data(
      {String? userId,
      String? nomor,
      String? status,
      String? tanggal,
      String? jenis,
      String? judul,
      String? lokasi,
      String? keterangan,
      String? foto,
      String? createdAt,
      String? deletedAt}) {
    if (userId != null) {
      this._userId = userId;
    }
    if (nomor != null) {
      this._nomor = nomor;
    }
    if (status != null) {
      this._status = status;
    }
    if (tanggal != null) {
      this._tanggal = tanggal;
    }
    if (jenis != null) {
      this._jenis = jenis;
    }
    if (judul != null) {
      this._judul = judul;
    }
    if (lokasi != null) {
      this._lokasi = lokasi;
    }
    if (keterangan != null) {
      this._keterangan = keterangan;
    }
    if (foto != null) {
      this._foto = foto;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (deletedAt != null) {
      this._deletedAt = deletedAt;
    }
  }

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get nomor => _nomor;
  set nomor(String? nomor) => _nomor = nomor;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get tanggal => _tanggal;
  set tanggal(String? tanggal) => _tanggal = tanggal;
  String? get jenis => _jenis;
  set jenis(String? jenis) => _jenis = jenis;
  String? get judul => _judul;
  set judul(String? judul) => _judul = judul;
  String? get lokasi => _lokasi;
  set lokasi(String? lokasi) => _lokasi = lokasi;
  String? get keterangan => _keterangan;
  set keterangan(String? keterangan) => _keterangan = keterangan;
  String? get foto => _foto;
  set foto(String? foto) => _foto = foto;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get deletedAt => _deletedAt;
  set deletedAt(String? deletedAt) => _deletedAt = deletedAt;

  Data.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _nomor = json['nomor'];
    _status = json['status'];
    _tanggal = json['tanggal'];
    _jenis = json['jenis'];
    _judul = json['judul'];
    _lokasi = json['lokasi'];
    _keterangan = json['keterangan'];
    _foto = json['foto'];
    _createdAt = json['created_at'];
    _deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this._userId;
    data['nomor'] = this._nomor;
    data['status'] = this._status;
    data['tanggal'] = this._tanggal;
    data['jenis'] = this._jenis;
    data['judul'] = this._judul;
    data['lokasi'] = this._lokasi;
    data['keterangan'] = this._keterangan;
    data['foto'] = this._foto;
    data['created_at'] = this._createdAt;
    data['deleted_at'] = this._deletedAt;
    return data;
  }
}
