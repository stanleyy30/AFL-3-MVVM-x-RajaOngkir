// lib/view/pages/international_page.dart
part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<InternationalViewModel>();
      vm.resetCountries();
      vm.getProvinceList(); // load provinsi untuk origin
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InternationalViewModel>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _InternationalHeader(),
                  const SizedBox(height: 16),

                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _InternationalFormCard(
                            vm: vm,
                            weightController: _weightController,
                            countryController: _countryController,
                            onCalculate: () => _onCalculate(context, vm),
                            onTapSearchCountry: () =>
                                _openCountryBottomSheet(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _InternationalResultCard(vm: vm),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _InternationalFormCard(
                          vm: vm,
                          weightController: _weightController,
                          countryController: _countryController,
                          onCalculate: () => _onCalculate(context, vm),
                          onTapSearchCountry: () =>
                              _openCountryBottomSheet(context),
                        ),
                        const SizedBox(height: 16),
                        _InternationalResultCard(vm: vm),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onCalculate(BuildContext context, InternationalViewModel vm) {
    final parsedWeight = int.tryParse(_weightController.text) ?? 0;

    if (parsedWeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Berat harus lebih dari 0 gram'),
          backgroundColor: Style.redAccent,
        ),
      );
      return;
    }

    if (vm.selectedOriginCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan pilih kota asal terlebih dahulu'),
          backgroundColor: Style.redAccent,
        ),
      );
      return;
    }

    if (vm.selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan pilih negara tujuan'),
          backgroundColor: Style.redAccent,
        ),
      );
      return;
    }

    vm.fetchInternationalCost(
      courier: vm.selectedCourierIntl,
      originCityId: vm.selectedOriginCity!.id!,
      countryId: vm.selectedCountry!.id,
      weight: parsedWeight,
    );
  }

  void _openCountryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Style.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Style.grey500,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    'Pilih Negara Tujuan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Style.blueGrey900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _CountrySearchField(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _CountryList(
                      scrollController: scrollController,
                      onSelected: (country, vm) {
                        vm.selectCountry(country);
                        _countryController.text = country.name;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// =====================
/// HEADER
/// =====================
class _InternationalHeader extends StatelessWidget {
  const _InternationalHeader();

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
          child: Icon(Icons.public, color: Style.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cek Ongkir Internasional',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Style.blueGrey900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Simulasi biaya kirim barang dari kota di Indonesia ke luar negeri.',
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
/// FORM CARD
/// =====================
class _InternationalFormCard extends StatelessWidget {
  final InternationalViewModel vm;
  final TextEditingController weightController;
  final TextEditingController countryController;
  final VoidCallback onCalculate;
  final VoidCallback onTapSearchCountry;

  const _InternationalFormCard({
    required this.vm,
    required this.weightController,
    required this.countryController,
    required this.onCalculate,
    required this.onTapSearchCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Style.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CourierAndWeightRow(vm: vm, weightController: weightController),
            const SizedBox(height: 20),
            _OriginSection(vm: vm),
            const SizedBox(height: 20),
            _DestinationSection(
              vm: vm,
              countryController: countryController,
              onTapSearch: onTapSearchCountry,
            ),
            const SizedBox(height: 20),
            _CalculateButton(onPressed: onCalculate),
          ],
        ),
      ),
    );
  }
}

class _CourierAndWeightRow extends StatelessWidget {
  final InternationalViewModel vm;
  final TextEditingController weightController;

  const _CourierAndWeightRow({
    required this.vm,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 480;

        final courierDropdown = Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: vm.selectedCourierIntl,
            decoration: const InputDecoration(
              labelText: 'Kurir',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'tiki', child: Text('TIKI')),
              DropdownMenuItem(value: 'pos', child: Text('POS INDONESIA')),
            ],
            onChanged: (value) {
              if (value != null) vm.setSelectedCourierIntl(value);
            },
          ),
        );

        final weightField = Expanded(
          flex: 3,
          child: TextFormField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Berat (gram)',
              border: OutlineInputBorder(),
            ),
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
            courierDropdown,
            const SizedBox(width: 12),
            weightField,
          ],
        );
      },
    );
  }
}

class _OriginSection extends StatelessWidget {
  final InternationalViewModel vm;

  const _OriginSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asal Pengiriman (Indonesia)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Style.grey800,
              ),
        ),
        const SizedBox(height: 8),
        _OriginSelector(vm: vm),
      ],
    );
  }
}

class _DestinationSection extends StatelessWidget {
  final InternationalViewModel vm;
  final TextEditingController countryController;
  final VoidCallback onTapSearch;

