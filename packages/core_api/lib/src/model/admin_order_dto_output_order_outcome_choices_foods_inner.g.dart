// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_outcome_choices_foods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_keptByCaptain =
    const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum._(
      'keptByCaptain',
    );
const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_returnedToRestaurant =
    const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum._(
      'returnedToRestaurant',
    );
const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_destroyed =
    const AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum._(
      'destroyed',
    );

AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
_$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumValueOf(String name) {
  switch (name) {
    case 'keptByCaptain':
      return _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_returnedToRestaurant;
    case 'destroyed':
      return _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum>
_$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum>(const <
      AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
    >[
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_keptByCaptain,
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_returnedToRestaurant,
      _$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum_destroyed,
    ]);

Serializer<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum>
_$adminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumSerializer =
    _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumSerializer();

class _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum
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
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner
    extends AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner {
  @override
  final AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum code;
  @override
  final String label;

  factory _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner([
    void Function(AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner._({
    required this.code,
    required this.label,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner rebuild(
    void Function(AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner &&
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
            r'AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner',
          )
          ..add('code', code)
          ..add('label', label))
        .toString();
  }
}

class AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner,
          AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner? _$v;

  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum? _code;
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum? get code =>
      _$this._code;
  set code(AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerCodeEnum? code) =>
      _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder() {
    AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderOutcomeChoicesFoodsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner build() => _build();

  _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner',
            'label',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
