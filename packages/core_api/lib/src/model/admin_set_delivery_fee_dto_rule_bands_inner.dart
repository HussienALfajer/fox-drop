//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_delivery_fee_dto_rule_bands_inner.g.dart';

/// AdminSetDeliveryFeeDtoRuleBandsInner
///
/// Properties:
/// * [upToMetres] - The band's upper edge in metres, included; null for the last band.
/// * [fee]
@BuiltValue()
abstract class AdminSetDeliveryFeeDtoRuleBandsInner
    implements
        Built<
          AdminSetDeliveryFeeDtoRuleBandsInner,
          AdminSetDeliveryFeeDtoRuleBandsInnerBuilder
        > {
  /// The band's upper edge in metres, included; null for the last band.
  @BuiltValueField(wireName: r'upToMetres')
  int? get upToMetres;

  @BuiltValueField(wireName: r'fee')
  String get fee;

  AdminSetDeliveryFeeDtoRuleBandsInner._();

  factory AdminSetDeliveryFeeDtoRuleBandsInner([
    void updates(AdminSetDeliveryFeeDtoRuleBandsInnerBuilder b),
  ]) = _$AdminSetDeliveryFeeDtoRuleBandsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetDeliveryFeeDtoRuleBandsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetDeliveryFeeDtoRuleBandsInner> get serializer =>
      _$AdminSetDeliveryFeeDtoRuleBandsInnerSerializer();
}

class _$AdminSetDeliveryFeeDtoRuleBandsInnerSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleBandsInner> {
  @override
  final Iterable<Type> types = const [
    AdminSetDeliveryFeeDtoRuleBandsInner,
    _$AdminSetDeliveryFeeDtoRuleBandsInner,
  ];

  @override
  final String wireName = r'AdminSetDeliveryFeeDtoRuleBandsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleBandsInner object, {
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
    AdminSetDeliveryFeeDtoRuleBandsInner object, {
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
    required AdminSetDeliveryFeeDtoRuleBandsInnerBuilder result,
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
  AdminSetDeliveryFeeDtoRuleBandsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetDeliveryFeeDtoRuleBandsInnerBuilder();
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
