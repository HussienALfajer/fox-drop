//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_outcome_history_inner.g.dart';

/// AdminOrderDtoOutputOrderOutcomeHistoryInner
///
/// Properties:
/// * [at]
/// * [replacedAt]
/// * [outcome] - AP §8.9; fake needs the customer responsible, and only fake takes the customer.
/// * [status]
/// * [responsible]
/// * [food] - A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
/// * [note]
/// * [setBy]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOutcomeHistoryInner
    implements
        Built<
          AdminOrderDtoOutputOrderOutcomeHistoryInner,
          AdminOrderDtoOutputOrderOutcomeHistoryInnerBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'replacedAt')
  DateTime get replacedAt;

  /// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
  @BuiltValueField(wireName: r'outcome')
  AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'status')
  AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum get status;
  // enum statusEnum {  delivered,  failed,  };

  @BuiltValueField(wireName: r'responsible')
  AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
  @BuiltValueField(wireName: r'food')
  AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'setBy')
  String get setBy;

  AdminOrderDtoOutputOrderOutcomeHistoryInner._();

  factory AdminOrderDtoOutputOrderOutcomeHistoryInner([
    void updates(AdminOrderDtoOutputOrderOutcomeHistoryInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderOutcomeHistoryInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderOutcomeHistoryInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOutcomeHistoryInner>
  get serializer => _$AdminOrderDtoOutputOrderOutcomeHistoryInnerSerializer();
}

class _$AdminOrderDtoOutputOrderOutcomeHistoryInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderOutcomeHistoryInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderOutcomeHistoryInner,
    _$AdminOrderDtoOutputOrderOutcomeHistoryInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOutcomeHistoryInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeHistoryInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'replacedAt';
    yield serializers.serialize(
      object.replacedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum,
      ),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum,
      ),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(
        AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum,
      ),
    );
    yield r'food';
    yield object.food == null
        ? null
        : serializers.serialize(
            object.food,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum,
            ),
          );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'setBy';
    yield serializers.serialize(
      object.setBy,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOutcomeHistoryInner object, {
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
    required AdminOrderDtoOutputOrderOutcomeHistoryInnerBuilder result,
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
        case r'replacedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.replacedAt = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'food':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum?;
          if (valueDes == null) continue;
          result.food = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        case r'setBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.setBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderOutcomeHistoryInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOutcomeHistoryInnerBuilder();
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

/// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
class AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum free =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum fake =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum damaged =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum
  wrongRefused =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum
  failedOther =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum_failedOther;

  static Serializer<AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum>
  get values => _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnumValues;
  static AdminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderOutcomeHistoryInnerOutcomeEnumValueOf(name);
}

class AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum delivered =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum failed =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum_failed;

  static Serializer<AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum>
  get values => _$adminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnumValues;
  static AdminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderOutcomeHistoryInnerStatusEnumValueOf(name);
}

class AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum
  restaurant =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum
  captain =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum
  customer =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum
  platform =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum_platform;

  static Serializer<AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum>
  get values =>
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnumValues;
  static AdminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnum valueOf(
    String name,
  ) =>
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerResponsibleEnumValueOf(name);
}

/// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
class AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum
  keptByCaptain =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum
  returnedToRestaurant =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum destroyed =
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum_destroyed;

  static Serializer<AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnumSerializer;

  const AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum>
  get values => _$adminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnumValues;
  static AdminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderOutcomeHistoryInnerFoodEnumValueOf(name);
}
