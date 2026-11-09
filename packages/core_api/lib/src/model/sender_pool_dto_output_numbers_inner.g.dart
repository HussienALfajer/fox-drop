// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output_numbers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnum_warming =
    const SenderPoolDtoOutputNumbersInnerStatusEnum._('warming');
const SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnum_active =
    const SenderPoolDtoOutputNumbersInnerStatusEnum._('active');
const SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnum_standby =
    const SenderPoolDtoOutputNumbersInnerStatusEnum._('standby');
const SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnum_throttled =
    const SenderPoolDtoOutputNumbersInnerStatusEnum._('throttled');
const SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnum_disconnected =
    const SenderPoolDtoOutputNumbersInnerStatusEnum._('disconnected');
const SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnum_banned =
    const SenderPoolDtoOutputNumbersInnerStatusEnum._('banned');

SenderPoolDtoOutputNumbersInnerStatusEnum
_$senderPoolDtoOutputNumbersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'warming':
      return _$senderPoolDtoOutputNumbersInnerStatusEnum_warming;
    case 'active':
      return _$senderPoolDtoOutputNumbersInnerStatusEnum_active;
    case 'standby':
      return _$senderPoolDtoOutputNumbersInnerStatusEnum_standby;
    case 'throttled':
      return _$senderPoolDtoOutputNumbersInnerStatusEnum_throttled;
    case 'disconnected':
      return _$senderPoolDtoOutputNumbersInnerStatusEnum_disconnected;
    case 'banned':
      return _$senderPoolDtoOutputNumbersInnerStatusEnum_banned;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SenderPoolDtoOutputNumbersInnerStatusEnum>
_$senderPoolDtoOutputNumbersInnerStatusEnumValues =
    BuiltSet<SenderPoolDtoOutputNumbersInnerStatusEnum>(
      const <SenderPoolDtoOutputNumbersInnerStatusEnum>[
        _$senderPoolDtoOutputNumbersInnerStatusEnum_warming,
        _$senderPoolDtoOutputNumbersInnerStatusEnum_active,
        _$senderPoolDtoOutputNumbersInnerStatusEnum_standby,
        _$senderPoolDtoOutputNumbersInnerStatusEnum_throttled,
        _$senderPoolDtoOutputNumbersInnerStatusEnum_disconnected,
        _$senderPoolDtoOutputNumbersInnerStatusEnum_banned,
      ],
    );

Serializer<SenderPoolDtoOutputNumbersInnerStatusEnum>
_$senderPoolDtoOutputNumbersInnerStatusEnumSerializer =
    _$SenderPoolDtoOutputNumbersInnerStatusEnumSerializer();

class _$SenderPoolDtoOutputNumbersInnerStatusEnumSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputNumbersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'warming': 'warming',
    'active': 'active',
    'standby': 'standby',
    'throttled': 'throttled',
    'disconnected': 'disconnected',
    'banned': 'banned',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'warming': 'warming',
    'active': 'active',
    'standby': 'standby',
    'throttled': 'throttled',
    'disconnected': 'disconnected',
    'banned': 'banned',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SenderPoolDtoOutputNumbersInnerStatusEnum,
  ];
  @override
  final String wireName = 'SenderPoolDtoOutputNumbersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SenderPoolDtoOutputNumbersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SenderPoolDtoOutputNumbersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SenderPoolDtoOutputNumbersInner
    extends SenderPoolDtoOutputNumbersInner {
  @override
  final String id;
  @override
  final String phone;
  @override
  final SenderPoolDtoOutputNumbersInnerStatusEnum status;
  @override
  final bool connected;
  @override
  final DateTime pairedAt;
  @override
  final DateTime? stoppedAt;
  @override
  final DateTime? throttledUntil;
  @override
  final SenderPoolDtoOutputNumbersInnerWarmup? warmup;
  @override
  final int dailyCap;
  @override
  final SenderPoolDtoOutputNumbersInnerToday today;

  factory _$SenderPoolDtoOutputNumbersInner([
    void Function(SenderPoolDtoOutputNumbersInnerBuilder)? updates,
  ]) => (SenderPoolDtoOutputNumbersInnerBuilder()..update(updates))._build();

  _$SenderPoolDtoOutputNumbersInner._({
    required this.id,
    required this.phone,
    required this.status,
    required this.connected,
    required this.pairedAt,
    this.stoppedAt,
    this.throttledUntil,
    this.warmup,
    required this.dailyCap,
    required this.today,
  }) : super._();
  @override
  SenderPoolDtoOutputNumbersInner rebuild(
    void Function(SenderPoolDtoOutputNumbersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputNumbersInnerBuilder toBuilder() =>
      SenderPoolDtoOutputNumbersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutputNumbersInner &&
        id == other.id &&
        phone == other.phone &&
        status == other.status &&
        connected == other.connected &&
        pairedAt == other.pairedAt &&
        stoppedAt == other.stoppedAt &&
        throttledUntil == other.throttledUntil &&
        warmup == other.warmup &&
        dailyCap == other.dailyCap &&
        today == other.today;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, connected.hashCode);
    _$hash = $jc(_$hash, pairedAt.hashCode);
    _$hash = $jc(_$hash, stoppedAt.hashCode);
    _$hash = $jc(_$hash, throttledUntil.hashCode);
    _$hash = $jc(_$hash, warmup.hashCode);
    _$hash = $jc(_$hash, dailyCap.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SenderPoolDtoOutputNumbersInner')
          ..add('id', id)
          ..add('phone', phone)
          ..add('status', status)
          ..add('connected', connected)
          ..add('pairedAt', pairedAt)
          ..add('stoppedAt', stoppedAt)
          ..add('throttledUntil', throttledUntil)
          ..add('warmup', warmup)
          ..add('dailyCap', dailyCap)
          ..add('today', today))
        .toString();
  }
}

