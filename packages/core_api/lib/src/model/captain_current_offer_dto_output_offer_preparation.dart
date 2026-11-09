//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_preparation.g.dart';

/// CaptainCurrentOfferDtoOutputOfferPreparation
///
/// Properties:
/// * [ready] - «جاهز».
/// * [readyAt] - «قيد التحضير — جاهز بعد {د} د تقريباً» counts to it while not ready.
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferPreparation implements Built<CaptainCurrentOfferDtoOutputOfferPreparation, CaptainCurrentOfferDtoOutputOfferPreparationBuilder> {
  /// «جاهز».
  @BuiltValueField(wireName: r'ready')
  bool get ready;

  /// «قيد التحضير — جاهز بعد {د} د تقريباً» counts to it while not ready.
  @BuiltValueField(wireName: r'readyAt')
  DateTime? get readyAt;

  CaptainCurrentOfferDtoOutputOfferPreparation._();

  factory CaptainCurrentOfferDtoOutputOfferPreparation([void updates(CaptainCurrentOfferDtoOutputOfferPreparationBuilder b)]) = _$CaptainCurrentOfferDtoOutputOfferPreparation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputOfferPreparationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferPreparation> get serializer => _$CaptainCurrentOfferDtoOutputOfferPreparationSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferPreparationSerializer implements PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferPreparation> {
  @override
  final Iterable<Type> types = const [CaptainCurrentOfferDtoOutputOfferPreparation, _$CaptainCurrentOfferDtoOutputOfferPreparation];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferPreparation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferPreparation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(bool),
    );
    yield r'readyAt';
    yield object.readyAt == null ? null : serializers.serialize(
      object.readyAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferPreparation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainCurrentOfferDtoOutputOfferPreparationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ready = valueDes;
          break;
        case r'readyAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readyAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutputOfferPreparation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferPreparationBuilder();
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


