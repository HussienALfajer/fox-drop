// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderPickup extends AdminOrderDtoOutputOrderPickup {
  @override
  final DateTime? at;
  @override
  final bool readyNotPressed;
  @override
  final BuiltList<AdminOrderDtoOutputOrderPickupRequestsInner> requests;
  @override
  final AdminOrderDtoOutputOrderPickupDispute? dispute;

  factory _$AdminOrderDtoOutputOrderPickup([
    void Function(AdminOrderDtoOutputOrderPickupBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderPickupBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderPickup._({
    this.at,
    required this.readyNotPressed,
    required this.requests,
    this.dispute,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderPickup rebuild(
    void Function(AdminOrderDtoOutputOrderPickupBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderPickupBuilder toBuilder() =>
      AdminOrderDtoOutputOrderPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderPickup &&
        at == other.at &&
        readyNotPressed == other.readyNotPressed &&
        requests == other.requests &&
        dispute == other.dispute;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, readyNotPressed.hashCode);
    _$hash = $jc(_$hash, requests.hashCode);
    _$hash = $jc(_$hash, dispute.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderPickup')
          ..add('at', at)
          ..add('readyNotPressed', readyNotPressed)
          ..add('requests', requests)
          ..add('dispute', dispute))
        .toString();
  }
}

class AdminOrderDtoOutputOrderPickupBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderPickup,
          AdminOrderDtoOutputOrderPickupBuilder
        > {
  _$AdminOrderDtoOutputOrderPickup? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  bool? _readyNotPressed;
  bool? get readyNotPressed => _$this._readyNotPressed;
  set readyNotPressed(bool? readyNotPressed) =>
      _$this._readyNotPressed = readyNotPressed;

  ListBuilder<AdminOrderDtoOutputOrderPickupRequestsInner>? _requests;
  ListBuilder<AdminOrderDtoOutputOrderPickupRequestsInner> get requests =>
      _$this._requests ??=
          ListBuilder<AdminOrderDtoOutputOrderPickupRequestsInner>();
  set requests(
    ListBuilder<AdminOrderDtoOutputOrderPickupRequestsInner>? requests,
  ) => _$this._requests = requests;

  AdminOrderDtoOutputOrderPickupDisputeBuilder? _dispute;
  AdminOrderDtoOutputOrderPickupDisputeBuilder get dispute =>
      _$this._dispute ??= AdminOrderDtoOutputOrderPickupDisputeBuilder();
  set dispute(AdminOrderDtoOutputOrderPickupDisputeBuilder? dispute) =>
      _$this._dispute = dispute;

  AdminOrderDtoOutputOrderPickupBuilder() {
    AdminOrderDtoOutputOrderPickup._defaults(this);
  }

  AdminOrderDtoOutputOrderPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _readyNotPressed = $v.readyNotPressed;
      _requests = $v.requests.toBuilder();
      _dispute = $v.dispute?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderPickup other) {
    _$v = other as _$AdminOrderDtoOutputOrderPickup;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderPickupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderPickup build() => _build();

  _$AdminOrderDtoOutputOrderPickup _build() {
    _$AdminOrderDtoOutputOrderPickup _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderPickup._(
            at: at,
            readyNotPressed: BuiltValueNullFieldError.checkNotNull(
              readyNotPressed,
              r'AdminOrderDtoOutputOrderPickup',
              'readyNotPressed',
            ),
            requests: requests.build(),
            dispute: _dispute?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requests';
        requests.build();
        _$failedField = 'dispute';
        _dispute?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderPickup',
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
