//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_timeline_inner_actor.g.dart';

/// AdminOrderDtoOutputOrderTimelineInnerActor
///
/// Properties:
/// * [type] 
/// * [id] 
@BuiltValue()
abstract class AdminOrderDtoOutputOrderTimelineInnerActor implements Built<AdminOrderDtoOutputOrderTimelineInnerActor, AdminOrderDtoOutputOrderTimelineInnerActorBuilder> {
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'id')
  String? get id;

  AdminOrderDtoOutputOrderTimelineInnerActor._();

  factory AdminOrderDtoOutputOrderTimelineInnerActor([void updates(AdminOrderDtoOutputOrderTimelineInnerActorBuilder b)]) = _$AdminOrderDtoOutputOrderTimelineInnerActor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderTimelineInnerActorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderTimelineInnerActor> get serializer => _$AdminOrderDtoOutputOrderTimelineInnerActorSerializer();
}

class _$AdminOrderDtoOutputOrderTimelineInnerActorSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderTimelineInnerActor> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderTimelineInnerActor, _$AdminOrderDtoOutputOrderTimelineInnerActor];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderTimelineInnerActor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInnerActor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield object.id == null ? null : serializers.serialize(
      object.id,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInnerActor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderTimelineInnerActorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderTimelineInnerActor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderTimelineInnerActorBuilder();
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


