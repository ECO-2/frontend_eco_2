import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:confetti/confetti.dart';
import 'package:frontend_eco_2/widgets/common/leaf_burst.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Play animated confetti for 4 seconds on screen entry
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent, // Lime green background matching Figma mockup
      body: Stack(
        children: [
          Column(
            children: [
              // CustomStatusBar with lime-green background (automatically configures dark icons)
              const CustomStatusBar(backgroundColor: AppColors.accent),
              
              // Close button at the top-right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 16.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.dashboard,
                          (route) => false,
                        );
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.primaryDark,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero, // Zero padding to let components span full screen width
                  child: Column(
                    children: [
                      // Full-Width Stack for Welcome Header
                      SizedBox(
                        height: 330,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 1. Central Checkmark Circle
                            Positioned(
                              top: 10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryDark,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.accent,
                                    size: 70,
                                  ),
                                ),
                              ),
                            ),
                            
                            // 2. Welcome Title
                            Positioned(
                              top: 160,
                              left: 24,
                              right: 24,
                              child: Text(
                                AppLocalizations.of(context)!.welcomeToEco2Plus,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1.15,
                                  fontFamily: 'DM Sans',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            // 3. Welcome Subtitle
                            Positioned(
                              top: 248,
                              left: 40,
                              right: 40,
                              child: Text(
                                AppLocalizations.of(context)!.subscriptionActive,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Next Steps White Card (with 24 horizontal margin)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header
                              Row(
                                children: [
                                  Icon(Icons.star_outline_rounded, color: AppColors.primaryDark, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.whatToDoNow,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              // Step 1
                              _buildStepRow(
                                number: '1',
                                title: AppLocalizations.of(context)!.tourScanFavourite,
                                subtitle: AppLocalizations.of(context)!.tourScanFavouriteDesc,
                              ),
                              const SizedBox(height: 18),
                              
                              // Step 2
                              _buildStepRow(
                                number: '2',
                                title: AppLocalizations.of(context)!.addPlantsWithoutLimit,
                                subtitle: AppLocalizations.of(context)!.gardenCanGrow,
                              ),
                              const SizedBox(height: 18),
                              
                              // Step 3
                              _buildStepRow(
                                number: '3',
                                title: AppLocalizations.of(context)!.exploreDiscounts,
                                subtitle: AppLocalizations.of(context)!.exploreDiscountsDesc,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              
              // Bottom Action Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark, // Dark green background
                        foregroundColor: AppColors.accent, // Lime green text!
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        // Navigate back and remove history to get fresh start in dashboard
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.dashboard,
                          (route) => false,
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.startUsingPlus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // 4. Confetti Widget overlay on top of everything
          Align(
            alignment: Alignment.topCenter,
            child: LeafBurst(controller: _confettiController),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number badge
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent, // Lime green badge
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Text Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryDark,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
