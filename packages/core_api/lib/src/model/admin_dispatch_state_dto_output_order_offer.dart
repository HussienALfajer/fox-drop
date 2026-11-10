//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dispatch_state_dto_output_order_offer.g.dart';

/// The open offer, while the captain decides (CA §8.4).
///
/// Properties:
/// * [id]
/// * [captainId]
/// * [expiresAt]
/// * [handover] - «استلام من كابتن» (AP §9.3.2, CA §9.10.1).
@BuiltValue()
abstract class AdminDispatchStateDtoOutputOrderOffer
    implements
        Built<
          AdminDispatchStateDtoOutputOrderOffer,
          AdminDispatchStateDtoOutputOrderOfferBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  /// «استلام من كابتن» (AP §9.3.2, CA §9.10.1).
  @BuiltValueField(wireName: r'handover')
  bool get handover;

  AdminDispatchStateDtoOutputOrderOffer._();

  factory AdminDispatchStateDtoOutputOrderOffer([
    void updates(AdminDispatchStateDtoOutputOrderOfferBuilder b),
  ]) = _$AdminDispatchStateDtoOutputOrderOffer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDispatchStateDtoOutputOrderOfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDispatchStateDtoOutputOrderOffer> get serializer =>
      _$AdminDispatchStateDtoOutputOrderOfferSerializer();
}

class _$AdminDispatchStateDtoOutputOrderOfferSerializer
    implements PrimitiveSerializer<AdminDispatchStateDtoOutputOrderOffer> {
  @override
  final Iterable<Type> types = const [
    AdminDispatchStateDtoOutputOrderOffer,
    _$AdminDispatchStateDtoOutputOrderOffer,
  ];

  @override
  final String wireName = r'AdminDispatchStateDtoOutputOrderOffer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDispatchStateDtoOutputOrderOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'handover';
    yield serializers.serialize(
      object.handover,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDispatchStateDtoOutputOrderOffer object, {
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
    required AdminDispatchStateDtoOutputOrderOfferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'handover':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.handover = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDispatchStateDtoOutputOrderOffer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDispatchStateDtoOutputOrderOfferBuilder();
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
