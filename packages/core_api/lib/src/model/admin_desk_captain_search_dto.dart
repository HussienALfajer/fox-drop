//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_captain_search_dto.g.dart';

/// AdminDeskCaptainSearchDto
///
/// Properties:
/// * [cityId]
/// * [q] - A part of the name, or the number in E.164.
@BuiltValue()
abstract class AdminDeskCaptainSearchDto
    implements
        Built<AdminDeskCaptainSearchDto, AdminDeskCaptainSearchDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A part of the name, or the number in E.164.
  @BuiltValueField(wireName: r'q')
  String get q;

  AdminDeskCaptainSearchDto._();

  factory AdminDeskCaptainSearchDto([
    void updates(AdminDeskCaptainSearchDtoBuilder b),
  ]) = _$AdminDeskCaptainSearchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCaptainSearchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCaptainSearchDto> get serializer =>
      _$AdminDeskCaptainSearchDtoSerializer();
}

class _$AdminDeskCaptainSearchDtoSerializer
    implements PrimitiveSerializer<AdminDeskCaptainSearchDto> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCaptainSearchDto,
    _$AdminDeskCaptainSearchDto,
  ];

  @override
  final String wireName = r'AdminDeskCaptainSearchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCaptainSearchDto object, {
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
    AdminDeskCaptainSearchDto object, {
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
    required AdminDeskCaptainSearchDtoBuilder result,
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
  AdminDeskCaptainSearchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCaptainSearchDtoBuilder();
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
