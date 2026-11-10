//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_change_preview_dto.g.dart';

/// AdminOutcomeChangePreviewDto
///
/// Properties:
/// * [outcome] - AP §8.9; fake needs the customer responsible, and only fake takes the customer.
/// * [responsible]
/// * [delivered] - Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
/// * [food] - A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
@BuiltValue()
abstract class AdminOutcomeChangePreviewDto
    implements
        Built<
          AdminOutcomeChangePreviewDto,
          AdminOutcomeChangePreviewDtoBuilder
        > {
  /// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
  @BuiltValueField(wireName: r'outcome')
  AdminOutcomeChangePreviewDtoOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'responsible')
  AdminOutcomeChangePreviewDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
  @BuiltValueField(wireName: r'delivered')
  bool get delivered;

  /// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
  @BuiltValueField(wireName: r'food')
  AdminOutcomeChangePreviewDtoFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  AdminOutcomeChangePreviewDto._();

  factory AdminOutcomeChangePreviewDto([
    void updates(AdminOutcomeChangePreviewDtoBuilder b),
  ]) = _$AdminOutcomeChangePreviewDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOutcomeChangePreviewDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomeChangePreviewDto> get serializer =>
      _$AdminOutcomeChangePreviewDtoSerializer();
}

class _$AdminOutcomeChangePreviewDtoSerializer
    implements PrimitiveSerializer<AdminOutcomeChangePreviewDto> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomeChangePreviewDto,
    _$AdminOutcomeChangePreviewDto,
  ];

  @override
  final String wireName = r'AdminOutcomeChangePreviewDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomeChangePreviewDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminOutcomeChangePreviewDtoOutcomeEnum),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(
        AdminOutcomeChangePreviewDtoResponsibleEnum,
      ),
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
              AdminOutcomeChangePreviewDtoFoodEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomeChangePreviewDto object, {
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
    required AdminOutcomeChangePreviewDtoBuilder result,
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
                      AdminOutcomeChangePreviewDtoOutcomeEnum,
                    ),
                  )
                  as AdminOutcomeChangePreviewDtoOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomeChangePreviewDtoResponsibleEnum,
                    ),
                  )
                  as AdminOutcomeChangePreviewDtoResponsibleEnum;
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
                      AdminOutcomeChangePreviewDtoFoodEnum,
                    ),
                  )
                  as AdminOutcomeChangePreviewDtoFoodEnum?;
          if (valueDes == null) continue;
          result.food = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOutcomeChangePreviewDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomeChangePreviewDtoBuilder();
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
class AdminOutcomeChangePreviewDtoOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOutcomeChangePreviewDtoOutcomeEnum free =
      _$adminOutcomeChangePreviewDtoOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOutcomeChangePreviewDtoOutcomeEnum fake =
      _$adminOutcomeChangePreviewDtoOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOutcomeChangePreviewDtoOutcomeEnum damaged =
      _$adminOutcomeChangePreviewDtoOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOutcomeChangePreviewDtoOutcomeEnum wrongRefused =
      _$adminOutcomeChangePreviewDtoOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOutcomeChangePreviewDtoOutcomeEnum failedOther =
      _$adminOutcomeChangePreviewDtoOutcomeEnum_failedOther;

  static Serializer<AdminOutcomeChangePreviewDtoOutcomeEnum> get serializer =>
      _$adminOutcomeChangePreviewDtoOutcomeEnumSerializer;

  const AdminOutcomeChangePreviewDtoOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminOutcomeChangePreviewDtoOutcomeEnum> get values =>
      _$adminOutcomeChangePreviewDtoOutcomeEnumValues;
  static AdminOutcomeChangePreviewDtoOutcomeEnum valueOf(String name) =>
      _$adminOutcomeChangePreviewDtoOutcomeEnumValueOf(name);
}

class AdminOutcomeChangePreviewDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOutcomeChangePreviewDtoResponsibleEnum restaurant =
      _$adminOutcomeChangePreviewDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOutcomeChangePreviewDtoResponsibleEnum captain =
      _$adminOutcomeChangePreviewDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOutcomeChangePreviewDtoResponsibleEnum customer =
      _$adminOutcomeChangePreviewDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOutcomeChangePreviewDtoResponsibleEnum platform =
      _$adminOutcomeChangePreviewDtoResponsibleEnum_platform;

  static Serializer<AdminOutcomeChangePreviewDtoResponsibleEnum>
  get serializer => _$adminOutcomeChangePreviewDtoResponsibleEnumSerializer;

  const AdminOutcomeChangePreviewDtoResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminOutcomeChangePreviewDtoResponsibleEnum> get values =>
      _$adminOutcomeChangePreviewDtoResponsibleEnumValues;
  static AdminOutcomeChangePreviewDtoResponsibleEnum valueOf(String name) =>
      _$adminOutcomeChangePreviewDtoResponsibleEnumValueOf(name);
}

/// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
class AdminOutcomeChangePreviewDtoFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminOutcomeChangePreviewDtoFoodEnum keptByCaptain =
      _$adminOutcomeChangePreviewDtoFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminOutcomeChangePreviewDtoFoodEnum returnedToRestaurant =
      _$adminOutcomeChangePreviewDtoFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminOutcomeChangePreviewDtoFoodEnum destroyed =
      _$adminOutcomeChangePreviewDtoFoodEnum_destroyed;

  static Serializer<AdminOutcomeChangePreviewDtoFoodEnum> get serializer =>
      _$adminOutcomeChangePreviewDtoFoodEnumSerializer;

  const AdminOutcomeChangePreviewDtoFoodEnum._(String name) : super(name);

  static BuiltSet<AdminOutcomeChangePreviewDtoFoodEnum> get values =>
      _$adminOutcomeChangePreviewDtoFoodEnumValues;
  static AdminOutcomeChangePreviewDtoFoodEnum valueOf(String name) =>
      _$adminOutcomeChangePreviewDtoFoodEnumValueOf(name);
}
