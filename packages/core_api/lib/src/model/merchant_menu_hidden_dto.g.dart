// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_hidden_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuHiddenDto extends MerchantMenuHiddenDto {
  @override
  final bool hidden;

  factory _$MerchantMenuHiddenDto([
    void Function(MerchantMenuHiddenDtoBuilder)? updates,
  ]) => (MerchantMenuHiddenDtoBuilder()..update(updates))._build();

  _$MerchantMenuHiddenDto._({required this.hidden}) : super._();
  @override
  MerchantMenuHiddenDto rebuild(
    void Function(MerchantMenuHiddenDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuHiddenDtoBuilder toBuilder() =>
      MerchantMenuHiddenDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuHiddenDto && hidden == other.hidden;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantMenuHiddenDto',
    )..add('hidden', hidden)).toString();
  }
}

class MerchantMenuHiddenDtoBuilder
    implements Builder<MerchantMenuHiddenDto, MerchantMenuHiddenDtoBuilder> {
  _$MerchantMenuHiddenDto? _$v;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  MerchantMenuHiddenDtoBuilder() {
    MerchantMenuHiddenDto._defaults(this);
  }

  MerchantMenuHiddenDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hidden = $v.hidden;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuHiddenDto other) {
    _$v = other as _$MerchantMenuHiddenDto;
  }

  @override
  void update(void Function(MerchantMenuHiddenDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuHiddenDto build() => _build();

  _$MerchantMenuHiddenDto _build() {
    final _$result =
        _$v ??
        _$MerchantMenuHiddenDto._(
          hidden: BuiltValueNullFieldError.checkNotNull(
            hidden,
            r'MerchantMenuHiddenDto',
            'hidden',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
