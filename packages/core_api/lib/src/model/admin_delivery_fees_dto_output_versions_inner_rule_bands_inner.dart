//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output_versions_inner_rule_bands_inner.g.dart';

/// AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner
///
/// Properties:
/// * [upToMetres] - The band's upper edge in metres, included; null for the last band.
/// * [fee]
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner
    implements
        Built<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder
        > {
  /// The band's upper edge in metres, included; null for the last band.
  @BuiltValueField(wireName: r'upToMetres')
  int? get upToMetres;

  @BuiltValueField(wireName: r'fee')
  String get fee;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner._();

  factory AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner([
    void updates(
      AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder b,
    ),
  ]) = _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>
  get serializer =>
      _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerSerializer();
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner,
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner,
  ];

  @override
  final String wireName =
      r'AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner object, {
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
    AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner object, {
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
    required AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder
    result,
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
  AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInnerBuilder();
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
