part of 'pages.dart';

class DomesticPage extends StatefulWidget {
  const DomesticPage({super.key});

  @override
  State<DomesticPage> createState() => _DomesticPageState();
}

class _DomesticPageState extends State<DomesticPage> {
  late DomesticViewModel domesticViewModel;

  final TextEditingController weightController = TextEditingController();

  final List<String> courierOptions = ["jne", "pos", "tiki", "lion", "sicepat"];
  String selectedCourier = "jne";

  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  int? selectedProvinceDestinationId;
  int? selectedCityDestinationId;

  ShippingTab selectedTab = ShippingTab.domestic;

  String rupiahMoneyFormatter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  @override
  void initState() {
    super.initState();
    domesticViewModel = Provider.of<DomesticViewModel>(context, listen: false);

    if (domesticViewModel.provinceList.status == Status.notStarted) {
      domesticViewModel.getProvinceList();
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(),
      bottomNavigationBar: BottomSheetCostTabs(
        selectedTab: selectedTab,
        onChanged: (tab) {
          setState(() {
            selectedTab = tab;
          });
        },
      ),
    );
  }

  Widget _buildPageContent() {
    switch (selectedTab) {
      case ShippingTab.domestic:
        return _buildDomesticPage();
      case ShippingTab.international:
        return const InternationalPage();
      case ShippingTab.hello:
        return const ShippingInsightsPage();
    }
  }

