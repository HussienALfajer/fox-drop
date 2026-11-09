// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_delivery_shortfall.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderDeliveryShortfall
    extends AdminOrderDtoOutputOrderDeliveryShortfall {
  @override
  final CaptainWentOfflineDtoOutputHandIn? amount;
  @override
  final String reason;
  @override
  final String label;
  @override
  final String? note;

  factory _$AdminOrderDtoOutputOrderDeliveryShortfall([
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderDeliveryShortfallBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderDeliveryShortfall._({
    this.amount,
    required this.reason,
    required this.label,
    this.note,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderDeliveryShortfall rebuild(
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallBuilder toBuilder() =>
      AdminOrderDtoOutputOrderDeliveryShortfallBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderDeliveryShortfall &&
        amount == other.amount &&
        reason == other.reason &&
        label == other.label &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderDeliveryShortfall',
          )
          ..add('amount', amount)
          ..add('reason', reason)
          ..add('label', label)
          ..add('note', note))
        .toString();
  }
}

class AdminOrderDtoOutputOrderDeliveryShortfallBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderDeliveryShortfall,
          AdminOrderDtoOutputOrderDeliveryShortfallBuilder
        > {
  _$AdminOrderDtoOutputOrderDeliveryShortfall? _$v;

  CaptainWentOfflineDtoOutputHandInBuilder? _amount;
  CaptainWentOfflineDtoOutputHandInBuilder get amount =>
      _$this._amount ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set amount(CaptainWentOfflineDtoOutputHandInBuilder? amount) =>
      _$this._amount = amount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminOrderDtoOutputOrderDeliveryShortfallBuilder() {
    AdminOrderDtoOutputOrderDeliveryShortfall._defaults(this);
  }

  AdminOrderDtoOutputOrderDeliveryShortfallBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount?.toBuilder();
      _reason = $v.reason;
      _label = $v.label;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderDeliveryShortfall other) {
    _$v = other as _$AdminOrderDtoOutputOrderDeliveryShortfall;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderDeliveryShortfall build() => _build();

  _$AdminOrderDtoOutputOrderDeliveryShortfall _build() {
    _$AdminOrderDtoOutputOrderDeliveryShortfall _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderDeliveryShortfall._(
            amount: _amount?.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminOrderDtoOutputOrderDeliveryShortfall',
              'reason',
            ),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'AdminOrderDtoOutputOrderDeliveryShortfall',
              'label',
            ),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        _amount?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderDeliveryShortfall',
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
