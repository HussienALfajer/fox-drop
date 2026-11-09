//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'done_dto_output.g.dart';

/// DoneDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class DoneDtoOutput
    implements Built<DoneDtoOutput, DoneDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  DoneDtoOutputStatusEnum get status;
  // enum statusEnum {  done,  };

  DoneDtoOutput._();

  factory DoneDtoOutput([void updates(DoneDtoOutputBuilder b)]) =
      _$DoneDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DoneDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DoneDtoOutput> get serializer =>
      _$DoneDtoOutputSerializer();
}

class _$DoneDtoOutputSerializer implements PrimitiveSerializer<DoneDtoOutput> {
  @override
  final Iterable<Type> types = const [DoneDtoOutput, _$DoneDtoOutput];

  @override
  final String wireName = r'DoneDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DoneDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DoneDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DoneDtoOutput object, {
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
    required DoneDtoOutputBuilder result,
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
                    specifiedType: const FullType(DoneDtoOutputStatusEnum),
                  )
                  as DoneDtoOutputStatusEnum;
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
  DoneDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DoneDtoOutputBuilder();
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

class DoneDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'done')
  static const DoneDtoOutputStatusEnum done = _$doneDtoOutputStatusEnum_done;

  static Serializer<DoneDtoOutputStatusEnum> get serializer =>
      _$doneDtoOutputStatusEnumSerializer;

  const DoneDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<DoneDtoOutputStatusEnum> get values =>
      _$doneDtoOutputStatusEnumValues;
  static DoneDtoOutputStatusEnum valueOf(String name) =>
      _$doneDtoOutputStatusEnumValueOf(name);
}
