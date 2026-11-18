// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_checklist_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_record =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('record');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_commission =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('commission');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_contract =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('contract');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_hours =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('hours');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_menu =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('menu');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_menuImages =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('menuImages');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_ownerAccount =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('ownerAccount');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_deviceCheck =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('deviceCheck');
const AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnum_testOrder =
    const AdminChecklistDtoOutputItemsInnerCodeEnum._('testOrder');

AdminChecklistDtoOutputItemsInnerCodeEnum
_$adminChecklistDtoOutputItemsInnerCodeEnumValueOf(String name) {
  switch (name) {
    case 'record':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_record;
    case 'commission':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_commission;
    case 'contract':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_contract;
    case 'hours':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_hours;
    case 'menu':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_menu;
    case 'menuImages':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_menuImages;
    case 'ownerAccount':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_ownerAccount;
    case 'deviceCheck':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_deviceCheck;
    case 'testOrder':
      return _$adminChecklistDtoOutputItemsInnerCodeEnum_testOrder;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChecklistDtoOutputItemsInnerCodeEnum>
_$adminChecklistDtoOutputItemsInnerCodeEnumValues =
    BuiltSet<AdminChecklistDtoOutputItemsInnerCodeEnum>(
      const <AdminChecklistDtoOutputItemsInnerCodeEnum>[
        _$adminChecklistDtoOutputItemsInnerCodeEnum_record,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_commission,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_contract,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_hours,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_menu,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_menuImages,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_ownerAccount,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_deviceCheck,
        _$adminChecklistDtoOutputItemsInnerCodeEnum_testOrder,
      ],
    );

const AdminChecklistDtoOutputItemsInnerStateEnum
_$adminChecklistDtoOutputItemsInnerStateEnum_met =
    const AdminChecklistDtoOutputItemsInnerStateEnum._('met');
const AdminChecklistDtoOutputItemsInnerStateEnum
_$adminChecklistDtoOutputItemsInnerStateEnum_missing =
    const AdminChecklistDtoOutputItemsInnerStateEnum._('missing');
const AdminChecklistDtoOutputItemsInnerStateEnum
_$adminChecklistDtoOutputItemsInnerStateEnum_waived =
    const AdminChecklistDtoOutputItemsInnerStateEnum._('waived');
const AdminChecklistDtoOutputItemsInnerStateEnum
_$adminChecklistDtoOutputItemsInnerStateEnum_notAvailable =
    const AdminChecklistDtoOutputItemsInnerStateEnum._('notAvailable');

AdminChecklistDtoOutputItemsInnerStateEnum
_$adminChecklistDtoOutputItemsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'met':
      return _$adminChecklistDtoOutputItemsInnerStateEnum_met;
    case 'missing':
      return _$adminChecklistDtoOutputItemsInnerStateEnum_missing;
    case 'waived':
      return _$adminChecklistDtoOutputItemsInnerStateEnum_waived;
    case 'notAvailable':
      return _$adminChecklistDtoOutputItemsInnerStateEnum_notAvailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChecklistDtoOutputItemsInnerStateEnum>
_$adminChecklistDtoOutputItemsInnerStateEnumValues =
    BuiltSet<AdminChecklistDtoOutputItemsInnerStateEnum>(
      const <AdminChecklistDtoOutputItemsInnerStateEnum>[
        _$adminChecklistDtoOutputItemsInnerStateEnum_met,
        _$adminChecklistDtoOutputItemsInnerStateEnum_missing,
        _$adminChecklistDtoOutputItemsInnerStateEnum_waived,
        _$adminChecklistDtoOutputItemsInnerStateEnum_notAvailable,
      ],
    );

Serializer<AdminChecklistDtoOutputItemsInnerCodeEnum>
_$adminChecklistDtoOutputItemsInnerCodeEnumSerializer =
    _$AdminChecklistDtoOutputItemsInnerCodeEnumSerializer();
Serializer<AdminChecklistDtoOutputItemsInnerStateEnum>
_$adminChecklistDtoOutputItemsInnerStateEnumSerializer =
    _$AdminChecklistDtoOutputItemsInnerStateEnumSerializer();

class _$AdminChecklistDtoOutputItemsInnerCodeEnumSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutputItemsInnerCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'record': 'record',
    'commission': 'commission',
    'contract': 'contract',
    'hours': 'hours',
    'menu': 'menu',
    'menuImages': 'menu_images',
    'ownerAccount': 'owner_account',
    'deviceCheck': 'device_check',
    'testOrder': 'test_order',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'record': 'record',
    'commission': 'commission',
    'contract': 'contract',
    'hours': 'hours',
    'menu': 'menu',
    'menu_images': 'menuImages',
    'owner_account': 'ownerAccount',
    'device_check': 'deviceCheck',
    'test_order': 'testOrder',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminChecklistDtoOutputItemsInnerCodeEnum,
  ];
  @override
  final String wireName = 'AdminChecklistDtoOutputItemsInnerCodeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutputItemsInnerCodeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChecklistDtoOutputItemsInnerCodeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChecklistDtoOutputItemsInnerCodeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChecklistDtoOutputItemsInnerStateEnumSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutputItemsInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'met': 'met',
    'missing': 'missing',
    'waived': 'waived',
    'notAvailable': 'not_available',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'met': 'met',
    'missing': 'missing',
    'waived': 'waived',
    'not_available': 'notAvailable',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminChecklistDtoOutputItemsInnerStateEnum,
  ];
  @override
  final String wireName = 'AdminChecklistDtoOutputItemsInnerStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutputItemsInnerStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChecklistDtoOutputItemsInnerStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChecklistDtoOutputItemsInnerStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChecklistDtoOutputItemsInner
    extends AdminChecklistDtoOutputItemsInner {
  @override
  final AdminChecklistDtoOutputItemsInnerCodeEnum code;
  @override
  final AdminChecklistDtoOutputItemsInnerStateEnum state;

  factory _$AdminChecklistDtoOutputItemsInner([
    void Function(AdminChecklistDtoOutputItemsInnerBuilder)? updates,
  ]) => (AdminChecklistDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminChecklistDtoOutputItemsInner._({
    required this.code,
    required this.state,
  }) : super._();
  @override
  AdminChecklistDtoOutputItemsInner rebuild(
    void Function(AdminChecklistDtoOutputItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChecklistDtoOutputItemsInnerBuilder toBuilder() =>
      AdminChecklistDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChecklistDtoOutputItemsInner &&
        code == other.code &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChecklistDtoOutputItemsInner')
          ..add('code', code)
          ..add('state', state))
        .toString();
  }
}

class AdminChecklistDtoOutputItemsInnerBuilder
    implements
        Builder<
          AdminChecklistDtoOutputItemsInner,
          AdminChecklistDtoOutputItemsInnerBuilder
        > {
  _$AdminChecklistDtoOutputItemsInner? _$v;

  AdminChecklistDtoOutputItemsInnerCodeEnum? _code;
  AdminChecklistDtoOutputItemsInnerCodeEnum? get code => _$this._code;
  set code(AdminChecklistDtoOutputItemsInnerCodeEnum? code) =>
      _$this._code = code;

  AdminChecklistDtoOutputItemsInnerStateEnum? _state;
  AdminChecklistDtoOutputItemsInnerStateEnum? get state => _$this._state;
  set state(AdminChecklistDtoOutputItemsInnerStateEnum? state) =>
      _$this._state = state;

  AdminChecklistDtoOutputItemsInnerBuilder() {
    AdminChecklistDtoOutputItemsInner._defaults(this);
  }

  AdminChecklistDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _state = $v.state;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChecklistDtoOutputItemsInner other) {
    _$v = other as _$AdminChecklistDtoOutputItemsInner;
  }

  @override
  void update(
    void Function(AdminChecklistDtoOutputItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminChecklistDtoOutputItemsInner build() => _build();

  _$AdminChecklistDtoOutputItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminChecklistDtoOutputItemsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminChecklistDtoOutputItemsInner',
            'code',
          ),
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'AdminChecklistDtoOutputItemsInner',
            'state',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
