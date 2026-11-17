//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_canned_replies_dto_output_replies_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_canned_replies_dto_output.g.dart';

/// AdminCannedRepliesDtoOutput
///
/// Properties:
/// * [replies]
@BuiltValue()
abstract class AdminCannedRepliesDtoOutput
    implements
        Built<AdminCannedRepliesDtoOutput, AdminCannedRepliesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'replies')
  BuiltList<AdminCannedRepliesDtoOutputRepliesInner> get replies;

  AdminCannedRepliesDtoOutput._();

  factory AdminCannedRepliesDtoOutput([
    void updates(AdminCannedRepliesDtoOutputBuilder b),
  ]) = _$AdminCannedRepliesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCannedRepliesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCannedRepliesDtoOutput> get serializer =>
      _$AdminCannedRepliesDtoOutputSerializer();
}

class _$AdminCannedRepliesDtoOutputSerializer
    implements PrimitiveSerializer<AdminCannedRepliesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCannedRepliesDtoOutput,
    _$AdminCannedRepliesDtoOutput,
  ];

  @override
  final String wireName = r'AdminCannedRepliesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCannedRepliesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'replies';
    yield serializers.serialize(
      object.replies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCannedRepliesDtoOutputRepliesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCannedRepliesDtoOutput object, {
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
    required AdminCannedRepliesDtoOutputBuilder result,
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
                      FullType(AdminCannedRepliesDtoOutputRepliesInner),
                    ]),
                  )
                  as BuiltList<AdminCannedRepliesDtoOutputRepliesInner>;
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
  AdminCannedRepliesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCannedRepliesDtoOutputBuilder();
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
