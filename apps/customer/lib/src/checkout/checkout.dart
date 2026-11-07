import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../cart/item_choice.dart';
import '../location/delivery_point.dart';
import '../location/position.dart';

typedef SavedAddress = CustomerAddressListDtoOutputAddressesInner;

/// A saved address this close to the browsing point is preselected (CU §10.3
/// item 1, fixed).
const nearbyAddressMetres = 200.0;

/// The note to the restaurant and the captain is up to 200 characters (CU
/// §10.3 item 2, fixed).
const maxOrderNote = 200;

/// The signed-in customer's saved addresses (CU §7.3); none for a guest.
final savedAddressesProvider = FutureProvider.autoDispose<List<SavedAddress>>((
  ref,
) async {
  final session = await ref.watch(customerAuth.session.future);
  if (session is! SignedIn) return const [];
  final response = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerProfileAddresses();
  return response.data!.addresses.toList();
});

/// The saved address to preselect for [point] (CU §10.3 item 1): the one it
/// came from, or else one inside a zone within [nearbyAddressMetres].
SavedAddress? preselectedAddress(PointChecked point, List<SavedAddress> saved) {
  for (final address in saved) {
    if (address.id == point.addressId) return address;
  }
  SavedAddress? nearest;
  var nearestMetres = double.infinity;
  for (final address in saved) {
    if (address.neighbourhood == null) continue;
    final metres = point.point.metresTo(
      GeoPoint(
        address.location.latitude.toDouble(),
        address.location.longitude.toDouble(),
      ),
    );
    if (metres <= nearbyAddressMetres && metres < nearestMetres) {
      nearest = address;
      nearestMetres = metres;
    }
  }
  return nearest;
}

enum AddressLabel { home, work, other }

/// The fields of an unsaved address (CU §7.3, §7.4) and the order's note,
/// kept while the app runs so a guest who signs in at «تأكيد الطلب» comes
/// back to what they typed.
class CheckoutForm {
  const CheckoutForm({
    this.street = '',
    this.floor = '',
    this.landmark = '',
    this.contactPhone = '',
    this.recipientName = '',
    this.directions = '',
    this.save = false,
    this.label = AddressLabel.home,
    this.customLabel = '',
    this.note = '',
  });

  final String street;
  final String floor;
  final String landmark;

  /// Empty is the account's own number (U5).
  final String contactPhone;
  final String recipientName;
  final String directions;

  /// «احفظ هذا العنوان», off by default (CU §7.4).
  final bool save;
  final AddressLabel label;
  final String customLabel;
  final String note;

  CheckoutForm copyWith({
    String? street,
    String? floor,
    String? landmark,
    String? contactPhone,
    String? recipientName,
    String? directions,
    bool? save,
    AddressLabel? label,
    String? customLabel,
    String? note,
  }) => CheckoutForm(
    street: street ?? this.street,
    floor: floor ?? this.floor,
    landmark: landmark ?? this.landmark,
    contactPhone: contactPhone ?? this.contactPhone,
    recipientName: recipientName ?? this.recipientName,
    directions: directions ?? this.directions,
    save: save ?? this.save,
    label: label ?? this.label,
    customLabel: customLabel ?? this.customLabel,
    note: note ?? this.note,
  );

  /// The contact number as E.164, null for the account's own; a Syrian or
  /// Turkish mobile (U5).
  String? get contactE164 {
    final value = contactPhone.trim();
    if (value.isEmpty) return null;
    return e164Phone(PhoneCountry.syria, value) ??
        e164Phone(PhoneCountry.turkey, value);
  }
}

/// A field of the unsaved address or the note that cannot be sent.
enum FormProblem {
  street,
  floor,
  landmark,
  contactPhone,
  recipientName,
  directions,
  customLabel,
  noteTooLong,
  notePhone,
}

String _t(String value) => value.trim();

bool _length(String value, int min, int max) {
  final length = _t(value).length;
  return length >= min && length <= max;
}

/// The checks of CU §7.3 and §10.3 item 2; the server checks them again.
/// [unsaved] is false when a saved address is chosen.
Set<FormProblem> formProblems(CheckoutForm form, {required bool unsaved}) => {
  if (unsaved) ...{
    if (!_length(form.street, 3, 100)) FormProblem.street,
    if (_t(form.floor).length > 100) FormProblem.floor,
    if (!_length(form.landmark, 3, 100)) FormProblem.landmark,
    if (_t(form.contactPhone).isNotEmpty && form.contactE164 == null)
      FormProblem.contactPhone,
    if (_t(form.contactPhone).isNotEmpty && !_length(form.recipientName, 2, 60))
      FormProblem.recipientName,
    if (_t(form.directions).length > 200) FormProblem.directions,
    if (form.save &&
        form.label == AddressLabel.other &&
        !_length(form.customLabel, 1, 30))
      FormProblem.customLabel,
  },
  if (_t(form.note).length > maxOrderNote) FormProblem.noteTooLong,
  if (hasPhoneNumber(form.note)) FormProblem.notePhone,
};

class CheckoutFormController extends Notifier<CheckoutForm> {
  @override
  CheckoutForm build() => const CheckoutForm();

  void update(CheckoutForm Function(CheckoutForm form) change) =>
      state = change(state);

  /// A preset note chip (CU §10.3 item 2) adds its text to the note.
  void addPreset(String preset) {
    final note = _t(state.note);
    if (note.contains(preset)) return;
    state = state.copyWith(note: note.isEmpty ? preset : '$note، $preset');
  }

  void reset() => state = const CheckoutForm();
}

final checkoutFormProvider =
    NotifierProvider<CheckoutFormController, CheckoutForm>(
      CheckoutFormController.new,
    );
