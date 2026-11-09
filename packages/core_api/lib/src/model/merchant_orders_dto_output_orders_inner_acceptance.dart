//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_acceptance.g.dart';

/// Null until the order is accepted.
///
/// Properties:
/// * [at]
/// * [prepMin] - The prep time chosen (RA §8.5).
/// * [prepDueAt] - While accepted, the prep countdown runs to it; past it the card turns red and counts up, «متأخر {د} د» (RA §8.7).
/// * [deviceName] - «قُبل الطلب من جهاز {اسم الجهاز}» (RA §4.7); null when not accepted on a named device of the restaurant.
/// * [byOperations] - Accepted by operations on the restaurant's behalf: the badge «قبلته العمليات», and every device chimes «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د» (RA §8.15, §16 #5).
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerAcceptance
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerAcceptance,
          MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The prep time chosen (RA §8.5).
  @BuiltValueField(wireName: r'prepMin')
  int get prepMin;

  /// While accepted, the prep countdown runs to it; past it the card turns red and counts up, «متأخر {د} د» (RA §8.7).
  @BuiltValueField(wireName: r'prepDueAt')
  DateTime get prepDueAt;

  /// «قُبل الطلب من جهاز {اسم الجهاز}» (RA §4.7); null when not accepted on a named device of the restaurant.
  @BuiltValueField(wireName: r'deviceName')
  String? get deviceName;

  /// Accepted by operations on the restaurant's behalf: the badge «قبلته العمليات», and every device chimes «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د» (RA §8.15, §16 #5).
  @BuiltValueField(wireName: r'byOperations')
  bool get byOperations;

  MerchantOrdersDtoOutputOrdersInnerAcceptance._();

  factory MerchantOrdersDtoOutputOrdersInnerAcceptance([
    void updates(MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerAcceptance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerAcceptance>
  get serializer => _$MerchantOrdersDtoOutputOrdersInnerAcceptanceSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerAcceptanceSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerAcceptance> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerAcceptance,
    _$MerchantOrdersDtoOutputOrdersInnerAcceptance,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerAcceptance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'prepMin';
    yield serializers.serialize(
      object.prepMin,
      specifiedType: const FullType(int),
    );
    yield r'prepDueAt';
    yield serializers.serialize(
      object.prepDueAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'deviceName';
    yield object.deviceName == null
        ? null
        : serializers.serialize(
            object.deviceName,
            specifiedType: const FullType.nullable(String),
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
    MerchantOrdersDtoOutputOrdersInnerAcceptance object, {
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
    required MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder result,
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
        case r'prepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepMin = valueDes;
          break;
        case r'prepDueAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.prepDueAt = valueDes;
          break;
        case r'deviceName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.deviceName = valueDes;
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
  MerchantOrdersDtoOutputOrdersInnerAcceptance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerAcceptanceBuilder();
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
