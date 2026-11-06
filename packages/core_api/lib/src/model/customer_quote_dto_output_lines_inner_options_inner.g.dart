// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_lines_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputLinesInnerOptionsInner
    extends CustomerQuoteDtoOutputLinesInnerOptionsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String priceDelta;

  factory _$CustomerQuoteDtoOutputLinesInnerOptionsInner([
    void Function(CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder()..update(updates))
      ._build();

  _$CustomerQuoteDtoOutputLinesInnerOptionsInner._({
    required this.id,
    required this.name,
    required this.priceDelta,
  }) : super._();
  @override
  CustomerQuoteDtoOutputLinesInnerOptionsInner rebuild(
    void Function(CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder toBuilder() =>
      CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputLinesInnerOptionsInner &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerQuoteDtoOutputLinesInnerOptionsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta))
        .toString();
  }
}

class CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputLinesInnerOptionsInner,
          CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder
        > {
  _$CustomerQuoteDtoOutputLinesInnerOptionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _priceDelta;
  String? get priceDelta => _$this._priceDelta;
  set priceDelta(String? priceDelta) => _$this._priceDelta = priceDelta;

  CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder() {
    CustomerQuoteDtoOutputLinesInnerOptionsInner._defaults(this);
  }

  CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputLinesInnerOptionsInner other) {
    _$v = other as _$CustomerQuoteDtoOutputLinesInnerOptionsInner;
  }

  @override
  void update(
    void Function(CustomerQuoteDtoOutputLinesInnerOptionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputLinesInnerOptionsInner build() => _build();

  _$CustomerQuoteDtoOutputLinesInnerOptionsInner _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputLinesInnerOptionsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CustomerQuoteDtoOutputLinesInnerOptionsInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CustomerQuoteDtoOutputLinesInnerOptionsInner',
            'name',
          ),
          priceDelta: BuiltValueNullFieldError.checkNotNull(
            priceDelta,
            r'CustomerQuoteDtoOutputLinesInnerOptionsInner',
            'priceDelta',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
