//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_publish_terms_dto.g.dart';

/// AdminPublishTermsDto
///
/// Properties:
/// * [body] 
@BuiltValue()
abstract class AdminPublishTermsDto implements Built<AdminPublishTermsDto, AdminPublishTermsDtoBuilder> {
  @BuiltValueField(wireName: r'body')
  String get body;

  AdminPublishTermsDto._();

  factory AdminPublishTermsDto([void updates(AdminPublishTermsDtoBuilder b)]) = _$AdminPublishTermsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPublishTermsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPublishTermsDto> get serializer => _$AdminPublishTermsDtoSerializer();
}

class _$AdminPublishTermsDtoSerializer implements PrimitiveSerializer<AdminPublishTermsDto> {
  @override
  final Iterable<Type> types = const [AdminPublishTermsDto, _$AdminPublishTermsDto];

  @override
  final String wireName = r'AdminPublishTermsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPublishTermsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPublishTermsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPublishTermsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPublishTermsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPublishTermsDtoBuilder();
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


