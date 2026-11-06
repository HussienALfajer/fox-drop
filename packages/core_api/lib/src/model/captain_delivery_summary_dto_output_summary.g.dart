// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_delivery_summary_dto_output_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDeliverySummaryDtoOutputSummary
    extends CaptainDeliverySummaryDtoOutputSummary {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final CaptainDeliverySummaryDtoOutputSummaryPay pay;
  @override
  final CaptainDeliverySummaryDtoOutputSummaryCustodyChange custodyChange;
  @override
  final CaptainDeliverySummaryDtoOutputSummaryHandInToday handInToday;

  factory _$CaptainDeliverySummaryDtoOutputSummary([
    void Function(CaptainDeliverySummaryDtoOutputSummaryBuilder)? updates,
  ]) => (CaptainDeliverySummaryDtoOutputSummaryBuilder()..update(updates))
      ._build();

  _$CaptainDeliverySummaryDtoOutputSummary._({
    required this.orderId,
    required this.number,
    required this.pay,
    required this.custodyChange,
    required this.handInToday,
  }) : super._();
  @override
  CaptainDeliverySummaryDtoOutputSummary rebuild(
    void Function(CaptainDeliverySummaryDtoOutputSummaryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverySummaryDtoOutputSummaryBuilder toBuilder() =>
      CaptainDeliverySummaryDtoOutputSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverySummaryDtoOutputSummary &&
        orderId == other.orderId &&
        number == other.number &&
        pay == other.pay &&
        custodyChange == other.custodyChange &&
        handInToday == other.handInToday;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, pay.hashCode);
    _$hash = $jc(_$hash, custodyChange.hashCode);
    _$hash = $jc(_$hash, handInToday.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainDeliverySummaryDtoOutputSummary',
          )
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('pay', pay)
          ..add('custodyChange', custodyChange)
          ..add('handInToday', handInToday))
        .toString();
  }
}

class CaptainDeliverySummaryDtoOutputSummaryBuilder
    implements
        Builder<
          CaptainDeliverySummaryDtoOutputSummary,
          CaptainDeliverySummaryDtoOutputSummaryBuilder
        > {
  _$CaptainDeliverySummaryDtoOutputSummary? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CaptainDeliverySummaryDtoOutputSummaryPayBuilder? _pay;
  CaptainDeliverySummaryDtoOutputSummaryPayBuilder get pay =>
      _$this._pay ??= CaptainDeliverySummaryDtoOutputSummaryPayBuilder();
  set pay(CaptainDeliverySummaryDtoOutputSummaryPayBuilder? pay) =>
      _$this._pay = pay;

  CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder? _custodyChange;
  CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder
  get custodyChange => _$this._custodyChange ??=
      CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder();
  set custodyChange(
    CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder? custodyChange,
  ) => _$this._custodyChange = custodyChange;

  CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder? _handInToday;
  CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder get handInToday =>
      _$this._handInToday ??=
          CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder();
  set handInToday(
    CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder? handInToday,
  ) => _$this._handInToday = handInToday;

  CaptainDeliverySummaryDtoOutputSummaryBuilder() {
    CaptainDeliverySummaryDtoOutputSummary._defaults(this);
  }

  CaptainDeliverySummaryDtoOutputSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _pay = $v.pay.toBuilder();
      _custodyChange = $v.custodyChange.toBuilder();
      _handInToday = $v.handInToday.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverySummaryDtoOutputSummary other) {
    _$v = other as _$CaptainDeliverySummaryDtoOutputSummary;
  }

  @override
  void update(
    void Function(CaptainDeliverySummaryDtoOutputSummaryBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverySummaryDtoOutputSummary build() => _build();

  _$CaptainDeliverySummaryDtoOutputSummary _build() {
    _$CaptainDeliverySummaryDtoOutputSummary _$result;
    try {
      _$result =
          _$v ??
          _$CaptainDeliverySummaryDtoOutputSummary._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'CaptainDeliverySummaryDtoOutputSummary',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CaptainDeliverySummaryDtoOutputSummary',
              'number',
            ),
            pay: pay.build(),
            custodyChange: custodyChange.build(),
            handInToday: handInToday.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pay';
        pay.build();
        _$failedField = 'custodyChange';
        custodyChange.build();
        _$failedField = 'handInToday';
        handInToday.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDeliverySummaryDtoOutputSummary',
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
