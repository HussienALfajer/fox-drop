import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'profile.dart';

/// «أكمل بياناتك» (CU §5.3), after a new account's first sign-in; then the
/// customer returns to [from]. Unstyled until the design.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, required this.from});

  final String from;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  Gender? _gender;
  DateTime? _birthday;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(today.year - 110),
      lastDate: today.subtract(const Duration(days: 1)),
      initialDate: _birthday ?? DateTime(today.year - 20),
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  void _save() => ref
      .read(profileSaveProvider.notifier)
      .save(
        ProfileDraft(
          firstName: _firstName.text,
          lastName: _lastName.text,
          gender: _gender,
          birthday: _birthday,
          acceptTerms: _acceptTerms,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(profileSaveProvider, (previous, next) {
      if (next is ProfileSaved) context.go(widget.from);
    });
    final state = ref.watch(profileSaveProvider);
    final problems = state is ProfileEditing
        ? state.problems
        : const <ProfileProblem>{};
    final birthday = _birthday;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerProfileTitle)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          TextField(
            key: const Key('profile-first-name'),
            controller: _firstName,
            decoration: InputDecoration(
              labelText: l10n.customerProfileFirstName,
              errorText: problems.contains(ProfileProblem.firstName)
                  ? l10n.customerProfileInvalidName
                  : null,
            ),
          ),
          TextField(
            key: const Key('profile-last-name'),
            controller: _lastName,
            decoration: InputDecoration(
              labelText: l10n.customerProfileLastName,
              errorText: problems.contains(ProfileProblem.lastName)
                  ? l10n.customerProfileInvalidName
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.customerProfileGender),
          RadioGroup<Gender>(
            groupValue: _gender,
            onChanged: (value) => setState(() => _gender = value),
            child: Column(
              children: [
                RadioListTile(
                  value: Gender.male,
                  title: Text(l10n.customerProfileMale),
                ),
                RadioListTile(
                  value: Gender.female,
                  title: Text(l10n.customerProfileFemale),
                ),
              ],
            ),
          ),
          if (problems.contains(ProfileProblem.gender))
            Text(l10n.customerProfileGenderRequired),
          ListTile(
            title: Text(l10n.customerProfileBirthday),
            subtitle: birthday == null ? null : Text(l10n.formatDate(birthday)),
            onTap: _pickBirthday,
          ),
          CheckboxListTile(
            key: const Key('profile-terms'),
            value: _acceptTerms,
            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
            title: Text(l10n.customerProfileTerms),
            subtitle: problems.contains(ProfileProblem.terms)
                ? Text(l10n.customerProfileTermsRequired)
                : null,
          ),
          if (state is ProfileEditing && state.failed)
            Text(l10n.customerSaveFailed),
          FilledButton(
            onPressed: state is ProfileSaving ? null : _save,
            child: Text(l10n.customerSave),
          ),
        ],
      ),
    );
  }
}
