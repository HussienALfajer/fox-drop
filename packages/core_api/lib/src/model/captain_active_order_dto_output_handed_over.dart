//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_handed_over.g.dart';

/// The latest order the captain handed to another within 12 hours that they have not acknowledged (POST …/acknowledge-handover).
///
/// Properties:
/// * [orderId]
/// * [number]
/// * [toCaptainName] - {الاسم} of «سلّمت الطلب للكابتن {الاسم}».
/// * [at]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputHandedOver
    implements
        Built<
          CaptainActiveOrderDtoOutputHandedOver,
          CaptainActiveOrderDtoOutputHandedOverBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  /// {الاسم} of «سلّمت الطلب للكابتن {الاسم}».
  @BuiltValueField(wireName: r'toCaptainName')
  String get toCaptainName;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputHandedOver._();

  factory CaptainActiveOrderDtoOutputHandedOver([
    void updates(CaptainActiveOrderDtoOutputHandedOverBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputHandedOver;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputHandedOverBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputHandedOver> get serializer =>
      _$CaptainActiveOrderDtoOutputHandedOverSerializer();
}

class _$CaptainActiveOrderDtoOutputHandedOverSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputHandedOver> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputHandedOver,
    _$CaptainActiveOrderDtoOutputHandedOver,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputHandedOver';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputHandedOver object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'toCaptainName';
    yield serializers.serialize(
      object.toCaptainName,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputHandedOver object, {
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
    required CaptainActiveOrderDtoOutputHandedOverBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'toCaptainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.toCaptainName = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputHandedOver deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputHandedOverBuilder();
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
