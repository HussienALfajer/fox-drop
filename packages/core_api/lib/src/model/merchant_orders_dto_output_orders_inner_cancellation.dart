//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_cancellation.g.dart';

/// RA §8.14: operations cancelled the accepted order; every device rings with «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}» until «حسناً» on any of them (POST …/acknowledge-cancellation), then the board drops the order. Null otherwise, and once acknowledged.
///
/// Properties:
/// * [at]
/// * [reason] - The code of Content's ops_cancel list.
/// * [label] - {السبب} of «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}».
/// * [byOperations] - Always true: only operations cancel after acceptance.
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerCancellation
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerCancellation,
          MerchantOrdersDtoOutputOrdersInnerCancellationBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The code of Content's ops_cancel list.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// {السبب} of «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}».
  @BuiltValueField(wireName: r'label')
  String get label;

  /// Always true: only operations cancel after acceptance.
  @BuiltValueField(wireName: r'byOperations')
  bool get byOperations;

  MerchantOrdersDtoOutputOrdersInnerCancellation._();

  factory MerchantOrdersDtoOutputOrdersInnerCancellation([
    void updates(MerchantOrdersDtoOutputOrdersInnerCancellationBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerCancellation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerCancellationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerCancellation>
  get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerCancellationSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerCancellationSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerCancellation> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerCancellation,
    _$MerchantOrdersDtoOutputOrdersInnerCancellation,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerCancellation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'byOperations';
    yield serializers.serialize(
      object.byOperations,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCancellation object, {
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
    required MerchantOrdersDtoOutputOrdersInnerCancellationBuilder result,
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'byOperations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.byOperations = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCancellation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerCancellationBuilder();
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
