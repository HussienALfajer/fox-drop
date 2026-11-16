//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_account_dto_output_pickups_inner_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account_dto_output_pickups_inner.g.dart';

/// MerchantAccountDtoOutputPickupsInner
///
/// Properties:
/// * [orderId]
/// * [orderNumber]
/// * [at]
/// * [captainName] - The captain's first name.
/// * [amount] - The full items value (RA §12.7).
/// * [lines] - The currency lines the captain paid.
@BuiltValue()
abstract class MerchantAccountDtoOutputPickupsInner
    implements
        Built<
          MerchantAccountDtoOutputPickupsInner,
          MerchantAccountDtoOutputPickupsInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String get orderNumber;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The captain's first name.
  @BuiltValueField(wireName: r'captainName')
  String? get captainName;

  /// The full items value (RA §12.7).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// The currency lines the captain paid.
  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantAccountDtoOutputPickupsInnerLinesInner> get lines;

  MerchantAccountDtoOutputPickupsInner._();

  factory MerchantAccountDtoOutputPickupsInner([
    void updates(MerchantAccountDtoOutputPickupsInnerBuilder b),
  ]) = _$MerchantAccountDtoOutputPickupsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountDtoOutputPickupsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccountDtoOutputPickupsInner> get serializer =>
      _$MerchantAccountDtoOutputPickupsInnerSerializer();
}

class _$MerchantAccountDtoOutputPickupsInnerSerializer
    implements PrimitiveSerializer<MerchantAccountDtoOutputPickupsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantAccountDtoOutputPickupsInner,
    _$MerchantAccountDtoOutputPickupsInner,
  ];

  @override
  final String wireName = r'MerchantAccountDtoOutputPickupsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccountDtoOutputPickupsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield serializers.serialize(
      object.orderNumber,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'captainName';
    yield object.captainName == null
        ? null
        : serializers.serialize(
            object.captainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantAccountDtoOutputPickupsInnerLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAccountDtoOutputPickupsInner object, {
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
    required MerchantAccountDtoOutputPickupsInnerBuilder result,
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
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderNumber = valueDes;
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
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainName = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantAccountDtoOutputPickupsInnerLinesInner),
                    ]),
                  )
                  as BuiltList<MerchantAccountDtoOutputPickupsInnerLinesInner>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAccountDtoOutputPickupsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountDtoOutputPickupsInnerBuilder();
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
