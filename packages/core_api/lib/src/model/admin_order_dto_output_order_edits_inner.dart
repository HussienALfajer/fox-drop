//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_edits_inner_items_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_changes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_edits_inner.g.dart';

/// AdminOrderDtoOutputOrderEditsInner
///
/// Properties:
/// * [at]
/// * [adminId]
/// * [status] - The status when edited.
/// * [changes]
/// * [addsItems]
/// * [itemsValue]
/// * [deliveryFee]
/// * [total]
/// * [extraPrepMin]
/// * [responsible] - After the pickup: who bore the edit.
/// * [charge] - Integer minor units (AP §8.6).
/// * [acknowledgedAt] - «اطلعت على التعديل» on a restaurant device (RA §8.13).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderEditsInner
    implements
        Built<
          AdminOrderDtoOutputOrderEditsInner,
          AdminOrderDtoOutputOrderEditsInnerBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'adminId')
  String get adminId;

  /// The status when edited.
  @BuiltValueField(wireName: r'status')
  AdminOrderDtoOutputOrderEditsInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'changes')
  BuiltList<AdminEditPreviewAnswerDtoOutputChangesInner> get changes;

  @BuiltValueField(wireName: r'addsItems')
  bool get addsItems;

  @BuiltValueField(wireName: r'itemsValue')
  AdminOrderDtoOutputOrderEditsInnerItemsValue get itemsValue;

  @BuiltValueField(wireName: r'deliveryFee')
  AdminOrderDtoOutputOrderEditsInnerItemsValue get deliveryFee;

  @BuiltValueField(wireName: r'total')
  AdminOrderDtoOutputOrderEditsInnerItemsValue get total;

  @BuiltValueField(wireName: r'extraPrepMin')
  int? get extraPrepMin;

  /// After the pickup: who bore the edit.
  @BuiltValueField(wireName: r'responsible')
  AdminOrderDtoOutputOrderEditsInnerResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  platform,  };

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'charge')
  String? get charge;

  /// «اطلعت على التعديل» on a restaurant device (RA §8.13).
  @BuiltValueField(wireName: r'acknowledgedAt')
  DateTime? get acknowledgedAt;

  AdminOrderDtoOutputOrderEditsInner._();

  factory AdminOrderDtoOutputOrderEditsInner([
    void updates(AdminOrderDtoOutputOrderEditsInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderEditsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderEditsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderEditsInner> get serializer =>
      _$AdminOrderDtoOutputOrderEditsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderEditsInnerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderEditsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderEditsInner,
    _$AdminOrderDtoOutputOrderEditsInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderEditsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'adminId';
    yield serializers.serialize(
      object.adminId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderEditsInnerStatusEnum,
      ),
    );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminEditPreviewAnswerDtoOutputChangesInner),
      ]),
    );
    yield r'addsItems';
    yield serializers.serialize(
      object.addsItems,
      specifiedType: const FullType(bool),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderEditsInnerItemsValue,
      ),
    );
    yield r'deliveryFee';
    yield serializers.serialize(
      object.deliveryFee,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderEditsInnerItemsValue,
      ),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderEditsInnerItemsValue,
      ),
    );
    yield r'extraPrepMin';
    yield object.extraPrepMin == null
        ? null
        : serializers.serialize(
            object.extraPrepMin,
            specifiedType: const FullType.nullable(int),
          );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderEditsInnerResponsibleEnum,
            ),
          );
    yield r'charge';
    yield object.charge == null
        ? null
        : serializers.serialize(
            object.charge,
            specifiedType: const FullType.nullable(String),
          );
    yield r'acknowledgedAt';
    yield object.acknowledgedAt == null
        ? null
        : serializers.serialize(
            object.acknowledgedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditsInner object, {
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
    required AdminOrderDtoOutputOrderEditsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'adminId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adminId = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderEditsInnerStatusEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderEditsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminEditPreviewAnswerDtoOutputChangesInner),
                    ]),
                  )
                  as BuiltList<AdminEditPreviewAnswerDtoOutputChangesInner>;
          result.changes.replace(valueDes);
          break;
        case r'addsItems':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.addsItems = valueDes;
          break;
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderEditsInnerItemsValue,
                    ),
                  )
                  as AdminOrderDtoOutputOrderEditsInnerItemsValue;
          result.itemsValue.replace(valueDes);
          break;
        case r'deliveryFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderEditsInnerItemsValue,
                    ),
                  )
                  as AdminOrderDtoOutputOrderEditsInnerItemsValue;
          result.deliveryFee.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderEditsInnerItemsValue,
                    ),
                  )
                  as AdminOrderDtoOutputOrderEditsInnerItemsValue;
          result.total.replace(valueDes);
          break;
        case r'extraPrepMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.extraPrepMin = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderEditsInnerResponsibleEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderEditsInnerResponsibleEnum?;
          if (valueDes == null) continue;
          result.responsible = valueDes;
          break;
        case r'charge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.charge = valueDes;
          break;
        case r'acknowledgedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.acknowledgedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderEditsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderEditsInnerBuilder();
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

/// The status when edited.
class AdminOrderDtoOutputOrderEditsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum placed =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum accepted =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum ready =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum pickedUp =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum arrived =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum delivered =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum rejected =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum cancelled =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderDtoOutputOrderEditsInnerStatusEnum failed =
      _$adminOrderDtoOutputOrderEditsInnerStatusEnum_failed;

  static Serializer<AdminOrderDtoOutputOrderEditsInnerStatusEnum>
  get serializer => _$adminOrderDtoOutputOrderEditsInnerStatusEnumSerializer;

  const AdminOrderDtoOutputOrderEditsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderEditsInnerStatusEnum> get values =>
      _$adminOrderDtoOutputOrderEditsInnerStatusEnumValues;
  static AdminOrderDtoOutputOrderEditsInnerStatusEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderEditsInnerStatusEnumValueOf(name);
}

/// After the pickup: who bore the edit.
class AdminOrderDtoOutputOrderEditsInnerResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderDtoOutputOrderEditsInnerResponsibleEnum restaurant =
      _$adminOrderDtoOutputOrderEditsInnerResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderEditsInnerResponsibleEnum captain =
      _$adminOrderDtoOutputOrderEditsInnerResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderDtoOutputOrderEditsInnerResponsibleEnum platform =
      _$adminOrderDtoOutputOrderEditsInnerResponsibleEnum_platform;

  static Serializer<AdminOrderDtoOutputOrderEditsInnerResponsibleEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderEditsInnerResponsibleEnumSerializer;

  const AdminOrderDtoOutputOrderEditsInnerResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderEditsInnerResponsibleEnum>
  get values => _$adminOrderDtoOutputOrderEditsInnerResponsibleEnumValues;
  static AdminOrderDtoOutputOrderEditsInnerResponsibleEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderEditsInnerResponsibleEnumValueOf(name);
}
