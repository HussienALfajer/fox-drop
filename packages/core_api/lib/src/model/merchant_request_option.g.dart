// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_request_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRequestOption extends MerchantRequestOption {
  @override
  final String id;
  @override
  final String name;
  @override
  final MerchantRequestOptionPriceDelta priceDelta;

  factory _$MerchantRequestOption([
    void Function(MerchantRequestOptionBuilder)? updates,
  ]) => (MerchantRequestOptionBuilder()..update(updates))._build();

  _$MerchantRequestOption._({
    required this.id,
    required this.name,
    required this.priceDelta,
  }) : super._();
  @override
  MerchantRequestOption rebuild(
    void Function(MerchantRequestOptionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRequestOptionBuilder toBuilder() =>
      MerchantRequestOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRequestOption &&
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
    return (newBuiltValueToStringHelper(r'MerchantRequestOption')
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta))
        .toString();
  }
}

class MerchantRequestOptionBuilder
    implements Builder<MerchantRequestOption, MerchantRequestOptionBuilder> {
  _$MerchantRequestOption? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantRequestOptionPriceDeltaBuilder? _priceDelta;
  MerchantRequestOptionPriceDeltaBuilder get priceDelta =>
      _$this._priceDelta ??= MerchantRequestOptionPriceDeltaBuilder();
  set priceDelta(MerchantRequestOptionPriceDeltaBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  MerchantRequestOptionBuilder() {
    MerchantRequestOption._defaults(this);
  }

  MerchantRequestOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRequestOption other) {
    _$v = other as _$MerchantRequestOption;
  }

  @override
  void update(void Function(MerchantRequestOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRequestOption build() => _build();

  _$MerchantRequestOption _build() {
    _$MerchantRequestOption _$result;
    try {
      _$result =
          _$v ??
          _$MerchantRequestOption._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantRequestOption',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantRequestOption',
              'name',
            ),
            priceDelta: priceDelta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantRequestOption',
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
