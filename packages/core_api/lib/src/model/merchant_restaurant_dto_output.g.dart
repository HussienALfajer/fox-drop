// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_restaurant_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantRestaurantDtoOutputAccountStatusEnum
_$merchantRestaurantDtoOutputAccountStatusEnum_draft =
    const MerchantRestaurantDtoOutputAccountStatusEnum._('draft');
const MerchantRestaurantDtoOutputAccountStatusEnum
_$merchantRestaurantDtoOutputAccountStatusEnum_test =
    const MerchantRestaurantDtoOutputAccountStatusEnum._('test');
const MerchantRestaurantDtoOutputAccountStatusEnum
_$merchantRestaurantDtoOutputAccountStatusEnum_active =
    const MerchantRestaurantDtoOutputAccountStatusEnum._('active');
const MerchantRestaurantDtoOutputAccountStatusEnum
_$merchantRestaurantDtoOutputAccountStatusEnum_suspended =
    const MerchantRestaurantDtoOutputAccountStatusEnum._('suspended');
const MerchantRestaurantDtoOutputAccountStatusEnum
_$merchantRestaurantDtoOutputAccountStatusEnum_terminated =
    const MerchantRestaurantDtoOutputAccountStatusEnum._('terminated');

MerchantRestaurantDtoOutputAccountStatusEnum
_$merchantRestaurantDtoOutputAccountStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$merchantRestaurantDtoOutputAccountStatusEnum_draft;
    case 'test':
      return _$merchantRestaurantDtoOutputAccountStatusEnum_test;
    case 'active':
      return _$merchantRestaurantDtoOutputAccountStatusEnum_active;
    case 'suspended':
      return _$merchantRestaurantDtoOutputAccountStatusEnum_suspended;
    case 'terminated':
      return _$merchantRestaurantDtoOutputAccountStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantRestaurantDtoOutputAccountStatusEnum>
_$merchantRestaurantDtoOutputAccountStatusEnumValues =
    BuiltSet<MerchantRestaurantDtoOutputAccountStatusEnum>(
      const <MerchantRestaurantDtoOutputAccountStatusEnum>[
        _$merchantRestaurantDtoOutputAccountStatusEnum_draft,
        _$merchantRestaurantDtoOutputAccountStatusEnum_test,
        _$merchantRestaurantDtoOutputAccountStatusEnum_active,
        _$merchantRestaurantDtoOutputAccountStatusEnum_suspended,
        _$merchantRestaurantDtoOutputAccountStatusEnum_terminated,
      ],
    );

const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_draft =
    const MerchantRestaurantDtoOutputStateEnum._('draft');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_suspended =
    const MerchantRestaurantDtoOutputStateEnum._('suspended');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_terminated =
    const MerchantRestaurantDtoOutputStateEnum._('terminated');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_holiday =
    const MerchantRestaurantDtoOutputStateEnum._('holiday');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_closed =
    const MerchantRestaurantDtoOutputStateEnum._('closed');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_paused =
    const MerchantRestaurantDtoOutputStateEnum._('paused');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_busy =
    const MerchantRestaurantDtoOutputStateEnum._('busy');
const MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnum_open =
    const MerchantRestaurantDtoOutputStateEnum._('open');

MerchantRestaurantDtoOutputStateEnum
_$merchantRestaurantDtoOutputStateEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$merchantRestaurantDtoOutputStateEnum_draft;
    case 'suspended':
      return _$merchantRestaurantDtoOutputStateEnum_suspended;
    case 'terminated':
      return _$merchantRestaurantDtoOutputStateEnum_terminated;
    case 'holiday':
      return _$merchantRestaurantDtoOutputStateEnum_holiday;
    case 'closed':
      return _$merchantRestaurantDtoOutputStateEnum_closed;
    case 'paused':
      return _$merchantRestaurantDtoOutputStateEnum_paused;
    case 'busy':
      return _$merchantRestaurantDtoOutputStateEnum_busy;
    case 'open':
      return _$merchantRestaurantDtoOutputStateEnum_open;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantRestaurantDtoOutputStateEnum>
_$merchantRestaurantDtoOutputStateEnumValues =
    BuiltSet<MerchantRestaurantDtoOutputStateEnum>(
      const <MerchantRestaurantDtoOutputStateEnum>[
        _$merchantRestaurantDtoOutputStateEnum_draft,
        _$merchantRestaurantDtoOutputStateEnum_suspended,
        _$merchantRestaurantDtoOutputStateEnum_terminated,
        _$merchantRestaurantDtoOutputStateEnum_holiday,
        _$merchantRestaurantDtoOutputStateEnum_closed,
        _$merchantRestaurantDtoOutputStateEnum_paused,
        _$merchantRestaurantDtoOutputStateEnum_busy,
        _$merchantRestaurantDtoOutputStateEnum_open,
      ],
    );

Serializer<MerchantRestaurantDtoOutputAccountStatusEnum>
_$merchantRestaurantDtoOutputAccountStatusEnumSerializer =
    _$MerchantRestaurantDtoOutputAccountStatusEnumSerializer();
