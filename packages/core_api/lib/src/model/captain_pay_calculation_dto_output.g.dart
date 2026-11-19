// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pay_calculation_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPayCalculationDtoOutput extends CaptainPayCalculationDtoOutput {
  @override
  final CaptainPayCalculationDtoOutputCurrent? current;
  @override
  final BuiltList<CaptainPayCalculationDtoOutputAnnouncedInner> announced;

  factory _$CaptainPayCalculationDtoOutput([
    void Function(CaptainPayCalculationDtoOutputBuilder)? updates,
  ]) => (CaptainPayCalculationDtoOutputBuilder()..update(updates))._build();

  _$CaptainPayCalculationDtoOutput._({this.current, required this.announced})
    : super._();
  @override
  CaptainPayCalculationDtoOutput rebuild(
    void Function(CaptainPayCalculationDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPayCalculationDtoOutputBuilder toBuilder() =>
      CaptainPayCalculationDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPayCalculationDtoOutput &&
        current == other.current &&
        announced == other.announced;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, announced.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPayCalculationDtoOutput')
          ..add('current', current)
          ..add('announced', announced))
        .toString();
  }
}

class CaptainPayCalculationDtoOutputBuilder
    implements
        Builder<
          CaptainPayCalculationDtoOutput,
          CaptainPayCalculationDtoOutputBuilder
        > {
  _$CaptainPayCalculationDtoOutput? _$v;

  CaptainPayCalculationDtoOutputCurrentBuilder? _current;
  CaptainPayCalculationDtoOutputCurrentBuilder get current =>
      _$this._current ??= CaptainPayCalculationDtoOutputCurrentBuilder();
  set current(CaptainPayCalculationDtoOutputCurrentBuilder? current) =>
      _$this._current = current;

  ListBuilder<CaptainPayCalculationDtoOutputAnnouncedInner>? _announced;
  ListBuilder<CaptainPayCalculationDtoOutputAnnouncedInner> get announced =>
      _$this._announced ??=
          ListBuilder<CaptainPayCalculationDtoOutputAnnouncedInner>();
  set announced(
    ListBuilder<CaptainPayCalculationDtoOutputAnnouncedInner>? announced,
  ) => _$this._announced = announced;

  CaptainPayCalculationDtoOutputBuilder() {
    CaptainPayCalculationDtoOutput._defaults(this);
  }

  CaptainPayCalculationDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _current = $v.current?.toBuilder();
      _announced = $v.announced.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPayCalculationDtoOutput other) {
    _$v = other as _$CaptainPayCalculationDtoOutput;
  }

  @override
  void update(void Function(CaptainPayCalculationDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPayCalculationDtoOutput build() => _build();

  _$CaptainPayCalculationDtoOutput _build() {
    _$CaptainPayCalculationDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPayCalculationDtoOutput._(
            current: _current?.build(),
            announced: announced.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        _current?.build();
        _$failedField = 'announced';
        announced.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPayCalculationDtoOutput',
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
