// class abstract sebagai kontak layer jaringan yang kemudian diimplementasikan oleh kelas turunan
abstract class BaseApiService {
  // melakukan request GET ke endpoint dan menghasilkan respon dinamis
  Future<dynamic> getApiResponse(String endPoint);
  // melakukan request POST ke endpoint dengan data tertentu dan menghasilkan respon dinamis
  Future<dynamic> postApiResponse(String url, dynamic data);
}