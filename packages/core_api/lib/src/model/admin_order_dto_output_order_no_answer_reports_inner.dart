//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_no_answer_reports_inner.g.dart';

/// AdminOrderDtoOutputOrderNoAnswerReportsInner
///
/// Properties:
/// * [captainId]
/// * [at]
/// * [waitedAt]
/// * [waitMessage] - Operations' «انتظر» message.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderNoAnswerReportsInner
    implements
        Built<
          AdminOrderDtoOutputOrderNoAnswerReportsInner,
          AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'waitedAt')
  DateTime? get waitedAt;

  /// Operations' «انتظر» message.
  @BuiltValueField(wireName: r'waitMessage')
  String? get waitMessage;

  AdminOrderDtoOutputOrderNoAnswerReportsInner._();

  factory AdminOrderDtoOutputOrderNoAnswerReportsInner([
    void updates(AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderNoAnswerReportsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderNoAnswerReportsInner>
  get serializer => _$AdminOrderDtoOutputOrderNoAnswerReportsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderNoAnswerReportsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderNoAnswerReportsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderNoAnswerReportsInner,
    _$AdminOrderDtoOutputOrderNoAnswerReportsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderNoAnswerReportsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswerReportsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'waitedAt';
    yield object.waitedAt == null
        ? null
        : serializers.serialize(
            object.waitedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'waitMessage';
    yield object.waitMessage == null
        ? null
        : serializers.serialize(
            object.waitMessage,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswerReportsInner object, {
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
    required AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder result,
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
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'waitedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.waitedAt = valueDes;
          break;
        case r'waitMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.waitMessage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderNoAnswerReportsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder();
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
