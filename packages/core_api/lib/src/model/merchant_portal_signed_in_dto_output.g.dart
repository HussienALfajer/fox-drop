// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_signed_in_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPortalSignedInDtoOutput
    extends MerchantPortalSignedInDtoOutput {
  @override
  final String accountId;
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final DateTime expiresAt;

  factory _$MerchantPortalSignedInDtoOutput([
    void Function(MerchantPortalSignedInDtoOutputBuilder)? updates,
  ]) => (MerchantPortalSignedInDtoOutputBuilder()..update(updates))._build();

  _$MerchantPortalSignedInDtoOutput._({
    required this.accountId,
    required this.restaurantId,
    required this.name,
    required this.expiresAt,
  }) : super._();
  @override
  MerchantPortalSignedInDtoOutput rebuild(
    void Function(MerchantPortalSignedInDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalSignedInDtoOutputBuilder toBuilder() =>
      MerchantPortalSignedInDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalSignedInDtoOutput &&
        accountId == other.accountId &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPortalSignedInDtoOutput')
          ..add('accountId', accountId)
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MerchantPortalSignedInDtoOutputBuilder
    implements
        Builder<
          MerchantPortalSignedInDtoOutput,
          MerchantPortalSignedInDtoOutputBuilder
        > {
  _$MerchantPortalSignedInDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MerchantPortalSignedInDtoOutputBuilder() {
    MerchantPortalSignedInDtoOutput._defaults(this);
  }

  MerchantPortalSignedInDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalSignedInDtoOutput other) {
    _$v = other as _$MerchantPortalSignedInDtoOutput;
  }

  @override
  void update(void Function(MerchantPortalSignedInDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalSignedInDtoOutput build() => _build();

  _$MerchantPortalSignedInDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantPortalSignedInDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'MerchantPortalSignedInDtoOutput',
            'accountId',
          ),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'MerchantPortalSignedInDtoOutput',
            'restaurantId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantPortalSignedInDtoOutput',
            'name',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MerchantPortalSignedInDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
