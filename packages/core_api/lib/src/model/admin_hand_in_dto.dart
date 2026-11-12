//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_open_drawer_session_dto_floats_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_dto.g.dart';

/// AdminHandInDto
///
/// Properties:
/// * [captainId]
/// * [lines]
@BuiltValue()
abstract class AdminHandInDto
    implements Built<AdminHandInDto, AdminHandInDtoBuilder> {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminOpenDrawerSessionDtoFloatsInner> get lines;

  AdminHandInDto._();

  factory AdminHandInDto([void updates(AdminHandInDtoBuilder b)]) =
      _$AdminHandInDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInDto> get serializer =>
      _$AdminHandInDtoSerializer();
}

class _$AdminHandInDtoSerializer
    implements PrimitiveSerializer<AdminHandInDto> {
  @override
  final Iterable<Type> types = const [AdminHandInDto, _$AdminHandInDto];

  @override
  final String wireName = r'AdminHandInDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOpenDrawerSessionDtoFloatsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandInDto object, {
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
    required AdminHandInDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOpenDrawerSessionDtoFloatsInner),
                    ]),
                  )
                  as BuiltList<AdminOpenDrawerSessionDtoFloatsInner>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHandInDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInDtoBuilder();
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
