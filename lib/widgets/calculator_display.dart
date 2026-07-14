// File: lib/widgets/calculator_display.dart

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calculator_provider.dart';

class CalculatorDisplay extends ConsumerWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: isLandscape
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Mode Indicator (DEG / RAD) - Only show if in Scientific Mode
          if (calcState.isScientific)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => ref.read(calculatorProvider.notifier).toggleDegRad(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      calcState.isDegMode ? 'DEG' : 'RAD',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // No extra labels here since the Appbar contains the mode title
                const SizedBox.shrink(),
              ],
            )
          else
            const SizedBox.shrink(),
          
          SizedBox(height: calcState.isScientific ? (isLandscape ? 4 : 8) : 0),

          // Running Formula Display
          SizedBox(
            height: isLandscape ? 30 : 40,
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                calcState.formulaValue.isEmpty ? '' : calcState.formulaValue,
                maxLines: 1,
                minFontSize: 14,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          SizedBox(height: isLandscape ? 4 : 8),

          // Main Display (Input or Result)
          SizedBox(
            height: isLandscape ? 50 : 70,
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                calcState.displayValue,
                maxLines: 1,
                minFontSize: 20,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
