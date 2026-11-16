//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_content_dto_output_reasons.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_content_dto_output_faq_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_content_dto_output.g.dart';

/// CaptainContentDtoOutput
///
/// Properties:
/// * [reasons]
/// * [faq]
/// * [workRules] - CA §11.4, plain text with one rule per line.
@BuiltValue()
abstract class CaptainContentDtoOutput
    implements Built<CaptainContentDtoOutput, CaptainContentDtoOutputBuilder> {
  @BuiltValueField(wireName: r'reasons')
  CaptainContentDtoOutputReasons get reasons;

  @BuiltValueField(wireName: r'faq')
  BuiltList<MerchantContentDtoOutputFaqInner> get faq;

  /// CA §11.4, plain text with one rule per line.
  @BuiltValueField(wireName: r'workRules')
  String get workRules;

  CaptainContentDtoOutput._();

  factory CaptainContentDtoOutput([
    void updates(CaptainContentDtoOutputBuilder b),
  ]) = _$CaptainContentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContentDtoOutput> get serializer =>
      _$CaptainContentDtoOutputSerializer();
}

class _$CaptainContentDtoOutputSerializer
    implements PrimitiveSerializer<CaptainContentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainContentDtoOutput,
    _$CaptainContentDtoOutput,
  ];

  @override
  final String wireName = r'CaptainContentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(CaptainContentDtoOutputReasons),
    );
    yield r'faq';
    yield serializers.serialize(
      object.faq,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputFaqInner),
      ]),
    );
    yield r'workRules';
    yield serializers.serialize(
      object.workRules,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainContentDtoOutput object, {
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
    required CaptainContentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainContentDtoOutputReasons,
                    ),
                  )
                  as CaptainContentDtoOutputReasons;
          result.reasons.replace(valueDes);
          break;
        case r'faq':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantContentDtoOutputFaqInner),
                    ]),
                  )
                  as BuiltList<MerchantContentDtoOutputFaqInner>;
          result.faq.replace(valueDes);
          break;
        case r'workRules':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.workRules = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainContentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContentDtoOutputBuilder();
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
