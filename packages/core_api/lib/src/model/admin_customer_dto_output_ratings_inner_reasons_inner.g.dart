// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_ratings_inner_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputRatingsInnerReasonsInner
    extends AdminCustomerDtoOutputRatingsInnerReasonsInner {
  @override
  final String code;
  @override
  final String label;

  factory _$AdminCustomerDtoOutputRatingsInnerReasonsInner([
    void Function(AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder()..update(updates))
          ._build();

  _$AdminCustomerDtoOutputRatingsInnerReasonsInner._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminCustomerDtoOutputRatingsInnerReasonsInner rebuild(
    void Function(AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputRatingsInnerReasonsInner &&
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
            r'AdminCustomerDtoOutputRatingsInnerReasonsInner',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputRatingsInnerReasonsInner,
          AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder
        > {
  _$AdminCustomerDtoOutputRatingsInnerReasonsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder() {
    AdminCustomerDtoOutputRatingsInnerReasonsInner._defaults(this);
  }

  AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputRatingsInnerReasonsInner other) {
    _$v = other as _$AdminCustomerDtoOutputRatingsInnerReasonsInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputRatingsInnerReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputRatingsInnerReasonsInner build() => _build();

  _$AdminCustomerDtoOutputRatingsInnerReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputRatingsInnerReasonsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCustomerDtoOutputRatingsInnerReasonsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminCustomerDtoOutputRatingsInnerReasonsInner',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
