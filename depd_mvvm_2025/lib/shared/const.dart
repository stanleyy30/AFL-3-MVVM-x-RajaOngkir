part of 'shared.dart';

class Const {
  static final baseUrl = dotenv.env['RAJAONGKIR_BASE_URL'] ?? 'rajaongkir.komerce.id';
  static final subUrl  = dotenv.env['RAJAONGKIR_SUB_URL'] ?? '/api/v1/';
  static final apiKey  = dotenv.env['RAJAONGKIR_API_KEY'] ?? '';
}
