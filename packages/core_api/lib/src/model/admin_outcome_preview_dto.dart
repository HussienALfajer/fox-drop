//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_preview_dto.g.dart';

/// AdminOutcomePreviewDto
///
/// Properties:
/// * [outcome] - AP §8.9; fake needs the customer responsible, and only fake takes the customer.
/// * [responsible]
/// * [delivered] - Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
/// * [food] - A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
/// * [amountToCollect] - What the customer still pays, in the base currency (K9): above 0 only on a delivered outcome and below the order total (owner decisions 2026-11-10), else 400 invalid_outcome. Above 0 the order waits «بانتظار تسجيل التحصيل» and the outcome is posted from the payment recorded.
@BuiltValue()
abstract class AdminOutcomePreviewDto
    implements Built<AdminOutcomePreviewDto, AdminOutcomePreviewDtoBuilder> {
  /// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
  @BuiltValueField(wireName: r'outcome')
  AdminOutcomePreviewDtoOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'responsible')
  AdminOutcomePreviewDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
  @BuiltValueField(wireName: r'delivered')
  bool get delivered;

  /// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
  @BuiltValueField(wireName: r'food')
  AdminOutcomePreviewDtoFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  /// What the customer still pays, in the base currency (K9): above 0 only on a delivered outcome and below the order total (owner decisions 2026-11-10), else 400 invalid_outcome. Above 0 the order waits «بانتظار تسجيل التحصيل» and the outcome is posted from the payment recorded.
  @BuiltValueField(wireName: r'amountToCollect')
  String? get amountToCollect;

  AdminOutcomePreviewDto._();

  factory AdminOutcomePreviewDto([
    void updates(AdminOutcomePreviewDtoBuilder b),
  ]) = _$AdminOutcomePreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOutcomePreviewDtoBuilder b) =>
      b..amountToCollect = '0';

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomePreviewDto> get serializer =>
      _$AdminOutcomePreviewDtoSerializer();
}

class _$AdminOutcomePreviewDtoSerializer
    implements PrimitiveSerializer<AdminOutcomePreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomePreviewDto,
    _$AdminOutcomePreviewDto,
  ];

  @override
  final String wireName = r'AdminOutcomePreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomePreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminOutcomePreviewDtoOutcomeEnum),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminOutcomePreviewDtoResponsibleEnum),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(bool),
    );
    yield r'food';
    yield object.food == null
        ? null
        : serializers.serialize(
            object.food,
            specifiedType: const FullType.nullable(
              AdminOutcomePreviewDtoFoodEnum,
            ),
          );
    if (object.amountToCollect != null) {
      yield r'amountToCollect';
      yield serializers.serialize(
        object.amountToCollect,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewDto object, {
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
    required AdminOutcomePreviewDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomePreviewDtoOutcomeEnum,
                    ),
                  )
                  as AdminOutcomePreviewDtoOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomePreviewDtoResponsibleEnum,
                    ),
                  )
                  as AdminOutcomePreviewDtoResponsibleEnum;
          result.responsible = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.delivered = valueDes;
          break;
        case r'food':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOutcomePreviewDtoFoodEnum,
                    ),
                  )
                  as AdminOutcomePreviewDtoFoodEnum?;
          if (valueDes == null) continue;
          result.food = valueDes;
          break;
        case r'amountToCollect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amountToCollect = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOutcomePreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomePreviewDtoBuilder();
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
class AdminOutcomePreviewDtoOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOutcomePreviewDtoOutcomeEnum free =
      _$adminOutcomePreviewDtoOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOutcomePreviewDtoOutcomeEnum fake =
      _$adminOutcomePreviewDtoOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOutcomePreviewDtoOutcomeEnum damaged =
      _$adminOutcomePreviewDtoOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOutcomePreviewDtoOutcomeEnum wrongRefused =
      _$adminOutcomePreviewDtoOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOutcomePreviewDtoOutcomeEnum failedOther =
      _$adminOutcomePreviewDtoOutcomeEnum_failedOther;

  static Serializer<AdminOutcomePreviewDtoOutcomeEnum> get serializer =>
      _$adminOutcomePreviewDtoOutcomeEnumSerializer;

  const AdminOutcomePreviewDtoOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminOutcomePreviewDtoOutcomeEnum> get values =>
      _$adminOutcomePreviewDtoOutcomeEnumValues;
  static AdminOutcomePreviewDtoOutcomeEnum valueOf(String name) =>
      _$adminOutcomePreviewDtoOutcomeEnumValueOf(name);
}

class AdminOutcomePreviewDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOutcomePreviewDtoResponsibleEnum restaurant =
      _$adminOutcomePreviewDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOutcomePreviewDtoResponsibleEnum captain =
      _$adminOutcomePreviewDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOutcomePreviewDtoResponsibleEnum customer =
      _$adminOutcomePreviewDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOutcomePreviewDtoResponsibleEnum platform =
      _$adminOutcomePreviewDtoResponsibleEnum_platform;

  static Serializer<AdminOutcomePreviewDtoResponsibleEnum> get serializer =>
      _$adminOutcomePreviewDtoResponsibleEnumSerializer;

  const AdminOutcomePreviewDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminOutcomePreviewDtoResponsibleEnum> get values =>
      _$adminOutcomePreviewDtoResponsibleEnumValues;
  static AdminOutcomePreviewDtoResponsibleEnum valueOf(String name) =>
      _$adminOutcomePreviewDtoResponsibleEnumValueOf(name);
}

/// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
class AdminOutcomePreviewDtoFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminOutcomePreviewDtoFoodEnum keptByCaptain =
      _$adminOutcomePreviewDtoFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminOutcomePreviewDtoFoodEnum returnedToRestaurant =
      _$adminOutcomePreviewDtoFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminOutcomePreviewDtoFoodEnum destroyed =
      _$adminOutcomePreviewDtoFoodEnum_destroyed;

  static Serializer<AdminOutcomePreviewDtoFoodEnum> get serializer =>
      _$adminOutcomePreviewDtoFoodEnumSerializer;

  const AdminOutcomePreviewDtoFoodEnum._(String name) : super(name);

  static BuiltSet<AdminOutcomePreviewDtoFoodEnum> get values =>
      _$adminOutcomePreviewDtoFoodEnumValues;
  static AdminOutcomePreviewDtoFoodEnum valueOf(String name) =>
      _$adminOutcomePreviewDtoFoodEnumValueOf(name);
}
