//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_earnings_dto_output_orders_inner_parts.g.dart';

/// Null when only the total is known (an order ended by an outcome).
///
/// Properties:
/// * [base_] - Including the first km.
/// * [distance] - Integer minor units of the base currency (AP §8.6).
/// * [topUp] - «إكمال للحد الأدنى».
/// * [waiting] - Integer minor units of the base currency (AP §8.6).
/// * [peak] - Integer minor units of the base currency (AP §8.6).
@BuiltValue()
abstract class CaptainEarningsDtoOutputOrdersInnerParts
    implements
        Built<
          CaptainEarningsDtoOutputOrdersInnerParts,
          CaptainEarningsDtoOutputOrdersInnerPartsBuilder
        > {
  /// Including the first km.
  @BuiltValueField(wireName: r'base')
  String get base_;

  /// Integer minor units of the base currency (AP §8.6).
  @BuiltValueField(wireName: r'distance')
  String get distance;

  /// «إكمال للحد الأدنى».
  @BuiltValueField(wireName: r'topUp')
  String get topUp;

  /// Integer minor units of the base currency (AP §8.6).
  @BuiltValueField(wireName: r'waiting')
  String get waiting;

  /// Integer minor units of the base currency (AP §8.6).
  @BuiltValueField(wireName: r'peak')
  String get peak;

  CaptainEarningsDtoOutputOrdersInnerParts._();

  factory CaptainEarningsDtoOutputOrdersInnerParts([
    void updates(CaptainEarningsDtoOutputOrdersInnerPartsBuilder b),
  ]) = _$CaptainEarningsDtoOutputOrdersInnerParts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEarningsDtoOutputOrdersInnerPartsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEarningsDtoOutputOrdersInnerParts> get serializer =>
      _$CaptainEarningsDtoOutputOrdersInnerPartsSerializer();
}

class _$CaptainEarningsDtoOutputOrdersInnerPartsSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputOrdersInnerParts> {
  @override
  final Iterable<Type> types = const [
    CaptainEarningsDtoOutputOrdersInnerParts,
    _$CaptainEarningsDtoOutputOrdersInnerParts,
  ];

  @override
  final String wireName = r'CaptainEarningsDtoOutputOrdersInnerParts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEarningsDtoOutputOrdersInnerParts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(String),
    );
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(String),
    );
    yield r'topUp';
    yield serializers.serialize(
      object.topUp,
      specifiedType: const FullType(String),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(String),
    );
    yield r'peak';
    yield serializers.serialize(
      object.peak,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputOrdersInnerParts object, {
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
    required CaptainEarningsDtoOutputOrdersInnerPartsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'base':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.base_ = valueDes;
          break;
        case r'distance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.distance = valueDes;
          break;
        case r'topUp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.topUp = valueDes;
          break;
        case r'waiting':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.waiting = valueDes;
          break;
        case r'peak':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.peak = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainEarningsDtoOutputOrdersInnerParts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEarningsDtoOutputOrdersInnerPartsBuilder();
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
