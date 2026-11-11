// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_last_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainLastOrderDto extends CaptainLastOrderDto {
  @override
  final bool on_;

  factory _$CaptainLastOrderDto([
    void Function(CaptainLastOrderDtoBuilder)? updates,
  ]) => (CaptainLastOrderDtoBuilder()..update(updates))._build();

  _$CaptainLastOrderDto._({required this.on_}) : super._();
  @override
  CaptainLastOrderDto rebuild(
    void Function(CaptainLastOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainLastOrderDtoBuilder toBuilder() =>
      CaptainLastOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainLastOrderDto && on_ == other.on_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, on_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainLastOrderDto',
    )..add('on_', on_)).toString();
  }
}

class CaptainLastOrderDtoBuilder
    implements Builder<CaptainLastOrderDto, CaptainLastOrderDtoBuilder> {
  _$CaptainLastOrderDto? _$v;

  bool? _on_;
  bool? get on_ => _$this._on_;
  set on_(bool? on_) => _$this._on_ = on_;

  CaptainLastOrderDtoBuilder() {
    CaptainLastOrderDto._defaults(this);
  }

  CaptainLastOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _on_ = $v.on_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainLastOrderDto other) {
    _$v = other as _$CaptainLastOrderDto;
  }

  @override
  void update(void Function(CaptainLastOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainLastOrderDto build() => _build();

  _$CaptainLastOrderDto _build() {
    final _$result =
        _$v ??
        _$CaptainLastOrderDto._(
          on_: BuiltValueNullFieldError.checkNotNull(
            on_,
            r'CaptainLastOrderDto',
            'on_',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
