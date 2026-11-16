//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_exchange_rate_dto.g.dart';

/// AdminSetExchangeRateDto
///
/// Properties:
/// * [cityId]
/// * [currency]
/// * [value] - A decimal such as 41.20.
/// * [direction] - «1 USD = 41.20 TRY» is base_per_unit, «1 TRY = 290 SYP» units_per_base.
/// * [reason]
/// * [confirmLargeChange] - The second confirmation of a change above fx.large_change_confirm_pct.
@BuiltValue()
abstract class AdminSetExchangeRateDto
    implements Built<AdminSetExchangeRateDto, AdminSetExchangeRateDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// A decimal such as 41.20.
  @BuiltValueField(wireName: r'value')
  String get value;

  /// «1 USD = 41.20 TRY» is base_per_unit, «1 TRY = 290 SYP» units_per_base.
  @BuiltValueField(wireName: r'direction')
  AdminSetExchangeRateDtoDirectionEnum get direction;
  // enum directionEnum {  base_per_unit,  units_per_base,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// The second confirmation of a change above fx.large_change_confirm_pct.
  @BuiltValueField(wireName: r'confirmLargeChange')
  bool? get confirmLargeChange;

  AdminSetExchangeRateDto._();

  factory AdminSetExchangeRateDto([
    void updates(AdminSetExchangeRateDtoBuilder b),
  ]) = _$AdminSetExchangeRateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetExchangeRateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetExchangeRateDto> get serializer =>
      _$AdminSetExchangeRateDtoSerializer();
}

class _$AdminSetExchangeRateDtoSerializer
    implements PrimitiveSerializer<AdminSetExchangeRateDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetExchangeRateDto,
    _$AdminSetExchangeRateDto,
  ];

  @override
  final String wireName = r'AdminSetExchangeRateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetExchangeRateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(AdminSetExchangeRateDtoDirectionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.confirmLargeChange != null) {
      yield r'confirmLargeChange';
      yield serializers.serialize(
        object.confirmLargeChange,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetExchangeRateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSetExchangeRateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.value = valueDes;
          break;
        case r'direction':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSetExchangeRateDtoDirectionEnum,
                    ),
                  )
                  as AdminSetExchangeRateDtoDirectionEnum;
          result.direction = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'confirmLargeChange':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.confirmLargeChange = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetExchangeRateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetExchangeRateDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

/// «1 USD = 41.20 TRY» is base_per_unit, «1 TRY = 290 SYP» units_per_base.
class AdminSetExchangeRateDtoDirectionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'base_per_unit')
  static const AdminSetExchangeRateDtoDirectionEnum basePerUnit =
      _$adminSetExchangeRateDtoDirectionEnum_basePerUnit;
  @BuiltValueEnumConst(wireName: r'units_per_base')
  static const AdminSetExchangeRateDtoDirectionEnum unitsPerBase =
      _$adminSetExchangeRateDtoDirectionEnum_unitsPerBase;

  static Serializer<AdminSetExchangeRateDtoDirectionEnum> get serializer =>
      _$adminSetExchangeRateDtoDirectionEnumSerializer;

  const AdminSetExchangeRateDtoDirectionEnum._(String name) : super(name);

  static BuiltSet<AdminSetExchangeRateDtoDirectionEnum> get values =>
      _$adminSetExchangeRateDtoDirectionEnumValues;
  static AdminSetExchangeRateDtoDirectionEnum valueOf(String name) =>
      _$adminSetExchangeRateDtoDirectionEnumValueOf(name);
}
