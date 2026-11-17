//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_receipt_dto_output_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_receipts_dto_output_receipts_inner.g.dart';

/// AdminCustomerReceiptsDtoOutputReceiptsInner
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [number]
/// * [sessionId]
/// * [cashierId]
/// * [cashierName]
/// * [customerId]
/// * [customerName]
/// * [currency]
/// * [dueBefore]
/// * [total]
/// * [dueAfter]
/// * [createdAt]
/// * [lines]
@BuiltValue()
abstract class AdminCustomerReceiptsDtoOutputReceiptsInner
    implements
        Built<
          AdminCustomerReceiptsDtoOutputReceiptsInner,
          AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'cashierId')
  String get cashierId;

  @BuiltValueField(wireName: r'cashierName')
  String? get cashierName;

  @BuiltValueField(wireName: r'customerId')
  String get customerId;

  @BuiltValueField(wireName: r'customerName')
  String get customerName;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'dueBefore')
  String get dueBefore;

  @BuiltValueField(wireName: r'total')
  String get total;

  @BuiltValueField(wireName: r'dueAfter')
  String get dueAfter;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminRestaurantReceiptDtoOutputLinesInner> get lines;

  AdminCustomerReceiptsDtoOutputReceiptsInner._();

  factory AdminCustomerReceiptsDtoOutputReceiptsInner([
    void updates(AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder b),
  ]) = _$AdminCustomerReceiptsDtoOutputReceiptsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerReceiptsDtoOutputReceiptsInner>
  get serializer => _$AdminCustomerReceiptsDtoOutputReceiptsInnerSerializer();
}

class _$AdminCustomerReceiptsDtoOutputReceiptsInnerSerializer
    implements
        PrimitiveSerializer<AdminCustomerReceiptsDtoOutputReceiptsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerReceiptsDtoOutputReceiptsInner,
    _$AdminCustomerReceiptsDtoOutputReceiptsInner,
  ];

  @override
  final String wireName = r'AdminCustomerReceiptsDtoOutputReceiptsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerReceiptsDtoOutputReceiptsInner object, {
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
    yield r'customerId';
    yield serializers.serialize(
      object.customerId,
      specifiedType: const FullType(String),
    );
    yield r'customerName';
    yield serializers.serialize(
      object.customerName,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'dueBefore';
    yield serializers.serialize(
      object.dueBefore,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'dueAfter';
    yield serializers.serialize(
      object.dueAfter,
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
        FullType(AdminRestaurantReceiptDtoOutputLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerReceiptsDtoOutputReceiptsInner object, {
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
    required AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder result,
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
        case r'customerId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerId = valueDes;
          break;
        case r'customerName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerName = valueDes;
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
        case r'dueBefore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.dueBefore = valueDes;
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
        case r'dueAfter':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.dueAfter = valueDes;
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
                      FullType(AdminRestaurantReceiptDtoOutputLinesInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantReceiptDtoOutputLinesInner>;
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
  AdminCustomerReceiptsDtoOutputReceiptsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerReceiptsDtoOutputReceiptsInnerBuilder();
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
