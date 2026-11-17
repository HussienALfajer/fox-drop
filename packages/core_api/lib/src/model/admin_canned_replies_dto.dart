//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_canned_replies_dto_replies_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_canned_replies_dto.g.dart';

/// AdminCannedRepliesDto
///
/// Properties:
/// * [replies]
@BuiltValue()
abstract class AdminCannedRepliesDto
    implements Built<AdminCannedRepliesDto, AdminCannedRepliesDtoBuilder> {
  @BuiltValueField(wireName: r'replies')
  BuiltList<AdminCannedRepliesDtoRepliesInner> get replies;

  AdminCannedRepliesDto._();

  factory AdminCannedRepliesDto([
    void updates(AdminCannedRepliesDtoBuilder b),
  ]) = _$AdminCannedRepliesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCannedRepliesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCannedRepliesDto> get serializer =>
      _$AdminCannedRepliesDtoSerializer();
}

class _$AdminCannedRepliesDtoSerializer
    implements PrimitiveSerializer<AdminCannedRepliesDto> {
  @override
  final Iterable<Type> types = const [
    AdminCannedRepliesDto,
    _$AdminCannedRepliesDto,
  ];

  @override
  final String wireName = r'AdminCannedRepliesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCannedRepliesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'replies';
    yield serializers.serialize(
      object.replies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCannedRepliesDtoRepliesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCannedRepliesDto object, {
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
    required AdminCannedRepliesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'replies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCannedRepliesDtoRepliesInner),
                    ]),
                  )
                  as BuiltList<AdminCannedRepliesDtoRepliesInner>;
          result.replies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCannedRepliesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCannedRepliesDtoBuilder();
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
