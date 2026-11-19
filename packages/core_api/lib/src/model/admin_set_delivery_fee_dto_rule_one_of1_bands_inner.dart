//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_delivery_fee_dto_rule_one_of1_bands_inner.g.dart';

/// AdminSetDeliveryFeeDtoRuleOneOf1BandsInner
///
/// Properties:
/// * [upToMetres] - The band's upper edge in metres, included; null for the last band.
/// * [fee]
@BuiltValue()
abstract class AdminSetDeliveryFeeDtoRuleOneOf1BandsInner
    implements
        Built<
          AdminSetDeliveryFeeDtoRuleOneOf1BandsInner,
          AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder
        > {
  /// The band's upper edge in metres, included; null for the last band.
  @BuiltValueField(wireName: r'upToMetres')
  int? get upToMetres;

  @BuiltValueField(wireName: r'fee')
  String get fee;

  AdminSetDeliveryFeeDtoRuleOneOf1BandsInner._();

  factory AdminSetDeliveryFeeDtoRuleOneOf1BandsInner([
    void updates(AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder b),
  ]) = _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner>
  get serializer => _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerSerializer();
}

class _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner> {
  @override
  final Iterable<Type> types = const [
    AdminSetDeliveryFeeDtoRuleOneOf1BandsInner,
    _$AdminSetDeliveryFeeDtoRuleOneOf1BandsInner,
  ];

  @override
  final String wireName = r'AdminSetDeliveryFeeDtoRuleOneOf1BandsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleOneOf1BandsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'upToMetres';
    yield object.upToMetres == null
        ? null
        : serializers.serialize(
            object.upToMetres,
            specifiedType: const FullType.nullable(int),
          );
    yield r'fee';
    yield serializers.serialize(
      object.fee,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleOneOf1BandsInner object, {
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
    required AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'upToMetres':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.upToMetres = valueDes;
          break;
        case r'fee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fee = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetDeliveryFeeDtoRuleOneOf1BandsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetDeliveryFeeDtoRuleOneOf1BandsInnerBuilder();
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