  Widget _buildDomesticPage() {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _DomesticHeader(),
                      const SizedBox(height: 16),

                      // FORM CARD
                      Card(
                        color: Style.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _CourierAndWeightRowDomestic(
                                courierOptions: courierOptions,
                                selectedCourier: selectedCourier,
                                onCourierChanged: (v) {
                                  setState(() {
                                    selectedCourier = v;
                                  });
                                },
                                weightController: weightController,
                              ),
                              const SizedBox(height: 24),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Origin",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Style.grey800,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              isWide
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: _OriginProvinceDropdown(
                                            selectedProvinceOriginId:
                                                selectedProvinceOriginId,
                                            onChanged: (newId) {
                                              setState(() {
                                                selectedProvinceOriginId =
                                                    newId;
                                                selectedCityOriginId = null;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _OriginCityDropdown(
                                            selectedCityOriginId:
                                                selectedCityOriginId,
                                            onChanged: (newId) {
                                              setState(() {
                                                selectedCityOriginId = newId;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _OriginProvinceDropdown(
                                          selectedProvinceOriginId:
                                              selectedProvinceOriginId,
                                          onChanged: (newId) {
                                            setState(() {
                                              selectedProvinceOriginId =
                                                  newId;
                                              selectedCityOriginId = null;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        _OriginCityDropdown(
                                          selectedCityOriginId:
                                              selectedCityOriginId,
                                          onChanged: (newId) {
                                            setState(() {
                                              selectedCityOriginId = newId;
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                              const SizedBox(height: 24),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Destination",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Style.grey800,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              isWide
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child:
                                              _DestinationProvinceDropdown(
                                            selectedProvinceDestinationId:
                                                selectedProvinceDestinationId,
                                            onChanged: (newId) {
                                              setState(() {
                                                selectedProvinceDestinationId =
                                                    newId;
                                                selectedCityDestinationId =
                                                    null;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _DestinationCityDropdown(
                                            selectedCityDestinationId:
                                                selectedCityDestinationId,
                                            onChanged: (newId) {
                                              setState(() {
                                                selectedCityDestinationId =
                                                    newId;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _DestinationProvinceDropdown(
                                          selectedProvinceDestinationId:
                                              selectedProvinceDestinationId,
                                          onChanged: (newId) {
                                            setState(() {
                                              selectedProvinceDestinationId =
                                                  newId;
                                              selectedCityDestinationId = null;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        _DestinationCityDropdown(
                                          selectedCityDestinationId:
                                              selectedCityDestinationId,
                                          onChanged: (newId) {
                                            setState(() {
                                              selectedCityDestinationId =
                                                  newId;
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _onCalculateDomesticPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Style.primaryBlue,
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  child: const Text(
                                    "Hitung Ongkir",
                                    style: TextStyle(color: Style.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // RESULT CARD
                      Card(
                        color: Style.primaryBlue50,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Consumer<DomesticViewModel>(
                            builder: (context, vm, _) {
                              switch (vm.costList.status) {
                                case Status.loading:
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(
                                        color: Style.black,
                                      ),
                                    ),
                                  );
                                case Status.error:
                                  return Center(
                                    child: Text(
                                      vm.costList.message ?? 'Error',
                                      style: TextStyle(color: Style.red500),
                                    ),
                                  );
                                case Status.completed:
                                  final data = vm.costList.data ?? [];
                                  if (data.isEmpty) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Tidak ada data ongkir.",
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final costItem = data[index];
                                      return InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Style.white,
                                            shape:
                                                const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(25),
                                              ),
                                            ),
                                            builder: (_) => ShipmentDetail(
                                              courierName:
                                                  costItem.name ?? '',
                                              code: costItem.code ?? '',
                                              service:
                                                  costItem.service ?? '',
                                              description:
                                                  costItem.description ?? '',
                                              cost: rupiahMoneyFormatter(
                                                costItem.cost,
                                              ),
                                              estimation:
                                                  "${costItem.etd ?? ''}"
                                                      .replaceAll(
                                                          'day', 'hari')
                                                      .replaceAll(
                                                          'days', 'hari'),
                                            ),
                                          );
                                        },
                                        child: CardCost(costItem),
                                      );
                                    },
                                  );
                                default:
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Belum ada estimasi ongkir.",
                                        style: TextStyle(
                                          color: Style.blueGrey900,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Pilih Origin, Destination, dan berat barang, lalu klik tombol \"Hitung Ongkir\".",
                                        style: TextStyle(
                                          color: Style.grey700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Overlay loading
        Consumer<DomesticViewModel>(
          builder: (context, vm, _) {
            if (!vm.isLoading) return const SizedBox.shrink();
            return Container(
              color: Style.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Style.white),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onCalculateDomesticPressed() {
    if (selectedCityOriginId == null ||
        selectedCityDestinationId == null ||
        weightController.text.isEmpty ||
        selectedCourier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi semua field!'),
          backgroundColor: Style.redAccent,
        ),
      );
      return;
    }

    final weight = int.tryParse(weightController.text) ?? 0;
    if (weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Berat harus lebih dari 0'),
          backgroundColor: Style.redAccent,
        ),
      );
      return;
    }

    domesticViewModel.checkShipmentCost(
      selectedCityOriginId!.toString(),
      "city",
      selectedCityDestinationId!.toString(),
      "city",
      weight,
      selectedCourier,
    );
  }
}

/// =====================
/// HEADER DOMESTIC
/// =====================

class _DomesticHeader extends StatelessWidget {
  const _DomesticHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Style.primaryBlue50,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.local_shipping, color: Style.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cek Ongkir Domestik',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Style.blueGrey900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hitung estimasi biaya kirim antar kota di Indonesia.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Style.grey700,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// =====================
/// ROW KURIR + BERAT (RESPONSIVE)
/// =====================

class _CourierAndWeightRowDomestic extends StatelessWidget {
  final List<String> courierOptions;
  final String selectedCourier;
  final ValueChanged<String> onCourierChanged;
  final TextEditingController weightController;

  const _CourierAndWeightRowDomestic({
    required this.courierOptions,
    required this.selectedCourier,
    required this.onCourierChanged,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;

        final courierDropdown = DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedCourier,
          decoration: const InputDecoration(
            labelText: 'Kurir',
            border: OutlineInputBorder(),
          ),
          items: courierOptions
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onCourierChanged(v);
          },
        );

        final weightField = TextFormField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Berat (gram)',
            border: OutlineInputBorder(),
          ),
        );

        if (isNarrow) {
          return Column(
            children: [
              courierDropdown,
              const SizedBox(height: 12),
              weightField,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: courierDropdown),
            const SizedBox(width: 16),
            Expanded(child: weightField),
          ],
        );
      },
    );
  }
}

/// =====================
/// DROPDOWN ORIGIN
/// =====================

class _OriginProvinceDropdown extends StatelessWidget {
  final int? selectedProvinceOriginId;
  final ValueChanged<int?> onChanged;

  const _OriginProvinceDropdown({
    required this.selectedProvinceOriginId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DomesticViewModel>(
      builder: (context, vm, _) {
        if (vm.provinceList.status == Status.loading) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(color: Style.black),
            ),
          );
        }
        if (vm.provinceList.status == Status.error) {
          return Text(
            vm.provinceList.message ?? 'Error',
            style: TextStyle(color: Style.red500),
          );
        }

        final provinces = vm.provinceList.data ?? [];
        if (provinces.isEmpty) {
          return Text(
            'Tidak ada provinsi',
            style: TextStyle(color: Style.grey500),
          );
        }

        return DropdownButtonFormField<int>(
          isExpanded: true,
          value: selectedProvinceOriginId,
          decoration: const InputDecoration(
            hintText: 'Pilih provinsi',
            border: OutlineInputBorder(),
          ),
          items: provinces
              .map(
                (p) => DropdownMenuItem<int>(
                  value: p.id,
                  child: Text(p.name ?? ''),
                ),
              )
              .toList(),
          onChanged: (newId) {
            onChanged(newId);
            if (newId != null) {
              vm.getCityOriginList(newId);
            }
          },
        );
      },
    );
  }
}

class _OriginCityDropdown extends StatelessWidget {
  final int? selectedCityOriginId;
  final ValueChanged<int?> onChanged;

  const _OriginCityDropdown({
    required this.selectedCityOriginId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DomesticViewModel>(
      builder: (context, vm, _) {
        final status = vm.cityOriginList.status;

        if (status == Status.notStarted) {
          return Text(
            'Pilih provinsi dulu',
            style: TextStyle(fontSize: 12, color: Style.grey500),
          );
        }
        if (status == Status.loading) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(color: Style.black),
            ),
          );
        }
        if (status == Status.error) {
          return Text(
            vm.cityOriginList.message ?? 'Error',
            style: TextStyle(color: Style.red500),
          );
        }

        final cities = vm.cityOriginList.data ?? [];
        if (cities.isEmpty) {
          return Text(
            'Tidak ada kota',
            style: TextStyle(fontSize: 12, color: Style.grey500),
          );
        }

        final validIds = cities.map((c) => c.id).toSet();
        final validValue =
            validIds.contains(selectedCityOriginId) ? selectedCityOriginId : null;

        return DropdownButtonFormField<int>(
          isExpanded: true,
          value: validValue,
          decoration: const InputDecoration(
            hintText: 'Pilih kota',
            border: OutlineInputBorder(),
          ),
          items: cities
              .map(
                (c) => DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name ?? ''),
                ),
              )
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}

/// =====================
/// DROPDOWN DESTINATION
/// =====================

class _DestinationProvinceDropdown extends StatelessWidget {
  final int? selectedProvinceDestinationId;
  final ValueChanged<int?> onChanged;

  const _DestinationProvinceDropdown({
    required this.selectedProvinceDestinationId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DomesticViewModel>(
      builder: (context, vm, _) {
        if (vm.provinceList.status == Status.loading) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(color: Style.black),
            ),
          );
        }
        if (vm.provinceList.status == Status.error) {
          return Text(
            vm.provinceList.message ?? 'Error',
            style: TextStyle(color: Style.red500, fontSize: 12),
          );
        }

        final provinces = vm.provinceList.data ?? [];
        if (provinces.isEmpty) {
          return Text(
            'Tidak ada provinsi',
            style: TextStyle(color: Style.grey500),
          );
        }

        return DropdownButtonFormField<int>(
          isExpanded: true,
          value: selectedProvinceDestinationId,
          decoration: const InputDecoration(
            hintText: 'Pilih provinsi',
            border: OutlineInputBorder(),
          ),
          items: provinces
              .map(
                (p) => DropdownMenuItem<int>(
                  value: p.id,
                  child: Text(p.name ?? ''),
                ),
              )
              .toList(),
          onChanged: (newId) {
            onChanged(newId);
            if (newId != null) {
              vm.getCityDestinationList(newId);
            }
          },
        );
      },
    );
  }
}

class _DestinationCityDropdown extends StatelessWidget {
  final int? selectedCityDestinationId;
  final ValueChanged<int?> onChanged;

  const _DestinationCityDropdown({
    required this.selectedCityDestinationId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DomesticViewModel>(
      builder: (context, vm, _) {
        final status = vm.cityDestinationList.status;

        if (status == Status.notStarted) {
          return Text(
            'Pilih provinsi dulu',
            style: TextStyle(fontSize: 12, color: Style.grey500),
          );
        }
        if (status == Status.loading) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(color: Style.black),
            ),
          );
        }
        if (status == Status.error) {
          return Text(
            vm.cityDestinationList.message ?? 'Error',
            style: TextStyle(color: Style.red500, fontSize: 12),
          );
        }

        final cities = vm.cityDestinationList.data ?? [];
        if (cities.isEmpty) {
          return Text(
            'Tidak ada kota',
            style: TextStyle(fontSize: 12, color: Style.grey500),
          );
        }

        final validIds = cities.map((c) => c.id).toSet();
        final validValue = validIds.contains(selectedCityDestinationId)
            ? selectedCityDestinationId
            : null;

        return DropdownButtonFormField<int>(
          isExpanded: true,
          value: validValue,
          decoration: const InputDecoration(
            hintText: 'Pilih kota',
            border: OutlineInputBorder(),
          ),
          items: cities
              .map(
                (c) => DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name ?? ''),
                ),
              )
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}