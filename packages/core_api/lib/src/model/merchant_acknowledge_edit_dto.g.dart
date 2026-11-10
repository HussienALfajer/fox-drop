// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_acknowledge_edit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAcknowledgeEditDto extends MerchantAcknowledgeEditDto {
  @override
  final DateTime through;

  factory _$MerchantAcknowledgeEditDto([
    void Function(MerchantAcknowledgeEditDtoBuilder)? updates,
  ]) => (MerchantAcknowledgeEditDtoBuilder()..update(updates))._build();

  _$MerchantAcknowledgeEditDto._({required this.through}) : super._();
  @override
  MerchantAcknowledgeEditDto rebuild(
    void Function(MerchantAcknowledgeEditDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAcknowledgeEditDtoBuilder toBuilder() =>
      MerchantAcknowledgeEditDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAcknowledgeEditDto && through == other.through;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, through.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantAcknowledgeEditDto',
    )..add('through', through)).toString();
  }
}

class MerchantAcknowledgeEditDtoBuilder
    implements
        Builder<MerchantAcknowledgeEditDto, MerchantAcknowledgeEditDtoBuilder> {
  _$MerchantAcknowledgeEditDto? _$v;

  DateTime? _through;
  DateTime? get through => _$this._through;
  set through(DateTime? through) => _$this._through = through;

  MerchantAcknowledgeEditDtoBuilder() {
    MerchantAcknowledgeEditDto._defaults(this);
  }

  MerchantAcknowledgeEditDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _through = $v.through;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAcknowledgeEditDto other) {
    _$v = other as _$MerchantAcknowledgeEditDto;
  }

  @override
  void update(void Function(MerchantAcknowledgeEditDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAcknowledgeEditDto build() => _build();

  _$MerchantAcknowledgeEditDto _build() {
    final _$result =
        _$v ??
        _$MerchantAcknowledgeEditDto._(
          through: BuiltValueNullFieldError.checkNotNull(
            through,
            r'MerchantAcknowledgeEditDto',
            'through',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
