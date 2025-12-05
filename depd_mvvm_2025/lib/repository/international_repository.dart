// lib/repository/international_repository.dart
import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

class InternationalRepository {
  final _api = NetworkApiServices();

  /// Cari list negara tujuan (RajaOngkir International Destination)
  Future<List<Country>> searchCountries(String query) async {
    // ❌ JANGAN PAKAI query di endpoint (nanti ? jadi %3F)
    // final endpoint =
    //   'destination/international-destination?search=$query&limit=99&offset=0';

    // ✅ Pakai path + queryParams
    final response = await _api.getApiResponse(
      'destination/international-destination',
      queryParams: {
        'search': query,
        'limit': '99',
        'offset': '0',
      },
    );

    final meta = response['meta'];
    if (meta == null) {
      throw Exception('Invalid API response: meta is null');
    }

    final status = meta['status'];
    final code = meta['code'];
    final message = meta['message'] ?? 'Unknown error';

    if (status != 'success') {
      throw Exception('API $code: $message');
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map<Country>((e) => Country.fromJson(e)).toList();
  }

  /// Hitung ongkir internasional
  Future<List<Costs>> getInternationalCost({
    required String courier,
    required int originCityId,
    required String countryId,
    required int weight,
  }) async {
    final body = {
      'courier': courier,
      'origin': originCityId.toString(),
      'destination': countryId,
      'weight': weight.toString(),
      'price': 'lowest',
    };

    final response =
        await _api.postApiResponse('calculate/international-cost', body);

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception(meta?['message'] ?? 'Failed to get international cost');
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map<Costs>((e) => Costs.fromJson(e)).toList();
  }
}