//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_owner.g.dart';

/// RA §8.4, R10: owners only (null for a cashier, and on a cancelled order). After the pickup the pickup's items value is the base, less the restaurant's own edits (AP §9.3.3). No restaurant-funded discount until codes (Phase 2).
///
/// Properties:
/// * [testOrder] - «طلب تجريبي — لا عمولة» instead of the commission lines (AP §9.6.3).
/// * [commissionBp] - The rate at placing in basis points (1500 is 15%); null on a test order.
/// * [commission] - Integer minor units (AP §8.6).
/// * [merchantNet] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerOwner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerOwner,
          MerchantOrdersDtoOutputOrdersInnerOwnerBuilder
        > {
  /// «طلب تجريبي — لا عمولة» instead of the commission lines (AP §9.6.3).
  @BuiltValueField(wireName: r'testOrder')
  bool get testOrder;

  /// The rate at placing in basis points (1500 is 15%); null on a test order.
  @BuiltValueField(wireName: r'commissionBp')
  int? get commissionBp;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'commission')
  String? get commission;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'merchantNet')
  String? get merchantNet;

  MerchantOrdersDtoOutputOrdersInnerOwner._();

  factory MerchantOrdersDtoOutputOrdersInnerOwner([
    void updates(MerchantOrdersDtoOutputOrdersInnerOwnerBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerOwner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputOrdersInnerOwnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerOwner> get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerOwnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerOwnerSerializer
    implements PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerOwner> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerOwner,
    _$MerchantOrdersDtoOutputOrdersInnerOwner,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerOwner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'testOrder';
    yield serializers.serialize(
      object.testOrder,
      specifiedType: const FullType(bool),
    );
    yield r'commissionBp';
    yield object.commissionBp == null
        ? null
        : serializers.serialize(
            object.commissionBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'commission';
    yield object.commission == null
        ? null
        : serializers.serialize(
            object.commission,
            specifiedType: const FullType.nullable(String),
          );
    yield r'merchantNet';
    yield object.merchantNet == null
        ? null
        : serializers.serialize(
            object.merchantNet,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerOwner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerOwnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'testOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.testOrder = valueDes;
          break;
        case r'commissionBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.commissionBp = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.commission = valueDes;
          break;
        case r'merchantNet':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.merchantNet = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerOwner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerOwnerBuilder();
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
