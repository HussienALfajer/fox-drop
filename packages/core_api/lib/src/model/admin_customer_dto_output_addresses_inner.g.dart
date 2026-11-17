// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_addresses_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputAddressesInner
    extends AdminCustomerDtoOutputAddressesInner {
  @override
  final String id;
  @override
  final String label;
  @override
  final String? customLabel;
  @override
  final String street;
  @override
  final String? floor;
  @override
  final String landmark;
  @override
  final String? neighbourhood;
  @override
  final AdminCustomerDtoOutputAddressesInnerLocation location;
  @override
  final bool isDefault;
  @override
  final String? recipientName;
  @override
  final String? maskedContactPhone;

  factory _$AdminCustomerDtoOutputAddressesInner([
    void Function(AdminCustomerDtoOutputAddressesInnerBuilder)? updates,
  ]) =>
      (AdminCustomerDtoOutputAddressesInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputAddressesInner._({
    required this.id,
    required this.label,
    this.customLabel,
    required this.street,
    this.floor,
    required this.landmark,
    this.neighbourhood,
    required this.location,
    required this.isDefault,
    this.recipientName,
    this.maskedContactPhone,
  }) : super._();
  @override
  AdminCustomerDtoOutputAddressesInner rebuild(
    void Function(AdminCustomerDtoOutputAddressesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputAddressesInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputAddressesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputAddressesInner &&
        id == other.id &&
        label == other.label &&
        customLabel == other.customLabel &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        neighbourhood == other.neighbourhood &&
        location == other.location &&
        isDefault == other.isDefault &&
        recipientName == other.recipientName &&
        maskedContactPhone == other.maskedContactPhone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customLabel.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, landmark.hashCode);
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, recipientName.hashCode);
    _$hash = $jc(_$hash, maskedContactPhone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputAddressesInner')
          ..add('id', id)
          ..add('label', label)
          ..add('customLabel', customLabel)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('neighbourhood', neighbourhood)
          ..add('location', location)
          ..add('isDefault', isDefault)
          ..add('recipientName', recipientName)
          ..add('maskedContactPhone', maskedContactPhone))
        .toString();
  }
}

class AdminCustomerDtoOutputAddressesInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputAddressesInner,
          AdminCustomerDtoOutputAddressesInnerBuilder
        > {
  _$AdminCustomerDtoOutputAddressesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customLabel;
  String? get customLabel => _$this._customLabel;
  set customLabel(String? customLabel) => _$this._customLabel = customLabel;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _floor;
  String? get floor => _$this._floor;
  set floor(String? floor) => _$this._floor = floor;

  String? _landmark;
  String? get landmark => _$this._landmark;
  set landmark(String? landmark) => _$this._landmark = landmark;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  AdminCustomerDtoOutputAddressesInnerLocationBuilder? _location;
  AdminCustomerDtoOutputAddressesInnerLocationBuilder get location =>
      _$this._location ??=
          AdminCustomerDtoOutputAddressesInnerLocationBuilder();
  set location(AdminCustomerDtoOutputAddressesInnerLocationBuilder? location) =>
      _$this._location = location;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  String? _recipientName;
  String? get recipientName => _$this._recipientName;
  set recipientName(String? recipientName) =>
      _$this._recipientName = recipientName;

  String? _maskedContactPhone;
  String? get maskedContactPhone => _$this._maskedContactPhone;
  set maskedContactPhone(String? maskedContactPhone) =>
      _$this._maskedContactPhone = maskedContactPhone;

  AdminCustomerDtoOutputAddressesInnerBuilder() {
    AdminCustomerDtoOutputAddressesInner._defaults(this);
  }

  AdminCustomerDtoOutputAddressesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _customLabel = $v.customLabel;
      _street = $v.street;
      _floor = $v.floor;
      _landmark = $v.landmark;
      _neighbourhood = $v.neighbourhood;
      _location = $v.location.toBuilder();
      _isDefault = $v.isDefault;
      _recipientName = $v.recipientName;
      _maskedContactPhone = $v.maskedContactPhone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputAddressesInner other) {
    _$v = other as _$AdminCustomerDtoOutputAddressesInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputAddressesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputAddressesInner build() => _build();

  _$AdminCustomerDtoOutputAddressesInner _build() {
    _$AdminCustomerDtoOutputAddressesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDtoOutputAddressesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCustomerDtoOutputAddressesInner',
              'id',
            ),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'AdminCustomerDtoOutputAddressesInner',
              'label',
            ),
            customLabel: customLabel,
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'AdminCustomerDtoOutputAddressesInner',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'AdminCustomerDtoOutputAddressesInner',
              'landmark',
            ),
            neighbourhood: neighbourhood,
            location: location.build(),
            isDefault: BuiltValueNullFieldError.checkNotNull(
              isDefault,
              r'AdminCustomerDtoOutputAddressesInner',
              'isDefault',
            ),
            recipientName: recipientName,
            maskedContactPhone: maskedContactPhone,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDtoOutputAddressesInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
