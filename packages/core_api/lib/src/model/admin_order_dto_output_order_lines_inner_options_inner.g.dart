// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_lines_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderLinesInnerOptionsInner
    extends AdminOrderDtoOutputOrderLinesInnerOptionsInner {
  @override
  final String name;
  @override
  final String priceDelta;

  factory _$AdminOrderDtoOutputOrderLinesInnerOptionsInner([
    void Function(AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder()..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderLinesInnerOptionsInner._({
    required this.name,
    required this.priceDelta,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderLinesInnerOptionsInner rebuild(
    void Function(AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderLinesInnerOptionsInner &&
        name == other.name &&
        priceDelta == other.priceDelta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderLinesInnerOptionsInner',
          )
          ..add('name', name)
          ..add('priceDelta', priceDelta))
        .toString();
  }
}

class AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderLinesInnerOptionsInner,
          AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderLinesInnerOptionsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _priceDelta;
  String? get priceDelta => _$this._priceDelta;
  set priceDelta(String? priceDelta) => _$this._priceDelta = priceDelta;

  AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder() {
    AdminOrderDtoOutputOrderLinesInnerOptionsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _priceDelta = $v.priceDelta;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderLinesInnerOptionsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderLinesInnerOptionsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderLinesInnerOptionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderLinesInnerOptionsInner build() => _build();

  _$AdminOrderDtoOutputOrderLinesInnerOptionsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderLinesInnerOptionsInner._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminOrderDtoOutputOrderLinesInnerOptionsInner',
            'name',
          ),
          priceDelta: BuiltValueNullFieldError.checkNotNull(
            priceDelta,
            r'AdminOrderDtoOutputOrderLinesInnerOptionsInner',
            'priceDelta',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
