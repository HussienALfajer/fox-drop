// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_no_answer_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderNoAnswerReport
    extends CaptainActiveOrderDtoOutputOrderNoAnswerReport {
  @override
  final DateTime at;
  @override
  final DateTime? waitedAt;
  @override
  final String? waitMessage;

  factory _$CaptainActiveOrderDtoOutputOrderNoAnswerReport([
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder()..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderNoAnswerReport._({
    required this.at,
    this.waitedAt,
    this.waitMessage,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerReport rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderNoAnswerReport &&
        at == other.at &&
        waitedAt == other.waitedAt &&
        waitMessage == other.waitMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, waitedAt.hashCode);
    _$hash = $jc(_$hash, waitMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderNoAnswerReport',
          )
          ..add('at', at)
          ..add('waitedAt', waitedAt)
          ..add('waitMessage', waitMessage))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderNoAnswerReport,
          CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderNoAnswerReport? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  DateTime? _waitedAt;
  DateTime? get waitedAt => _$this._waitedAt;
  set waitedAt(DateTime? waitedAt) => _$this._waitedAt = waitedAt;

  String? _waitMessage;
  String? get waitMessage => _$this._waitMessage;
  set waitMessage(String? waitMessage) => _$this._waitMessage = waitMessage;

  CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder() {
    CaptainActiveOrderDtoOutputOrderNoAnswerReport._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _waitedAt = $v.waitedAt;
      _waitMessage = $v.waitMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderNoAnswerReport other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderNoAnswerReport;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderNoAnswerReportBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerReport build() => _build();

  _$CaptainActiveOrderDtoOutputOrderNoAnswerReport _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderNoAnswerReport._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderNoAnswerReport',
            'at',
          ),
          waitedAt: waitedAt,
          waitMessage: waitMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
