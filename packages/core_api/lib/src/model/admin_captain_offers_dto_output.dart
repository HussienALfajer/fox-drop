//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_offers_dto_output_offers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_offers_dto_output.g.dart';

/// AdminCaptainOffersDtoOutput
///
/// Properties:
/// * [offers] - The latest 200, newest first.
@BuiltValue()
abstract class AdminCaptainOffersDtoOutput
    implements
        Built<AdminCaptainOffersDtoOutput, AdminCaptainOffersDtoOutputBuilder> {
  /// The latest 200, newest first.
  @BuiltValueField(wireName: r'offers')
  BuiltList<AdminCaptainOffersDtoOutputOffersInner> get offers;

  AdminCaptainOffersDtoOutput._();

  factory AdminCaptainOffersDtoOutput([
    void updates(AdminCaptainOffersDtoOutputBuilder b),
  ]) = _$AdminCaptainOffersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainOffersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainOffersDtoOutput> get serializer =>
      _$AdminCaptainOffersDtoOutputSerializer();
}

class _$AdminCaptainOffersDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainOffersDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainOffersDtoOutput,
    _$AdminCaptainOffersDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainOffersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainOffersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'offers';
    yield serializers.serialize(
      object.offers,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainOffersDtoOutputOffersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainOffersDtoOutput object, {
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
    required AdminCaptainOffersDtoOutputBuilder result,
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
                      FullType(AdminCaptainOffersDtoOutputOffersInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainOffersDtoOutputOffersInner>;
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
  AdminCaptainOffersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainOffersDtoOutputBuilder();
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
