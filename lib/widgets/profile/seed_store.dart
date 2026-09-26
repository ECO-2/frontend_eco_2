import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

/// Premio del canje. Solo guarda datos que no son texto visible: el titulo y
/// la descripcion se resuelven por `id` en _rewardTitle / _rewardDescription,
/// porque esta lista es `const` y ahi no hay BuildContext que traduzca.
class SeedRewardItem {
  final String id;
  final int cost;
  final IconData icon;

  const SeedRewardItem({
    required this.id,
    required this.cost,
    required this.icon,
  });
}

class SeedStoreList extends StatelessWidget {
  const SeedStoreList({super.key});

  final List<SeedRewardItem> _rewards = const [
    SeedRewardItem(
      id: 'r1',
      cost: 50,
      icon: Icons.local_offer_outlined,
    ),
    SeedRewardItem(
      id: 'r2',
      cost: 100,
      icon: Icons.emoji_events_outlined,
    ),
    SeedRewardItem(
      id: 'r3',
      cost: 150,
      icon: Icons.grid_view_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final missionsProvider = Provider.of<MissionsProvider>(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _rewards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final reward = _rewards[index];
        final canAfford = missionsProvider.userSeeds >= reward.cost;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECE9), width: 1.5),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(reward.icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _rewardTitle(context, reward.id),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primaryDark,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _rewardDescription(context, reward.id),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? AppColors.accent : const Color(0xFFECECEC),
                  foregroundColor: canAfford ? AppColors.primaryDark : const Color(0xFF909090),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: canAfford
                    ? () {
                        _showRedeemDialog(context, reward, missionsProvider);
                      }
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.seedsShort(reward.cost),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRedeemDialog(
    BuildContext context,
    SeedRewardItem reward,
    MissionsProvider missionsProvider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.redeemRewardTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
            fontFamily: 'DM Sans',
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.redeemRewardBody(
              _rewardTitle(context, reward.id), reward.cost),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await missionsProvider.spendSeeds(reward.cost);
              if (success) {
                if (!context.mounted) return;
                showAppToast(
                  context,
                  AppLocalizations.of(context)!.redeemSuccess(_rewardTitle(context, reward.id)),
                  type: ToastType.success,
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }
}

// Textos de los premios, resueltos en la UI: el catalogo es una lista const y
// ahi no hay BuildContext con el que traducir.
String _rewardTitle(BuildContext context, String id) {
  final l = AppLocalizations.of(context)!;
  switch (id) {
    case 'r1':
      return l.rewardDiscountTitle;
    case 'r2':
      return l.rewardBadgeTitle;
    case 'r3':
      return l.rewardPotsTitle;
    default:
      return id;
  }
}

String _rewardDescription(BuildContext context, String id) {
  final l = AppLocalizations.of(context)!;
  switch (id) {
    case 'r1':
      return l.rewardDiscountDesc;
    case 'r2':
      return l.rewardBadgeDesc;
    case 'r3':
      return l.rewardPotsDesc;
    default:
      return '';
  }
}
