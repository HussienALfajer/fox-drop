//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_overdue_dto_output_overdue.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_overdue_dto_output.g.dart';

/// MerchantOverdueDtoOutput
///
/// Properties:
/// * [overdue]
@BuiltValue()
abstract class MerchantOverdueDtoOutput
    implements
        Built<MerchantOverdueDtoOutput, MerchantOverdueDtoOutputBuilder> {
  @BuiltValueField(wireName: r'overdue')
  MerchantOverdueDtoOutputOverdue? get overdue;

  MerchantOverdueDtoOutput._();

  factory MerchantOverdueDtoOutput([
    void updates(MerchantOverdueDtoOutputBuilder b),
  ]) = _$MerchantOverdueDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOverdueDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOverdueDtoOutput> get serializer =>
      _$MerchantOverdueDtoOutputSerializer();
}

class _$MerchantOverdueDtoOutputSerializer
    implements PrimitiveSerializer<MerchantOverdueDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantOverdueDtoOutput,
    _$MerchantOverdueDtoOutput,
  ];

  @override
  final String wireName = r'MerchantOverdueDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOverdueDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'overdue';
    yield object.overdue == null
        ? null
        : serializers.serialize(
            object.overdue,
            specifiedType: const FullType.nullable(
              MerchantOverdueDtoOutputOverdue,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOverdueDtoOutput object, {
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
    required MerchantOverdueDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'overdue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantOverdueDtoOutputOverdue,
                    ),
                  )
                  as MerchantOverdueDtoOutputOverdue?;
          if (valueDes == null) continue;
          result.overdue.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOverdueDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOverdueDtoOutputBuilder();
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
