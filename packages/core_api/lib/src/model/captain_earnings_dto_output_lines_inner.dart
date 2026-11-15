//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_earnings_dto_output_lines_inner.g.dart';

/// CaptainEarningsDtoOutputLinesInner
///
/// Properties:
/// * [kind]
/// * [amount] - + to the captain, − taken off.
/// * [reason]
/// * [orderNumber] - A charge's order.
/// * [receiptNumber] - A payout's receipt.
/// * [at]
@BuiltValue()
abstract class CaptainEarningsDtoOutputLinesInner
    implements
        Built<
          CaptainEarningsDtoOutputLinesInner,
          CaptainEarningsDtoOutputLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  CaptainEarningsDtoOutputLinesInnerKindEnum get kind;
  // enum kindEnum {  bonus,  charge,  instalment,  payout,  adjustment,  };

  /// + to the captain, − taken off.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// A charge's order.
  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// A payout's receipt.
  @BuiltValueField(wireName: r'receiptNumber')
  String? get receiptNumber;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainEarningsDtoOutputLinesInner._();

  factory CaptainEarningsDtoOutputLinesInner([
    void updates(CaptainEarningsDtoOutputLinesInnerBuilder b),
  ]) = _$CaptainEarningsDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEarningsDtoOutputLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEarningsDtoOutputLinesInner> get serializer =>
      _$CaptainEarningsDtoOutputLinesInnerSerializer();
}

class _$CaptainEarningsDtoOutputLinesInnerSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutputLinesInner> {
  @override
  final Iterable<Type> types = const [
    CaptainEarningsDtoOutputLinesInner,
    _$CaptainEarningsDtoOutputLinesInner,
  ];

  @override
  final String wireName = r'CaptainEarningsDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEarningsDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(CaptainEarningsDtoOutputLinesInnerKindEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
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
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutputLinesInner object, {
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
    required CaptainEarningsDtoOutputLinesInnerBuilder result,
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
                    specifiedType: const FullType(
                      CaptainEarningsDtoOutputLinesInnerKindEnum,
                    ),
                  )
                  as CaptainEarningsDtoOutputLinesInnerKindEnum;
          result.kind = valueDes;
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
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
  CaptainEarningsDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEarningsDtoOutputLinesInnerBuilder();
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

class CaptainEarningsDtoOutputLinesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'bonus')
  static const CaptainEarningsDtoOutputLinesInnerKindEnum bonus =
      _$captainEarningsDtoOutputLinesInnerKindEnum_bonus;
  @BuiltValueEnumConst(wireName: r'charge')
  static const CaptainEarningsDtoOutputLinesInnerKindEnum charge =
      _$captainEarningsDtoOutputLinesInnerKindEnum_charge;
  @BuiltValueEnumConst(wireName: r'instalment')
  static const CaptainEarningsDtoOutputLinesInnerKindEnum instalment =
      _$captainEarningsDtoOutputLinesInnerKindEnum_instalment;
  @BuiltValueEnumConst(wireName: r'payout')
  static const CaptainEarningsDtoOutputLinesInnerKindEnum payout =
      _$captainEarningsDtoOutputLinesInnerKindEnum_payout;
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const CaptainEarningsDtoOutputLinesInnerKindEnum adjustment =
      _$captainEarningsDtoOutputLinesInnerKindEnum_adjustment;

  static Serializer<CaptainEarningsDtoOutputLinesInnerKindEnum>
  get serializer => _$captainEarningsDtoOutputLinesInnerKindEnumSerializer;

  const CaptainEarningsDtoOutputLinesInnerKindEnum._(String name) : super(name);

  static BuiltSet<CaptainEarningsDtoOutputLinesInnerKindEnum> get values =>
      _$captainEarningsDtoOutputLinesInnerKindEnumValues;
  static CaptainEarningsDtoOutputLinesInnerKindEnum valueOf(String name) =>
      _$captainEarningsDtoOutputLinesInnerKindEnumValueOf(name);
}
