// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_status_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantStatusDtoOutputStateEnum
_$merchantStatusDtoOutputStateEnum_draft =
    const MerchantStatusDtoOutputStateEnum._('draft');
const MerchantStatusDtoOutputStateEnum
_$merchantStatusDtoOutputStateEnum_suspended =
    const MerchantStatusDtoOutputStateEnum._('suspended');
const MerchantStatusDtoOutputStateEnum
_$merchantStatusDtoOutputStateEnum_terminated =
    const MerchantStatusDtoOutputStateEnum._('terminated');
const MerchantStatusDtoOutputStateEnum
_$merchantStatusDtoOutputStateEnum_holiday =
    const MerchantStatusDtoOutputStateEnum._('holiday');
const MerchantStatusDtoOutputStateEnum
_$merchantStatusDtoOutputStateEnum_closed =
    const MerchantStatusDtoOutputStateEnum._('closed');
const MerchantStatusDtoOutputStateEnum
_$merchantStatusDtoOutputStateEnum_paused =
    const MerchantStatusDtoOutputStateEnum._('paused');
const MerchantStatusDtoOutputStateEnum _$merchantStatusDtoOutputStateEnum_busy =
    const MerchantStatusDtoOutputStateEnum._('busy');
const MerchantStatusDtoOutputStateEnum _$merchantStatusDtoOutputStateEnum_open =
    const MerchantStatusDtoOutputStateEnum._('open');

