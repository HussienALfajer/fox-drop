// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_on_behalf_rejection_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner
    extends AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner {
  @override
  final String code;
  @override
  final String label;

  factory _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner([
    void Function(AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner rebuild(
    void Function(AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner &&
        code == other.code &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner,
          AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder() {
    AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner build() => _build();

  _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderOnBehalfRejectionReasonsInner',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