class SenderPoolDtoOutputNumbersInnerBuilder
    implements
        Builder<
          SenderPoolDtoOutputNumbersInner,
          SenderPoolDtoOutputNumbersInnerBuilder
        > {
  _$SenderPoolDtoOutputNumbersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  SenderPoolDtoOutputNumbersInnerStatusEnum? _status;
  SenderPoolDtoOutputNumbersInnerStatusEnum? get status => _$this._status;
  set status(SenderPoolDtoOutputNumbersInnerStatusEnum? status) =>
      _$this._status = status;

  bool? _connected;
  bool? get connected => _$this._connected;
  set connected(bool? connected) => _$this._connected = connected;

  DateTime? _pairedAt;
  DateTime? get pairedAt => _$this._pairedAt;
  set pairedAt(DateTime? pairedAt) => _$this._pairedAt = pairedAt;

  DateTime? _stoppedAt;
  DateTime? get stoppedAt => _$this._stoppedAt;
  set stoppedAt(DateTime? stoppedAt) => _$this._stoppedAt = stoppedAt;

  DateTime? _throttledUntil;
  DateTime? get throttledUntil => _$this._throttledUntil;
  set throttledUntil(DateTime? throttledUntil) =>
      _$this._throttledUntil = throttledUntil;

  SenderPoolDtoOutputNumbersInnerWarmupBuilder? _warmup;
  SenderPoolDtoOutputNumbersInnerWarmupBuilder get warmup =>
      _$this._warmup ??= SenderPoolDtoOutputNumbersInnerWarmupBuilder();
  set warmup(SenderPoolDtoOutputNumbersInnerWarmupBuilder? warmup) =>
      _$this._warmup = warmup;

  int? _dailyCap;
  int? get dailyCap => _$this._dailyCap;
  set dailyCap(int? dailyCap) => _$this._dailyCap = dailyCap;

  SenderPoolDtoOutputNumbersInnerTodayBuilder? _today;
  SenderPoolDtoOutputNumbersInnerTodayBuilder get today =>
      _$this._today ??= SenderPoolDtoOutputNumbersInnerTodayBuilder();
  set today(SenderPoolDtoOutputNumbersInnerTodayBuilder? today) =>
      _$this._today = today;

  SenderPoolDtoOutputNumbersInnerBuilder() {
    SenderPoolDtoOutputNumbersInner._defaults(this);
  }

  SenderPoolDtoOutputNumbersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _phone = $v.phone;
      _status = $v.status;
      _connected = $v.connected;
      _pairedAt = $v.pairedAt;
      _stoppedAt = $v.stoppedAt;
      _throttledUntil = $v.throttledUntil;
      _warmup = $v.warmup?.toBuilder();
      _dailyCap = $v.dailyCap;
      _today = $v.today.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutputNumbersInner other) {
    _$v = other as _$SenderPoolDtoOutputNumbersInner;
  }

  @override
  void update(void Function(SenderPoolDtoOutputNumbersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutputNumbersInner build() => _build();

  _$SenderPoolDtoOutputNumbersInner _build() {
    _$SenderPoolDtoOutputNumbersInner _$result;
    try {
      _$result =
          _$v ??
          _$SenderPoolDtoOutputNumbersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'SenderPoolDtoOutputNumbersInner',
              'id',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'SenderPoolDtoOutputNumbersInner',
              'phone',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'SenderPoolDtoOutputNumbersInner',
              'status',
            ),
            connected: BuiltValueNullFieldError.checkNotNull(
              connected,
              r'SenderPoolDtoOutputNumbersInner',
              'connected',
            ),
            pairedAt: BuiltValueNullFieldError.checkNotNull(
              pairedAt,
              r'SenderPoolDtoOutputNumbersInner',
              'pairedAt',
            ),
            stoppedAt: stoppedAt,
            throttledUntil: throttledUntil,
            warmup: _warmup?.build(),
            dailyCap: BuiltValueNullFieldError.checkNotNull(
              dailyCap,
              r'SenderPoolDtoOutputNumbersInner',
              'dailyCap',
            ),
            today: today.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'warmup';
        _warmup?.build();

        _$failedField = 'today';
        today.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SenderPoolDtoOutputNumbersInner',
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
