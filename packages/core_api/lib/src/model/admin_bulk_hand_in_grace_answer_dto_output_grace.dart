//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bulk_hand_in_grace_answer_dto_output_grace.g.dart';

/// AdminBulkHandInGraceAnswerDtoOutputGrace
///
/// Properties:
/// * [id]
/// * [until] - The next business-day cutoff when it was granted.
/// * [reason]
/// * [bulk] - The city's bulk grace for one business day.
/// * [grantedAt]
@BuiltValue()
abstract class AdminBulkHandInGraceAnswerDtoOutputGrace
    implements
        Built<
          AdminBulkHandInGraceAnswerDtoOutputGrace,
          AdminBulkHandInGraceAnswerDtoOutputGraceBuilder
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

  AdminBulkHandInGraceAnswerDtoOutputGrace._();

  factory AdminBulkHandInGraceAnswerDtoOutputGrace([
    void updates(AdminBulkHandInGraceAnswerDtoOutputGraceBuilder b),
  ]) = _$AdminBulkHandInGraceAnswerDtoOutputGrace;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBulkHandInGraceAnswerDtoOutputGraceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBulkHandInGraceAnswerDtoOutputGrace> get serializer =>
      _$AdminBulkHandInGraceAnswerDtoOutputGraceSerializer();
}

class _$AdminBulkHandInGraceAnswerDtoOutputGraceSerializer
    implements PrimitiveSerializer<AdminBulkHandInGraceAnswerDtoOutputGrace> {
  @override
  final Iterable<Type> types = const [
    AdminBulkHandInGraceAnswerDtoOutputGrace,
    _$AdminBulkHandInGraceAnswerDtoOutputGrace,
  ];

  @override
  final String wireName = r'AdminBulkHandInGraceAnswerDtoOutputGrace';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBulkHandInGraceAnswerDtoOutputGrace object, {
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
    AdminBulkHandInGraceAnswerDtoOutputGrace object, {
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
    required AdminBulkHandInGraceAnswerDtoOutputGraceBuilder result,
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
  AdminBulkHandInGraceAnswerDtoOutputGrace deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBulkHandInGraceAnswerDtoOutputGraceBuilder();
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
