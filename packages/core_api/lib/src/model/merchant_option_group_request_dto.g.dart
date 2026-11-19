// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_option_group_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOptionGroupRequestDto extends MerchantOptionGroupRequestDto {
  @override
  final String name;
  @override
  final int minChoices;
  @override
  final int maxChoices;
  @override
  final BuiltList<String> itemIds;
  @override
  final BuiltList<MerchantRequestOption> options;

  factory _$MerchantOptionGroupRequestDto([
    void Function(MerchantOptionGroupRequestDtoBuilder)? updates,
  ]) => (MerchantOptionGroupRequestDtoBuilder()..update(updates))._build();

  _$MerchantOptionGroupRequestDto._({
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.itemIds,
    required this.options,
  }) : super._();
  @override
  MerchantOptionGroupRequestDto rebuild(
    void Function(MerchantOptionGroupRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOptionGroupRequestDtoBuilder toBuilder() =>
      MerchantOptionGroupRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOptionGroupRequestDto &&
        name == other.name &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices &&
        itemIds == other.itemIds &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOptionGroupRequestDto')
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('itemIds', itemIds)
          ..add('options', options))
        .toString();
  }
}

class MerchantOptionGroupRequestDtoBuilder
    implements
        Builder<
          MerchantOptionGroupRequestDto,
          MerchantOptionGroupRequestDtoBuilder
        > {
  _$MerchantOptionGroupRequestDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _minChoices;
  int? get minChoices => _$this._minChoices;
  set minChoices(int? minChoices) => _$this._minChoices = minChoices;

  int? _maxChoices;
  int? get maxChoices => _$this._maxChoices;
  set maxChoices(int? maxChoices) => _$this._maxChoices = maxChoices;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  ListBuilder<MerchantRequestOption>? _options;
  ListBuilder<MerchantRequestOption> get options =>
      _$this._options ??= ListBuilder<MerchantRequestOption>();
  set options(ListBuilder<MerchantRequestOption>? options) =>
      _$this._options = options;

  MerchantOptionGroupRequestDtoBuilder() {
    MerchantOptionGroupRequestDto._defaults(this);
  }

  MerchantOptionGroupRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _itemIds = $v.itemIds.toBuilder();
      _options = $v.options.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOptionGroupRequestDto other) {
    _$v = other as _$MerchantOptionGroupRequestDto;
  }

  @override
  void update(void Function(MerchantOptionGroupRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOptionGroupRequestDto build() => _build();

  _$MerchantOptionGroupRequestDto _build() {
    _$MerchantOptionGroupRequestDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOptionGroupRequestDto._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantOptionGroupRequestDto',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'MerchantOptionGroupRequestDto',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'MerchantOptionGroupRequestDto',
              'maxChoices',
            ),
            itemIds: itemIds.build(),
            options: options.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOptionGroupRequestDto',
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
