import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';

/// The signed-in customer's details (CU §5.3); null for a guest. The server
/// answers `completed: false` until the first save, so an app that stopped
/// before «أكمل بياناتك» shows it again.
final profileProvider = FutureProvider<CustomerProfileDtoOutput?>((ref) async {
  final session = await ref.watch(customerAuth.session.future);
  if (session is! SignedIn) return null;
  final response = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerProfileProfile();
  return response.data;
});

// Arabic letters with their marks, and Latin letters (CU §5.3).
final _nameCharacters = RegExp(r'^[A-Za-zء-غف-يً-ٰٟٱ-ۓ \-]+$');
final _letter = RegExp(r'[A-Za-zء-غف-يٱ-ۓ]');

/// A first or last name of CU §5.3: 2 to 30 Arabic or Latin letters, with
/// spaces and «-», two letters at least. The server checks it again.
bool validName(String name) {
  final value = name.trim();
  return value.length >= 2 &&
      value.length <= 30 &&
      _nameCharacters.hasMatch(value) &&
      _letter.allMatches(value).length >= 2;
}

enum Gender { male, female }

/// What «أكمل بياناتك» sends.
class ProfileDraft {
  const ProfileDraft({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthday,
    required this.acceptTerms,
  });

  final String firstName;
  final String lastName;
  final Gender? gender;
  final DateTime? birthday;
  final bool acceptTerms;
}

/// Why a draft cannot be sent yet.
enum ProfileProblem { firstName, lastName, gender, terms }

Set<ProfileProblem> profileProblems(ProfileDraft draft) => {
  if (!validName(draft.firstName)) ProfileProblem.firstName,
  if (draft.lastName.trim().isNotEmpty && !validName(draft.lastName))
    ProfileProblem.lastName,
  if (draft.gender == null) ProfileProblem.gender,
  if (!draft.acceptTerms) ProfileProblem.terms,
};

sealed class ProfileSaveState {
  const ProfileSaveState();
}

class ProfileEditing extends ProfileSaveState {
  const ProfileEditing({this.problems = const {}, this.failed = false});

  final Set<ProfileProblem> problems;

  /// The server refused or could not be reached.
  final bool failed;
}

class ProfileSaving extends ProfileSaveState {
  const ProfileSaving();
}

class ProfileSaved extends ProfileSaveState {
  const ProfileSaved();
}

/// Saves «أكمل بياناتك» (`PUT /v1/customer/profile`).
class ProfileSaveController extends Notifier<ProfileSaveState> {
  @override
  ProfileSaveState build() => const ProfileEditing();

  Future<void> save(ProfileDraft draft) async {
    if (state is ProfileSaving) return;
    final problems = profileProblems(draft);
    if (problems.isNotEmpty) {
      state = ProfileEditing(problems: problems);
      return;
    }
    state = const ProfileSaving();
    final lastName = draft.lastName.trim();
    final birthday = draft.birthday;
    try {
      await ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerProfileSaveProfile(
            customerSaveProfileDto: CustomerSaveProfileDto(
              (b) => b
                ..firstName = draft.firstName.trim()
                ..lastName = lastName.isEmpty ? null : lastName
                ..gender = draft.gender == Gender.male
                    ? CustomerSaveProfileDtoGenderEnum.male
                    : CustomerSaveProfileDtoGenderEnum.female
                ..birthday = birthday == null
                    ? null
                    : Date(birthday.year, birthday.month, birthday.day)
                ..acceptTerms = true,
            ),
          );
      ref.invalidate(profileProvider);
      await ref.read(profileProvider.future);
      state = const ProfileSaved();
    } on Object {
      state = const ProfileEditing(failed: true);
    }
  }
}

final profileSaveProvider =
    NotifierProvider.autoDispose<ProfileSaveController, ProfileSaveState>(
      ProfileSaveController.new,
    );
