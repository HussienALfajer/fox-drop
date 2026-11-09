//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'terms_accepted_dto_output.g.dart';

/// TermsAcceptedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class TermsAcceptedDtoOutput
    implements Built<TermsAcceptedDtoOutput, TermsAcceptedDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  TermsAcceptedDtoOutputStatusEnum get status;
  // enum statusEnum {  accepted,  };

  TermsAcceptedDtoOutput._();

  factory TermsAcceptedDtoOutput([
    void updates(TermsAcceptedDtoOutputBuilder b),
  ]) = _$TermsAcceptedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TermsAcceptedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TermsAcceptedDtoOutput> get serializer =>
      _$TermsAcceptedDtoOutputSerializer();
}

class _$TermsAcceptedDtoOutputSerializer
    implements PrimitiveSerializer<TermsAcceptedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    TermsAcceptedDtoOutput,
    _$TermsAcceptedDtoOutput,
  ];

  @override
  final String wireName = r'TermsAcceptedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TermsAcceptedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TermsAcceptedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TermsAcceptedDtoOutput object, {
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
    required TermsAcceptedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      TermsAcceptedDtoOutputStatusEnum,
                    ),
                  )
                  as TermsAcceptedDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TermsAcceptedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TermsAcceptedDtoOutputBuilder();
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

class TermsAcceptedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'accepted')
  static const TermsAcceptedDtoOutputStatusEnum accepted =
      _$termsAcceptedDtoOutputStatusEnum_accepted;

  static Serializer<TermsAcceptedDtoOutputStatusEnum> get serializer =>
      _$termsAcceptedDtoOutputStatusEnumSerializer;

  const TermsAcceptedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<TermsAcceptedDtoOutputStatusEnum> get values =>
      _$termsAcceptedDtoOutputStatusEnumValues;
  static TermsAcceptedDtoOutputStatusEnum valueOf(String name) =>
      _$termsAcceptedDtoOutputStatusEnumValueOf(name);
}
