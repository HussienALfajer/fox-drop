//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settle_dto_payout_rates_inner.g.dart';

/// AdminSettleDtoPayoutRatesInner
///
/// Properties:
/// * [currency]
/// * [rateVersionId]
@BuiltValue()
abstract class AdminSettleDtoPayoutRatesInner
    implements
        Built<
          AdminSettleDtoPayoutRatesInner,
          AdminSettleDtoPayoutRatesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'rateVersionId')
  String get rateVersionId;

  AdminSettleDtoPayoutRatesInner._();

  factory AdminSettleDtoPayoutRatesInner([
    void updates(AdminSettleDtoPayoutRatesInnerBuilder b),
  ]) = _$AdminSettleDtoPayoutRatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettleDtoPayoutRatesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettleDtoPayoutRatesInner> get serializer =>
      _$AdminSettleDtoPayoutRatesInnerSerializer();
}

class _$AdminSettleDtoPayoutRatesInnerSerializer
    implements PrimitiveSerializer<AdminSettleDtoPayoutRatesInner> {
  @override
  final Iterable<Type> types = const [
    AdminSettleDtoPayoutRatesInner,
    _$AdminSettleDtoPayoutRatesInner,
  ];

  @override
  final String wireName = r'AdminSettleDtoPayoutRatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettleDtoPayoutRatesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'rateVersionId';
    yield serializers.serialize(
      object.rateVersionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettleDtoPayoutRatesInner object, {
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
    required AdminSettleDtoPayoutRatesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'rateVersionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.rateVersionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettleDtoPayoutRatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettleDtoPayoutRatesInnerBuilder();
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
