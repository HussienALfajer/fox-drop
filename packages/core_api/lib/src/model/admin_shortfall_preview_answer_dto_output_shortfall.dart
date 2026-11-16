//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shortfall_preview_answer_dto_output_shortfall.g.dart';

/// The missing amount, in the base currency.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class AdminShortfallPreviewAnswerDtoOutputShortfall
    implements
        Built<
          AdminShortfallPreviewAnswerDtoOutputShortfall,
          AdminShortfallPreviewAnswerDtoOutputShortfallBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminShortfallPreviewAnswerDtoOutputShortfall._();

  factory AdminShortfallPreviewAnswerDtoOutputShortfall([
    void updates(AdminShortfallPreviewAnswerDtoOutputShortfallBuilder b),
  ]) = _$AdminShortfallPreviewAnswerDtoOutputShortfall;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminShortfallPreviewAnswerDtoOutputShortfallBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminShortfallPreviewAnswerDtoOutputShortfall>
  get serializer => _$AdminShortfallPreviewAnswerDtoOutputShortfallSerializer();
}

class _$AdminShortfallPreviewAnswerDtoOutputShortfallSerializer
    implements
        PrimitiveSerializer<AdminShortfallPreviewAnswerDtoOutputShortfall> {
  @override
  final Iterable<Type> types = const [
    AdminShortfallPreviewAnswerDtoOutputShortfall,
    _$AdminShortfallPreviewAnswerDtoOutputShortfall,
  ];

  @override
  final String wireName = r'AdminShortfallPreviewAnswerDtoOutputShortfall';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminShortfallPreviewAnswerDtoOutputShortfall object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminShortfallPreviewAnswerDtoOutputShortfall object, {
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
    required AdminShortfallPreviewAnswerDtoOutputShortfallBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminShortfallPreviewAnswerDtoOutputShortfall deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminShortfallPreviewAnswerDtoOutputShortfallBuilder();
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
