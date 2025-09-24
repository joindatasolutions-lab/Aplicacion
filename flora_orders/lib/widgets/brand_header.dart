import 'package:flutter/material.dart';
import '../theme.dart';

class FloraBrandHeader extends StatelessWidget {
  const FloraBrandHeader({
    super.key,
    this.assetLogoPath = 'assets/images/flora_logo.png',
    this.networkLogoUrl,
    this.subtitle,
  });

  final String assetLogoPath;   // usa el asset local
  final String? networkLogoUrl; // o una URL (S3/Cloud Storage)
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final logo = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 44, width: 44,
        child: networkLogoUrl != null
            ? Image.network(networkLogoUrl!, fit: BoxFit.cover)
            : Image.asset(assetLogoPath, fit: BoxFit.cover),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kFloraBlush),
        boxShadow: [
          BoxShadow(
            color: kFloraRose.withOpacity(.10),
            blurRadius: 20, offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          logo,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FLORA', style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                ]
              ],
            ),
          ),
          const _SoftBadge(text: 'Gestión de pedidos'),
        ],
      ),
    );
  }
}

class _SoftBadge extends StatelessWidget {
  const _SoftBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kFloraBlush.withOpacity(.6),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kFloraDust),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
