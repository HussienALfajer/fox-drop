// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_reassign_choices_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner
    extends AdminOrderDtoOutputOrderReassignChoicesReasonsInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final bool captainFault;

  factory _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner([
    void Function(AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner._({
    required this.code,
    required this.label,
    required this.captainFault,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderReassignChoicesReasonsInner rebuild(
    void Function(AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderReassignChoicesReasonsInner &&
        code == other.code &&
        label == other.label &&
        captainFault == other.captainFault;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderReassignChoicesReasonsInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('captainFault', captainFault))
        .toString();
  }
}

class AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderReassignChoicesReasonsInner,
          AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder() {
    AdminOrderDtoOutputOrderReassignChoicesReasonsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _captainFault = $v.captainFault;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderReassignChoicesReasonsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderReassignChoicesReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderReassignChoicesReasonsInner build() => _build();

  _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderReassignChoicesReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminOrderDtoOutputOrderReassignChoicesReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderReassignChoicesReasonsInner',
            'label',
          ),
          captainFault: BuiltValueNullFieldError.checkNotNull(
            captainFault,
            r'AdminOrderDtoOutputOrderReassignChoicesReasonsInner',
            'captainFault',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
