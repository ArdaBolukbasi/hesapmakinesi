// File: lib/screens/vat_calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VatCalculatorScreen extends ConsumerStatefulWidget {
  const VatCalculatorScreen({super.key});

  @override
  ConsumerState<VatCalculatorScreen> createState() => _VatCalculatorScreenState();
}

class _VatCalculatorScreenState extends ConsumerState<VatCalculatorScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  double _amount = 0.0;
  double _vatRate = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _calculate() {
    String cleanAmount = _amountController.text.replaceAll('.', '').replaceAll(',', '.');
    final RegExp regExp = RegExp(r'[^0-9.]');
    cleanAmount = cleanAmount.replaceAll(regExp, '');

    String cleanRate = _rateController.text.replaceAll(',', '.');
    cleanRate = cleanRate.replaceAll(regExp, '');

    setState(() {
      _amount = double.tryParse(cleanAmount) ?? 0.0;
      _vatRate = double.tryParse(cleanRate) ?? 0.0;
    });
  }

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) return "0.00";
    
    // Split integer and decimal parts
    final String fixed = value.toStringAsFixed(2);
    final List<String> parts = fixed.split('.');
    String integerPart = parts[0];
    final String decimalPart = parts[1];

    final bool isNegative = integerPart.startsWith('-');
    if (isNegative) {
      integerPart = integerPart.substring(1);
    }

    // Standard notation: Dot decimal, Comma thousands
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(reg, (Match m) => '${m[1]},');

    return '${isNegative ? '-' : ''}$integerPart.$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // KDV HARIÇ Calculations (Adding KDV to Base Amount)
    final double addedVatAmount = _amount * (_vatRate / 100);
    final double addedTotalAmount = _amount + addedVatAmount;

    // KDV DAHİL Calculations (Extracting KDV from Total Amount)
    final double extractedBaseAmount = _amount / (1 + (_vatRate / 100));
    final double extractedVatAmount = _amount - extractedBaseAmount;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'KDV Hesaplama',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // -------------------------------------------------------------
              // INPUT SECTION
              // -------------------------------------------------------------
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Amount Input (Tutar)
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Tutar (TL)',
                          hintText: 'Tutar girin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.wallet),
                        ),
                        onChanged: (val) => _calculate(),
                      ),
                      const SizedBox(height: 16),

                      // VAT Rate Input (KDV Oranı)
                      TextField(
                        controller: _rateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'KDV Oranı (%)',
                          hintText: 'Oran girin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.percent),
                        ),
                        onChanged: (val) => _calculate(),
                      ),
                      const SizedBox(height: 12),

                      // Quick VAT Rate Buttons (%1, %10, %20)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [1, 10, 20].map((rate) {
                          final isSelected = _vatRate == rate;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(
                                  '%$rate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: theme.colorScheme.primary,
                                backgroundColor: theme.colorScheme.surface,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  if (selected) {
                                    _rateController.text = rate.toString();
                                    _calculate();
                                  }
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // OUTPUT SECTION 1: KDV HARİÇ (KDV Ekleme)
              // -------------------------------------------------------------
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'KDV HARİÇ (KDV Eklenecek)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRowResult('KDV\'siz Tutar', _formatCurrency(_amount), theme),
                      const Divider(height: 16),
                      _buildRowResult('KDV Tutarı (%${_vatRate.toStringAsFixed(0)})', _formatCurrency(addedVatAmount), theme),
                      const Divider(height: 16),
                      _buildRowResult(
                        'Toplam Tutar (KDV Dahil)',
                        _formatCurrency(addedTotalAmount),
                        theme,
                        isTotal: true,
                        valueColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // OUTPUT SECTION 2: KDV DAHİL (KDV Ayıklama)
              // -------------------------------------------------------------
              Card(
                elevation: 0,
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.remove_circle_outline, color: theme.colorScheme.secondary),
                          const SizedBox(width: 8),
                          Text(
                            'KDV DAHİL (KDV Ayıklanacak)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRowResult('KDV\'siz Tutar (Net)', _formatCurrency(extractedBaseAmount), theme),
                      const Divider(height: 16),
                      _buildRowResult('KDV Tutarı (%${_vatRate.toStringAsFixed(0)})', _formatCurrency(extractedVatAmount), theme),
                      const Divider(height: 16),
                      _buildRowResult(
                        'Toplam Tutar',
                        _formatCurrency(_amount),
                        theme,
                        isTotal: true,
                        valueColor: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowResult(String label, String value, ThemeData theme, {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                fontSize: isTotal ? 15 : 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$value TL',
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 17 : 15,
                color: valueColor ?? theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
