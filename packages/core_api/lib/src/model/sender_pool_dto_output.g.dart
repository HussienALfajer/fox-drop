// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SenderPoolDtoOutput extends SenderPoolDtoOutput {
  @override
  final BuiltList<SenderPoolDtoOutputNumbersInner> numbers;
  @override
  final BuiltList<SenderPoolDtoOutputAlertsInner> alerts;

  factory _$SenderPoolDtoOutput([
    void Function(SenderPoolDtoOutputBuilder)? updates,
  ]) => (SenderPoolDtoOutputBuilder()..update(updates))._build();

  _$SenderPoolDtoOutput._({required this.numbers, required this.alerts})
    : super._();
  @override
  SenderPoolDtoOutput rebuild(
    void Function(SenderPoolDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputBuilder toBuilder() =>
      SenderPoolDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutput &&
        numbers == other.numbers &&
        alerts == other.alerts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numbers.hashCode);
    _$hash = $jc(_$hash, alerts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SenderPoolDtoOutput')
          ..add('numbers', numbers)
          ..add('alerts', alerts))
        .toString();
  }
}

class SenderPoolDtoOutputBuilder
    implements Builder<SenderPoolDtoOutput, SenderPoolDtoOutputBuilder> {
  _$SenderPoolDtoOutput? _$v;

  ListBuilder<SenderPoolDtoOutputNumbersInner>? _numbers;
  ListBuilder<SenderPoolDtoOutputNumbersInner> get numbers =>
      _$this._numbers ??= ListBuilder<SenderPoolDtoOutputNumbersInner>();
  set numbers(ListBuilder<SenderPoolDtoOutputNumbersInner>? numbers) =>
      _$this._numbers = numbers;

  ListBuilder<SenderPoolDtoOutputAlertsInner>? _alerts;
  ListBuilder<SenderPoolDtoOutputAlertsInner> get alerts =>
      _$this._alerts ??= ListBuilder<SenderPoolDtoOutputAlertsInner>();
  set alerts(ListBuilder<SenderPoolDtoOutputAlertsInner>? alerts) =>
      _$this._alerts = alerts;

  SenderPoolDtoOutputBuilder() {
    SenderPoolDtoOutput._defaults(this);
  }

  SenderPoolDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numbers = $v.numbers.toBuilder();
      _alerts = $v.alerts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutput other) {
    _$v = other as _$SenderPoolDtoOutput;
  }

  @override
  void update(void Function(SenderPoolDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutput build() => _build();

  _$SenderPoolDtoOutput _build() {
    _$SenderPoolDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$SenderPoolDtoOutput._(
            numbers: numbers.build(),
            alerts: alerts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'numbers';
        numbers.build();
        _$failedField = 'alerts';
        alerts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SenderPoolDtoOutput',
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
