// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_problem_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainProblemBodyDto extends CaptainProblemBodyDto {
  @override
  final String reasonCode;
  @override
  final String? note;
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner>? paidLines;

  factory _$CaptainProblemBodyDto([
    void Function(CaptainProblemBodyDtoBuilder)? updates,
  ]) => (CaptainProblemBodyDtoBuilder()..update(updates))._build();

  _$CaptainProblemBodyDto._({
    required this.reasonCode,
    this.note,
    this.paidLines,
  }) : super._();
  @override
  CaptainProblemBodyDto rebuild(
    void Function(CaptainProblemBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainProblemBodyDtoBuilder toBuilder() =>
      CaptainProblemBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainProblemBodyDto &&
        reasonCode == other.reasonCode &&
        note == other.note &&
        paidLines == other.paidLines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, paidLines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainProblemBodyDto')
          ..add('reasonCode', reasonCode)
          ..add('note', note)
          ..add('paidLines', paidLines))
        .toString();
  }
}

class CaptainProblemBodyDtoBuilder
    implements Builder<CaptainProblemBodyDto, CaptainProblemBodyDtoBuilder> {
  _$CaptainProblemBodyDto? _$v;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? _paidLines;
  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner> get paidLines =>
      _$this._paidLines ??=
          ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>();
  set paidLines(
    ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? paidLines,
  ) => _$this._paidLines = paidLines;

  CaptainProblemBodyDtoBuilder() {
    CaptainProblemBodyDto._defaults(this);
  }

  CaptainProblemBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasonCode = $v.reasonCode;
      _note = $v.note;
      _paidLines = $v.paidLines?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainProblemBodyDto other) {
    _$v = other as _$CaptainProblemBodyDto;
  }

  @override
  void update(void Function(CaptainProblemBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainProblemBodyDto build() => _build();

  _$CaptainProblemBodyDto _build() {
    _$CaptainProblemBodyDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainProblemBodyDto._(
            reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode,
              r'CaptainProblemBodyDto',
              'reasonCode',
            ),
            note: note,
            paidLines: _paidLines?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'paidLines';
        _paidLines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainProblemBodyDto',
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
