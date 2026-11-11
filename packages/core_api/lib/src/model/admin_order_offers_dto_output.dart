//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_offers_dto_output_offers_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_offers_dto_output.g.dart';

/// AdminOrderOffersDtoOutput
///
/// Properties:
/// * [offers] - Every offer of the order, oldest first (AP §9.3.1, §9.7.4).
@BuiltValue()
abstract class AdminOrderOffersDtoOutput
    implements
        Built<AdminOrderOffersDtoOutput, AdminOrderOffersDtoOutputBuilder> {
  /// Every offer of the order, oldest first (AP §9.3.1, §9.7.4).
  @BuiltValueField(wireName: r'offers')
  BuiltList<AdminOrderOffersDtoOutputOffersInner> get offers;

  AdminOrderOffersDtoOutput._();

  factory AdminOrderOffersDtoOutput([
    void updates(AdminOrderOffersDtoOutputBuilder b),
  ]) = _$AdminOrderOffersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderOffersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderOffersDtoOutput> get serializer =>
      _$AdminOrderOffersDtoOutputSerializer();
}

class _$AdminOrderOffersDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderOffersDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderOffersDtoOutput,
    _$AdminOrderOffersDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderOffersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderOffersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'offers';
    yield serializers.serialize(
      object.offers,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderOffersDtoOutputOffersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderOffersDtoOutput object, {
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
    required AdminOrderOffersDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'offers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderOffersDtoOutputOffersInner),
                    ]),
                  )
                  as BuiltList<AdminOrderOffersDtoOutputOffersInner>;
          result.offers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderOffersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderOffersDtoOutputBuilder();
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
