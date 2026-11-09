//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_image_set_dto_output.g.dart';

/// AdminImageSetDtoOutput
///
/// Properties:
/// * [key] 
@BuiltValue()
abstract class AdminImageSetDtoOutput implements Built<AdminImageSetDtoOutput, AdminImageSetDtoOutputBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  AdminImageSetDtoOutput._();

  factory AdminImageSetDtoOutput([void updates(AdminImageSetDtoOutputBuilder b)]) = _$AdminImageSetDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminImageSetDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminImageSetDtoOutput> get serializer => _$AdminImageSetDtoOutputSerializer();
}

class _$AdminImageSetDtoOutputSerializer implements PrimitiveSerializer<AdminImageSetDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminImageSetDtoOutput, _$AdminImageSetDtoOutput];

  @override
  final String wireName = r'AdminImageSetDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminImageSetDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminImageSetDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminImageSetDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminImageSetDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminImageSetDtoOutputBuilder();
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


