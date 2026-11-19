// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fee_preview_dto_output_distance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum
_$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_road =
    const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum._('road');
const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum
_$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_straightX1Period3 =
    const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum._(
      'straightX1Period3',
    );

AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum
_$adminDeliveryFeePreviewDtoOutputDistanceMethodEnumValueOf(String name) {
  switch (name) {
    case 'road':
      return _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_road;
    case 'straightX1Period3':
      return _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_straightX1Period3;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum>
_$adminDeliveryFeePreviewDtoOutputDistanceMethodEnumValues =
    BuiltSet<AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum>(
      const <AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum>[
        _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_road,
        _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_straightX1Period3,
      ],
    );

Serializer<AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum>
_$adminDeliveryFeePreviewDtoOutputDistanceMethodEnumSerializer =
    _$AdminDeliveryFeePreviewDtoOutputDistanceMethodEnumSerializer();

class _$AdminDeliveryFeePreviewDtoOutputDistanceMethodEnumSerializer
    implements
        PrimitiveSerializer<
          AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'road': 'road',
    'straightX1Period3': 'straight_x1.3',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'road': 'road',
    'straight_x1.3': 'straightX1Period3',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum,
  ];
  @override
  final String wireName = 'AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeliveryFeePreviewDtoOutputDistance
    extends AdminDeliveryFeePreviewDtoOutputDistance {
  @override
  final int metres;
  @override
  final AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum method;

  factory _$AdminDeliveryFeePreviewDtoOutputDistance([
    void Function(AdminDeliveryFeePreviewDtoOutputDistanceBuilder)? updates,
  ]) => (AdminDeliveryFeePreviewDtoOutputDistanceBuilder()..update(updates))
      ._build();

  _$AdminDeliveryFeePreviewDtoOutputDistance._({
    required this.metres,
    required this.method,
  }) : super._();
  @override
  AdminDeliveryFeePreviewDtoOutputDistance rebuild(
    void Function(AdminDeliveryFeePreviewDtoOutputDistanceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeePreviewDtoOutputDistanceBuilder toBuilder() =>
      AdminDeliveryFeePreviewDtoOutputDistanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeePreviewDtoOutputDistance &&
        metres == other.metres &&
        method == other.method;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metres.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDeliveryFeePreviewDtoOutputDistance',
          )
          ..add('metres', metres)
          ..add('method', method))
        .toString();
  }
}

class AdminDeliveryFeePreviewDtoOutputDistanceBuilder
    implements
        Builder<
          AdminDeliveryFeePreviewDtoOutputDistance,
          AdminDeliveryFeePreviewDtoOutputDistanceBuilder
        > {
  _$AdminDeliveryFeePreviewDtoOutputDistance? _$v;

  int? _metres;
  int? get metres => _$this._metres;
  set metres(int? metres) => _$this._metres = metres;

  AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum? _method;
  AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum? get method =>
      _$this._method;
  set method(AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum? method) =>
      _$this._method = method;

  AdminDeliveryFeePreviewDtoOutputDistanceBuilder() {
    AdminDeliveryFeePreviewDtoOutputDistance._defaults(this);
  }

  AdminDeliveryFeePreviewDtoOutputDistanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metres = $v.metres;
      _method = $v.method;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeePreviewDtoOutputDistance other) {
    _$v = other as _$AdminDeliveryFeePreviewDtoOutputDistance;
  }

  @override
  void update(
    void Function(AdminDeliveryFeePreviewDtoOutputDistanceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeePreviewDtoOutputDistance build() => _build();

  _$AdminDeliveryFeePreviewDtoOutputDistance _build() {
    final _$result =
        _$v ??
        _$AdminDeliveryFeePreviewDtoOutputDistance._(
          metres: BuiltValueNullFieldError.checkNotNull(
            metres,
            r'AdminDeliveryFeePreviewDtoOutputDistance',
            'metres',
          ),
          method: BuiltValueNullFieldError.checkNotNull(
            method,
            r'AdminDeliveryFeePreviewDtoOutputDistance',
            'method',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
