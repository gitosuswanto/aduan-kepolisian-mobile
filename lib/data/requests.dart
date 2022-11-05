import 'dart:convert';

import 'package:aduan/config/config.dart';
import 'package:aduan/data/aduan_data.dart';
import 'package:http/http.dart' as http;

class ApiRequests {

  // create aduan
  static Future<AduanData> createAduan(Data aduan) async {
    final req = await http.MultipartRequest(
      'POST',
      Uri.parse('${Config().getApiUrl}/aduan/create'),
    );
    req.fields['users'] = aduan.userId!;
    req.fields['tanggal_kejadian'] = aduan.tanggal!;
    req.fields['jenis_aduan'] = aduan.jenis!;
    req.fields['judul'] = aduan.judul!;
    req.fields['lokasi'] = aduan.lokasi!;
    req.fields['keterangan'] = aduan.keterangan!;
    req.files.add(
      await http.MultipartFile.fromPath(
        'foto_aduan',
        aduan.foto!,
      ),
    );
    final res = await req.send();

    if (res.statusCode == 200) {
      final data = await res.stream.bytesToString();
      return AduanData.fromRawJson(data);
    } else {
      return AduanData(
        code: res.statusCode,
        success: false,
        message: 'Failed to create aduan',
        data: [],
      );
    }
  }

  Future<AduanData> getAllAduan(String id) async {
    final res = await http.get(Uri.parse('${Config().getApiUrl}/aduan/${id}/all'));

    if (res.statusCode == 200) {
      return AduanData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<AduanData> getAduanByStatus({required String status, required String id}) async {
    final res = await http.get(Uri.parse('${Config().getApiUrl}/aduan/${id}/$status'));

    if (res.statusCode == 200) {
      return AduanData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<AduanData> getAduanByNomor({required String nomor}) async {
    final res = await http.get(Uri.parse('${Config().getApiUrl}/aduan/$nomor'));

    if (res.statusCode == 200) {
      return AduanData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<AduanData> deleteAduan({required String nomor}) async {
    final res = await http.delete(Uri.parse('${Config().getApiUrl}/aduan/delete/$nomor'));

    if (res.statusCode == 200) {
      return AduanData.fromJson(jsonDecode(res.body));
    } else {
      return AduanData.fromJson(
        {
          "success": false,
          "message": "Gagal menghapus aduan, nampaknya ada masalah",
        }
      );
    }
  }
}
