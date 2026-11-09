//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_reason_lists_dto_output_lists_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reason_lists_dto_output.g.dart';

/// AdminReasonListsDtoOutput
///
/// Properties:
/// * [lists]
@BuiltValue()
abstract class AdminReasonListsDtoOutput
    implements
        Built<AdminReasonListsDtoOutput, AdminReasonListsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'lists')
  BuiltList<AdminReasonListsDtoOutputListsInner> get lists;

  AdminReasonListsDtoOutput._();

  factory AdminReasonListsDtoOutput([
    void updates(AdminReasonListsDtoOutputBuilder b),
  ]) = _$AdminReasonListsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReasonListsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReasonListsDtoOutput> get serializer =>
      _$AdminReasonListsDtoOutputSerializer();
}

class _$AdminReasonListsDtoOutputSerializer
    implements PrimitiveSerializer<AdminReasonListsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminReasonListsDtoOutput,
    _$AdminReasonListsDtoOutput,
  ];

  @override
  final String wireName = r'AdminReasonListsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReasonListsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lists';
    yield serializers.serialize(
      object.lists,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminReasonListsDtoOutputListsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReasonListsDtoOutput object, {
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
    required AdminReasonListsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lists':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminReasonListsDtoOutputListsInner),
                    ]),
                  )
                  as BuiltList<AdminReasonListsDtoOutputListsInner>;
          result.lists.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReasonListsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReasonListsDtoOutputBuilder();
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
