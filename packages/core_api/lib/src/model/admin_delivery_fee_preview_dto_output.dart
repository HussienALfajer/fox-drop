//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_delivery_fee_preview_dto_output_distance.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fee_preview_dto_output.g.dart';

/// AdminDeliveryFeePreviewDtoOutput
///
/// Properties:
/// * [fee]
/// * [currency]
/// * [free] - The free-delivery threshold reached.
/// * [scope] - The city's rule or the restaurant's own.
/// * [ruleId]
/// * [freeDeliveryFrom]
/// * [distance]
/// * [covers] - Whether the restaurant delivers to the point (CU §8).
/// * [zoneName] - The active zone at the point; null outside.
@BuiltValue()
abstract class AdminDeliveryFeePreviewDtoOutput
    implements
        Built<
          AdminDeliveryFeePreviewDtoOutput,
          AdminDeliveryFeePreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'fee')
  String get fee;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// The free-delivery threshold reached.
  @BuiltValueField(wireName: r'free')
  bool get free;

  /// The city's rule or the restaurant's own.
  @BuiltValueField(wireName: r'scope')
  AdminDeliveryFeePreviewDtoOutputScopeEnum get scope;
  // enum scopeEnum {  city,  restaurant,  };

  @BuiltValueField(wireName: r'ruleId')
  String get ruleId;

  @BuiltValueField(wireName: r'freeDeliveryFrom')
  String? get freeDeliveryFrom;

  @BuiltValueField(wireName: r'distance')
  AdminDeliveryFeePreviewDtoOutputDistance get distance;

  /// Whether the restaurant delivers to the point (CU §8).
  @BuiltValueField(wireName: r'covers')
  bool get covers;

  /// The active zone at the point; null outside.
  @BuiltValueField(wireName: r'zoneName')
  String? get zoneName;

  AdminDeliveryFeePreviewDtoOutput._();

  factory AdminDeliveryFeePreviewDtoOutput([
    void updates(AdminDeliveryFeePreviewDtoOutputBuilder b),
  ]) = _$AdminDeliveryFeePreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeliveryFeePreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeePreviewDtoOutput> get serializer =>
      _$AdminDeliveryFeePreviewDtoOutputSerializer();
}

class _$AdminDeliveryFeePreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminDeliveryFeePreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeePreviewDtoOutput,
    _$AdminDeliveryFeePreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminDeliveryFeePreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeePreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fee';
    yield serializers.serialize(
      object.fee,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'free';
    yield serializers.serialize(
      object.free,
      specifiedType: const FullType(bool),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(AdminDeliveryFeePreviewDtoOutputScopeEnum),
    );
    yield r'ruleId';
    yield serializers.serialize(
      object.ruleId,
      specifiedType: const FullType(String),
    );
    yield r'freeDeliveryFrom';
    yield object.freeDeliveryFrom == null
        ? null
        : serializers.serialize(
            object.freeDeliveryFrom,
            specifiedType: const FullType.nullable(String),
          );
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(AdminDeliveryFeePreviewDtoOutputDistance),
    );
    yield r'covers';
    yield serializers.serialize(
      object.covers,
      specifiedType: const FullType(bool),
    );
    yield r'zoneName';
    yield object.zoneName == null
        ? null
        : serializers.serialize(
            object.zoneName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeePreviewDtoOutput object, {
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
    required AdminDeliveryFeePreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fee = valueDes;
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
        case r'free':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.free = valueDes;
          break;
        case r'scope':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeePreviewDtoOutputScopeEnum,
                    ),
                  )
                  as AdminDeliveryFeePreviewDtoOutputScopeEnum;
          result.scope = valueDes;
          break;
        case r'ruleId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ruleId = valueDes;
          break;
        case r'freeDeliveryFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.freeDeliveryFrom = valueDes;
          break;
        case r'distance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeePreviewDtoOutputDistance,
                    ),
                  )
                  as AdminDeliveryFeePreviewDtoOutputDistance;
          result.distance.replace(valueDes);
          break;
        case r'covers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.covers = valueDes;
          break;
        case r'zoneName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeliveryFeePreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeePreviewDtoOutputBuilder();
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

/// The city's rule or the restaurant's own.
class AdminDeliveryFeePreviewDtoOutputScopeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'city')
  static const AdminDeliveryFeePreviewDtoOutputScopeEnum city =
      _$adminDeliveryFeePreviewDtoOutputScopeEnum_city;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminDeliveryFeePreviewDtoOutputScopeEnum restaurant =
      _$adminDeliveryFeePreviewDtoOutputScopeEnum_restaurant;

  static Serializer<AdminDeliveryFeePreviewDtoOutputScopeEnum> get serializer =>
      _$adminDeliveryFeePreviewDtoOutputScopeEnumSerializer;

  const AdminDeliveryFeePreviewDtoOutputScopeEnum._(String name) : super(name);

  static BuiltSet<AdminDeliveryFeePreviewDtoOutputScopeEnum> get values =>
      _$adminDeliveryFeePreviewDtoOutputScopeEnumValues;
  static AdminDeliveryFeePreviewDtoOutputScopeEnum valueOf(String name) =>
      _$adminDeliveryFeePreviewDtoOutputScopeEnumValueOf(name);
}
