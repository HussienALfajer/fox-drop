//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_record_deposit_answer_dto_output_receipt_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_record_deposit_answer_dto_output_receipt_conversions_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_deposit_answer_dto_output_receipt.g.dart';

/// None when nothing was paid now.
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [number] - Such as AZ-2026-000123 (AP §4.8).
/// * [type]
/// * [sessionId]
/// * [cashierId]
/// * [cashierName]
/// * [captainId]
/// * [captainName]
/// * [createdAt]
/// * [conversions]
/// * [lines]
@BuiltValue()
abstract class AdminRecordDepositAnswerDtoOutputReceipt
    implements
        Built<
          AdminRecordDepositAnswerDtoOutputReceipt,
          AdminRecordDepositAnswerDtoOutputReceiptBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Such as AZ-2026-000123 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'type')
  AdminRecordDepositAnswerDtoOutputReceiptTypeEnum get type;
  // enum typeEnum {  captain_hand_in,  captain_reimbursement,  captain_payout,  captain_earnings_collection,  captain_deposit,  captain_deposit_refund,  };

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'cashierId')
  String get cashierId;

  @BuiltValueField(wireName: r'cashierName')
  String? get cashierName;

  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'captainName')
  String get captainName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'conversions')
  BuiltList<AdminRecordDepositAnswerDtoOutputReceiptConversionsInner>
  get conversions;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRecordDepositAnswerDtoOutputReceiptLinesInner> get lines;

  AdminRecordDepositAnswerDtoOutputReceipt._();

  factory AdminRecordDepositAnswerDtoOutputReceipt([
    void updates(AdminRecordDepositAnswerDtoOutputReceiptBuilder b),
  ]) = _$AdminRecordDepositAnswerDtoOutputReceipt;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordDepositAnswerDtoOutputReceiptBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordDepositAnswerDtoOutputReceipt> get serializer =>
      _$AdminRecordDepositAnswerDtoOutputReceiptSerializer();
}

class _$AdminRecordDepositAnswerDtoOutputReceiptSerializer
    implements PrimitiveSerializer<AdminRecordDepositAnswerDtoOutputReceipt> {
  @override
  final Iterable<Type> types = const [
    AdminRecordDepositAnswerDtoOutputReceipt,
    _$AdminRecordDepositAnswerDtoOutputReceipt,
  ];

  @override
  final String wireName = r'AdminRecordDepositAnswerDtoOutputReceipt';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordDepositAnswerDtoOutputReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
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
        AdminRecordDepositAnswerDtoOutputReceiptTypeEnum,
      ),
    );
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'cashierId';
    yield serializers.serialize(
      object.cashierId,
      specifiedType: const FullType(String),
    );
    yield r'cashierName';
    yield object.cashierName == null
        ? null
        : serializers.serialize(
            object.cashierName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'captainName';
    yield serializers.serialize(
      object.captainName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'conversions';
    yield serializers.serialize(
      object.conversions,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRecordDepositAnswerDtoOutputReceiptConversionsInner),
      ]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRecordDepositAnswerDtoOutputReceiptLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDepositAnswerDtoOutputReceipt object, {
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
    required AdminRecordDepositAnswerDtoOutputReceiptBuilder result,
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
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
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
                      AdminRecordDepositAnswerDtoOutputReceiptTypeEnum,
                    ),
                  )
                  as AdminRecordDepositAnswerDtoOutputReceiptTypeEnum;
          result.type = valueDes;
          break;
        case r'sessionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sessionId = valueDes;
          break;
        case r'cashierId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cashierId = valueDes;
          break;
        case r'cashierName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cashierName = valueDes;
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainName = valueDes;
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
        case r'conversions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRecordDepositAnswerDtoOutputReceiptConversionsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRecordDepositAnswerDtoOutputReceiptConversionsInner
                  >;
          result.conversions.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRecordDepositAnswerDtoOutputReceiptLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRecordDepositAnswerDtoOutputReceiptLinesInner
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
  AdminRecordDepositAnswerDtoOutputReceipt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordDepositAnswerDtoOutputReceiptBuilder();
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

class AdminRecordDepositAnswerDtoOutputReceiptTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain_hand_in')
  static const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum captainHandIn =
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainHandIn;
  @BuiltValueEnumConst(wireName: r'captain_reimbursement')
  static const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
  captainReimbursement =
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainReimbursement;
  @BuiltValueEnumConst(wireName: r'captain_payout')
  static const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum captainPayout =
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainPayout;
  @BuiltValueEnumConst(wireName: r'captain_earnings_collection')
  static const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
  captainEarningsCollection =
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainEarningsCollection;
  @BuiltValueEnumConst(wireName: r'captain_deposit')
  static const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum captainDeposit =
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainDeposit;
  @BuiltValueEnumConst(wireName: r'captain_deposit_refund')
  static const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum
  captainDepositRefund =
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnum_captainDepositRefund;

  static Serializer<AdminRecordDepositAnswerDtoOutputReceiptTypeEnum>
  get serializer =>
      _$adminRecordDepositAnswerDtoOutputReceiptTypeEnumSerializer;

  const AdminRecordDepositAnswerDtoOutputReceiptTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminRecordDepositAnswerDtoOutputReceiptTypeEnum>
  get values => _$adminRecordDepositAnswerDtoOutputReceiptTypeEnumValues;
  static AdminRecordDepositAnswerDtoOutputReceiptTypeEnum valueOf(
    String name,
  ) => _$adminRecordDepositAnswerDtoOutputReceiptTypeEnumValueOf(name);
}
