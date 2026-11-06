//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_arrival.g.dart';

/// Null until «وصلت إلى المطعم».
///
/// Properties:
/// * [at] - The waiting timer counts from it (CA §9.3).
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderArrival
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderArrival,
          CaptainActiveOrderDtoOutputOrderArrivalBuilder
        > {
  /// The waiting timer counts from it (CA §9.3).
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputOrderArrival._();

  factory CaptainActiveOrderDtoOutputOrderArrival([
    void updates(CaptainActiveOrderDtoOutputOrderArrivalBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderArrival;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderArrivalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderArrival> get serializer =>
      _$CaptainActiveOrderDtoOutputOrderArrivalSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderArrivalSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderArrival> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderArrival,
    _$CaptainActiveOrderDtoOutputOrderArrival,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderArrival';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderArrival object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderArrival object, {
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
    required CaptainActiveOrderDtoOutputOrderArrivalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderArrival deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderArrivalBuilder();
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