Serializer<MerchantRestaurantDtoOutputStateEnum>
_$merchantRestaurantDtoOutputStateEnumSerializer =
    _$MerchantRestaurantDtoOutputStateEnumSerializer();

class _$MerchantRestaurantDtoOutputAccountStatusEnumSerializer
    implements
        PrimitiveSerializer<MerchantRestaurantDtoOutputAccountStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantRestaurantDtoOutputAccountStatusEnum,
  ];
  @override
  final String wireName = 'MerchantRestaurantDtoOutputAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantRestaurantDtoOutputAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantRestaurantDtoOutputAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantRestaurantDtoOutputAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantRestaurantDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<MerchantRestaurantDtoOutputStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'suspended': 'suspended',
    'terminated': 'terminated',
    'holiday': 'holiday',
    'closed': 'closed',
    'paused': 'paused',
    'busy': 'busy',
    'open': 'open',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'suspended': 'suspended',
    'terminated': 'terminated',
    'holiday': 'holiday',
    'closed': 'closed',
    'paused': 'paused',
    'busy': 'busy',
    'open': 'open',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantRestaurantDtoOutputStateEnum,
  ];
  @override
  final String wireName = 'MerchantRestaurantDtoOutputStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantRestaurantDtoOutputStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantRestaurantDtoOutputStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantRestaurantDtoOutputStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantRestaurantDtoOutput extends MerchantRestaurantDtoOutput {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final MerchantRestaurantDtoOutputAccountStatusEnum accountStatus;
  @override
  final String? suspensionReason;
  @override
  final MerchantRestaurantDtoOutputStateEnum state;
  @override
  final DateTime? stateUntil;

  factory _$MerchantRestaurantDtoOutput([
    void Function(MerchantRestaurantDtoOutputBuilder)? updates,
  ]) => (MerchantRestaurantDtoOutputBuilder()..update(updates))._build();

  _$MerchantRestaurantDtoOutput._({
    required this.id,
    required this.nameAr,
    this.nameEn,
    required this.accountStatus,
    this.suspensionReason,
    required this.state,
    this.stateUntil,
  }) : super._();
  @override
  MerchantRestaurantDtoOutput rebuild(
    void Function(MerchantRestaurantDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantRestaurantDtoOutputBuilder toBuilder() =>
      MerchantRestaurantDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRestaurantDtoOutput &&
        id == other.id &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        accountStatus == other.accountStatus &&
        suspensionReason == other.suspensionReason &&
        state == other.state &&
        stateUntil == other.stateUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, suspensionReason.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, stateUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantRestaurantDtoOutput')
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('accountStatus', accountStatus)
          ..add('suspensionReason', suspensionReason)
          ..add('state', state)
          ..add('stateUntil', stateUntil))
        .toString();
  }
}

class MerchantRestaurantDtoOutputBuilder
    implements
        Builder<
          MerchantRestaurantDtoOutput,
          MerchantRestaurantDtoOutputBuilder
        > {
  _$MerchantRestaurantDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _nameEn;
  String? get nameEn => _$this._nameEn;
  set nameEn(String? nameEn) => _$this._nameEn = nameEn;

  MerchantRestaurantDtoOutputAccountStatusEnum? _accountStatus;
  MerchantRestaurantDtoOutputAccountStatusEnum? get accountStatus =>
      _$this._accountStatus;
  set accountStatus(
    MerchantRestaurantDtoOutputAccountStatusEnum? accountStatus,
  ) => _$this._accountStatus = accountStatus;

  String? _suspensionReason;
  String? get suspensionReason => _$this._suspensionReason;
  set suspensionReason(String? suspensionReason) =>
      _$this._suspensionReason = suspensionReason;

  MerchantRestaurantDtoOutputStateEnum? _state;
  MerchantRestaurantDtoOutputStateEnum? get state => _$this._state;
  set state(MerchantRestaurantDtoOutputStateEnum? state) =>
      _$this._state = state;

  DateTime? _stateUntil;
  DateTime? get stateUntil => _$this._stateUntil;
  set stateUntil(DateTime? stateUntil) => _$this._stateUntil = stateUntil;

  MerchantRestaurantDtoOutputBuilder() {
    MerchantRestaurantDtoOutput._defaults(this);
  }

  MerchantRestaurantDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _accountStatus = $v.accountStatus;
      _suspensionReason = $v.suspensionReason;
      _state = $v.state;
      _stateUntil = $v.stateUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRestaurantDtoOutput other) {
    _$v = other as _$MerchantRestaurantDtoOutput;
  }

  @override
  void update(void Function(MerchantRestaurantDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRestaurantDtoOutput build() => _build();

  _$MerchantRestaurantDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantRestaurantDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'MerchantRestaurantDtoOutput',
            'id',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'MerchantRestaurantDtoOutput',
            'nameAr',
          ),
          nameEn: nameEn,
          accountStatus: BuiltValueNullFieldError.checkNotNull(
            accountStatus,
            r'MerchantRestaurantDtoOutput',
            'accountStatus',
          ),
          suspensionReason: suspensionReason,
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'MerchantRestaurantDtoOutput',
            'state',
          ),
          stateUntil: stateUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
