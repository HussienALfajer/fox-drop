// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_lines_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner
    extends MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner {
  @override
  final String name;

  factory _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner([
    void Function(
      MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder,
    )?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner._({
    required this.name,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner rebuild(
    void Function(
      MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner',
    )..add('name', name)).toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner,
          MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner;
  }

  @override
  void update(
    void Function(
      MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
