// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_receipt_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantReceiptDtoOutputTypeEnum
_$merchantReceiptDtoOutputTypeEnum_merchantSettlement =
    const MerchantReceiptDtoOutputTypeEnum._('merchantSettlement');
const MerchantReceiptDtoOutputTypeEnum
_$merchantReceiptDtoOutputTypeEnum_merchantPayout =
    const MerchantReceiptDtoOutputTypeEnum._('merchantPayout');

MerchantReceiptDtoOutputTypeEnum _$merchantReceiptDtoOutputTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'merchantSettlement':
      return _$merchantReceiptDtoOutputTypeEnum_merchantSettlement;
    case 'merchantPayout':
      return _$merchantReceiptDtoOutputTypeEnum_merchantPayout;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantReceiptDtoOutputTypeEnum>
_$merchantReceiptDtoOutputTypeEnumValues =
    BuiltSet<MerchantReceiptDtoOutputTypeEnum>(
      const <MerchantReceiptDtoOutputTypeEnum>[
        _$merchantReceiptDtoOutputTypeEnum_merchantSettlement,
        _$merchantReceiptDtoOutputTypeEnum_merchantPayout,
      ],
    );

const MerchantReceiptDtoOutputMethodEnum
_$merchantReceiptDtoOutputMethodEnum_office =
    const MerchantReceiptDtoOutputMethodEnum._('office');
const MerchantReceiptDtoOutputMethodEnum
_$merchantReceiptDtoOutputMethodEnum_field =
    const MerchantReceiptDtoOutputMethodEnum._('field');

MerchantReceiptDtoOutputMethodEnum _$merchantReceiptDtoOutputMethodEnumValueOf(
  String name,
) {
  switch (name) {
    case 'office':
      return _$merchantReceiptDtoOutputMethodEnum_office;
    case 'field':
      return _$merchantReceiptDtoOutputMethodEnum_field;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantReceiptDtoOutputMethodEnum>
_$merchantReceiptDtoOutputMethodEnumValues =
    BuiltSet<MerchantReceiptDtoOutputMethodEnum>(
      const <MerchantReceiptDtoOutputMethodEnum>[
        _$merchantReceiptDtoOutputMethodEnum_office,
        _$merchantReceiptDtoOutputMethodEnum_field,
      ],
    );

Serializer<MerchantReceiptDtoOutputTypeEnum>
_$merchantReceiptDtoOutputTypeEnumSerializer =
    _$MerchantReceiptDtoOutputTypeEnumSerializer();
Serializer<MerchantReceiptDtoOutputMethodEnum>
_$merchantReceiptDtoOutputMethodEnumSerializer =
    _$MerchantReceiptDtoOutputMethodEnumSerializer();

class _$MerchantReceiptDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<MerchantReceiptDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'merchantSettlement': 'merchant_settlement',
    'merchantPayout': 'merchant_payout',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'merchant_settlement': 'merchantSettlement',
    'merchant_payout': 'merchantPayout',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantReceiptDtoOutputTypeEnum];
  @override
  final String wireName = 'MerchantReceiptDtoOutputTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptDtoOutputTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantReceiptDtoOutputTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantReceiptDtoOutputTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantReceiptDtoOutputMethodEnumSerializer
    implements PrimitiveSerializer<MerchantReceiptDtoOutputMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'office': 'office',
    'field': 'field',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'office': 'office',
    'field': 'field',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantReceiptDtoOutputMethodEnum];
  @override
  final String wireName = 'MerchantReceiptDtoOutputMethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptDtoOutputMethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantReceiptDtoOutputMethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantReceiptDtoOutputMethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantReceiptDtoOutput extends MerchantReceiptDtoOutput {
  @override
  final String id;
  @override
  final String number;
  @override
  final MerchantReceiptDtoOutputTypeEnum type;
  @override
  final MerchantReceiptDtoOutputMethodEnum method;
  @override
  final String? staffName;
  @override
  final String currency;
  @override
  final String total;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<MerchantReceiptListDtoOutputReceiptsInnerLinesInner> lines;
  @override
  final String dueBefore;
  @override
  final String dueAfter;

  factory _$MerchantReceiptDtoOutput([
    void Function(MerchantReceiptDtoOutputBuilder)? updates,
  ]) => (MerchantReceiptDtoOutputBuilder()..update(updates))._build();

  _$MerchantReceiptDtoOutput._({
    required this.id,
    required this.number,
    required this.type,
    required this.method,
    this.staffName,
    required this.currency,
    required this.total,
    required this.createdAt,
    required this.lines,
    required this.dueBefore,
    required this.dueAfter,
  }) : super._();
  @override
  MerchantReceiptDtoOutput rebuild(
    void Function(MerchantReceiptDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReceiptDtoOutputBuilder toBuilder() =>
      MerchantReceiptDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReceiptDtoOutput &&
        id == other.id &&
        number == other.number &&
        type == other.type &&
        method == other.method &&
        staffName == other.staffName &&
        currency == other.currency &&
        total == other.total &&
        createdAt == other.createdAt &&
        lines == other.lines &&
        dueBefore == other.dueBefore &&
        dueAfter == other.dueAfter;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, staffName.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, dueBefore.hashCode);
    _$hash = $jc(_$hash, dueAfter.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantReceiptDtoOutput')
          ..add('id', id)
          ..add('number', number)
          ..add('type', type)
          ..add('method', method)
          ..add('staffName', staffName)
          ..add('currency', currency)
          ..add('total', total)
          ..add('createdAt', createdAt)
          ..add('lines', lines)
          ..add('dueBefore', dueBefore)
          ..add('dueAfter', dueAfter))
        .toString();
  }
}

