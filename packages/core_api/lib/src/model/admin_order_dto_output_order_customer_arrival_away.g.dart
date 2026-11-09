// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_customer_arrival_away.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCustomerArrivalAway
    extends AdminOrderDtoOutputOrderCustomerArrivalAway {
  @override
  final String reason;
  @override
  final String label;
  @override
  final String? note;

  factory _$AdminOrderDtoOutputOrderCustomerArrivalAway([
    void Function(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCustomerArrivalAway._({
    required this.reason,
    required this.label,
    this.note,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCustomerArrivalAway rebuild(
    void Function(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCustomerArrivalAway &&
        reason == other.reason &&
        label == other.label &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderCustomerArrivalAway',
          )
          ..add('reason', reason)
          ..add('label', label)
          ..add('note', note))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCustomerArrivalAway,
          AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder
        > {
  _$AdminOrderDtoOutputOrderCustomerArrivalAway? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder() {
    AdminOrderDtoOutputOrderCustomerArrivalAway._defaults(this);
  }

  AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _label = $v.label;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCustomerArrivalAway other) {
    _$v = other as _$AdminOrderDtoOutputOrderCustomerArrivalAway;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCustomerArrivalAway build() => _build();

  _$AdminOrderDtoOutputOrderCustomerArrivalAway _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderCustomerArrivalAway._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderDtoOutputOrderCustomerArrivalAway',
            'reason',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderCustomerArrivalAway',
            'label',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
