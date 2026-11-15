//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_settlements_dto_output_restaurants_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settlements_dto_output.g.dart';

/// AdminRestaurantSettlementsDtoOutput
///
/// Properties:
/// * [currency]
/// * [settlementWeekday]
/// * [nextCutoff]
/// * [restaurants]
@BuiltValue()
abstract class AdminRestaurantSettlementsDtoOutput
    implements
        Built<
          AdminRestaurantSettlementsDtoOutput,
          AdminRestaurantSettlementsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String? get currency;

  @BuiltValueField(wireName: r'settlementWeekday')
  AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
  get settlementWeekday;
  // enum settlementWeekdayEnum {  saturday,  sunday,  monday,  tuesday,  wednesday,  thursday,  friday,  };

  @BuiltValueField(wireName: r'nextCutoff')
  DateTime get nextCutoff;

  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminRestaurantSettlementsDtoOutputRestaurantsInner>
  get restaurants;

  AdminRestaurantSettlementsDtoOutput._();

  factory AdminRestaurantSettlementsDtoOutput([
    void updates(AdminRestaurantSettlementsDtoOutputBuilder b),
  ]) = _$AdminRestaurantSettlementsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantSettlementsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettlementsDtoOutput> get serializer =>
      _$AdminRestaurantSettlementsDtoOutputSerializer();
}

class _$AdminRestaurantSettlementsDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantSettlementsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettlementsDtoOutput,
    _$AdminRestaurantSettlementsDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantSettlementsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'settlementWeekday';
    yield serializers.serialize(
      object.settlementWeekday,
      specifiedType: const FullType(
        AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum,
      ),
    );
    yield r'nextCutoff';
    yield serializers.serialize(
      object.nextCutoff,
      specifiedType: const FullType(DateTime),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantSettlementsDtoOutputRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutput object, {
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
    required AdminRestaurantSettlementsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
          break;
        case r'settlementWeekday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum,
                    ),
                  )
                  as AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum;
          result.settlementWeekday = valueDes;
          break;
        case r'nextCutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.nextCutoff = valueDes;
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantSettlementsDtoOutputRestaurantsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantSettlementsDtoOutputRestaurantsInner
                  >;
          result.restaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSettlementsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettlementsDtoOutputBuilder();
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

class AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'saturday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
  saturday =
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_saturday;
  @BuiltValueEnumConst(wireName: r'sunday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum sunday =
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_sunday;
  @BuiltValueEnumConst(wireName: r'monday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum monday =
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_monday;
  @BuiltValueEnumConst(wireName: r'tuesday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
  tuesday = _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_tuesday;
  @BuiltValueEnumConst(wireName: r'wednesday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
  wednesday =
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_wednesday;
  @BuiltValueEnumConst(wireName: r'thursday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
  thursday =
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_thursday;
  @BuiltValueEnumConst(wireName: r'friday')
  static const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum friday =
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_friday;

  static Serializer<AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum>
  get serializer =>
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnumSerializer;

  const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum>
  get values =>
      _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnumValues;
  static AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum valueOf(
    String name,
  ) => _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnumValueOf(name);
}
