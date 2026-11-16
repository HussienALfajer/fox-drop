//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_receipt_list_dto_output_receipts_inner_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_receipt_dto_output.g.dart';

/// MerchantReceiptDtoOutput
///
/// Properties:
/// * [id]
/// * [number]
/// * [type] - The restaurant paid, or FOX DROP paid it.
/// * [method] - «في المكتب» or «زيارة ميدانية».
/// * [staffName] - The staff member: the visitor on a field visit, else the cashier.
/// * [currency] - The account's base currency.
/// * [total] - In the base.
/// * [createdAt]
/// * [lines]
/// * [dueBefore] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [dueAfter] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
@BuiltValue()
abstract class MerchantReceiptDtoOutput
    implements
        Built<MerchantReceiptDtoOutput, MerchantReceiptDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  /// The restaurant paid, or FOX DROP paid it.
  @BuiltValueField(wireName: r'type')
  MerchantReceiptDtoOutputTypeEnum get type;
  // enum typeEnum {  merchant_settlement,  merchant_payout,  };

  /// «في المكتب» or «زيارة ميدانية».
  @BuiltValueField(wireName: r'method')
  MerchantReceiptDtoOutputMethodEnum get method;
  // enum methodEnum {  office,  field,  };

  /// The staff member: the visitor on a field visit, else the cashier.
  @BuiltValueField(wireName: r'staffName')
  String? get staffName;

  /// The account's base currency.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// In the base.
  @BuiltValueField(wireName: r'total')
  String get total;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantReceiptListDtoOutputReceiptsInnerLinesInner> get lines;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'dueBefore')
  String get dueBefore;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'dueAfter')
  String get dueAfter;

  MerchantReceiptDtoOutput._();

  factory MerchantReceiptDtoOutput([
    void updates(MerchantReceiptDtoOutputBuilder b),
  ]) = _$MerchantReceiptDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReceiptDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReceiptDtoOutput> get serializer =>
      _$MerchantReceiptDtoOutputSerializer();
}

class _$MerchantReceiptDtoOutputSerializer
    implements PrimitiveSerializer<MerchantReceiptDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantReceiptDtoOutput,
    _$MerchantReceiptDtoOutput,
  ];

  @override
  final String wireName = r'MerchantReceiptDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReceiptDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(MerchantReceiptDtoOutputTypeEnum),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(MerchantReceiptDtoOutputMethodEnum),
    );
    yield r'staffName';
    yield object.staffName == null
        ? null
        : serializers.serialize(
            object.staffName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantReceiptListDtoOutputReceiptsInnerLinesInner),
      ]),
    );
    yield r'dueBefore';
    yield serializers.serialize(
      object.dueBefore,
      specifiedType: const FullType(String),
    );
    yield r'dueAfter';
    yield serializers.serialize(
      object.dueAfter,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptDtoOutput object, {
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
    required MerchantReceiptDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantReceiptDtoOutputTypeEnum,
                    ),
                  )
                  as MerchantReceiptDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'method':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantReceiptDtoOutputMethodEnum,
                    ),
                  )
                  as MerchantReceiptDtoOutputMethodEnum;
          result.method = valueDes;
          break;
        case r'staffName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.staffName = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantReceiptListDtoOutputReceiptsInnerLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantReceiptListDtoOutputReceiptsInnerLinesInner
                  >;
          result.lines.replace(valueDes);
          break;
        case r'dueBefore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.dueBefore = valueDes;
          break;
        case r'dueAfter':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.dueAfter = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReceiptDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReceiptDtoOutputBuilder();
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

/// The restaurant paid, or FOX DROP paid it.
class MerchantReceiptDtoOutputTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant_settlement')
  static const MerchantReceiptDtoOutputTypeEnum merchantSettlement =
      _$merchantReceiptDtoOutputTypeEnum_merchantSettlement;
  @BuiltValueEnumConst(wireName: r'merchant_payout')
  static const MerchantReceiptDtoOutputTypeEnum merchantPayout =
      _$merchantReceiptDtoOutputTypeEnum_merchantPayout;

  static Serializer<MerchantReceiptDtoOutputTypeEnum> get serializer =>
      _$merchantReceiptDtoOutputTypeEnumSerializer;

  const MerchantReceiptDtoOutputTypeEnum._(String name) : super(name);

  static BuiltSet<MerchantReceiptDtoOutputTypeEnum> get values =>
      _$merchantReceiptDtoOutputTypeEnumValues;
  static MerchantReceiptDtoOutputTypeEnum valueOf(String name) =>
      _$merchantReceiptDtoOutputTypeEnumValueOf(name);
}

/// «في المكتب» or «زيارة ميدانية».
class MerchantReceiptDtoOutputMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'office')
  static const MerchantReceiptDtoOutputMethodEnum office =
      _$merchantReceiptDtoOutputMethodEnum_office;
  @BuiltValueEnumConst(wireName: r'field')
  static const MerchantReceiptDtoOutputMethodEnum field =
      _$merchantReceiptDtoOutputMethodEnum_field;

  static Serializer<MerchantReceiptDtoOutputMethodEnum> get serializer =>
      _$merchantReceiptDtoOutputMethodEnumSerializer;

  const MerchantReceiptDtoOutputMethodEnum._(String name) : super(name);

  static BuiltSet<MerchantReceiptDtoOutputMethodEnum> get values =>
      _$merchantReceiptDtoOutputMethodEnumValues;
  static MerchantReceiptDtoOutputMethodEnum valueOf(String name) =>
      _$merchantReceiptDtoOutputMethodEnumValueOf(name);
}
