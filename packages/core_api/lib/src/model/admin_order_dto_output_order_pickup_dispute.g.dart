// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_pickup_dispute.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum
_$adminOrderDtoOutputOrderPickupDisputeOpenedByEnum_restaurant =
    const AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum._('restaurant');
const AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum
_$adminOrderDtoOutputOrderPickupDisputeOpenedByEnum_captain =
    const AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum._('captain');

AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum
_$adminOrderDtoOutputOrderPickupDisputeOpenedByEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminOrderDtoOutputOrderPickupDisputeOpenedByEnum_restaurant;
    case 'captain':
      return _$adminOrderDtoOutputOrderPickupDisputeOpenedByEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum>
_$adminOrderDtoOutputOrderPickupDisputeOpenedByEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum>(
      const <AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum>[
        _$adminOrderDtoOutputOrderPickupDisputeOpenedByEnum_restaurant,
        _$adminOrderDtoOutputOrderPickupDisputeOpenedByEnum_captain,
      ],
    );

Serializer<AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum>
_$adminOrderDtoOutputOrderPickupDisputeOpenedByEnumSerializer =
    _$AdminOrderDtoOutputOrderPickupDisputeOpenedByEnumSerializer();

class _$AdminOrderDtoOutputOrderPickupDisputeOpenedByEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderPickupDispute
    extends AdminOrderDtoOutputOrderPickupDispute {
  @override
  final DateTime at;
  @override
  final String accountId;
  @override
  final String device;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> receivedLines;
  @override
  final AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum openedBy;

  factory _$AdminOrderDtoOutputOrderPickupDispute([
    void Function(AdminOrderDtoOutputOrderPickupDisputeBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderPickupDisputeBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderPickupDispute._({
    required this.at,
    required this.accountId,
    required this.device,
    required this.receivedLines,
    required this.openedBy,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderPickupDispute rebuild(
    void Function(AdminOrderDtoOutputOrderPickupDisputeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderPickupDisputeBuilder toBuilder() =>
      AdminOrderDtoOutputOrderPickupDisputeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderPickupDispute &&
        at == other.at &&
        accountId == other.accountId &&
        device == other.device &&
        receivedLines == other.receivedLines &&
        openedBy == other.openedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jc(_$hash, openedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderPickupDispute',
          )
          ..add('at', at)
          ..add('accountId', accountId)
          ..add('device', device)
          ..add('receivedLines', receivedLines)
          ..add('openedBy', openedBy))
        .toString();
  }
}

class AdminOrderDtoOutputOrderPickupDisputeBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderPickupDispute,
          AdminOrderDtoOutputOrderPickupDisputeBuilder
        > {
  _$AdminOrderDtoOutputOrderPickupDispute? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _device;
  String? get device => _$this._device;
  set device(String? device) => _$this._device = device;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _receivedLines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get receivedLines =>
      _$this._receivedLines ??=
          ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set receivedLines(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? receivedLines,
  ) => _$this._receivedLines = receivedLines;

  AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum? _openedBy;
  AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum? get openedBy =>
      _$this._openedBy;
  set openedBy(AdminOrderDtoOutputOrderPickupDisputeOpenedByEnum? openedBy) =>
      _$this._openedBy = openedBy;

  AdminOrderDtoOutputOrderPickupDisputeBuilder() {
    AdminOrderDtoOutputOrderPickupDispute._defaults(this);
  }

  AdminOrderDtoOutputOrderPickupDisputeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _accountId = $v.accountId;
      _device = $v.device;
      _receivedLines = $v.receivedLines.toBuilder();
      _openedBy = $v.openedBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderPickupDispute other) {
    _$v = other as _$AdminOrderDtoOutputOrderPickupDispute;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderPickupDisputeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderPickupDispute build() => _build();

  _$AdminOrderDtoOutputOrderPickupDispute _build() {
    _$AdminOrderDtoOutputOrderPickupDispute _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderPickupDispute._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'at',
            ),
            accountId: BuiltValueNullFieldError.checkNotNull(
              accountId,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'accountId',
            ),
            device: BuiltValueNullFieldError.checkNotNull(
              device,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'device',
            ),
            receivedLines: receivedLines.build(),
            openedBy: BuiltValueNullFieldError.checkNotNull(
              openedBy,
              r'AdminOrderDtoOutputOrderPickupDispute',
              'openedBy',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receivedLines';
        receivedLines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderPickupDispute',
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