  const _DestinationSection({
    required this.vm,
    required this.countryController,
    required this.onTapSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tujuan Pengiriman (Luar Negeri)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Style.grey800,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: countryController,
          readOnly: true,
          onTap: onTapSearch,
          decoration: InputDecoration(
            hintText: vm.selectedCountry?.name ?? 'Pilih negara tujuan',
            suffixIcon: Icon(Icons.search, color: Style.grey500),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class _CalculateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CalculateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.calculate),
        label: const Text('Hitung Ongkir Internasional'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Style.blue800,
          foregroundColor: Style.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

/// =====================
/// RESULT CARD
/// =====================
class _InternationalResultCard extends StatelessWidget {
  final InternationalViewModel vm;

  const _InternationalResultCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Style.primaryBlue50,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _InternationalResult(vm: vm),
      ),
    );
  }
}

class _InternationalResult extends StatelessWidget {
  final InternationalViewModel vm;

  const _InternationalResult({required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.intlCostStatus == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.intlCostStatus == Status.error) {
      return Text(
        vm.intlError,
        style: TextStyle(color: Style.red500),
      );
    }

    if (vm.intlCostStatus == Status.completed &&
        vm.intlCostList.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vm.intlCostList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = vm.intlCostList[index];
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Style.white,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25)),
                ),
                builder: (_) => ShipmentDetail(
                  courierName: item.name ?? '',
                  code: item.code ?? '',
                  service: item.service ?? '',
                  description: item.description ?? '',
                  cost: 'Rp${item.cost}',
                  estimation: '${item.etd} hari',
                ),
              );
            },
            child: CardCost(item),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Belum ada estimasi biaya.',
          style: TextStyle(
            color: Style.blueGrey900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Lengkapi data asal, tujuan, dan berat barang lalu tekan tombol '
          '"Hitung Ongkir Internasional".',
          style: TextStyle(color: Style.grey700, fontSize: 12),
        ),
      ],
    );
  }
}

/// =====================
/// ORIGIN PROVINSI & KOTA
/// =====================
class _OriginSelector extends StatelessWidget {
  final InternationalViewModel vm;

  const _OriginSelector({required this.vm});

  @override
  Widget build(BuildContext context) {
    City? alignedCity;
    if (vm.selectedOriginCity != null && vm.originCities.isNotEmpty) {
      try {
        alignedCity = vm.originCities.firstWhere(
          (city) => city.id == vm.selectedOriginCity!.id,
        );
      } catch (_) {
        alignedCity = null;
      }
    }

    return Column(
      children: [
        DropdownButtonFormField<Province>(
          value: vm.selectedOriginProvince,
          decoration: const InputDecoration(
            hintText: 'Pilih provinsi asal',
            border: OutlineInputBorder(),
          ),
          items: vm.provinces
              .map(
                (prov) => DropdownMenuItem(
                  value: prov,
                  child: Text(prov.name ?? ''),
                ),
              )
              .toList(),
          onChanged: (value) {
            vm.selectOriginProvince(value);
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<City>(
          value: alignedCity,
          decoration: const InputDecoration(
            hintText: 'Pilih kota asal',
            border: OutlineInputBorder(),
          ),
          items: vm.originCities
              .map(
                (city) => DropdownMenuItem(
                  value: city,
                  child: Text(city.name ?? ''),
                ),
              )
              .toList(),
          onChanged: (value) {
            vm.selectOriginCity(value);
          },
        ),
      ],
    );
  }
}

/// =====================
/// COUNTRY SEARCH
/// =====================
class _CountrySearchField extends StatelessWidget {
  const _CountrySearchField();

  @override
  Widget build(BuildContext context) {
    return Consumer<InternationalViewModel>(
      builder: (context, vm, _) {
        return TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Ketik nama negara...',
            prefixIcon: Icon(Icons.search, color: Style.grey500),
            border: const OutlineInputBorder(),
          ),
          onChanged: (keyword) {
            vm.searchCountry(keyword);
          },
        );
      },
    );
  }
}

class _CountryList extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(Country country, InternationalViewModel vm) onSelected;

  const _CountryList({
    required this.scrollController,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InternationalViewModel>(
      builder: (context, vm, _) {
        if (vm.intlCountryStatus == Status.notStarted &&
            vm.filteredCountries.isEmpty &&
            vm.intlError.isEmpty) {
          return Center(
            child: Text(
              'Ketik nama negara pada kolom di atas',
              textAlign: TextAlign.center,
              style: TextStyle(color: Style.grey500),
            ),
          );
        }

        if (vm.intlCountryStatus == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.intlCountryStatus == Status.error) {
          return Center(
            child: Text(
              'Terjadi kesalahan:\n${vm.intlError}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Style.red500),
            ),
          );
        }

        final countries = vm.filteredCountries;
        if (countries.isEmpty) {
          return Center(
            child: Text(
              'Negara tidak ditemukan.\nCoba cek lagi penulisannya.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Style.grey500),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];
            return ListTile(
              title: Text(
                country.name,
                style: TextStyle(color: Style.blueGrey900),
              ),
              onTap: () => onSelected(country, vm),
            );
          },
        );
      },
    );
  }
}