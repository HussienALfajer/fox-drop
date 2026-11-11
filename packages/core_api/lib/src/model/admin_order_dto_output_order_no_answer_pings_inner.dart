//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_no_answer_pings_inner.g.dart';

/// AdminOrderDtoOutputOrderNoAnswerPingsInner
///
/// Properties:
/// * [captainId]
/// * [at]
/// * [answer] - «أنا قادم» or «سأتصل بالمستلم»; null unanswered.
/// * [answeredAt]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderNoAnswerPingsInner
    implements
        Built<
          AdminOrderDtoOutputOrderNoAnswerPingsInner,
          AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// «أنا قادم» or «سأتصل بالمستلم»; null unanswered.
  @BuiltValueField(wireName: r'answer')
  AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum? get answer;
  // enum answerEnum {  coming,  contacting_recipient,  };

  @BuiltValueField(wireName: r'answeredAt')
  DateTime? get answeredAt;

  AdminOrderDtoOutputOrderNoAnswerPingsInner._();

  factory AdminOrderDtoOutputOrderNoAnswerPingsInner([
    void updates(AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderNoAnswerPingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderNoAnswerPingsInner>
  get serializer => _$AdminOrderDtoOutputOrderNoAnswerPingsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderNoAnswerPingsInnerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderNoAnswerPingsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderNoAnswerPingsInner,
    _$AdminOrderDtoOutputOrderNoAnswerPingsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderNoAnswerPingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswerPingsInner object, {
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
    yield r'answer';
    yield object.answer == null
        ? null
        : serializers.serialize(
            object.answer,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum,
            ),
          );
    yield r'answeredAt';
    yield object.answeredAt == null
        ? null
        : serializers.serialize(
            object.answeredAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswerPingsInner object, {
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
    required AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder result,
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
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum?;
          if (valueDes == null) continue;
          result.answer = valueDes;
          break;
        case r'answeredAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.answeredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderNoAnswerPingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderNoAnswerPingsInnerBuilder();
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

/// «أنا قادم» or «سأتصل بالمستلم»; null unanswered.
class AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'coming')
  static const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum coming =
      _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_coming;
  @BuiltValueEnumConst(wireName: r'contacting_recipient')
  static const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum
  contactingRecipient =
      _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum_contactingRecipient;

  static Serializer<AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumSerializer;

  const AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum>
  get values => _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumValues;
  static AdminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderNoAnswerPingsInnerAnswerEnumValueOf(name);
}
