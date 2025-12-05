import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

// Repository untuk menangani logika bisnis terkait data ongkir DOMESTIK
class DomesticRepository {
  final _apiServices = NetworkApiServices();

  // Mengambil daftar provinsi dari API
  Future<List<Province>> fetchProvinceList() async {
    final response = await _apiServices.getApiResponse('destination/province');

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Province.fromJson(e)).toList();
  }

  // Mengambil daftar kota berdasarkan ID provinsi
  Future<List<City>> fetchCityList(int provId) async {
    final response =
        await _apiServices.getApiResponse('destination/city/$provId');

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => City.fromJson(e)).toList();
  }

  // =========================
  // ✅ CITY → CITY, TANPA DISTRICT MODEL
  // =========================
  Future<List<Costs>> checkShipmentCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int weight,
    String courier,
  ) async {
    // ⛔ JANGAN LAGI:
    // 'calculate/district/domestic-cost'

    // ✅ PAKAI INI:
    final response =
        await _apiServices.postApiResponse('calculate/domestic-cost', {
      "origin": origin,                // city id asal
      "originType": originType,        // "city"
      "destination": destination,      // city id tujuan
      "destinationType": destinationType, // "city"
      "weight": weight.toString(),     // gram
      "courier": courier,              // jne / sicepat / dst
      "price": "lowest",               // sesuai docs RajaOngkir
    });

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map<Costs>((e) => Costs.fromJson(e)).toList();
  }
}