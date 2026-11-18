//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_images_waiver_dto.g.dart';

/// AdminImagesWaiverDto
///
/// Properties:
/// * [waived]
@BuiltValue()
abstract class AdminImagesWaiverDto
    implements Built<AdminImagesWaiverDto, AdminImagesWaiverDtoBuilder> {
  @BuiltValueField(wireName: r'waived')
  bool get waived;

  AdminImagesWaiverDto._();

  factory AdminImagesWaiverDto([void updates(AdminImagesWaiverDtoBuilder b)]) =
      _$AdminImagesWaiverDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminImagesWaiverDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminImagesWaiverDto> get serializer =>
      _$AdminImagesWaiverDtoSerializer();
}

class _$AdminImagesWaiverDtoSerializer
    implements PrimitiveSerializer<AdminImagesWaiverDto> {
  @override
  final Iterable<Type> types = const [
    AdminImagesWaiverDto,
    _$AdminImagesWaiverDto,
  ];

  @override
  final String wireName = r'AdminImagesWaiverDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminImagesWaiverDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'waived';
    yield serializers.serialize(
      object.waived,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminImagesWaiverDto object, {
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
    required AdminImagesWaiverDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'waived':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.waived = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminImagesWaiverDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminImagesWaiverDtoBuilder();
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
