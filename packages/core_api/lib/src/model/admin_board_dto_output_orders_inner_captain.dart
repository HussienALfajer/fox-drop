//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_board_dto_output_orders_inner_captain.g.dart';

/// Null shows a red «بلا كابتن».
///
/// Properties:
/// * [id]
/// * [name]
/// * [vehicle]
@BuiltValue()
abstract class AdminBoardDtoOutputOrdersInnerCaptain
    implements
        Built<
          AdminBoardDtoOutputOrdersInnerCaptain,
          AdminBoardDtoOutputOrdersInnerCaptainBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vehicle')
  String get vehicle;

  AdminBoardDtoOutputOrdersInnerCaptain._();

  factory AdminBoardDtoOutputOrdersInnerCaptain([
    void updates(AdminBoardDtoOutputOrdersInnerCaptainBuilder b),
  ]) = _$AdminBoardDtoOutputOrdersInnerCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBoardDtoOutputOrdersInnerCaptainBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBoardDtoOutputOrdersInnerCaptain> get serializer =>
      _$AdminBoardDtoOutputOrdersInnerCaptainSerializer();
}

class _$AdminBoardDtoOutputOrdersInnerCaptainSerializer
    implements PrimitiveSerializer<AdminBoardDtoOutputOrdersInnerCaptain> {
  @override
  final Iterable<Type> types = const [
    AdminBoardDtoOutputOrdersInnerCaptain,
    _$AdminBoardDtoOutputOrdersInnerCaptain,
  ];

  @override
  final String wireName = r'AdminBoardDtoOutputOrdersInnerCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInnerCaptain object, {
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
    AdminBoardDtoOutputOrdersInnerCaptain object, {
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
    required AdminBoardDtoOutputOrdersInnerCaptainBuilder result,
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
  AdminBoardDtoOutputOrdersInnerCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBoardDtoOutputOrdersInnerCaptainBuilder();
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
