import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/data/response/status.dart';
import 'package:depd_mvvm_2025/repository/domestic_repository.dart';

/// ViewModel untuk fitur ongkir DOMESTIK (province, city, dan ongkir city → city)
class DomesticViewModel with ChangeNotifier {
  final DomesticRepository _repo = DomesticRepository();

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
  // STATE PROVINSI & KOTA
  // =========================

  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();
  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  ApiResponse<List<City>> cityDestinationList = ApiResponse.notStarted();

  /// Cache kota per provinsi (biar gak hit API berulang)
  final Map<int, List<City>> _cityCache = {};

  void setProvinceList(ApiResponse<List<Province>> value) {
    provinceList = value;
    _notify();
  }

  void setCityOriginList(ApiResponse<List<City>> value) {
    cityOriginList = value;
    _notify();
  }

  void setCityDestinationList(ApiResponse<List<City>> value) {
    cityDestinationList = value;
    _notify();
  }

  /// Ambil list provinsi (sekali saja, setelah itu pakai state)
  Future<void> getProvinceList() async {
    if (provinceList.status == Status.completed) return;

    setProvinceList(ApiResponse.loading());

    _repo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, _) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  /// Ambil list kota untuk ORIGIN berdasarkan provinsi
  Future<void> getCityOriginList(int provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityOriginList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }

    setCityOriginList(ApiResponse.loading());

    _repo.fetchCityList(provId).then((value) {
      _cityCache[provId] = value;
      setCityOriginList(ApiResponse.completed(value));
    }).onError((error, _) {
      setCityOriginList(ApiResponse.error(error.toString()));
    });
  }

  /// Ambil list kota untuk DESTINATION berdasarkan provinsi
  Future<void> getCityDestinationList(int provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityDestinationList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }

    setCityDestinationList(ApiResponse.loading());

    _repo.fetchCityList(provId).then((value) {
      _cityCache[provId] = value;
      setCityDestinationList(ApiResponse.completed(value));
    }).onError((error, _) {
      setCityDestinationList(ApiResponse.error(error.toString()));
    });
  }

  // =========================
  // STATE ONGKIR DOMESTIC
  // =========================

  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();
  bool isLoading = false;

  void setCostList(ApiResponse<List<Costs>> value) {
    costList = value;
    _notify();
  }

  void setLoading(bool value) {
    isLoading = value;
    _notify();
  }

  /// Cek ongkir city → city (tanpa district model)
  Future<void> checkShipmentCost(
    String origin,
    String originType, // "city"
    String destination,
    String destinationType, // "city"
    int weight,
    String courier,
  ) async {
    setLoading(true);
    setCostList(ApiResponse.loading());

    _repo
        .checkShipmentCost(
          origin,
          originType,
          destination,
          destinationType,
          weight,
          courier,
        )
        .then((value) {
          setCostList(ApiResponse.completed(value));
          setLoading(false);
        })
        .onError((error, _) {
          setCostList(ApiResponse.error(error.toString()));
          setLoading(false);
        });
  }
}