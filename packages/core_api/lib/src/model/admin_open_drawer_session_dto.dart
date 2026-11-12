//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_open_drawer_session_dto_floats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_open_drawer_session_dto.g.dart';

/// AdminOpenDrawerSessionDto
///
/// Properties:
/// * [cityId]
/// * [floats]
@BuiltValue()
abstract class AdminOpenDrawerSessionDto
    implements
        Built<AdminOpenDrawerSessionDto, AdminOpenDrawerSessionDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'floats')
  BuiltList<AdminOpenDrawerSessionDtoFloatsInner> get floats;

  AdminOpenDrawerSessionDto._();

  factory AdminOpenDrawerSessionDto([
    void updates(AdminOpenDrawerSessionDtoBuilder b),
  ]) = _$AdminOpenDrawerSessionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOpenDrawerSessionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOpenDrawerSessionDto> get serializer =>
      _$AdminOpenDrawerSessionDtoSerializer();
}

class _$AdminOpenDrawerSessionDtoSerializer
    implements PrimitiveSerializer<AdminOpenDrawerSessionDto> {
  @override
  final Iterable<Type> types = const [
    AdminOpenDrawerSessionDto,
    _$AdminOpenDrawerSessionDto,
  ];

  @override
  final String wireName = r'AdminOpenDrawerSessionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOpenDrawerSessionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'floats';
    yield serializers.serialize(
      object.floats,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOpenDrawerSessionDtoFloatsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOpenDrawerSessionDto object, {
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
    required AdminOpenDrawerSessionDtoBuilder result,
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
        case r'floats':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOpenDrawerSessionDtoFloatsInner),
                    ]),
                  )
                  as BuiltList<AdminOpenDrawerSessionDtoFloatsInner>;
          result.floats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOpenDrawerSessionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOpenDrawerSessionDtoBuilder();
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
