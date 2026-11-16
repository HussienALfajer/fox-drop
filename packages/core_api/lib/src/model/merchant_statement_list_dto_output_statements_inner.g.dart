// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_statement_list_dto_output_statements_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantStatementListDtoOutputStatementsInnerStatusEnum
_$merchantStatementListDtoOutputStatementsInnerStatusEnum_unpaid =
    const MerchantStatementListDtoOutputStatementsInnerStatusEnum._('unpaid');
const MerchantStatementListDtoOutputStatementsInnerStatusEnum
_$merchantStatementListDtoOutputStatementsInnerStatusEnum_partlyPaid =
    const MerchantStatementListDtoOutputStatementsInnerStatusEnum._(
      'partlyPaid',
    );
const MerchantStatementListDtoOutputStatementsInnerStatusEnum
_$merchantStatementListDtoOutputStatementsInnerStatusEnum_paid =
    const MerchantStatementListDtoOutputStatementsInnerStatusEnum._('paid');

MerchantStatementListDtoOutputStatementsInnerStatusEnum
_$merchantStatementListDtoOutputStatementsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'unpaid':
      return _$merchantStatementListDtoOutputStatementsInnerStatusEnum_unpaid;
    case 'partlyPaid':
      return _$merchantStatementListDtoOutputStatementsInnerStatusEnum_partlyPaid;
    case 'paid':
      return _$merchantStatementListDtoOutputStatementsInnerStatusEnum_paid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantStatementListDtoOutputStatementsInnerStatusEnum>
_$merchantStatementListDtoOutputStatementsInnerStatusEnumValues =
    BuiltSet<MerchantStatementListDtoOutputStatementsInnerStatusEnum>(
      const <MerchantStatementListDtoOutputStatementsInnerStatusEnum>[
        _$merchantStatementListDtoOutputStatementsInnerStatusEnum_unpaid,
        _$merchantStatementListDtoOutputStatementsInnerStatusEnum_partlyPaid,
        _$merchantStatementListDtoOutputStatementsInnerStatusEnum_paid,
      ],
    );

Serializer<MerchantStatementListDtoOutputStatementsInnerStatusEnum>
_$merchantStatementListDtoOutputStatementsInnerStatusEnumSerializer =
    _$MerchantStatementListDtoOutputStatementsInnerStatusEnumSerializer();

class _$MerchantStatementListDtoOutputStatementsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantStatementListDtoOutputStatementsInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unpaid': 'unpaid',
    'partlyPaid': 'partly_paid',
    'paid': 'paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'unpaid': 'unpaid',
    'partly_paid': 'partlyPaid',
    'paid': 'paid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantStatementListDtoOutputStatementsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'MerchantStatementListDtoOutputStatementsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementListDtoOutputStatementsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantStatementListDtoOutputStatementsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantStatementListDtoOutputStatementsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantStatementListDtoOutputStatementsInner
    extends MerchantStatementListDtoOutputStatementsInner {
  @override
  final String id;
  @override
  final DateTime cutoff;
  @override
  final DateTime? periodFrom;
  @override
  final String currency;
  @override
  final String weekTotal;
  @override
  final String totalDue;
  @override
  final MerchantStatementListDtoOutputStatementsInnerStatusEnum? status;
  @override
  final String unpaid;

  factory _$MerchantStatementListDtoOutputStatementsInner([
    void Function(MerchantStatementListDtoOutputStatementsInnerBuilder)?
    updates,
  ]) =>
      (MerchantStatementListDtoOutputStatementsInnerBuilder()..update(updates))
          ._build();

  _$MerchantStatementListDtoOutputStatementsInner._({
    required this.id,
    required this.cutoff,
    this.periodFrom,
    required this.currency,
    required this.weekTotal,
    required this.totalDue,
    this.status,
    required this.unpaid,
  }) : super._();
  @override
  MerchantStatementListDtoOutputStatementsInner rebuild(
    void Function(MerchantStatementListDtoOutputStatementsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatementListDtoOutputStatementsInnerBuilder toBuilder() =>
      MerchantStatementListDtoOutputStatementsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatementListDtoOutputStatementsInner &&
        id == other.id &&
        cutoff == other.cutoff &&
        periodFrom == other.periodFrom &&
        currency == other.currency &&
        weekTotal == other.weekTotal &&
        totalDue == other.totalDue &&
        status == other.status &&
        unpaid == other.unpaid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cutoff.hashCode);
    _$hash = $jc(_$hash, periodFrom.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, weekTotal.hashCode);
    _$hash = $jc(_$hash, totalDue.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, unpaid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantStatementListDtoOutputStatementsInner',
          )
          ..add('id', id)
          ..add('cutoff', cutoff)
          ..add('periodFrom', periodFrom)
          ..add('currency', currency)
          ..add('weekTotal', weekTotal)
          ..add('totalDue', totalDue)
          ..add('status', status)
          ..add('unpaid', unpaid))
        .toString();
  }
}

