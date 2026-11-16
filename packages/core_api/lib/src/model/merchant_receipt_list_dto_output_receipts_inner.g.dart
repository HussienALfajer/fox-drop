// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_receipt_list_dto_output_receipts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum
_$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantSettlement =
    const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum._(
      'merchantSettlement',
    );
const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum
_$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantPayout =
    const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum._('merchantPayout');

MerchantReceiptListDtoOutputReceiptsInnerTypeEnum
_$merchantReceiptListDtoOutputReceiptsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'merchantSettlement':
      return _$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantSettlement;
    case 'merchantPayout':
      return _$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantPayout;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantReceiptListDtoOutputReceiptsInnerTypeEnum>
_$merchantReceiptListDtoOutputReceiptsInnerTypeEnumValues =
    BuiltSet<MerchantReceiptListDtoOutputReceiptsInnerTypeEnum>(
      const <MerchantReceiptListDtoOutputReceiptsInnerTypeEnum>[
        _$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantSettlement,
        _$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantPayout,
      ],
    );

const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum
_$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_office =
    const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum._('office');
const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum
_$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_field =
    const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum._('field');

MerchantReceiptListDtoOutputReceiptsInnerMethodEnum
_$merchantReceiptListDtoOutputReceiptsInnerMethodEnumValueOf(String name) {
  switch (name) {
    case 'office':
      return _$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_office;
    case 'field':
      return _$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_field;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantReceiptListDtoOutputReceiptsInnerMethodEnum>
_$merchantReceiptListDtoOutputReceiptsInnerMethodEnumValues =
    BuiltSet<MerchantReceiptListDtoOutputReceiptsInnerMethodEnum>(
      const <MerchantReceiptListDtoOutputReceiptsInnerMethodEnum>[
        _$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_office,
        _$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_field,
      ],
    );

Serializer<MerchantReceiptListDtoOutputReceiptsInnerTypeEnum>
_$merchantReceiptListDtoOutputReceiptsInnerTypeEnumSerializer =
    _$MerchantReceiptListDtoOutputReceiptsInnerTypeEnumSerializer();
Serializer<MerchantReceiptListDtoOutputReceiptsInnerMethodEnum>
_$merchantReceiptListDtoOutputReceiptsInnerMethodEnumSerializer =
    _$MerchantReceiptListDtoOutputReceiptsInnerMethodEnumSerializer();

class _$MerchantReceiptListDtoOutputReceiptsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<MerchantReceiptListDtoOutputReceiptsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'merchantSettlement': 'merchant_settlement',
    'merchantPayout': 'merchant_payout',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'merchant_settlement': 'merchantSettlement',
    'merchant_payout': 'merchantPayout',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantReceiptListDtoOutputReceiptsInnerTypeEnum,
  ];
  @override
  final String wireName = 'MerchantReceiptListDtoOutputReceiptsInnerTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptListDtoOutputReceiptsInnerTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantReceiptListDtoOutputReceiptsInnerTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantReceiptListDtoOutputReceiptsInnerTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantReceiptListDtoOutputReceiptsInnerMethodEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantReceiptListDtoOutputReceiptsInnerMethodEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'office': 'office',
    'field': 'field',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'office': 'office',
    'field': 'field',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantReceiptListDtoOutputReceiptsInnerMethodEnum,
  ];
  @override
  final String wireName = 'MerchantReceiptListDtoOutputReceiptsInnerMethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptListDtoOutputReceiptsInnerMethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantReceiptListDtoOutputReceiptsInnerMethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantReceiptListDtoOutputReceiptsInnerMethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantReceiptListDtoOutputReceiptsInner
    extends MerchantReceiptListDtoOutputReceiptsInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final MerchantReceiptListDtoOutputReceiptsInnerTypeEnum type;
  @override
  final MerchantReceiptListDtoOutputReceiptsInnerMethodEnum method;
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

  factory _$MerchantReceiptListDtoOutputReceiptsInner([
    void Function(MerchantReceiptListDtoOutputReceiptsInnerBuilder)? updates,
  ]) => (MerchantReceiptListDtoOutputReceiptsInnerBuilder()..update(updates))
      ._build();

  _$MerchantReceiptListDtoOutputReceiptsInner._({
    required this.id,
    required this.number,
    required this.type,
    required this.method,
    this.staffName,
    required this.currency,
    required this.total,
    required this.createdAt,
    required this.lines,
  }) : super._();
  @override
  MerchantReceiptListDtoOutputReceiptsInner rebuild(
    void Function(MerchantReceiptListDtoOutputReceiptsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReceiptListDtoOutputReceiptsInnerBuilder toBuilder() =>
      MerchantReceiptListDtoOutputReceiptsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReceiptListDtoOutputReceiptsInner &&
        id == other.id &&
        number == other.number &&
        type == other.type &&
        method == other.method &&
        staffName == other.staffName &&
        currency == other.currency &&
        total == other.total &&
        createdAt == other.createdAt &&
        lines == other.lines;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantReceiptListDtoOutputReceiptsInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('type', type)
          ..add('method', method)
          ..add('staffName', staffName)
          ..add('currency', currency)
          ..add('total', total)
          ..add('createdAt', createdAt)
          ..add('lines', lines))
        .toString();
  }
}

class MerchantReceiptListDtoOutputReceiptsInnerBuilder
    implements
        Builder<
          MerchantReceiptListDtoOutputReceiptsInner,
          MerchantReceiptListDtoOutputReceiptsInnerBuilder
        > {
  _$MerchantReceiptListDtoOutputReceiptsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  MerchantReceiptListDtoOutputReceiptsInnerTypeEnum? _type;
  MerchantReceiptListDtoOutputReceiptsInnerTypeEnum? get type => _$this._type;
  set type(MerchantReceiptListDtoOutputReceiptsInnerTypeEnum? type) =>
      _$this._type = type;

  MerchantReceiptListDtoOutputReceiptsInnerMethodEnum? _method;
  MerchantReceiptListDtoOutputReceiptsInnerMethodEnum? get method =>
      _$this._method;
  set method(MerchantReceiptListDtoOutputReceiptsInnerMethodEnum? method) =>
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

  MerchantReceiptListDtoOutputReceiptsInnerBuilder() {
    MerchantReceiptListDtoOutputReceiptsInner._defaults(this);
  }

  MerchantReceiptListDtoOutputReceiptsInnerBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReceiptListDtoOutputReceiptsInner other) {
    _$v = other as _$MerchantReceiptListDtoOutputReceiptsInner;
  }

  @override
  void update(
    void Function(MerchantReceiptListDtoOutputReceiptsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReceiptListDtoOutputReceiptsInner build() => _build();

  _$MerchantReceiptListDtoOutputReceiptsInner _build() {
    _$MerchantReceiptListDtoOutputReceiptsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantReceiptListDtoOutputReceiptsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'type',
            ),
            method: BuiltValueNullFieldError.checkNotNull(
              method,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'method',
            ),
            staffName: staffName,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'currency',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'total',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'MerchantReceiptListDtoOutputReceiptsInner',
              'createdAt',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantReceiptListDtoOutputReceiptsInner',
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
