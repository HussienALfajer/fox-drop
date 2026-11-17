// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_problem_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderProblemBodyDto extends MerchantOrderProblemBodyDto {
  @override
  final String reasonCode;
  @override
  final String? note;

  factory _$MerchantOrderProblemBodyDto([
    void Function(MerchantOrderProblemBodyDtoBuilder)? updates,
  ]) => (MerchantOrderProblemBodyDtoBuilder()..update(updates))._build();

  _$MerchantOrderProblemBodyDto._({required this.reasonCode, this.note})
    : super._();
  @override
  MerchantOrderProblemBodyDto rebuild(
    void Function(MerchantOrderProblemBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderProblemBodyDtoBuilder toBuilder() =>
      MerchantOrderProblemBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderProblemBodyDto &&
        reasonCode == other.reasonCode &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrderProblemBodyDto')
          ..add('reasonCode', reasonCode)
          ..add('note', note))
        .toString();
  }
}

class MerchantOrderProblemBodyDtoBuilder
    implements
        Builder<
          MerchantOrderProblemBodyDto,
          MerchantOrderProblemBodyDtoBuilder
        > {
  _$MerchantOrderProblemBodyDto? _$v;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  MerchantOrderProblemBodyDtoBuilder() {
    MerchantOrderProblemBodyDto._defaults(this);
  }

  MerchantOrderProblemBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasonCode = $v.reasonCode;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderProblemBodyDto other) {
    _$v = other as _$MerchantOrderProblemBodyDto;
  }

  @override
  void update(void Function(MerchantOrderProblemBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderProblemBodyDto build() => _build();

  _$MerchantOrderProblemBodyDto _build() {
    final _$result =
        _$v ??
        _$MerchantOrderProblemBodyDto._(
          reasonCode: BuiltValueNullFieldError.checkNotNull(
            reasonCode,
            r'MerchantOrderProblemBodyDto',
            'reasonCode',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
