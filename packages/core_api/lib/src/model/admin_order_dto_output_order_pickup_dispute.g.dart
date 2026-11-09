// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_pickup_dispute.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderPickupDispute
    extends AdminOrderDtoOutputOrderPickupDispute {
  @override
  final DateTime at;
  @override
  final String accountId;
  @override
  final String device;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> receivedLines;

  factory _$AdminOrderDtoOutputOrderPickupDispute([
    void Function(AdminOrderDtoOutputOrderPickupDisputeBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderPickupDisputeBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderPickupDispute._({
    required this.at,
    required this.accountId,
    required this.device,
    required this.receivedLines,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderPickupDispute rebuild(
    void Function(AdminOrderDtoOutputOrderPickupDisputeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderPickupDisputeBuilder toBuilder() =>
      AdminOrderDtoOutputOrderPickupDisputeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderPickupDispute &&
        at == other.at &&
        accountId == other.accountId &&
        device == other.device &&
        receivedLines == other.receivedLines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderPickupDispute',
          )
          ..add('at', at)
          ..add('accountId', accountId)
          ..add('device', device)
          ..add('receivedLines', receivedLines))
        .toString();
  }
}

class AdminOrderDtoOutputOrderPickupDisputeBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderPickupDispute,
          AdminOrderDtoOutputOrderPickupDisputeBuilder
        > {
  _$AdminOrderDtoOutputOrderPickupDispute? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _device;
  String? get device => _$this._device;
  set device(String? device) => _$this._device = device;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _receivedLines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get receivedLines =>
      _$this._receivedLines ??=
          ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set receivedLines(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? receivedLines,
  ) => _$this._receivedLines = receivedLines;

  AdminOrderDtoOutputOrderPickupDisputeBuilder() {
    AdminOrderDtoOutputOrderPickupDispute._defaults(this);
  }

  AdminOrderDtoOutputOrderPickupDisputeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _accountId = $v.accountId;
      _device = $v.device;
      _receivedLines = $v.receivedLines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderPickupDispute other) {
    _$v = other as _$AdminOrderDtoOutputOrderPickupDispute;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderPickupDisputeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderPickupDispute build() => _build();

  _$AdminOrderDtoOutputOrderPickupDispute _build() {
    _$AdminOrderDtoOutputOrderPickupDispute _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderPickupDispute._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'at',
            ),
            accountId: BuiltValueNullFieldError.checkNotNull(
              accountId,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'accountId',
            ),
            device: BuiltValueNullFieldError.checkNotNull(
              device,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'device',
            ),
            receivedLines: receivedLines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receivedLines';
        receivedLines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderPickupDispute',
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
