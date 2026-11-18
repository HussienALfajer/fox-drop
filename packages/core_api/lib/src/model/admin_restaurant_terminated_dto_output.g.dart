// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_terminated_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantTerminatedDtoOutputAccountStatusEnum
_$adminRestaurantTerminatedDtoOutputAccountStatusEnum_terminated =
    const AdminRestaurantTerminatedDtoOutputAccountStatusEnum._('terminated');

AdminRestaurantTerminatedDtoOutputAccountStatusEnum
_$adminRestaurantTerminatedDtoOutputAccountStatusEnumValueOf(String name) {
  switch (name) {
    case 'terminated':
      return _$adminRestaurantTerminatedDtoOutputAccountStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantTerminatedDtoOutputAccountStatusEnum>
_$adminRestaurantTerminatedDtoOutputAccountStatusEnumValues =
    BuiltSet<AdminRestaurantTerminatedDtoOutputAccountStatusEnum>(
      const <AdminRestaurantTerminatedDtoOutputAccountStatusEnum>[
        _$adminRestaurantTerminatedDtoOutputAccountStatusEnum_terminated,
      ],
    );

Serializer<AdminRestaurantTerminatedDtoOutputAccountStatusEnum>
_$adminRestaurantTerminatedDtoOutputAccountStatusEnumSerializer =
    _$AdminRestaurantTerminatedDtoOutputAccountStatusEnumSerializer();

class _$AdminRestaurantTerminatedDtoOutputAccountStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantTerminatedDtoOutputAccountStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantTerminatedDtoOutputAccountStatusEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantTerminatedDtoOutputAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantTerminatedDtoOutputAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantTerminatedDtoOutputAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantTerminatedDtoOutputAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantTerminatedDtoOutput
    extends AdminRestaurantTerminatedDtoOutput {
  @override
  final String restaurantId;
  @override
  final AdminRestaurantTerminatedDtoOutputAccountStatusEnum accountStatus;

  factory _$AdminRestaurantTerminatedDtoOutput([
    void Function(AdminRestaurantTerminatedDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantTerminatedDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantTerminatedDtoOutput._({
    required this.restaurantId,
    required this.accountStatus,
  }) : super._();
  @override
  AdminRestaurantTerminatedDtoOutput rebuild(
    void Function(AdminRestaurantTerminatedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantTerminatedDtoOutputBuilder toBuilder() =>
      AdminRestaurantTerminatedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantTerminatedDtoOutput &&
        restaurantId == other.restaurantId &&
        accountStatus == other.accountStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantTerminatedDtoOutput')
          ..add('restaurantId', restaurantId)
          ..add('accountStatus', accountStatus))
        .toString();
  }
}

class AdminRestaurantTerminatedDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantTerminatedDtoOutput,
          AdminRestaurantTerminatedDtoOutputBuilder
        > {
  _$AdminRestaurantTerminatedDtoOutput? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  AdminRestaurantTerminatedDtoOutputAccountStatusEnum? _accountStatus;
  AdminRestaurantTerminatedDtoOutputAccountStatusEnum? get accountStatus =>
      _$this._accountStatus;
  set accountStatus(
    AdminRestaurantTerminatedDtoOutputAccountStatusEnum? accountStatus,
  ) => _$this._accountStatus = accountStatus;

  AdminRestaurantTerminatedDtoOutputBuilder() {
    AdminRestaurantTerminatedDtoOutput._defaults(this);
  }

  AdminRestaurantTerminatedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _accountStatus = $v.accountStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantTerminatedDtoOutput other) {
    _$v = other as _$AdminRestaurantTerminatedDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantTerminatedDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantTerminatedDtoOutput build() => _build();

  _$AdminRestaurantTerminatedDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantTerminatedDtoOutput._(
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'AdminRestaurantTerminatedDtoOutput',
            'restaurantId',
          ),
          accountStatus: BuiltValueNullFieldError.checkNotNull(
            accountStatus,
            r'AdminRestaurantTerminatedDtoOutput',
            'accountStatus',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
