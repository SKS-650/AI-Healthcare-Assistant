import 'package:flutter/material.dart';

import '../../../../constants/app_strings.dart';
import '../../../../routing/route_names.dart';
import '../controllers/symptom_controller.dart';
import '../widgets/severity_slider.dart';
import '../widgets/symptom_card.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';

class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key});

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  late final SymptomController _controller;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = SymptomController()..loadSymptoms();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runPrediction() async {
    final prediction = await _controller.predict();
    if (!mounted) return;

    if (prediction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select at least one symptom.'),
          backgroundColor: AppColors.surfaceVariant,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    await Navigator.of(context).pushNamed(
      RouteNames.prediction,
      arguments: prediction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final filteredSymptoms = _searchQuery.isEmpty
            ? _controller.symptoms
            : _controller.symptoms
                .where((s) =>
                    s.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    s.category
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                .toList();

        final selectedCount =
            _controller.selectedSymptomIds.length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── Premium SliverAppBar ──────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        size: 18, color: AppColors.textPrimary),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  // History button
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(RouteNames.history),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history_rounded,
                                size: 16,
                                color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text('History',
                                style: AppTextStyles.labelMedium
                                    .copyWith(
                                        color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.fromLTRB(
                        20, 100, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(AppStrings.symptomChecker,
                                style:
                                    AppTextStyles.headlineLarge),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                gradient:
                                    AppColors.gradientPrimary,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 11,
                                      color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text('AI',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight:
                                                  FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Body ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _controller.isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(
                            20, 4, 20, 120),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(AppStrings.splashSubtitle,
                                style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 20),

                            // Severity slider
                            SeveritySlider(
                              value: _controller.severity,
                              onChanged:
                                  _controller.updateSeverity,
                            ),
                            const SizedBox(height: 20),

                            // Search bar
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(
                                        AppSpacing.radiusLg),
                                border: Border.all(
                                    color: AppColors.border),
                              ),
                              child: TextField(
                                style: AppTextStyles.bodyMedium
                                    .copyWith(
                                        color:
                                            AppColors.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Search symptoms…',
                                  hintStyle:
                                      AppTextStyles.bodyMedium,
                                  prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color:
                                          AppColors.textTertiary,
                                      size: 20),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14),
                                ),
                                onChanged: (v) => setState(
                                    () => _searchQuery = v),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Section header + count
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select Symptoms',
                                    style: AppTextStyles
                                        .headlineSmall),
                                if (selectedCount > 0)
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 5),
                                    decoration: BoxDecoration(
                                      gradient: AppColors
                                          .gradientPrimary,
                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                    ),
                                    child: Text(
                                        '$selectedCount selected',
                                        style: AppTextStyles.caption
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.w700)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Symptom list
                            if (filteredSymptoms.isEmpty)
                              _EmptySearchState(
                                  query: _searchQuery)
                            else
                              ...List.generate(
                                  filteredSymptoms.length,
                                  (i) {
                                final s = filteredSymptoms[i];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10),
                                  child: SymptomCard(
                                    symptom: s,
                                    isSelected: _controller
                                        .selectedSymptomIds
                                        .contains(s.id),
                                    onTap: () => _controller
                                        .toggleSymptom(s),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
              ),
            ],
          ),

          // ── Floating CTA ───────────────────────────────────────────────
          floatingActionButton: selectedCount > 0
              ? _AnalyzeButton(
                  count: selectedCount,
                  onTap: _runPrediction,
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  const _AnalyzeButton(
      {required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.gradientPrimary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: AppColors.shadowPrimary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.analytics_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Analyze $count Symptom${count > 1 ? 's' : ''}',
                style: AppTextStyles.titleSmall
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.search_off_rounded,
                  size: 30, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 14),
            Text('No symptoms found for "$query"',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
