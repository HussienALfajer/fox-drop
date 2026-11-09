//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_signed_out_dto_output.g.dart';

/// CaptainSignedOutDtoOutput
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class CaptainSignedOutDtoOutput implements Built<CaptainSignedOutDtoOutput, CaptainSignedOutDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  CaptainSignedOutDtoOutputStatusEnum get status;
  // enum statusEnum {  signed_out,  };

  CaptainSignedOutDtoOutput._();

  factory CaptainSignedOutDtoOutput([void updates(CaptainSignedOutDtoOutputBuilder b)]) = _$CaptainSignedOutDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainSignedOutDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainSignedOutDtoOutput> get serializer => _$CaptainSignedOutDtoOutputSerializer();
}

class _$CaptainSignedOutDtoOutputSerializer implements PrimitiveSerializer<CaptainSignedOutDtoOutput> {
  @override
  final Iterable<Type> types = const [CaptainSignedOutDtoOutput, _$CaptainSignedOutDtoOutput];

  @override
  final String wireName = r'CaptainSignedOutDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CaptainSignedOutDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainSignedOutDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainSignedOutDtoOutputStatusEnum),
          ) as CaptainSignedOutDtoOutputStatusEnum;
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
  CaptainSignedOutDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainSignedOutDtoOutputBuilder();
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


class CaptainSignedOutDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'signed_out')
  static const CaptainSignedOutDtoOutputStatusEnum signedOut = _$captainSignedOutDtoOutputStatusEnum_signedOut;

  static Serializer<CaptainSignedOutDtoOutputStatusEnum> get serializer => _$captainSignedOutDtoOutputStatusEnumSerializer;

  const CaptainSignedOutDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<CaptainSignedOutDtoOutputStatusEnum> get values => _$captainSignedOutDtoOutputStatusEnumValues;
  static CaptainSignedOutDtoOutputStatusEnum valueOf(String name) => _$captainSignedOutDtoOutputStatusEnumValueOf(name);
}

