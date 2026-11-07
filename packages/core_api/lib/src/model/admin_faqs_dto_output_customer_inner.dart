//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_faqs_dto_output_customer_inner.g.dart';

/// AdminFaqsDtoOutputCustomerInner
///
/// Properties:
/// * [question]
/// * [answer]
@BuiltValue()
abstract class AdminFaqsDtoOutputCustomerInner
    implements
        Built<
          AdminFaqsDtoOutputCustomerInner,
          AdminFaqsDtoOutputCustomerInnerBuilder
        > {
  @BuiltValueField(wireName: r'question')
  String get question;

  @BuiltValueField(wireName: r'answer')
  String get answer;

  AdminFaqsDtoOutputCustomerInner._();

  factory AdminFaqsDtoOutputCustomerInner([
    void updates(AdminFaqsDtoOutputCustomerInnerBuilder b),
  ]) = _$AdminFaqsDtoOutputCustomerInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFaqsDtoOutputCustomerInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFaqsDtoOutputCustomerInner> get serializer =>
      _$AdminFaqsDtoOutputCustomerInnerSerializer();
}

class _$AdminFaqsDtoOutputCustomerInnerSerializer
    implements PrimitiveSerializer<AdminFaqsDtoOutputCustomerInner> {
  @override
  final Iterable<Type> types = const [
    AdminFaqsDtoOutputCustomerInner,
    _$AdminFaqsDtoOutputCustomerInner,
  ];

  @override
  final String wireName = r'AdminFaqsDtoOutputCustomerInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFaqsDtoOutputCustomerInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'question';
    yield serializers.serialize(
      object.question,
      specifiedType: const FullType(String),
    );
    yield r'answer';
    yield serializers.serialize(
      object.answer,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminFaqsDtoOutputCustomerInner object, {
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
    required AdminFaqsDtoOutputCustomerInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'question':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.question = valueDes;
          break;
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.answer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminFaqsDtoOutputCustomerInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFaqsDtoOutputCustomerInnerBuilder();
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
