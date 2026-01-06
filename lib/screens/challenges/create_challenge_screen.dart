import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../blocs/challenge/challenge_state.dart';
import '../../models/challenge.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class CreateChallengeScreen extends StatefulWidget {
  final String restaurantId;

  const CreateChallengeScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetCountController = TextEditingController();
  final _rewardBadgeController = TextEditingController();

  ChallengeType _selectedType = ChallengeType.general;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetCountController.dispose();
    _rewardBadgeController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.add(const Duration(days: 7)),
      firstDate: initialDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  void _submitChallenge() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectStartEndDates ?? 'Please select start and end dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ChallengeBloc>().add(
          CreateChallenge(
            restaurantId: widget.restaurantId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            type: _selectedType,
            targetCount: int.parse(_targetCountController.text.trim()),
            startDate: _startDate!,
            endDate: _endDate!,
            rewardBadge: _rewardBadgeController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createChallenge ?? 'Create Challenge'),
        centerTitle: true,
      ),
      body: BlocListener<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
          if (state is ChallengeActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ChallengeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            final isLoading = state is ChallengeLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.createNewChallenge ?? 'Create a New Challenge',
                      style: AppTextStyles.heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.challengeDescription ??
                          'Challenge your customers to visit your restaurant',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.challengeTitle ?? 'Challenge Title *',
                        hintText:
                            l10n.enterChallengeTitle ?? 'e.g., "Try 5 Dishes"',
                        prefixIcon: const Icon(Icons.title),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.titleRequired ?? 'Title is required';
                        }
                        if (value.trim().length < 5) {
                          return l10n.titleTooShort ??
                              'Title must be at least 5 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description ?? 'Description *',
                        hintText: l10n.enterDescription ??
                            'Describe the challenge...',
                        prefixIcon: const Icon(Icons.description),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.descriptionRequired ??
                              'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Challenge Type
                    DropdownButtonFormField<ChallengeType>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.challengeType ?? 'Challenge Type',
                        prefixIcon: const Icon(Icons.category),
                        border: const OutlineInputBorder(),
                      ),
                      items: ChallengeType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getChallengeTypeLabel(context, type)),
                        );
                      }).toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() => _selectedType = value);
                              }
                            },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Target Count
                    TextFormField(
                      controller: _targetCountController,
                      decoration: InputDecoration(
                        labelText: l10n.targetCount ?? 'Target Count *',
                        hintText: l10n.enterTargetCount ??
                            'e.g., 5 (number of posts required)',
                        prefixIcon: const Icon(Icons.confirmation_number),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.targetCountRequired ??
                              'Target count is required';
                        }
                        final count = int.tryParse(value.trim());
                        if (count == null || count < 1) {
                          return l10n.invalidTargetCount ??
                              'Must be at least 1';
                        }
                        if (count > 100) {
                          return l10n.targetCountTooHigh ??
                              'Must be 100 or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Reward Badge
                    TextFormField(
                      controller: _rewardBadgeController,
                      decoration: InputDecoration(
                        labelText: l10n.rewardBadge ?? 'Reward Badge *',
                        hintText: l10n.enterRewardBadge ??
                            'e.g., "Food Explorer 🍕"',
                        prefixIcon: const Icon(Icons.emoji_events_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.rewardBadgeRequired ??
                              'Reward badge is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isLoading ? null : _selectStartDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _startDate == null
                                  ? (l10n.startDate ?? 'Start Date')
                                  : '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}',
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isLoading ? null : _selectEndDate,
                            icon: const Icon(Icons.event),
                            label: Text(
                              _endDate == null
                                  ? (l10n.endDate ?? 'End Date')
                                  : '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}',
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              l10n.challengeInfo ??
                                  'Users will earn progress by posting about your restaurant',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitChallenge,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              l10n.createChallenge ?? 'Create Challenge',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getChallengeTypeLabel(BuildContext context, ChallengeType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case ChallengeType.general:
        return l10n.challengeTypeGeneral ?? 'General';
      case ChallengeType.restaurant:
        return l10n.challengeTypeRestaurant ?? 'Restaurant-Specific';
      case ChallengeType.dish:
        return l10n.challengeTypeDish ?? 'Dish-Specific';
      case ChallengeType.location:
        return l10n.challengeTypeLocation ?? 'Location-Based';
    }
  }
}