class MerchantReceiptDtoOutputBuilder
    implements
        Builder<MerchantReceiptDtoOutput, MerchantReceiptDtoOutputBuilder> {
  _$MerchantReceiptDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  MerchantReceiptDtoOutputTypeEnum? _type;
  MerchantReceiptDtoOutputTypeEnum? get type => _$this._type;
  set type(MerchantReceiptDtoOutputTypeEnum? type) => _$this._type = type;

  MerchantReceiptDtoOutputMethodEnum? _method;
  MerchantReceiptDtoOutputMethodEnum? get method => _$this._method;
  set method(MerchantReceiptDtoOutputMethodEnum? method) =>
      _$this._method = method;

  String? _staffName;
  String? get staffName => _$this._staffName;
  set staffName(String? staffName) => _$this._staffName = staffName;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<MerchantReceiptListDtoOutputReceiptsInnerLinesInner>? _lines;
  ListBuilder<MerchantReceiptListDtoOutputReceiptsInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<MerchantReceiptListDtoOutputReceiptsInnerLinesInner>();
  set lines(
    ListBuilder<MerchantReceiptListDtoOutputReceiptsInnerLinesInner>? lines,
  ) => _$this._lines = lines;

  String? _dueBefore;
  String? get dueBefore => _$this._dueBefore;
  set dueBefore(String? dueBefore) => _$this._dueBefore = dueBefore;

  String? _dueAfter;
  String? get dueAfter => _$this._dueAfter;
  set dueAfter(String? dueAfter) => _$this._dueAfter = dueAfter;

  MerchantReceiptDtoOutputBuilder() {
    MerchantReceiptDtoOutput._defaults(this);
  }

  MerchantReceiptDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _type = $v.type;
      _method = $v.method;
      _staffName = $v.staffName;
      _currency = $v.currency;
      _total = $v.total;
      _createdAt = $v.createdAt;
      _lines = $v.lines.toBuilder();
      _dueBefore = $v.dueBefore;
      _dueAfter = $v.dueAfter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReceiptDtoOutput other) {
    _$v = other as _$MerchantReceiptDtoOutput;
  }

  @override
  void update(void Function(MerchantReceiptDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReceiptDtoOutput build() => _build();

  _$MerchantReceiptDtoOutput _build() {
    _$MerchantReceiptDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantReceiptDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantReceiptDtoOutput',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'MerchantReceiptDtoOutput',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'MerchantReceiptDtoOutput',
              'type',
            ),
            method: BuiltValueNullFieldError.checkNotNull(
              method,
              r'MerchantReceiptDtoOutput',
              'method',
            ),
            staffName: staffName,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantReceiptDtoOutput',
              'currency',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'MerchantReceiptDtoOutput',
              'total',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'MerchantReceiptDtoOutput',
              'createdAt',
            ),
            lines: lines.build(),
            dueBefore: BuiltValueNullFieldError.checkNotNull(
              dueBefore,
              r'MerchantReceiptDtoOutput',
              'dueBefore',
            ),
            dueAfter: BuiltValueNullFieldError.checkNotNull(
              dueAfter,
              r'MerchantReceiptDtoOutput',
              'dueAfter',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantReceiptDtoOutput',
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
