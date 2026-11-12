//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_grace_answer_dto_output.g.dart';

/// AdminHandInGraceAnswerDtoOutput
///
/// Properties:
/// * [id]
/// * [until] - The next business-day cutoff when it was granted.
/// * [reason]
/// * [bulk] - The city's bulk grace for one business day.
/// * [grantedAt]
@BuiltValue()
abstract class AdminHandInGraceAnswerDtoOutput
    implements
        Built<
          AdminHandInGraceAnswerDtoOutput,
          AdminHandInGraceAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The next business-day cutoff when it was granted.
  @BuiltValueField(wireName: r'until')
  DateTime get until;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The city's bulk grace for one business day.
  @BuiltValueField(wireName: r'bulk')
  bool get bulk;

  @BuiltValueField(wireName: r'grantedAt')
  DateTime get grantedAt;

  AdminHandInGraceAnswerDtoOutput._();

  factory AdminHandInGraceAnswerDtoOutput([
    void updates(AdminHandInGraceAnswerDtoOutputBuilder b),
  ]) = _$AdminHandInGraceAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInGraceAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInGraceAnswerDtoOutput> get serializer =>
      _$AdminHandInGraceAnswerDtoOutputSerializer();
}

class _$AdminHandInGraceAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminHandInGraceAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminHandInGraceAnswerDtoOutput,
    _$AdminHandInGraceAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminHandInGraceAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInGraceAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'bulk';
    yield serializers.serialize(
      object.bulk,
      specifiedType: const FullType(bool),
    );
    yield r'grantedAt';
    yield serializers.serialize(
      object.grantedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandInGraceAnswerDtoOutput object, {
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
    required AdminHandInGraceAnswerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'bulk':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.bulk = valueDes;
          break;
        case r'grantedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.grantedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHandInGraceAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInGraceAnswerDtoOutputBuilder();
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
