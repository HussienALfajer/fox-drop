// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnum_normal =
    const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._('normal');
const AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnum_free =
    const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._('free');
const AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnum_fake =
    const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._('fake');
const AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnum_damaged =
    const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._('damaged');
const AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnum_wrongRefused =
    const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._('wrongRefused');
const AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnum_failedOther =
    const AdminOrderDtoOutputOrderDeliveryOutcomeEnum._('failedOther');

AdminOrderDtoOutputOrderDeliveryOutcomeEnum
_$adminOrderDtoOutputOrderDeliveryOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'normal':
      return _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_normal;
    case 'free':
      return _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_free;
    case 'fake':
      return _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_fake;
    case 'damaged':
      return _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderDeliveryOutcomeEnum>
_$adminOrderDtoOutputOrderDeliveryOutcomeEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderDeliveryOutcomeEnum>(
      const <AdminOrderDtoOutputOrderDeliveryOutcomeEnum>[
        _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_normal,
        _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_free,
        _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_fake,
        _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_damaged,
        _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_wrongRefused,
        _$adminOrderDtoOutputOrderDeliveryOutcomeEnum_failedOther,
      ],
    );

Serializer<AdminOrderDtoOutputOrderDeliveryOutcomeEnum>
_$adminOrderDtoOutputOrderDeliveryOutcomeEnumSerializer =
    _$AdminOrderDtoOutputOrderDeliveryOutcomeEnumSerializer();

class _$AdminOrderDtoOutputOrderDeliveryOutcomeEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderDeliveryOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'normal': 'normal',
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrongRefused': 'wrong_refused',
    'failedOther': 'failed_other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'normal': 'normal',
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrong_refused': 'wrongRefused',
    'failed_other': 'failedOther',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderDeliveryOutcomeEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderDeliveryOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderDeliveryOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderDeliveryOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderDelivery
    extends AdminOrderDtoOutputOrderDelivery {
  @override
  final DateTime at;
  @override
  final AdminOrderDtoOutputOrderDeliveryOutcomeEnum outcome;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> received;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> change;
  @override
  final AdminOrderDtoOutputOrderDeliveryNetReceived netReceived;
  @override
  final AdminOrderDtoOutputOrderDeliveryShortfall? shortfall;
  @override
  final AdminOrderDtoOutputOrderDeliveryRecordedBy recordedBy;

  factory _$AdminOrderDtoOutputOrderDelivery([
    void Function(AdminOrderDtoOutputOrderDeliveryBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderDeliveryBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderDelivery._({
    required this.at,
    required this.outcome,
    required this.received,
    required this.change,
    required this.netReceived,
    this.shortfall,
    required this.recordedBy,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderDelivery rebuild(
    void Function(AdminOrderDtoOutputOrderDeliveryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderDeliveryBuilder toBuilder() =>
      AdminOrderDtoOutputOrderDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderDelivery &&
        at == other.at &&
        outcome == other.outcome &&
        received == other.received &&
        change == other.change &&
        netReceived == other.netReceived &&
        shortfall == other.shortfall &&
        recordedBy == other.recordedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jc(_$hash, netReceived.hashCode);
    _$hash = $jc(_$hash, shortfall.hashCode);
    _$hash = $jc(_$hash, recordedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderDelivery')
          ..add('at', at)
          ..add('outcome', outcome)
          ..add('received', received)
          ..add('change', change)
          ..add('netReceived', netReceived)
          ..add('shortfall', shortfall)
          ..add('recordedBy', recordedBy))
        .toString();
  }
}

class AdminOrderDtoOutputOrderDeliveryBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderDelivery,
          AdminOrderDtoOutputOrderDeliveryBuilder
        > {
  _$AdminOrderDtoOutputOrderDelivery? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminOrderDtoOutputOrderDeliveryOutcomeEnum? _outcome;
  AdminOrderDtoOutputOrderDeliveryOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminOrderDtoOutputOrderDeliveryOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _received;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get received =>
      _$this._received ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set received(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? received) =>
      _$this._received = received;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _change;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get change =>
      _$this._change ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set change(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? change) =>
      _$this._change = change;

  AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder? _netReceived;
  AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder get netReceived =>
      _$this._netReceived ??=
          AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder();
  set netReceived(
    AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder? netReceived,
  ) => _$this._netReceived = netReceived;

  AdminOrderDtoOutputOrderDeliveryShortfallBuilder? _shortfall;
  AdminOrderDtoOutputOrderDeliveryShortfallBuilder get shortfall =>
      _$this._shortfall ??= AdminOrderDtoOutputOrderDeliveryShortfallBuilder();
  set shortfall(AdminOrderDtoOutputOrderDeliveryShortfallBuilder? shortfall) =>
      _$this._shortfall = shortfall;

  AdminOrderDtoOutputOrderDeliveryRecordedByBuilder? _recordedBy;
  AdminOrderDtoOutputOrderDeliveryRecordedByBuilder get recordedBy =>
      _$this._recordedBy ??=
          AdminOrderDtoOutputOrderDeliveryRecordedByBuilder();
  set recordedBy(
    AdminOrderDtoOutputOrderDeliveryRecordedByBuilder? recordedBy,
  ) => _$this._recordedBy = recordedBy;

  AdminOrderDtoOutputOrderDeliveryBuilder() {
    AdminOrderDtoOutputOrderDelivery._defaults(this);
  }

  AdminOrderDtoOutputOrderDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _outcome = $v.outcome;
      _received = $v.received.toBuilder();
      _change = $v.change.toBuilder();
      _netReceived = $v.netReceived.toBuilder();
      _shortfall = $v.shortfall?.toBuilder();
      _recordedBy = $v.recordedBy.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderDelivery other) {
    _$v = other as _$AdminOrderDtoOutputOrderDelivery;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderDeliveryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderDelivery build() => _build();

  _$AdminOrderDtoOutputOrderDelivery _build() {
    _$AdminOrderDtoOutputOrderDelivery _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderDelivery._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderDelivery',
              'at',
            ),
            outcome: BuiltValueNullFieldError.checkNotNull(
              outcome,
              r'AdminOrderDtoOutputOrderDelivery',
              'outcome',
            ),
            received: received.build(),
            change: change.build(),
            netReceived: netReceived.build(),
            shortfall: _shortfall?.build(),
            recordedBy: recordedBy.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'received';
        received.build();
        _$failedField = 'change';
        change.build();
        _$failedField = 'netReceived';
        netReceived.build();
        _$failedField = 'shortfall';
        _shortfall?.build();
        _$failedField = 'recordedBy';
        recordedBy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderDelivery',
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
