// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_receipts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainCustodyDtoOutputReceiptsInnerTypeEnum
_$captainCustodyDtoOutputReceiptsInnerTypeEnum_captainHandIn =
    const CaptainCustodyDtoOutputReceiptsInnerTypeEnum._('captainHandIn');
const CaptainCustodyDtoOutputReceiptsInnerTypeEnum
_$captainCustodyDtoOutputReceiptsInnerTypeEnum_captainReimbursement =
    const CaptainCustodyDtoOutputReceiptsInnerTypeEnum._(
      'captainReimbursement',
    );

CaptainCustodyDtoOutputReceiptsInnerTypeEnum
_$captainCustodyDtoOutputReceiptsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'captainHandIn':
      return _$captainCustodyDtoOutputReceiptsInnerTypeEnum_captainHandIn;
    case 'captainReimbursement':
      return _$captainCustodyDtoOutputReceiptsInnerTypeEnum_captainReimbursement;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainCustodyDtoOutputReceiptsInnerTypeEnum>
_$captainCustodyDtoOutputReceiptsInnerTypeEnumValues =
    BuiltSet<CaptainCustodyDtoOutputReceiptsInnerTypeEnum>(
      const <CaptainCustodyDtoOutputReceiptsInnerTypeEnum>[
        _$captainCustodyDtoOutputReceiptsInnerTypeEnum_captainHandIn,
        _$captainCustodyDtoOutputReceiptsInnerTypeEnum_captainReimbursement,
      ],
    );

Serializer<CaptainCustodyDtoOutputReceiptsInnerTypeEnum>
_$captainCustodyDtoOutputReceiptsInnerTypeEnumSerializer =
    _$CaptainCustodyDtoOutputReceiptsInnerTypeEnumSerializer();

class _$CaptainCustodyDtoOutputReceiptsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<CaptainCustodyDtoOutputReceiptsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captainHandIn': 'captain_hand_in',
    'captainReimbursement': 'captain_reimbursement',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain_hand_in': 'captainHandIn',
    'captain_reimbursement': 'captainReimbursement',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainCustodyDtoOutputReceiptsInnerTypeEnum,
  ];
  @override
  final String wireName = 'CaptainCustodyDtoOutputReceiptsInnerTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustodyDtoOutputReceiptsInnerTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainCustodyDtoOutputReceiptsInnerTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainCustodyDtoOutputReceiptsInnerTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainCustodyDtoOutputReceiptsInner
    extends CaptainCustodyDtoOutputReceiptsInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final CaptainCustodyDtoOutputReceiptsInnerTypeEnum type;
  @override
  final DateTime at;
  @override
  final String? cashierName;
  @override
  final BuiltList<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>
  conversions;
  @override
  final BuiltList<CaptainCustodyDtoOutputReceiptsInnerLinesInner> lines;

  factory _$CaptainCustodyDtoOutputReceiptsInner([
    void Function(CaptainCustodyDtoOutputReceiptsInnerBuilder)? updates,
  ]) =>
      (CaptainCustodyDtoOutputReceiptsInnerBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutputReceiptsInner._({
    required this.id,
    required this.number,
    required this.type,
    required this.at,
    this.cashierName,
    required this.conversions,
    required this.lines,
  }) : super._();
  @override
  CaptainCustodyDtoOutputReceiptsInner rebuild(
    void Function(CaptainCustodyDtoOutputReceiptsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputReceiptsInnerBuilder toBuilder() =>
      CaptainCustodyDtoOutputReceiptsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputReceiptsInner &&
        id == other.id &&
        number == other.number &&
        type == other.type &&
        at == other.at &&
        cashierName == other.cashierName &&
        conversions == other.conversions &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, cashierName.hashCode);
    _$hash = $jc(_$hash, conversions.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutputReceiptsInner')
          ..add('id', id)
          ..add('number', number)
          ..add('type', type)
          ..add('at', at)
          ..add('cashierName', cashierName)
          ..add('conversions', conversions)
          ..add('lines', lines))
        .toString();
  }
}

class CaptainCustodyDtoOutputReceiptsInnerBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputReceiptsInner,
          CaptainCustodyDtoOutputReceiptsInnerBuilder
        > {
  _$CaptainCustodyDtoOutputReceiptsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CaptainCustodyDtoOutputReceiptsInnerTypeEnum? _type;
  CaptainCustodyDtoOutputReceiptsInnerTypeEnum? get type => _$this._type;
  set type(CaptainCustodyDtoOutputReceiptsInnerTypeEnum? type) =>
      _$this._type = type;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _cashierName;
  String? get cashierName => _$this._cashierName;
  set cashierName(String? cashierName) => _$this._cashierName = cashierName;

  ListBuilder<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>?
  _conversions;
  ListBuilder<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>
  get conversions => _$this._conversions ??=
      ListBuilder<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>();
  set conversions(
    ListBuilder<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>?
    conversions,
  ) => _$this._conversions = conversions;

  ListBuilder<CaptainCustodyDtoOutputReceiptsInnerLinesInner>? _lines;
  ListBuilder<CaptainCustodyDtoOutputReceiptsInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<CaptainCustodyDtoOutputReceiptsInnerLinesInner>();
  set lines(
    ListBuilder<CaptainCustodyDtoOutputReceiptsInnerLinesInner>? lines,
  ) => _$this._lines = lines;

  CaptainCustodyDtoOutputReceiptsInnerBuilder() {
    CaptainCustodyDtoOutputReceiptsInner._defaults(this);
  }

  CaptainCustodyDtoOutputReceiptsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _type = $v.type;
      _at = $v.at;
      _cashierName = $v.cashierName;
      _conversions = $v.conversions.toBuilder();
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputReceiptsInner other) {
    _$v = other as _$CaptainCustodyDtoOutputReceiptsInner;
  }

  @override
  void update(
    void Function(CaptainCustodyDtoOutputReceiptsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputReceiptsInner build() => _build();

  _$CaptainCustodyDtoOutputReceiptsInner _build() {
    _$CaptainCustodyDtoOutputReceiptsInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCustodyDtoOutputReceiptsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainCustodyDtoOutputReceiptsInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CaptainCustodyDtoOutputReceiptsInner',
              'number',
            ),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'CaptainCustodyDtoOutputReceiptsInner',
              'type',
            ),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CaptainCustodyDtoOutputReceiptsInner',
              'at',
            ),
            cashierName: cashierName,
            conversions: conversions.build(),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversions';
        conversions.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCustodyDtoOutputReceiptsInner',
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
