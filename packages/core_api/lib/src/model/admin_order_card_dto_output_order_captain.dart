//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_card_dto_output_order_captain.g.dart';

/// Null shows a red «بلا كابتن».
///
/// Properties:
/// * [id]
/// * [name]
/// * [vehicle]
@BuiltValue()
abstract class AdminOrderCardDtoOutputOrderCaptain
    implements
        Built<
          AdminOrderCardDtoOutputOrderCaptain,
          AdminOrderCardDtoOutputOrderCaptainBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vehicle')
  String get vehicle;

  AdminOrderCardDtoOutputOrderCaptain._();

  factory AdminOrderCardDtoOutputOrderCaptain([
    void updates(AdminOrderCardDtoOutputOrderCaptainBuilder b),
  ]) = _$AdminOrderCardDtoOutputOrderCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCardDtoOutputOrderCaptainBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCardDtoOutputOrderCaptain> get serializer =>
      _$AdminOrderCardDtoOutputOrderCaptainSerializer();
}

class _$AdminOrderCardDtoOutputOrderCaptainSerializer
    implements PrimitiveSerializer<AdminOrderCardDtoOutputOrderCaptain> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCardDtoOutputOrderCaptain,
    _$AdminOrderCardDtoOutputOrderCaptain,
  ];

  @override
  final String wireName = r'AdminOrderCardDtoOutputOrderCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderCaptain object, {
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
    required AdminOrderCardDtoOutputOrderCaptainBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.vehicle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCardDtoOutputOrderCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCardDtoOutputOrderCaptainBuilder();
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