class MerchantStatementListDtoOutputStatementsInnerBuilder
    implements
        Builder<
          MerchantStatementListDtoOutputStatementsInner,
          MerchantStatementListDtoOutputStatementsInnerBuilder
        > {
  _$MerchantStatementListDtoOutputStatementsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _cutoff;
  DateTime? get cutoff => _$this._cutoff;
  set cutoff(DateTime? cutoff) => _$this._cutoff = cutoff;

  DateTime? _periodFrom;
  DateTime? get periodFrom => _$this._periodFrom;
  set periodFrom(DateTime? periodFrom) => _$this._periodFrom = periodFrom;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _weekTotal;
  String? get weekTotal => _$this._weekTotal;
  set weekTotal(String? weekTotal) => _$this._weekTotal = weekTotal;

  String? _totalDue;
  String? get totalDue => _$this._totalDue;
  set totalDue(String? totalDue) => _$this._totalDue = totalDue;

  MerchantStatementListDtoOutputStatementsInnerStatusEnum? _status;
  MerchantStatementListDtoOutputStatementsInnerStatusEnum? get status =>
      _$this._status;
  set status(MerchantStatementListDtoOutputStatementsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _unpaid;
  String? get unpaid => _$this._unpaid;
  set unpaid(String? unpaid) => _$this._unpaid = unpaid;

  MerchantStatementListDtoOutputStatementsInnerBuilder() {
    MerchantStatementListDtoOutputStatementsInner._defaults(this);
  }

  MerchantStatementListDtoOutputStatementsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cutoff = $v.cutoff;
      _periodFrom = $v.periodFrom;
      _currency = $v.currency;
      _weekTotal = $v.weekTotal;
      _totalDue = $v.totalDue;
      _status = $v.status;
      _unpaid = $v.unpaid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatementListDtoOutputStatementsInner other) {
    _$v = other as _$MerchantStatementListDtoOutputStatementsInner;
  }

  @override
  void update(
    void Function(MerchantStatementListDtoOutputStatementsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatementListDtoOutputStatementsInner build() => _build();

  _$MerchantStatementListDtoOutputStatementsInner _build() {
    final _$result =
        _$v ??
        _$MerchantStatementListDtoOutputStatementsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'MerchantStatementListDtoOutputStatementsInner',
            'id',
          ),
          cutoff: BuiltValueNullFieldError.checkNotNull(
            cutoff,
            r'MerchantStatementListDtoOutputStatementsInner',
            'cutoff',
          ),
          periodFrom: periodFrom,
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantStatementListDtoOutputStatementsInner',
            'currency',
          ),
          weekTotal: BuiltValueNullFieldError.checkNotNull(
            weekTotal,
            r'MerchantStatementListDtoOutputStatementsInner',
            'weekTotal',
          ),
          totalDue: BuiltValueNullFieldError.checkNotNull(
            totalDue,
            r'MerchantStatementListDtoOutputStatementsInner',
            'totalDue',
          ),
          status: status,
          unpaid: BuiltValueNullFieldError.checkNotNull(
            unpaid,
            r'MerchantStatementListDtoOutputStatementsInner',
            'unpaid',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
