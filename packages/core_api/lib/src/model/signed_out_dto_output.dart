//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signed_out_dto_output.g.dart';

/// SignedOutDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class SignedOutDtoOutput
    implements Built<SignedOutDtoOutput, SignedOutDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  SignedOutDtoOutputStatusEnum get status;
  // enum statusEnum {  signed_out,  };

  SignedOutDtoOutput._();

  factory SignedOutDtoOutput([void updates(SignedOutDtoOutputBuilder b)]) =
      _$SignedOutDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignedOutDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignedOutDtoOutput> get serializer =>
      _$SignedOutDtoOutputSerializer();
}

class _$SignedOutDtoOutputSerializer
    implements PrimitiveSerializer<SignedOutDtoOutput> {
  @override
  final Iterable<Type> types = const [SignedOutDtoOutput, _$SignedOutDtoOutput];

  @override
  final String wireName = r'SignedOutDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SignedOutDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SignedOutDtoOutput object, {
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
    required SignedOutDtoOutputBuilder result,
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
                    specifiedType: const FullType(SignedOutDtoOutputStatusEnum),
                  )
                  as SignedOutDtoOutputStatusEnum;
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
  SignedOutDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignedOutDtoOutputBuilder();
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

class SignedOutDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'signed_out')
  static const SignedOutDtoOutputStatusEnum signedOut =
      _$signedOutDtoOutputStatusEnum_signedOut;

  static Serializer<SignedOutDtoOutputStatusEnum> get serializer =>
      _$signedOutDtoOutputStatusEnumSerializer;

  const SignedOutDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<SignedOutDtoOutputStatusEnum> get values =>
      _$signedOutDtoOutputStatusEnumValues;
  static SignedOutDtoOutputStatusEnum valueOf(String name) =>
      _$signedOutDtoOutputStatusEnumValueOf(name);
}
