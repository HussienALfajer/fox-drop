// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_item_text_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantItemTextRequestDto extends MerchantItemTextRequestDto {
  @override
  final String name;
  @override
  final String? description;

  factory _$MerchantItemTextRequestDto([
    void Function(MerchantItemTextRequestDtoBuilder)? updates,
  ]) => (MerchantItemTextRequestDtoBuilder()..update(updates))._build();

  _$MerchantItemTextRequestDto._({required this.name, this.description})
    : super._();
  @override
  MerchantItemTextRequestDto rebuild(
    void Function(MerchantItemTextRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantItemTextRequestDtoBuilder toBuilder() =>
      MerchantItemTextRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantItemTextRequestDto &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantItemTextRequestDto')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class MerchantItemTextRequestDtoBuilder
    implements
        Builder<MerchantItemTextRequestDto, MerchantItemTextRequestDtoBuilder> {
  _$MerchantItemTextRequestDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  MerchantItemTextRequestDtoBuilder() {
    MerchantItemTextRequestDto._defaults(this);
  }

  MerchantItemTextRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantItemTextRequestDto other) {
    _$v = other as _$MerchantItemTextRequestDto;
  }

  @override
  void update(void Function(MerchantItemTextRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantItemTextRequestDto build() => _build();

  _$MerchantItemTextRequestDto _build() {
    final _$result =
        _$v ??
        _$MerchantItemTextRequestDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantItemTextRequestDto',
            'name',
          ),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
