import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedMethod = 'card'; // 'card', 'apple_pay', 'paypal'
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.confirmPayment,
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected Plan Card (Dark Teal Box)
                  _buildPlanCard(),
                  const SizedBox(height: 24),
                  
                  // Payment Method Section Title
                  Text(
                    AppLocalizations.of(context)!.paymentMethod,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Payment Methods
                  _buildPaymentOption(
                    id: 'card',
                    title: AppLocalizations.of(context)!.card,
                    subtitle: '•••• 4242',
                    icon: Icons.credit_card_rounded,
                  ),
                  SizedBox(height: 12),
                  
                  _buildPaymentOption(
                    id: 'apple_pay',
                    title: 'Apple Pay',
                    subtitle: AppLocalizations.of(context)!.quickPay,
                    icon: Icons.apple,
                  ),
                  const SizedBox(height: 12),
                  
                  _buildPaymentOption(
                    id: 'paypal',
                    title: 'PayPal',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: 20),
                  
                  // Security Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(AppLocalizations.of(context)!.securePayments,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Aviso honesto: la pasarela es una maqueta y no cobra nada.
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF0D9A8)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: Color(0xFFB8860B), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.simulatedPayment,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Color(0xFF7A5C00),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Bottom Payment Bar
          _buildBottomPaymentBar(context),
        ],
      ),
    );
  }

  Widget _buildPlanCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F3138), // Deep dark green/teal
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(AppLocalizations.of(context)!.selectedPlan,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Row with Plan Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.eco2PlusAnnual,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.cancelAnytime,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '\$39.99',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.perMonthPrice('\$3.33'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          
          // Benefits list
          _buildPlanBenefit('Macetas ilimitadas'),
          const SizedBox(height: 10),
          _buildPlanBenefit(AppLocalizations.of(context)!.aiSearch),
          const SizedBox(height: 10),
          _buildPlanBenefit('How to treat con IA'),
          const SizedBox(height: 10),
          _buildPlanBenefit('Descuentos en viveros'),
        ],
      ),
    );
  }

  Widget _buildPlanBenefit(String text) {
    return Row(
      children: [
        const Icon(Icons.check_rounded, color: AppColors.accent, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    String? subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E7E4),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Left icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : const Color(0xFFF1F4F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            
            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  // El subtítulo es opcional: PayPal mostraba un correo de
                  // ejemplo como si fuera la cuenta de quien usa la app.
                  if (subtitle != null) ...[
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
                ],
              ),
            ),
            
            // Selected radio indicator
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : const Color(0xFFE2E7E4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPaymentBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.totalToPay,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.oneYearPlus,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const Text(
                  '\$39.99',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Pay button
            CustomButton(
              text: AppLocalizations.of(context)!.payAmount('\$39.99'),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primary,
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);

    // Cobro simulado: la pasarela es una maqueta. Lo que si es real es la
    // activacion del plan en el backend, que es lo que levanta los topes de
    // macetas y escaneos. Antes esto solo escribia 'premium' en el estado
    // local, asi que no cambiaba nada y se perdia al reiniciar.
    final planProvider = Provider.of<PlanProvider>(context, listen: false);
    final ok = await planProvider.activatePlus();
    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (!ok) {
      showAppToast(
        context,
        planProvider.errorText(context) ??
            AppLocalizations.of(context)!.connectionError,
        type: ToastType.error,
      );
      return;
    }

    // El perfil cacheado tambien debe reflejar el plan nuevo.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      userProvider.setUser(currentUser.copyWith(planType: 'plus'));
    }

    Navigator.pushReplacementNamed(context, AppRoutes.success);
  }
}
