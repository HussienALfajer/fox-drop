//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_set_delivery_fee_dto_rule.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_delivery_fee_dto.g.dart';

/// AdminSetDeliveryFeeDto
///
/// Properties:
/// * [cityId]
/// * [rule]
/// * [reason]
@BuiltValue()
abstract class AdminSetDeliveryFeeDto
    implements Built<AdminSetDeliveryFeeDto, AdminSetDeliveryFeeDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'rule')
  AdminSetDeliveryFeeDtoRule get rule;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminSetDeliveryFeeDto._();

  factory AdminSetDeliveryFeeDto([
    void updates(AdminSetDeliveryFeeDtoBuilder b),
  ]) = _$AdminSetDeliveryFeeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetDeliveryFeeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetDeliveryFeeDto> get serializer =>
      _$AdminSetDeliveryFeeDtoSerializer();
}

class _$AdminSetDeliveryFeeDtoSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetDeliveryFeeDto,
    _$AdminSetDeliveryFeeDto,
  ];

  @override
  final String wireName = r'AdminSetDeliveryFeeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetDeliveryFeeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'rule';
    yield serializers.serialize(
      object.rule,
      specifiedType: const FullType(AdminSetDeliveryFeeDtoRule),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDto object, {
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
    required AdminSetDeliveryFeeDtoBuilder result,
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
        case r'rule':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminSetDeliveryFeeDtoRule),
                  )
                  as AdminSetDeliveryFeeDtoRule;
          result.rule.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetDeliveryFeeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetDeliveryFeeDtoBuilder();
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
