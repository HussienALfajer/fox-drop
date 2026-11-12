//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_open_drawer_session_dto_floats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_close_drawer_session_dto.g.dart';

/// AdminCloseDrawerSessionDto
///
/// Properties:
/// * [counted]
/// * [note] - Required when any currency has a variance.
@BuiltValue()
abstract class AdminCloseDrawerSessionDto
    implements
        Built<AdminCloseDrawerSessionDto, AdminCloseDrawerSessionDtoBuilder> {
  @BuiltValueField(wireName: r'counted')
  BuiltList<AdminOpenDrawerSessionDtoFloatsInner> get counted;

  /// Required when any currency has a variance.
  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminCloseDrawerSessionDto._();

  factory AdminCloseDrawerSessionDto([
    void updates(AdminCloseDrawerSessionDtoBuilder b),
  ]) = _$AdminCloseDrawerSessionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCloseDrawerSessionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCloseDrawerSessionDto> get serializer =>
      _$AdminCloseDrawerSessionDtoSerializer();
}

class _$AdminCloseDrawerSessionDtoSerializer
    implements PrimitiveSerializer<AdminCloseDrawerSessionDto> {
  @override
  final Iterable<Type> types = const [
    AdminCloseDrawerSessionDto,
    _$AdminCloseDrawerSessionDto,
  ];

  @override
  final String wireName = r'AdminCloseDrawerSessionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCloseDrawerSessionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'counted';
    yield serializers.serialize(
      object.counted,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOpenDrawerSessionDtoFloatsInner),
      ]),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCloseDrawerSessionDto object, {
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
    required AdminCloseDrawerSessionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'counted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOpenDrawerSessionDtoFloatsInner),
                    ]),
                  )
                  as BuiltList<AdminOpenDrawerSessionDtoFloatsInner>;
          result.counted.replace(valueDes);
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCloseDrawerSessionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCloseDrawerSessionDtoBuilder();
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
