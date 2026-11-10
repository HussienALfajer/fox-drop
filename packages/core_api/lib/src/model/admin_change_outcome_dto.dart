//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_outcome_dto.g.dart';

/// AdminChangeOutcomeDto
///
/// Properties:
/// * [outcome] - AP §8.9; fake needs the customer responsible, and only fake takes the customer.
/// * [responsible]
/// * [delivered] - Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
/// * [food] - A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
/// * [version] - The order's version the dialog previewed (AP §8.9 «Preview»); any other is 409 order_state_changed.
/// * [reason] - Required (AP §8.9): why the outcome changes, never shown to the apps.
@BuiltValue()
abstract class AdminChangeOutcomeDto
    implements Built<AdminChangeOutcomeDto, AdminChangeOutcomeDtoBuilder> {
  /// AP §8.9; fake needs the customer responsible, and only fake takes the customer.
  @BuiltValueField(wireName: r'outcome')
  AdminChangeOutcomeDtoOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'responsible')
  AdminChangeOutcomeDtoResponsibleEnum get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// Free is delivered, fake, wrong_refused and failed_other failed; damaged either.
  @BuiltValueField(wireName: r'delivered')
  bool get delivered;

  /// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
  @BuiltValueField(wireName: r'food')
  AdminChangeOutcomeDtoFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  /// The order's version the dialog previewed (AP §8.9 «Preview»); any other is 409 order_state_changed.
  @BuiltValueField(wireName: r'version')
  int get version;

  /// Required (AP §8.9): why the outcome changes, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminChangeOutcomeDto._();

  factory AdminChangeOutcomeDto([
    void updates(AdminChangeOutcomeDtoBuilder b),
  ]) = _$AdminChangeOutcomeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeOutcomeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeOutcomeDto> get serializer =>
      _$AdminChangeOutcomeDtoSerializer();
}

class _$AdminChangeOutcomeDtoSerializer
    implements PrimitiveSerializer<AdminChangeOutcomeDto> {
  @override
  final Iterable<Type> types = const [
    AdminChangeOutcomeDto,
    _$AdminChangeOutcomeDto,
  ];

  @override
  final String wireName = r'AdminChangeOutcomeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeOutcomeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminChangeOutcomeDtoOutcomeEnum),
    );
    yield r'responsible';
    yield serializers.serialize(
      object.responsible,
      specifiedType: const FullType(AdminChangeOutcomeDtoResponsibleEnum),
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
              AdminChangeOutcomeDtoFoodEnum,
            ),
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
    AdminChangeOutcomeDto object, {
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
    required AdminChangeOutcomeDtoBuilder result,
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
                      AdminChangeOutcomeDtoOutcomeEnum,
                    ),
                  )
                  as AdminChangeOutcomeDtoOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChangeOutcomeDtoResponsibleEnum,
                    ),
                  )
                  as AdminChangeOutcomeDtoResponsibleEnum;
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
                      AdminChangeOutcomeDtoFoodEnum,
                    ),
                  )
                  as AdminChangeOutcomeDtoFoodEnum?;
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
  AdminChangeOutcomeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeOutcomeDtoBuilder();
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
class AdminChangeOutcomeDtoOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminChangeOutcomeDtoOutcomeEnum free =
      _$adminChangeOutcomeDtoOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminChangeOutcomeDtoOutcomeEnum fake =
      _$adminChangeOutcomeDtoOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminChangeOutcomeDtoOutcomeEnum damaged =
      _$adminChangeOutcomeDtoOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminChangeOutcomeDtoOutcomeEnum wrongRefused =
      _$adminChangeOutcomeDtoOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminChangeOutcomeDtoOutcomeEnum failedOther =
      _$adminChangeOutcomeDtoOutcomeEnum_failedOther;

  static Serializer<AdminChangeOutcomeDtoOutcomeEnum> get serializer =>
      _$adminChangeOutcomeDtoOutcomeEnumSerializer;

  const AdminChangeOutcomeDtoOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminChangeOutcomeDtoOutcomeEnum> get values =>
      _$adminChangeOutcomeDtoOutcomeEnumValues;
  static AdminChangeOutcomeDtoOutcomeEnum valueOf(String name) =>
      _$adminChangeOutcomeDtoOutcomeEnumValueOf(name);
}

class AdminChangeOutcomeDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminChangeOutcomeDtoResponsibleEnum restaurant =
      _$adminChangeOutcomeDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminChangeOutcomeDtoResponsibleEnum captain =
      _$adminChangeOutcomeDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminChangeOutcomeDtoResponsibleEnum customer =
      _$adminChangeOutcomeDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminChangeOutcomeDtoResponsibleEnum platform =
      _$adminChangeOutcomeDtoResponsibleEnum_platform;

  static Serializer<AdminChangeOutcomeDtoResponsibleEnum> get serializer =>
      _$adminChangeOutcomeDtoResponsibleEnumSerializer;

  const AdminChangeOutcomeDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminChangeOutcomeDtoResponsibleEnum> get values =>
      _$adminChangeOutcomeDtoResponsibleEnumValues;
  static AdminChangeOutcomeDtoResponsibleEnum valueOf(String name) =>
      _$adminChangeOutcomeDtoResponsibleEnumValueOf(name);
}

/// A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.
class AdminChangeOutcomeDtoFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const AdminChangeOutcomeDtoFoodEnum keptByCaptain =
      _$adminChangeOutcomeDtoFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const AdminChangeOutcomeDtoFoodEnum returnedToRestaurant =
      _$adminChangeOutcomeDtoFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const AdminChangeOutcomeDtoFoodEnum destroyed =
      _$adminChangeOutcomeDtoFoodEnum_destroyed;

  static Serializer<AdminChangeOutcomeDtoFoodEnum> get serializer =>
      _$adminChangeOutcomeDtoFoodEnumSerializer;

  const AdminChangeOutcomeDtoFoodEnum._(String name) : super(name);

  static BuiltSet<AdminChangeOutcomeDtoFoodEnum> get values =>
      _$adminChangeOutcomeDtoFoodEnumValues;
  static AdminChangeOutcomeDtoFoodEnum valueOf(String name) =>
      _$adminChangeOutcomeDtoFoodEnumValueOf(name);
}
