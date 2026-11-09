// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_cancel_choices_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner
    extends AdminOrderDtoOutputOrderCancelChoicesReasonsInner {
  @override
  final String code;
  @override
  final String label;

  factory _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner([
    void Function(AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCancelChoicesReasonsInner rebuild(
    void Function(AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCancelChoicesReasonsInner &&
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
            r'AdminOrderDtoOutputOrderCancelChoicesReasonsInner',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCancelChoicesReasonsInner,
          AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder() {
    AdminOrderDtoOutputOrderCancelChoicesReasonsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCancelChoicesReasonsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCancelChoicesReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCancelChoicesReasonsInner build() => _build();

  _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderCancelChoicesReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminOrderDtoOutputOrderCancelChoicesReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderCancelChoicesReasonsInner',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
