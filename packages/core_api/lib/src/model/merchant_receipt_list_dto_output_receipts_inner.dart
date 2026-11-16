//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_receipt_list_dto_output_receipts_inner_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_receipt_list_dto_output_receipts_inner.g.dart';

/// MerchantReceiptListDtoOutputReceiptsInner
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
@BuiltValue()
abstract class MerchantReceiptListDtoOutputReceiptsInner
    implements
        Built<
          MerchantReceiptListDtoOutputReceiptsInner,
          MerchantReceiptListDtoOutputReceiptsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  /// The restaurant paid, or FOX DROP paid it.
  @BuiltValueField(wireName: r'type')
  MerchantReceiptListDtoOutputReceiptsInnerTypeEnum get type;
  // enum typeEnum {  merchant_settlement,  merchant_payout,  };

  /// «في المكتب» or «زيارة ميدانية».
  @BuiltValueField(wireName: r'method')
  MerchantReceiptListDtoOutputReceiptsInnerMethodEnum get method;
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

  MerchantReceiptListDtoOutputReceiptsInner._();

  factory MerchantReceiptListDtoOutputReceiptsInner([
    void updates(MerchantReceiptListDtoOutputReceiptsInnerBuilder b),
  ]) = _$MerchantReceiptListDtoOutputReceiptsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReceiptListDtoOutputReceiptsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReceiptListDtoOutputReceiptsInner> get serializer =>
      _$MerchantReceiptListDtoOutputReceiptsInnerSerializer();
}

class _$MerchantReceiptListDtoOutputReceiptsInnerSerializer
    implements PrimitiveSerializer<MerchantReceiptListDtoOutputReceiptsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantReceiptListDtoOutputReceiptsInner,
    _$MerchantReceiptListDtoOutputReceiptsInner,
  ];

  @override
  final String wireName = r'MerchantReceiptListDtoOutputReceiptsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReceiptListDtoOutputReceiptsInner object, {
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
      specifiedType: const FullType(
        MerchantReceiptListDtoOutputReceiptsInnerTypeEnum,
      ),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(
        MerchantReceiptListDtoOutputReceiptsInnerMethodEnum,
      ),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptListDtoOutputReceiptsInner object, {
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
    required MerchantReceiptListDtoOutputReceiptsInnerBuilder result,
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
                      MerchantReceiptListDtoOutputReceiptsInnerTypeEnum,
                    ),
                  )
                  as MerchantReceiptListDtoOutputReceiptsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'method':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantReceiptListDtoOutputReceiptsInnerMethodEnum,
                    ),
                  )
                  as MerchantReceiptListDtoOutputReceiptsInnerMethodEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReceiptListDtoOutputReceiptsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReceiptListDtoOutputReceiptsInnerBuilder();
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
class MerchantReceiptListDtoOutputReceiptsInnerTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant_settlement')
  static const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum
  merchantSettlement =
      _$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantSettlement;
  @BuiltValueEnumConst(wireName: r'merchant_payout')
  static const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum
  merchantPayout =
      _$merchantReceiptListDtoOutputReceiptsInnerTypeEnum_merchantPayout;

  static Serializer<MerchantReceiptListDtoOutputReceiptsInnerTypeEnum>
  get serializer =>
      _$merchantReceiptListDtoOutputReceiptsInnerTypeEnumSerializer;

  const MerchantReceiptListDtoOutputReceiptsInnerTypeEnum._(String name)
    : super(name);

  static BuiltSet<MerchantReceiptListDtoOutputReceiptsInnerTypeEnum>
  get values => _$merchantReceiptListDtoOutputReceiptsInnerTypeEnumValues;
  static MerchantReceiptListDtoOutputReceiptsInnerTypeEnum valueOf(
    String name,
  ) => _$merchantReceiptListDtoOutputReceiptsInnerTypeEnumValueOf(name);
}

/// «في المكتب» or «زيارة ميدانية».
class MerchantReceiptListDtoOutputReceiptsInnerMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'office')
  static const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum office =
      _$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_office;
  @BuiltValueEnumConst(wireName: r'field')
  static const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum field =
      _$merchantReceiptListDtoOutputReceiptsInnerMethodEnum_field;

  static Serializer<MerchantReceiptListDtoOutputReceiptsInnerMethodEnum>
  get serializer =>
      _$merchantReceiptListDtoOutputReceiptsInnerMethodEnumSerializer;

  const MerchantReceiptListDtoOutputReceiptsInnerMethodEnum._(String name)
    : super(name);

  static BuiltSet<MerchantReceiptListDtoOutputReceiptsInnerMethodEnum>
  get values => _$merchantReceiptListDtoOutputReceiptsInnerMethodEnumValues;
  static MerchantReceiptListDtoOutputReceiptsInnerMethodEnum valueOf(
    String name,
  ) => _$merchantReceiptListDtoOutputReceiptsInnerMethodEnumValueOf(name);
}
