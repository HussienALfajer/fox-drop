// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_outcome_change_foods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_keptByCaptain =
    const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum._(
      'keptByCaptain',
    );
const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_returnedToRestaurant =
    const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum._(
      'returnedToRestaurant',
    );
const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_destroyed =
    const AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum._(
      'destroyed',
    );

AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumValueOf(String name) {
  switch (name) {
    case 'keptByCaptain':
      return _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_returnedToRestaurant;
    case 'destroyed':
      return _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum>
_$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum>(const <
      AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
    >[
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_keptByCaptain,
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_returnedToRestaurant,
      _$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum_destroyed,
    ]);

Serializer<AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum>
_$adminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumSerializer =
    _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumSerializer();

class _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'keptByCaptain': 'kept_by_captain',
    'returnedToRestaurant': 'returned_to_restaurant',
    'destroyed': 'destroyed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'kept_by_captain': 'keptByCaptain',
    'returned_to_restaurant': 'returnedToRestaurant',
    'destroyed': 'destroyed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner
    extends AdminOrderDtoOutputOrderOutcomeChangeFoodsInner {
  @override
  final AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum code;
  @override
  final String label;

  factory _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner([
    void Function(AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInner rebuild(
    void Function(AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOutcomeChangeFoodsInner &&
        code == other.code &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderOutcomeChangeFoodsInner',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOutcomeChangeFoodsInner,
          AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner? _$v;

  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum? _code;
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum? get code =>
      _$this._code;
  set code(AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerCodeEnum? code) =>
      _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder() {
    AdminOrderDtoOutputOrderOutcomeChangeFoodsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderOutcomeChangeFoodsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderOutcomeChangeFoodsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOutcomeChangeFoodsInner build() => _build();

  _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderOutcomeChangeFoodsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminOrderDtoOutputOrderOutcomeChangeFoodsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderOutcomeChangeFoodsInner',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