MerchantStatusDtoOutputStateEnum _$merchantStatusDtoOutputStateEnumValueOf(
  String name,
) {
  switch (name) {
    case 'draft':
      return _$merchantStatusDtoOutputStateEnum_draft;
    case 'suspended':
      return _$merchantStatusDtoOutputStateEnum_suspended;
    case 'terminated':
      return _$merchantStatusDtoOutputStateEnum_terminated;
    case 'holiday':
      return _$merchantStatusDtoOutputStateEnum_holiday;
    case 'closed':
      return _$merchantStatusDtoOutputStateEnum_closed;
    case 'paused':
      return _$merchantStatusDtoOutputStateEnum_paused;
    case 'busy':
      return _$merchantStatusDtoOutputStateEnum_busy;
    case 'open':
      return _$merchantStatusDtoOutputStateEnum_open;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantStatusDtoOutputStateEnum>
_$merchantStatusDtoOutputStateEnumValues =
    BuiltSet<MerchantStatusDtoOutputStateEnum>(
      const <MerchantStatusDtoOutputStateEnum>[
        _$merchantStatusDtoOutputStateEnum_draft,
        _$merchantStatusDtoOutputStateEnum_suspended,
        _$merchantStatusDtoOutputStateEnum_terminated,
        _$merchantStatusDtoOutputStateEnum_holiday,
        _$merchantStatusDtoOutputStateEnum_closed,
        _$merchantStatusDtoOutputStateEnum_paused,
        _$merchantStatusDtoOutputStateEnum_busy,
        _$merchantStatusDtoOutputStateEnum_open,
      ],
    );

const MerchantStatusDtoOutputPauseSourceEnum
_$merchantStatusDtoOutputPauseSourceEnum_restaurant =
    const MerchantStatusDtoOutputPauseSourceEnum._('restaurant');
const MerchantStatusDtoOutputPauseSourceEnum
_$merchantStatusDtoOutputPauseSourceEnum_ops =
    const MerchantStatusDtoOutputPauseSourceEnum._('ops');
const MerchantStatusDtoOutputPauseSourceEnum
_$merchantStatusDtoOutputPauseSourceEnum_auto =
    const MerchantStatusDtoOutputPauseSourceEnum._('auto');

MerchantStatusDtoOutputPauseSourceEnum
_$merchantStatusDtoOutputPauseSourceEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$merchantStatusDtoOutputPauseSourceEnum_restaurant;
    case 'ops':
      return _$merchantStatusDtoOutputPauseSourceEnum_ops;
    case 'auto':
      return _$merchantStatusDtoOutputPauseSourceEnum_auto;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantStatusDtoOutputPauseSourceEnum>
_$merchantStatusDtoOutputPauseSourceEnumValues =
    BuiltSet<MerchantStatusDtoOutputPauseSourceEnum>(
      const <MerchantStatusDtoOutputPauseSourceEnum>[
        _$merchantStatusDtoOutputPauseSourceEnum_restaurant,
        _$merchantStatusDtoOutputPauseSourceEnum_ops,
        _$merchantStatusDtoOutputPauseSourceEnum_auto,
      ],
    );

Serializer<MerchantStatusDtoOutputStateEnum>
_$merchantStatusDtoOutputStateEnumSerializer =
    _$MerchantStatusDtoOutputStateEnumSerializer();
Serializer<MerchantStatusDtoOutputPauseSourceEnum>
_$merchantStatusDtoOutputPauseSourceEnumSerializer =
    _$MerchantStatusDtoOutputPauseSourceEnumSerializer();

class _$MerchantStatusDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<MerchantStatusDtoOutputStateEnum> {
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
  final Iterable<Type> types = const <Type>[MerchantStatusDtoOutputStateEnum];
  @override
  final String wireName = 'MerchantStatusDtoOutputStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatusDtoOutputStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantStatusDtoOutputStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantStatusDtoOutputStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantStatusDtoOutputPauseSourceEnumSerializer
    implements PrimitiveSerializer<MerchantStatusDtoOutputPauseSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'ops': 'ops',
    'auto': 'auto',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'ops': 'ops',
    'auto': 'auto',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantStatusDtoOutputPauseSourceEnum,
  ];
  @override
  final String wireName = 'MerchantStatusDtoOutputPauseSourceEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatusDtoOutputPauseSourceEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantStatusDtoOutputPauseSourceEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantStatusDtoOutputPauseSourceEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantStatusDtoOutput extends MerchantStatusDtoOutput {
  @override
  final MerchantStatusDtoOutputStateEnum state;
  @override
  final MerchantStatusDtoOutputPauseSourceEnum? pauseSource;
  @override
  final DateTime? stateUntil;
  @override
  final DateTime? closesAt;
  @override
  final DateTime? opensAt;
  @override
  final MerchantStatusDtoOutputBusyMode? busyMode;
  @override
  final int? activeOrders;
  @override
  final int? maxActiveOrders;
  @override
  final MerchantStatusDtoOutputHoliday? holiday;
  @override
  final BuiltList<int> pauseChoicesMin;
  @override
  final BuiltList<int> busyExtraOptionsMin;
  @override
  final int busyReminderMin;

  factory _$MerchantStatusDtoOutput([
    void Function(MerchantStatusDtoOutputBuilder)? updates,
  ]) => (MerchantStatusDtoOutputBuilder()..update(updates))._build();

  _$MerchantStatusDtoOutput._({
    required this.state,
    this.pauseSource,
    this.stateUntil,
    this.closesAt,
    this.opensAt,
    this.busyMode,
    this.activeOrders,
    this.maxActiveOrders,
    this.holiday,
    required this.pauseChoicesMin,
    required this.busyExtraOptionsMin,
    required this.busyReminderMin,
  }) : super._();
  @override
  MerchantStatusDtoOutput rebuild(
    void Function(MerchantStatusDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatusDtoOutputBuilder toBuilder() =>
      MerchantStatusDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatusDtoOutput &&
        state == other.state &&
        pauseSource == other.pauseSource &&
        stateUntil == other.stateUntil &&
        closesAt == other.closesAt &&
        opensAt == other.opensAt &&
        busyMode == other.busyMode &&
        activeOrders == other.activeOrders &&
        maxActiveOrders == other.maxActiveOrders &&
        holiday == other.holiday &&
        pauseChoicesMin == other.pauseChoicesMin &&
        busyExtraOptionsMin == other.busyExtraOptionsMin &&
        busyReminderMin == other.busyReminderMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, pauseSource.hashCode);
    _$hash = $jc(_$hash, stateUntil.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, busyMode.hashCode);
    _$hash = $jc(_$hash, activeOrders.hashCode);
    _$hash = $jc(_$hash, maxActiveOrders.hashCode);
    _$hash = $jc(_$hash, holiday.hashCode);
    _$hash = $jc(_$hash, pauseChoicesMin.hashCode);
    _$hash = $jc(_$hash, busyExtraOptionsMin.hashCode);
    _$hash = $jc(_$hash, busyReminderMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantStatusDtoOutput')
          ..add('state', state)
          ..add('pauseSource', pauseSource)
          ..add('stateUntil', stateUntil)
          ..add('closesAt', closesAt)
          ..add('opensAt', opensAt)
          ..add('busyMode', busyMode)
          ..add('activeOrders', activeOrders)
          ..add('maxActiveOrders', maxActiveOrders)
          ..add('holiday', holiday)
          ..add('pauseChoicesMin', pauseChoicesMin)
          ..add('busyExtraOptionsMin', busyExtraOptionsMin)
          ..add('busyReminderMin', busyReminderMin))
        .toString();
  }
}

class MerchantStatusDtoOutputBuilder
    implements
        Builder<MerchantStatusDtoOutput, MerchantStatusDtoOutputBuilder> {
  _$MerchantStatusDtoOutput? _$v;

  MerchantStatusDtoOutputStateEnum? _state;
  MerchantStatusDtoOutputStateEnum? get state => _$this._state;
  set state(MerchantStatusDtoOutputStateEnum? state) => _$this._state = state;

  MerchantStatusDtoOutputPauseSourceEnum? _pauseSource;
  MerchantStatusDtoOutputPauseSourceEnum? get pauseSource =>
      _$this._pauseSource;
  set pauseSource(MerchantStatusDtoOutputPauseSourceEnum? pauseSource) =>
      _$this._pauseSource = pauseSource;

  DateTime? _stateUntil;
  DateTime? get stateUntil => _$this._stateUntil;
  set stateUntil(DateTime? stateUntil) => _$this._stateUntil = stateUntil;

  DateTime? _closesAt;
  DateTime? get closesAt => _$this._closesAt;
  set closesAt(DateTime? closesAt) => _$this._closesAt = closesAt;

  DateTime? _opensAt;
  DateTime? get opensAt => _$this._opensAt;
  set opensAt(DateTime? opensAt) => _$this._opensAt = opensAt;

  MerchantStatusDtoOutputBusyModeBuilder? _busyMode;
  MerchantStatusDtoOutputBusyModeBuilder get busyMode =>
      _$this._busyMode ??= MerchantStatusDtoOutputBusyModeBuilder();
  set busyMode(MerchantStatusDtoOutputBusyModeBuilder? busyMode) =>
      _$this._busyMode = busyMode;

  int? _activeOrders;
  int? get activeOrders => _$this._activeOrders;
  set activeOrders(int? activeOrders) => _$this._activeOrders = activeOrders;

  int? _maxActiveOrders;
  int? get maxActiveOrders => _$this._maxActiveOrders;
  set maxActiveOrders(int? maxActiveOrders) =>
      _$this._maxActiveOrders = maxActiveOrders;

  MerchantStatusDtoOutputHolidayBuilder? _holiday;
  MerchantStatusDtoOutputHolidayBuilder get holiday =>
      _$this._holiday ??= MerchantStatusDtoOutputHolidayBuilder();
  set holiday(MerchantStatusDtoOutputHolidayBuilder? holiday) =>
      _$this._holiday = holiday;

  ListBuilder<int>? _pauseChoicesMin;
  ListBuilder<int> get pauseChoicesMin =>
      _$this._pauseChoicesMin ??= ListBuilder<int>();
  set pauseChoicesMin(ListBuilder<int>? pauseChoicesMin) =>
      _$this._pauseChoicesMin = pauseChoicesMin;

  ListBuilder<int>? _busyExtraOptionsMin;
  ListBuilder<int> get busyExtraOptionsMin =>
      _$this._busyExtraOptionsMin ??= ListBuilder<int>();
  set busyExtraOptionsMin(ListBuilder<int>? busyExtraOptionsMin) =>
      _$this._busyExtraOptionsMin = busyExtraOptionsMin;

  int? _busyReminderMin;
  int? get busyReminderMin => _$this._busyReminderMin;
  set busyReminderMin(int? busyReminderMin) =>
      _$this._busyReminderMin = busyReminderMin;

  MerchantStatusDtoOutputBuilder() {
    MerchantStatusDtoOutput._defaults(this);
  }

  MerchantStatusDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _pauseSource = $v.pauseSource;
      _stateUntil = $v.stateUntil;
      _closesAt = $v.closesAt;
      _opensAt = $v.opensAt;
      _busyMode = $v.busyMode?.toBuilder();
      _activeOrders = $v.activeOrders;
      _maxActiveOrders = $v.maxActiveOrders;
      _holiday = $v.holiday?.toBuilder();
      _pauseChoicesMin = $v.pauseChoicesMin.toBuilder();
      _busyExtraOptionsMin = $v.busyExtraOptionsMin.toBuilder();
      _busyReminderMin = $v.busyReminderMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatusDtoOutput other) {
    _$v = other as _$MerchantStatusDtoOutput;
  }

  @override
  void update(void Function(MerchantStatusDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatusDtoOutput build() => _build();

  _$MerchantStatusDtoOutput _build() {
    _$MerchantStatusDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantStatusDtoOutput._(
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'MerchantStatusDtoOutput',
              'state',
            ),
            pauseSource: pauseSource,
            stateUntil: stateUntil,
            closesAt: closesAt,
            opensAt: opensAt,
            busyMode: _busyMode?.build(),
            activeOrders: activeOrders,
            maxActiveOrders: maxActiveOrders,
            holiday: _holiday?.build(),
            pauseChoicesMin: pauseChoicesMin.build(),
            busyExtraOptionsMin: busyExtraOptionsMin.build(),
            busyReminderMin: BuiltValueNullFieldError.checkNotNull(
              busyReminderMin,
              r'MerchantStatusDtoOutput',
              'busyReminderMin',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'busyMode';
        _busyMode?.build();

        _$failedField = 'holiday';
        _holiday?.build();
        _$failedField = 'pauseChoicesMin';
        pauseChoicesMin.build();
        _$failedField = 'busyExtraOptionsMin';
        busyExtraOptionsMin.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantStatusDtoOutput',
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
