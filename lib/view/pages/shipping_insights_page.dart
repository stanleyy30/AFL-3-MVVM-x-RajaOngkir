part of 'pages.dart';

class ShippingInsightsPage extends StatelessWidget {
  const ShippingInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        final isDesktop = constraints.maxWidth >= 900;

        // spacing dinamis tergantung lebar layar
        final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
        final verticalPadding = isDesktop ? 24.0 : 16.0;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER / HERO
              _HeaderSection(isTablet: isTablet, isDesktop: isDesktop),

              const SizedBox(height: 20),

              // GRID: CARD INSIGHT / TIPS
              _ResponsiveGrid(
                isTablet: isTablet,
                isDesktop: isDesktop,
              ),

              const SizedBox(height: 24),

              // SECTION BAWAH: RINGKASAN / EDUKASI
              _BottomInfoSection(isTablet: isTablet),
            ],
          ),
        );
      },
    );
  }
}

// =================== HEADER SECTION ===================

class _HeaderSection extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;

  const _HeaderSection({
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: isDesktop
          ? 26
          : (isTablet ? 22 : 20),
      fontWeight: FontWeight.bold,
    );

    final subtitleStyle = TextStyle(
      fontSize: isDesktop
          ? 14
          : (isTablet ? 13 : 12),
      color: Colors.grey[700],
      height: 1.4,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _HeaderText(titleStyle, subtitleStyle),
                ),
                const SizedBox(width: 16),
                // side illustration / icon
                Icon(
                  Icons.local_shipping_outlined,
                  size: isDesktop ? 64 : 52,
                  color: Colors.blue[800],
                ),
              ],
            )
          : _HeaderText(titleStyle, subtitleStyle),
    );
  }

  Widget _HeaderText(TextStyle titleStyle, TextStyle subtitleStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Insights', style: titleStyle),
        const SizedBox(height: 8),
        Text(
          'Ringkasan informasi yang membantu kamu memilih layanan pengiriman '
          'secara lebih cerdas, baik untuk ongkir domestik maupun internasional.',
          style: subtitleStyle,
        ),
      ],
    );
  }
}

// =================== RESPONSIVE GRID SECTION ===================

class _ResponsiveGrid extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;

  const _ResponsiveGrid({
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isDesktop
        ? 3
        : (isTablet ? 2 : 1);

    final cardSpacing = isDesktop ? 18.0 : 12.0;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: cardSpacing,
      mainAxisSpacing: cardSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isDesktop
          ? 1.6
          : (isTablet ? 1.4 : 1.9),
      children: const [
        _InsightCard(
          icon: Icons.speed,
          title: 'Kecepatan vs Harga',
          description:
              'Layanan reguler biasanya lebih murah tetapi sedikit lebih lama. '
              'Untuk pengiriman mendesak, gunakan layanan ekspres meski biaya sedikit lebih tinggi.',
        ),
        _InsightCard(
          icon: Icons.crop_7_5,
          title: 'Dimensi & Volumetrik',
          description:
              'Kurir menghitung biaya berdasarkan berat aktual atau volumetrik. '
              'Gunakan kemasan yang proporsional agar tidak membayar ongkir berlebih.',
        ),
        _InsightCard(
          icon: Icons.flight_takeoff,
          title: 'Pengiriman Internasional',
          description:
              'Untuk tujuan luar negeri, cek negara tujuan dan pilih kurir yang memiliki jaringan kuat '
              'di wilayah tersebut untuk mengurangi risiko keterlambatan.',
        ),
        _InsightCard(
          icon: Icons.lock_outline,
          title: 'Asuransi & Barang Bernilai Tinggi',
          description:
              'Untuk barang elektronik, fashion premium, atau dokumen penting, '
              'gunakan asuransi pengiriman dan simpan bukti foto sebelum dikirim.',
        ),
        _InsightCard(
          icon: Icons.inventory_2_outlined,
          title: 'Packing yang Efisien',
          description:
              'Isi ruang kosong dengan bahan pelindung, tetapi hindari karton yang terlalu besar. '
              'Hal ini menjaga barang tetap aman sekaligus menekan berat volumetrik.',
        ),
        _InsightCard(
          icon: Icons.public,
          title: 'Zona & Jarak',
          description:
              'Perbedaan kota, provinsi, hingga negara akan memengaruhi zona tarif. '
              'Bandingkan beberapa opsi kurir untuk rute yang sama sebelum memilih.',
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Container(
      padding: EdgeInsets.all(isWide ? 14 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: isWide ? 32 : 28, color: Colors.blue[700]),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isWide ? 14 : 13,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: isWide ? 12 : 11.5,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================== BOTTOM SECTION ===================

class _BottomInfoSection extends StatelessWidget {
  final bool isTablet;

  const _BottomInfoSection({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: isTablet ? 16 : 15,
      fontWeight: FontWeight.bold,
    );

    final bodyStyle = TextStyle(
      fontSize: isTablet ? 13 : 12,
      color: Colors.grey[800],
      height: 1.4,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tips Sebelum Mengirim Barang', style: titleStyle),
          const SizedBox(height: 8),
          Text(
            '• Cek kembali alamat penerima dan nomor telepon.\n'
            '• Simpan struk atau nomor resi setelah mengirim.\n'
            '• Untuk pengiriman internasional, pastikan isi paket sesuai aturan bea cukai.\n'
            '• Gunakan fitur cek ongkir di aplikasi untuk membandingkan layanan sebelum ke agen kurir.',
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}