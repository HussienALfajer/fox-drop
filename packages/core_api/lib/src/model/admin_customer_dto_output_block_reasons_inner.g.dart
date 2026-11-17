// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_block_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputBlockReasonsInner
    extends AdminCustomerDtoOutputBlockReasonsInner {
  @override
  final String code;
  @override
  final String label;

  factory _$AdminCustomerDtoOutputBlockReasonsInner([
    void Function(AdminCustomerDtoOutputBlockReasonsInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputBlockReasonsInnerBuilder()..update(updates))
      ._build();

  _$AdminCustomerDtoOutputBlockReasonsInner._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminCustomerDtoOutputBlockReasonsInner rebuild(
    void Function(AdminCustomerDtoOutputBlockReasonsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputBlockReasonsInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputBlockReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputBlockReasonsInner &&
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
            r'AdminCustomerDtoOutputBlockReasonsInner',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminCustomerDtoOutputBlockReasonsInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputBlockReasonsInner,
          AdminCustomerDtoOutputBlockReasonsInnerBuilder
        > {
  _$AdminCustomerDtoOutputBlockReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminCustomerDtoOutputBlockReasonsInnerBuilder() {
    AdminCustomerDtoOutputBlockReasonsInner._defaults(this);
  }

  AdminCustomerDtoOutputBlockReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputBlockReasonsInner other) {
    _$v = other as _$AdminCustomerDtoOutputBlockReasonsInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputBlockReasonsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputBlockReasonsInner build() => _build();

  _$AdminCustomerDtoOutputBlockReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputBlockReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCustomerDtoOutputBlockReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminCustomerDtoOutputBlockReasonsInner',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
