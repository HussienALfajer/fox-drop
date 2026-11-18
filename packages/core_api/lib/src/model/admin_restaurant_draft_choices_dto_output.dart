//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_draft_point_output.dart';
import 'package:core_api/src/model/admin_draft_choice_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_draft_money_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_choices_dto_output.g.dart';

/// AdminRestaurantDraftChoicesDtoOutput
///
/// Properties:
/// * [categories]
/// * [categoriesMax]
/// * [zones]
/// * [baseCurrency]
/// * [centre] - Where the map starts: the centre of the city's active zones; null without any.
/// * [prepFloorMin]
/// * [prepCeilingMin]
/// * [defaultPrepMin] - merchant.default_prep_min, the step-3 start.
/// * [defaultMinimumOrder] - merchant.default_min_order; null when unset.
/// * [defaultCommissionBp] - merchant.default_commission_pct, in basis points.
/// * [nameMax]
/// * [descriptionMax]
/// * [addressMax]
@BuiltValue()
abstract class AdminRestaurantDraftChoicesDtoOutput
    implements
        Built<
          AdminRestaurantDraftChoicesDtoOutput,
          AdminRestaurantDraftChoicesDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'categories')
  BuiltList<AdminDraftChoiceOutput> get categories;

  @BuiltValueField(wireName: r'categoriesMax')
  int get categoriesMax;

  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminDraftChoiceOutput> get zones;

  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  /// Where the map starts: the centre of the city's active zones; null without any.
  @BuiltValueField(wireName: r'centre')
  AdminDraftPointOutput? get centre;

  @BuiltValueField(wireName: r'prepFloorMin')
  int get prepFloorMin;

  @BuiltValueField(wireName: r'prepCeilingMin')
  int get prepCeilingMin;

  /// merchant.default_prep_min, the step-3 start.
  @BuiltValueField(wireName: r'defaultPrepMin')
  int get defaultPrepMin;

  /// merchant.default_min_order; null when unset.
  @BuiltValueField(wireName: r'defaultMinimumOrder')
  AdminDraftMoneyOutput? get defaultMinimumOrder;

  /// merchant.default_commission_pct, in basis points.
  @BuiltValueField(wireName: r'defaultCommissionBp')
  int get defaultCommissionBp;

  @BuiltValueField(wireName: r'nameMax')
  int get nameMax;

  @BuiltValueField(wireName: r'descriptionMax')
  int get descriptionMax;

  @BuiltValueField(wireName: r'addressMax')
  int get addressMax;

  AdminRestaurantDraftChoicesDtoOutput._();

  factory AdminRestaurantDraftChoicesDtoOutput([
    void updates(AdminRestaurantDraftChoicesDtoOutputBuilder b),
  ]) = _$AdminRestaurantDraftChoicesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftChoicesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftChoicesDtoOutput> get serializer =>
      _$AdminRestaurantDraftChoicesDtoOutputSerializer();
}

class _$AdminRestaurantDraftChoicesDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftChoicesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftChoicesDtoOutput,
    _$AdminRestaurantDraftChoicesDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftChoicesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftChoicesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDraftChoiceOutput),
      ]),
    );
    yield r'categoriesMax';
    yield serializers.serialize(
      object.categoriesMax,
      specifiedType: const FullType(int),
    );
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDraftChoiceOutput),
      ]),
    );
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'centre';
    yield object.centre == null
        ? null
        : serializers.serialize(
            object.centre,
            specifiedType: const FullType.nullable(AdminDraftPointOutput),
          );
    yield r'prepFloorMin';
    yield serializers.serialize(
      object.prepFloorMin,
      specifiedType: const FullType(int),
    );
    yield r'prepCeilingMin';
    yield serializers.serialize(
      object.prepCeilingMin,
      specifiedType: const FullType(int),
    );
    yield r'defaultPrepMin';
    yield serializers.serialize(
      object.defaultPrepMin,
      specifiedType: const FullType(int),
    );
    yield r'defaultMinimumOrder';
    yield object.defaultMinimumOrder == null
        ? null
        : serializers.serialize(
            object.defaultMinimumOrder,
            specifiedType: const FullType.nullable(AdminDraftMoneyOutput),
          );
    yield r'defaultCommissionBp';
    yield serializers.serialize(
      object.defaultCommissionBp,
      specifiedType: const FullType(int),
    );
    yield r'nameMax';
    yield serializers.serialize(
      object.nameMax,
      specifiedType: const FullType(int),
    );
    yield r'descriptionMax';
    yield serializers.serialize(
      object.descriptionMax,
      specifiedType: const FullType(int),
    );
    yield r'addressMax';
    yield serializers.serialize(
      object.addressMax,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftChoicesDtoOutput object, {
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
    required AdminRestaurantDraftChoicesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDraftChoiceOutput),
                    ]),
                  )
                  as BuiltList<AdminDraftChoiceOutput>;
          result.categories.replace(valueDes);
          break;
        case r'categoriesMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.categoriesMax = valueDes;
          break;
        case r'zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDraftChoiceOutput),
                    ]),
                  )
                  as BuiltList<AdminDraftChoiceOutput>;
          result.zones.replace(valueDes);
          break;
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.baseCurrency = valueDes;
          break;
        case r'centre':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDraftPointOutput,
                    ),
                  )
                  as AdminDraftPointOutput?;
          if (valueDes == null) continue;
          result.centre.replace(valueDes);
          break;
        case r'prepFloorMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepFloorMin = valueDes;
          break;
        case r'prepCeilingMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepCeilingMin = valueDes;
          break;
        case r'defaultPrepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.defaultPrepMin = valueDes;
          break;
        case r'defaultMinimumOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDraftMoneyOutput,
                    ),
                  )
                  as AdminDraftMoneyOutput?;
          if (valueDes == null) continue;
          result.defaultMinimumOrder.replace(valueDes);
          break;
        case r'defaultCommissionBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.defaultCommissionBp = valueDes;
          break;
        case r'nameMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.nameMax = valueDes;
          break;
        case r'descriptionMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.descriptionMax = valueDes;
          break;
        case r'addressMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.addressMax = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftChoicesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftChoicesDtoOutputBuilder();
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
