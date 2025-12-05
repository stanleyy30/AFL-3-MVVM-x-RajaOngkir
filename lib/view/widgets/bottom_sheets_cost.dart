part of 'widgets.dart';

enum ShippingTab {
  domestic,
  international,
  hello,
}

class BottomSheetCostTabs extends StatelessWidget {
  final ShippingTab selectedTab;
  final ValueChanged<ShippingTab> onChanged;

  const BottomSheetCostTabs({
    Key? key,
    required this.selectedTab,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabItem(
            icon: Icons.local_shipping,
            label: 'Domestic',
            isActive: selectedTab == ShippingTab.domestic,
            onTap: () => onChanged(ShippingTab.domestic),
          ),
          _TabItem(
            icon: Icons.flight,
            label: 'International',
            isActive: selectedTab == ShippingTab.international,
            onTap: () => onChanged(ShippingTab.international),
          ),
            _TabItem(
            icon: Icons.insights,        // ICON BARU
            label: 'Insight',            // LABEL BARU
            isActive: selectedTab == ShippingTab.hello,
            onTap: () => onChanged(ShippingTab.hello),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Style.blue800;
    final Color inactiveColor = Style.grey500;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
