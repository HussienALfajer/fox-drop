//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_custody_dto_output_entries_inner_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_custody_dto_output_entries_inner.g.dart';

/// CaptainCustodyDtoOutputEntriesInner
///
/// Properties:
/// * [kind] - Null for a kind the app does not name.
/// * [orderNumber] - The order's number, for an order's entry.
/// * [receiptNumber] - The receipt, for a desk entry.
/// * [amount]
/// * [at]
@BuiltValue()
abstract class CaptainCustodyDtoOutputEntriesInner
    implements
        Built<
          CaptainCustodyDtoOutputEntriesInner,
          CaptainCustodyDtoOutputEntriesInnerBuilder
        > {
  /// Null for a kind the app does not name.
  @BuiltValueField(wireName: r'kind')
  CaptainCustodyDtoOutputEntriesInnerKindEnum? get kind;
  // enum kindEnum {  pay_merchant,  collect,  change_given,  hand_in,  reimburse,  fx_convert,  pickup_correction,  adjustment,  };

  /// The order's number, for an order's entry.
  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// The receipt, for a desk entry.
  @BuiltValueField(wireName: r'receiptNumber')
  String? get receiptNumber;

  @BuiltValueField(wireName: r'amount')
  CaptainCustodyDtoOutputEntriesInnerAmount get amount;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainCustodyDtoOutputEntriesInner._();

  factory CaptainCustodyDtoOutputEntriesInner([
    void updates(CaptainCustodyDtoOutputEntriesInnerBuilder b),
  ]) = _$CaptainCustodyDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCustodyDtoOutputEntriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustodyDtoOutputEntriesInner> get serializer =>
      _$CaptainCustodyDtoOutputEntriesInnerSerializer();
}

class _$CaptainCustodyDtoOutputEntriesInnerSerializer
    implements PrimitiveSerializer<CaptainCustodyDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    CaptainCustodyDtoOutputEntriesInner,
    _$CaptainCustodyDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'CaptainCustodyDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustodyDtoOutputEntriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield object.kind == null
        ? null
        : serializers.serialize(
            object.kind,
            specifiedType: const FullType.nullable(
              CaptainCustodyDtoOutputEntriesInnerKindEnum,
            ),
          );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'receiptNumber';
    yield object.receiptNumber == null
        ? null
        : serializers.serialize(
            object.receiptNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(CaptainCustodyDtoOutputEntriesInnerAmount),
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
    CaptainCustodyDtoOutputEntriesInner object, {
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
    required CaptainCustodyDtoOutputEntriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainCustodyDtoOutputEntriesInnerKindEnum,
                    ),
                  )
                  as CaptainCustodyDtoOutputEntriesInnerKindEnum?;
          if (valueDes == null) continue;
          result.kind = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'receiptNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.receiptNumber = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainCustodyDtoOutputEntriesInnerAmount,
                    ),
                  )
                  as CaptainCustodyDtoOutputEntriesInnerAmount;
          result.amount.replace(valueDes);
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
  CaptainCustodyDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCustodyDtoOutputEntriesInnerBuilder();
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

/// Null for a kind the app does not name.
class CaptainCustodyDtoOutputEntriesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pay_merchant')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum payMerchant =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_payMerchant;
  @BuiltValueEnumConst(wireName: r'collect')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum collect =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_collect;
  @BuiltValueEnumConst(wireName: r'change_given')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum changeGiven =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_changeGiven;
  @BuiltValueEnumConst(wireName: r'hand_in')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum handIn =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_handIn;
  @BuiltValueEnumConst(wireName: r'reimburse')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum reimburse =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_reimburse;
  @BuiltValueEnumConst(wireName: r'fx_convert')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum fxConvert =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_fxConvert;
  @BuiltValueEnumConst(wireName: r'pickup_correction')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum pickupCorrection =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_pickupCorrection;
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const CaptainCustodyDtoOutputEntriesInnerKindEnum adjustment =
      _$captainCustodyDtoOutputEntriesInnerKindEnum_adjustment;

  static Serializer<CaptainCustodyDtoOutputEntriesInnerKindEnum>
  get serializer => _$captainCustodyDtoOutputEntriesInnerKindEnumSerializer;

  const CaptainCustodyDtoOutputEntriesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<CaptainCustodyDtoOutputEntriesInnerKindEnum> get values =>
      _$captainCustodyDtoOutputEntriesInnerKindEnumValues;
  static CaptainCustodyDtoOutputEntriesInnerKindEnum valueOf(String name) =>
      _$captainCustodyDtoOutputEntriesInnerKindEnumValueOf(name);
}
