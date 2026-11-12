//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_bulk_hand_in_grace_answer_dto_output_grace.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bulk_hand_in_grace_answer_dto_output.g.dart';

/// AdminBulkHandInGraceAnswerDtoOutput
///
/// Properties:
/// * [grace]
/// * [captainIds] - The captains blocked by cash due who were told; none on a repeat.
@BuiltValue()
abstract class AdminBulkHandInGraceAnswerDtoOutput
    implements
        Built<
          AdminBulkHandInGraceAnswerDtoOutput,
          AdminBulkHandInGraceAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'grace')
  AdminBulkHandInGraceAnswerDtoOutputGrace get grace;

  /// The captains blocked by cash due who were told; none on a repeat.
  @BuiltValueField(wireName: r'captainIds')
  BuiltList<String> get captainIds;

  AdminBulkHandInGraceAnswerDtoOutput._();

  factory AdminBulkHandInGraceAnswerDtoOutput([
    void updates(AdminBulkHandInGraceAnswerDtoOutputBuilder b),
  ]) = _$AdminBulkHandInGraceAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBulkHandInGraceAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBulkHandInGraceAnswerDtoOutput> get serializer =>
      _$AdminBulkHandInGraceAnswerDtoOutputSerializer();
}

class _$AdminBulkHandInGraceAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminBulkHandInGraceAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminBulkHandInGraceAnswerDtoOutput,
    _$AdminBulkHandInGraceAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminBulkHandInGraceAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBulkHandInGraceAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'grace';
    yield serializers.serialize(
      object.grace,
      specifiedType: const FullType(AdminBulkHandInGraceAnswerDtoOutputGrace),
    );
    yield r'captainIds';
    yield serializers.serialize(
      object.captainIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBulkHandInGraceAnswerDtoOutput object, {
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
    required AdminBulkHandInGraceAnswerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'grace':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminBulkHandInGraceAnswerDtoOutputGrace,
                    ),
                  )
                  as AdminBulkHandInGraceAnswerDtoOutputGrace;
          result.grace.replace(valueDes);
          break;
        case r'captainIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.captainIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBulkHandInGraceAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBulkHandInGraceAnswerDtoOutputBuilder();
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
