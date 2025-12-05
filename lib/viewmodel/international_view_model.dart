// lib/viewmodel/international_view_model.dart
import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/data/response/status.dart';
import 'package:depd_mvvm_2025/repository/domestic_repository.dart';
import 'package:depd_mvvm_2025/repository/international_repository.dart';

class InternationalViewModel with ChangeNotifier {
  final DomesticRepository _domesticRepo = DomesticRepository();
  final InternationalRepository _internationalRepo = InternationalRepository();

  void _notify() {
    try {
      notifyListeners();
    } catch (_) {
      Future.microtask(() {
        try {
          notifyListeners();
        } catch (_) {}
      });
    }
  }

  // =========================
  // ORIGIN (PROVINSI & KOTA DI INDONESIA)
  // =========================

  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();
  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();

  final Map<int, List<City>> _cityCache = {};

  Province? selectedOriginProvince;
  City? selectedOriginCity;

  List<Province> get provinces => provinceList.data ?? [];
  List<City> get originCities => cityOriginList.data ?? [];

  Future<void> getProvinceList() async {
    if (provinceList.status == Status.completed) return;
    provinceList = ApiResponse.loading();
    _notify();

    _domesticRepo.fetchProvinceList().then((value) {
      provinceList = ApiResponse.completed(value);
      _notify();
    }).onError((error, _) {
      provinceList = ApiResponse.error(error.toString());
      _notify();
    });
  }

  Future<void> getCityOriginList(int provId) async {
    if (_cityCache.containsKey(provId)) {
      cityOriginList = ApiResponse.completed(_cityCache[provId]!);
      _notify();
      return;
    }

    cityOriginList = ApiResponse.loading();
    _notify();

    _domesticRepo.fetchCityList(provId).then((value) {
      _cityCache[provId] = value;
      cityOriginList = ApiResponse.completed(value);
      _notify();
    }).onError((error, _) {
      cityOriginList = ApiResponse.error(error.toString());
      _notify();
    });
  }

  void selectOriginProvince(Province? province) {
    selectedOriginProvince = province;
    selectedOriginCity = null;

    if (province?.id != null) {
      getCityOriginList(province!.id!);
    }
    _notify();
  }

  void selectOriginCity(City? city) {
    selectedOriginCity = city;
    _notify();
  }

  // =========================
  // NEGARA & ONGKIR INTERNASIONAL
  // =========================

  List<Country> countries = [];
  List<Country> filteredCountries = [];
  Country? selectedCountry;

  Status intlCountryStatus = Status.notStarted;
  Status intlCostStatus = Status.notStarted;

  List<Costs> intlCostList = [];
  String intlError = '';

  String selectedCourierIntl = 'tiki';

  void setSelectedCourierIntl(String courier) {
    selectedCourierIntl = courier;
    _notify();
  }

  /// Dipanggil di initState InternationalPage: reset state negara
  Future<void> resetCountries() async {
    intlCountryStatus = Status.notStarted;
    intlError = '';
    countries = [];
    filteredCountries = [];
    selectedCountry = null;
    _notify();
  }

  Future<void> searchCountry(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      // reset ke state awal
      intlCountryStatus = Status.notStarted;
      intlError = '';
      countries = [];
      filteredCountries = [];
      _notify();
      return;
    }

    intlCountryStatus = Status.loading;
    intlError = '';
    _notify();

    try {
      countries = await _internationalRepo.searchCountries(trimmed);
      filteredCountries = countries;
      intlCountryStatus = Status.completed;
    } catch (e) {
      final msg = e.toString();

      // Kalau error dari API mengandung 404 → treat sebagai "tidak ada negara"
      if (msg.contains('404')) {
        countries = [];
        filteredCountries = [];
        intlCountryStatus = Status.completed;
        intlError = '';
      } else {
        intlCountryStatus = Status.error;
        intlError = msg;
      }
    }

    _notify();
  }

  void selectCountry(Country country) {
    selectedCountry = country;
    _notify();
  }

  Future<void> fetchInternationalCost({
    required String courier,
    required int originCityId,
    required String countryId,
    required int weight,
  }) async {
    intlCostStatus = Status.loading;
    intlError = '';
    _notify();

    try {
      intlCostList = await _internationalRepo.getInternationalCost(
        courier: courier,
        originCityId: originCityId,
        countryId: countryId,
        weight: weight,
      );
      intlCostStatus = Status.completed;
    } catch (e, st) {
      debugPrint('fetchInternationalCost error: $e\n$st');
      intlCostStatus = Status.error;
      intlError = e.toString();
    }

    _notify();
  }
}