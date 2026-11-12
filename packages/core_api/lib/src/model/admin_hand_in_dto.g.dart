// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInDto extends AdminHandInDto {
  @override
  final String captainId;
  @override
  final BuiltList<AdminHandInDtoConversionsInner>? conversions;
  @override
  final BuiltList<AdminOpenDrawerSessionDtoFloatsInner> lines;

  factory _$AdminHandInDto([void Function(AdminHandInDtoBuilder)? updates]) =>
      (AdminHandInDtoBuilder()..update(updates))._build();

  _$AdminHandInDto._({
    required this.captainId,
    this.conversions,
    required this.lines,
  }) : super._();
  @override
  AdminHandInDto rebuild(void Function(AdminHandInDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminHandInDtoBuilder toBuilder() => AdminHandInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInDto &&
        captainId == other.captainId &&
        conversions == other.conversions &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, conversions.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHandInDto')
          ..add('captainId', captainId)
          ..add('conversions', conversions)
          ..add('lines', lines))
        .toString();
  }
}

class AdminHandInDtoBuilder
    implements Builder<AdminHandInDto, AdminHandInDtoBuilder> {
  _$AdminHandInDto? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  ListBuilder<AdminHandInDtoConversionsInner>? _conversions;
  ListBuilder<AdminHandInDtoConversionsInner> get conversions =>
      _$this._conversions ??= ListBuilder<AdminHandInDtoConversionsInner>();
  set conversions(ListBuilder<AdminHandInDtoConversionsInner>? conversions) =>
      _$this._conversions = conversions;

  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? _lines;
  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner> get lines =>
      _$this._lines ??= ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>();
  set lines(ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? lines) =>
      _$this._lines = lines;

  AdminHandInDtoBuilder() {
    AdminHandInDto._defaults(this);
  }

  AdminHandInDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _conversions = $v.conversions?.toBuilder();
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandInDto other) {
    _$v = other as _$AdminHandInDto;
  }

  @override
  void update(void Function(AdminHandInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInDto build() => _build();

  _$AdminHandInDto _build() {
    _$AdminHandInDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminHandInDto._(
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminHandInDto',
              'captainId',
            ),
            conversions: _conversions?.build(),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversions';
        _conversions?.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminHandInDto',
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
