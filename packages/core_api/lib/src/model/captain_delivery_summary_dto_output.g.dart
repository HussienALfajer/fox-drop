// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_delivery_summary_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDeliverySummaryDtoOutput
    extends CaptainDeliverySummaryDtoOutput {
  @override
  final CaptainDeliverySummaryDtoOutputSummary summary;

  factory _$CaptainDeliverySummaryDtoOutput([
    void Function(CaptainDeliverySummaryDtoOutputBuilder)? updates,
  ]) => (CaptainDeliverySummaryDtoOutputBuilder()..update(updates))._build();

  _$CaptainDeliverySummaryDtoOutput._({required this.summary}) : super._();
  @override
  CaptainDeliverySummaryDtoOutput rebuild(
    void Function(CaptainDeliverySummaryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverySummaryDtoOutputBuilder toBuilder() =>
      CaptainDeliverySummaryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverySummaryDtoOutput && summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainDeliverySummaryDtoOutput',
    )..add('summary', summary)).toString();
  }
}

class CaptainDeliverySummaryDtoOutputBuilder
    implements
        Builder<
          CaptainDeliverySummaryDtoOutput,
          CaptainDeliverySummaryDtoOutputBuilder
        > {
  _$CaptainDeliverySummaryDtoOutput? _$v;

  CaptainDeliverySummaryDtoOutputSummaryBuilder? _summary;
  CaptainDeliverySummaryDtoOutputSummaryBuilder get summary =>
      _$this._summary ??= CaptainDeliverySummaryDtoOutputSummaryBuilder();
  set summary(CaptainDeliverySummaryDtoOutputSummaryBuilder? summary) =>
      _$this._summary = summary;

  CaptainDeliverySummaryDtoOutputBuilder() {
    CaptainDeliverySummaryDtoOutput._defaults(this);
  }

  CaptainDeliverySummaryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _summary = $v.summary.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverySummaryDtoOutput other) {
    _$v = other as _$CaptainDeliverySummaryDtoOutput;
  }

  @override
  void update(void Function(CaptainDeliverySummaryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverySummaryDtoOutput build() => _build();

  _$CaptainDeliverySummaryDtoOutput _build() {
    _$CaptainDeliverySummaryDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainDeliverySummaryDtoOutput._(summary: summary.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        summary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDeliverySummaryDtoOutput',
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
