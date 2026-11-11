// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_no_answer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderNoAnswer
    extends CaptainActiveOrderDtoOutputOrderNoAnswer {
  @override
  final int pingsLeft;
  @override
  final DateTime? nextPingAt;
  @override
  final CaptainActiveOrderDtoOutputOrderNoAnswerAnswer? answer;
  @override
  final DateTime? reportableAt;
  @override
  final CaptainActiveOrderDtoOutputOrderNoAnswerReport? report;

  factory _$CaptainActiveOrderDtoOutputOrderNoAnswer([
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderNoAnswerBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderNoAnswer._({
    required this.pingsLeft,
    this.nextPingAt,
    this.answer,
    this.reportableAt,
    this.report,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderNoAnswer rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderNoAnswerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderNoAnswer &&
        pingsLeft == other.pingsLeft &&
        nextPingAt == other.nextPingAt &&
        answer == other.answer &&
        reportableAt == other.reportableAt &&
        report == other.report;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pingsLeft.hashCode);
    _$hash = $jc(_$hash, nextPingAt.hashCode);
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jc(_$hash, reportableAt.hashCode);
    _$hash = $jc(_$hash, report.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderNoAnswer',
          )
          ..add('pingsLeft', pingsLeft)
          ..add('nextPingAt', nextPingAt)
          ..add('answer', answer)
          ..add('reportableAt', reportableAt)
          ..add('report', report))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderNoAnswerBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderNoAnswer,
          CaptainActiveOrderDtoOutputOrderNoAnswerBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderNoAnswer? _$v;

  int? _pingsLeft;
  int? get pingsLeft => _$this._pingsLeft;
  set pingsLeft(int? pingsLeft) => _$this._pingsLeft = pingsLeft;

  DateTime? _nextPingAt;
  DateTime? get nextPingAt => _$this._nextPingAt;
  set nextPingAt(DateTime? nextPingAt) => _$this._nextPingAt = nextPingAt;

  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder? _answer;
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder get answer =>
      _$this._answer ??=
          CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder();
  set answer(CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder? answer) =>
      _$this._answer = answer;

  DateTime? _reportableAt;
  DateTime? get reportableAt => _$this._reportableAt;
  set reportableAt(DateTime? reportableAt) =>
      _$this._reportableAt = reportableAt;

  CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder? _report;
  CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder get report =>
      _$this._report ??=
          CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder();
  set report(CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder? report) =>
      _$this._report = report;

  CaptainActiveOrderDtoOutputOrderNoAnswerBuilder() {
    CaptainActiveOrderDtoOutputOrderNoAnswer._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderNoAnswerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pingsLeft = $v.pingsLeft;
      _nextPingAt = $v.nextPingAt;
      _answer = $v.answer?.toBuilder();
      _reportableAt = $v.reportableAt;
      _report = $v.report?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderNoAnswer other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderNoAnswer;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswer build() => _build();

  _$CaptainActiveOrderDtoOutputOrderNoAnswer _build() {
    _$CaptainActiveOrderDtoOutputOrderNoAnswer _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderNoAnswer._(
            pingsLeft: BuiltValueNullFieldError.checkNotNull(
              pingsLeft,
              r'CaptainActiveOrderDtoOutputOrderNoAnswer',
              'pingsLeft',
            ),
            nextPingAt: nextPingAt,
            answer: _answer?.build(),
            reportableAt: reportableAt,
            report: _report?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'answer';
        _answer?.build();

        _$failedField = 'report';
        _report?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderNoAnswer',
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
