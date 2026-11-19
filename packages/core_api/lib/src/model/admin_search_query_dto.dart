//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_search_query_dto.g.dart';

/// AdminSearchQueryDto
///
/// Properties:
/// * [cityId]
/// * [q] - An order or ticket number (#10001, T-5521), a phone, or a part of a restaurant or captain name.
@BuiltValue()
abstract class AdminSearchQueryDto
    implements Built<AdminSearchQueryDto, AdminSearchQueryDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// An order or ticket number (#10001, T-5521), a phone, or a part of a restaurant or captain name.
  @BuiltValueField(wireName: r'q')
  String get q;

  AdminSearchQueryDto._();

  factory AdminSearchQueryDto([void updates(AdminSearchQueryDtoBuilder b)]) =
      _$AdminSearchQueryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSearchQueryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSearchQueryDto> get serializer =>
      _$AdminSearchQueryDtoSerializer();
}

class _$AdminSearchQueryDtoSerializer
    implements PrimitiveSerializer<AdminSearchQueryDto> {
  @override
  final Iterable<Type> types = const [
    AdminSearchQueryDto,
    _$AdminSearchQueryDto,
  ];

  @override
  final String wireName = r'AdminSearchQueryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSearchQueryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'q';
    yield serializers.serialize(
      object.q,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSearchQueryDto object, {
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
    required AdminSearchQueryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'q':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.q = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSearchQueryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSearchQueryDtoBuilder();
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
