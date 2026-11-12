//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_hand_in_receipts_dto_output_receipts_inner_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_receipts_dto_output_receipts_inner.g.dart';

/// AdminHandInReceiptsDtoOutputReceiptsInner
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
/// * [lines]
@BuiltValue()
abstract class AdminHandInReceiptsDtoOutputReceiptsInner
    implements
        Built<
          AdminHandInReceiptsDtoOutputReceiptsInner,
          AdminHandInReceiptsDtoOutputReceiptsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Such as AZ-2026-000123 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'type')
  AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum get type;
  // enum typeEnum {  captain_hand_in,  captain_reimbursement,  };

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

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner> get lines;

  AdminHandInReceiptsDtoOutputReceiptsInner._();

  factory AdminHandInReceiptsDtoOutputReceiptsInner([
    void updates(AdminHandInReceiptsDtoOutputReceiptsInnerBuilder b),
  ]) = _$AdminHandInReceiptsDtoOutputReceiptsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInReceiptsDtoOutputReceiptsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInReceiptsDtoOutputReceiptsInner> get serializer =>
      _$AdminHandInReceiptsDtoOutputReceiptsInnerSerializer();
}

class _$AdminHandInReceiptsDtoOutputReceiptsInnerSerializer
    implements PrimitiveSerializer<AdminHandInReceiptsDtoOutputReceiptsInner> {
  @override
  final Iterable<Type> types = const [
    AdminHandInReceiptsDtoOutputReceiptsInner,
    _$AdminHandInReceiptsDtoOutputReceiptsInner,
  ];

  @override
  final String wireName = r'AdminHandInReceiptsDtoOutputReceiptsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInReceiptsDtoOutputReceiptsInner object, {
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
        AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum,
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
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandInReceiptsDtoOutputReceiptsInner object, {
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
    required AdminHandInReceiptsDtoOutputReceiptsInnerBuilder result,
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
                      AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum,
                    ),
                  )
                  as AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum;
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
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner
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
  AdminHandInReceiptsDtoOutputReceiptsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInReceiptsDtoOutputReceiptsInnerBuilder();
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

class AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain_hand_in')
  static const AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum captainHandIn =
      _$adminHandInReceiptsDtoOutputReceiptsInnerTypeEnum_captainHandIn;
  @BuiltValueEnumConst(wireName: r'captain_reimbursement')
  static const AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum
  captainReimbursement =
      _$adminHandInReceiptsDtoOutputReceiptsInnerTypeEnum_captainReimbursement;

  static Serializer<AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum>
  get serializer =>
      _$adminHandInReceiptsDtoOutputReceiptsInnerTypeEnumSerializer;

  const AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum>
  get values => _$adminHandInReceiptsDtoOutputReceiptsInnerTypeEnumValues;
  static AdminHandInReceiptsDtoOutputReceiptsInnerTypeEnum valueOf(
    String name,
  ) => _$adminHandInReceiptsDtoOutputReceiptsInnerTypeEnumValueOf(name);
}
