part of 'widgets.dart';

/// Bottom sheet widget to show shipment/cost detail, like the JNE detail in the design.
class ShipmentDetail extends StatelessWidget {
  final String courierName; 
  final String code;
  final String service; 
  final String description; 
  final String cost; 
  final String estimation;

  const ShipmentDetail({
    Key? key,
    required this.courierName,
    required this.code,
    required this.service,
    required this.description,
    required this.cost,
    required this.estimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + title + close button
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courierName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Style.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          _ShipmentDetailRow(title: 'Nama Kurir', value: courierName),
          _ShipmentDetailRow(title: 'Kode', value: code),
          _ShipmentDetailRow(title: 'Layanan', value: service),
          _ShipmentDetailRow(title: 'Deskripsi', value: description),
          _ShipmentDetailRow(title: 'Biaya', value: cost),
          _ShipmentDetailRow(title: 'Estimasi Pengiriman', value: estimation),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ShipmentDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _ShipmentDetailRow({Key? key, required this.title, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text('$title :', style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
