//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_receipt_dto_output_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_receipt_dto_output.g.dart';

/// AdminRestaurantReceiptDtoOutput
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [number]
/// * [type]
/// * [sessionId]
/// * [method]
/// * [cashierId]
/// * [cashierName]
/// * [restaurantId]
/// * [restaurantName]
/// * [currency]
/// * [dueBefore]
/// * [total]
/// * [dueAfter]
/// * [createdAt]
/// * [lines]
@BuiltValue()
abstract class AdminRestaurantReceiptDtoOutput
    implements
        Built<
          AdminRestaurantReceiptDtoOutput,
          AdminRestaurantReceiptDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'type')
  AdminRestaurantReceiptDtoOutputTypeEnum get type;
  // enum typeEnum {  merchant_settlement,  merchant_payout,  };

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'method')
  AdminRestaurantReceiptDtoOutputMethodEnum get method;
  // enum methodEnum {  office,  };

  @BuiltValueField(wireName: r'cashierId')
  String get cashierId;

  @BuiltValueField(wireName: r'cashierName')
  String? get cashierName;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

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

  AdminRestaurantReceiptDtoOutput._();

  factory AdminRestaurantReceiptDtoOutput([
    void updates(AdminRestaurantReceiptDtoOutputBuilder b),
  ]) = _$AdminRestaurantReceiptDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantReceiptDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantReceiptDtoOutput> get serializer =>
      _$AdminRestaurantReceiptDtoOutputSerializer();
}

class _$AdminRestaurantReceiptDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantReceiptDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantReceiptDtoOutput,
    _$AdminRestaurantReceiptDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantReceiptDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantReceiptDtoOutput object, {
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
      specifiedType: const FullType(AdminRestaurantReceiptDtoOutputTypeEnum),
    );
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(AdminRestaurantReceiptDtoOutputMethodEnum),
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
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
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
    AdminRestaurantReceiptDtoOutput object, {
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
    required AdminRestaurantReceiptDtoOutputBuilder result,
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
                      AdminRestaurantReceiptDtoOutputTypeEnum,
                    ),
                  )
                  as AdminRestaurantReceiptDtoOutputTypeEnum;
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
        case r'method':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantReceiptDtoOutputMethodEnum,
                    ),
                  )
                  as AdminRestaurantReceiptDtoOutputMethodEnum;
          result.method = valueDes;
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
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
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
  AdminRestaurantReceiptDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantReceiptDtoOutputBuilder();
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

class AdminRestaurantReceiptDtoOutputTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant_settlement')
  static const AdminRestaurantReceiptDtoOutputTypeEnum merchantSettlement =
      _$adminRestaurantReceiptDtoOutputTypeEnum_merchantSettlement;
  @BuiltValueEnumConst(wireName: r'merchant_payout')
  static const AdminRestaurantReceiptDtoOutputTypeEnum merchantPayout =
      _$adminRestaurantReceiptDtoOutputTypeEnum_merchantPayout;

  static Serializer<AdminRestaurantReceiptDtoOutputTypeEnum> get serializer =>
      _$adminRestaurantReceiptDtoOutputTypeEnumSerializer;

  const AdminRestaurantReceiptDtoOutputTypeEnum._(String name) : super(name);

  static BuiltSet<AdminRestaurantReceiptDtoOutputTypeEnum> get values =>
      _$adminRestaurantReceiptDtoOutputTypeEnumValues;
  static AdminRestaurantReceiptDtoOutputTypeEnum valueOf(String name) =>
      _$adminRestaurantReceiptDtoOutputTypeEnumValueOf(name);
}

class AdminRestaurantReceiptDtoOutputMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'office')
  static const AdminRestaurantReceiptDtoOutputMethodEnum office =
      _$adminRestaurantReceiptDtoOutputMethodEnum_office;

  static Serializer<AdminRestaurantReceiptDtoOutputMethodEnum> get serializer =>
      _$adminRestaurantReceiptDtoOutputMethodEnumSerializer;

  const AdminRestaurantReceiptDtoOutputMethodEnum._(String name) : super(name);

  static BuiltSet<AdminRestaurantReceiptDtoOutputMethodEnum> get values =>
      _$adminRestaurantReceiptDtoOutputMethodEnumValues;
  static AdminRestaurantReceiptDtoOutputMethodEnum valueOf(String name) =>
      _$adminRestaurantReceiptDtoOutputMethodEnumValueOf(name);
}
