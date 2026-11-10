//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_outcome_dto.g.dart';

/// AdminSetOutcomeDto
///
/// Properties:
/// * [outcome] - AP §8.9; fake needs the customer responsible, and only fake takes the customer.
/// * [responsible]
/// * [delivered] - Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
/// * [food] - A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
/// * [version] - The order's version the dialog previewed (AP §8.9 «Preview»); any other is 409 order_state_changed.
/// * [reason] - Required (AP §9.3.2): the internal note, never shown to the apps.
@BuiltValue()
abstract class AdminSetOutcomeDto
    implements Built<AdminSetOutcomeDto, AdminSetOutcomeDtoBuilder> {
  /// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
  @BuiltValueField(wireName: r'outcome')
  AdminSetOutcomeDtoOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'responsible')
  AdminSetOutcomeDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
  @BuiltValueField(wireName: r'delivered')
  bool get delivered;

  /// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
  @BuiltValueField(wireName: r'food')
  AdminSetOutcomeDtoFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  /// The order's version the dialog previewed (AP §8.9 «Preview»); any other is 409 order_state_changed.
  @BuiltValueField(wireName: r'version')
  int get version;

  /// Required (AP §9.3.2): the internal note, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminSetOutcomeDto._();

  factory AdminSetOutcomeDto([void updates(AdminSetOutcomeDtoBuilder b)]) =
      _$AdminSetOutcomeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetOutcomeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetOutcomeDto> get serializer =>
      _$AdminSetOutcomeDtoSerializer();
}

class _$AdminSetOutcomeDtoSerializer
    implements PrimitiveSerializer<AdminSetOutcomeDto> {
  @override
  final Iterable<Type> types = const [AdminSetOutcomeDto, _$AdminSetOutcomeDto];

  @override
  final String wireName = r'AdminSetOutcomeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetOutcomeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminSetOutcomeDtoOutcomeEnum),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminSetOutcomeDtoResponsibleEnum),
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
            specifiedType: const FullType.nullable(AdminSetOutcomeDtoFoodEnum),
          );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetOutcomeDto object, {
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
    required AdminSetOutcomeDtoBuilder result,
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
                      AdminSetOutcomeDtoOutcomeEnum,
                    ),
                  )
                  as AdminSetOutcomeDtoOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSetOutcomeDtoResponsibleEnum,
                    ),
                  )
                  as AdminSetOutcomeDtoResponsibleEnum;
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
                      AdminSetOutcomeDtoFoodEnum,
                    ),
                  )
                  as AdminSetOutcomeDtoFoodEnum?;
          if (valueDes == null) continue;
          result.food = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetOutcomeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetOutcomeDtoBuilder();
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
class AdminSetOutcomeDtoOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminSetOutcomeDtoOutcomeEnum free =
      _$adminSetOutcomeDtoOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminSetOutcomeDtoOutcomeEnum fake =
      _$adminSetOutcomeDtoOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminSetOutcomeDtoOutcomeEnum damaged =
      _$adminSetOutcomeDtoOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminSetOutcomeDtoOutcomeEnum wrongRefused =
      _$adminSetOutcomeDtoOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminSetOutcomeDtoOutcomeEnum failedOther =
      _$adminSetOutcomeDtoOutcomeEnum_failedOther;

  static Serializer<AdminSetOutcomeDtoOutcomeEnum> get serializer =>
      _$adminSetOutcomeDtoOutcomeEnumSerializer;

  const AdminSetOutcomeDtoOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminSetOutcomeDtoOutcomeEnum> get values =>
      _$adminSetOutcomeDtoOutcomeEnumValues;
  static AdminSetOutcomeDtoOutcomeEnum valueOf(String name) =>
      _$adminSetOutcomeDtoOutcomeEnumValueOf(name);
}

class AdminSetOutcomeDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminSetOutcomeDtoResponsibleEnum restaurant =
      _$adminSetOutcomeDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminSetOutcomeDtoResponsibleEnum captain =
      _$adminSetOutcomeDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminSetOutcomeDtoResponsibleEnum customer =
      _$adminSetOutcomeDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminSetOutcomeDtoResponsibleEnum platform =
      _$adminSetOutcomeDtoResponsibleEnum_platform;

  static Serializer<AdminSetOutcomeDtoResponsibleEnum> get serializer =>
      _$adminSetOutcomeDtoResponsibleEnumSerializer;

  const AdminSetOutcomeDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminSetOutcomeDtoResponsibleEnum> get values =>
      _$adminSetOutcomeDtoResponsibleEnumValues;
  static AdminSetOutcomeDtoResponsibleEnum valueOf(String name) =>
      _$adminSetOutcomeDtoResponsibleEnumValueOf(name);
}

/// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
class AdminSetOutcomeDtoFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminSetOutcomeDtoFoodEnum keptByCaptain =
      _$adminSetOutcomeDtoFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminSetOutcomeDtoFoodEnum returnedToRestaurant =
      _$adminSetOutcomeDtoFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminSetOutcomeDtoFoodEnum destroyed =
      _$adminSetOutcomeDtoFoodEnum_destroyed;

  static Serializer<AdminSetOutcomeDtoFoodEnum> get serializer =>
      _$adminSetOutcomeDtoFoodEnumSerializer;

  const AdminSetOutcomeDtoFoodEnum._(String name) : super(name);

  static BuiltSet<AdminSetOutcomeDtoFoodEnum> get values =>
      _$adminSetOutcomeDtoFoodEnumValues;
  static AdminSetOutcomeDtoFoodEnum valueOf(String name) =>
      _$adminSetOutcomeDtoFoodEnumValueOf(name);
}
