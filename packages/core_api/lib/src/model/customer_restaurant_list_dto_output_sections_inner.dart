//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output_sections_inner.g.dart';

/// CustomerRestaurantListDtoOutputSectionsInner
///
/// Properties:
/// * [kind] - «البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section under its title.
/// * [title] - A custom section's title; null otherwise.
/// * [restaurantIds] - The cards of `restaurants` it shows, in its order (open first, closed last); empty for banners and categories, which the app fills.
@BuiltValue()
abstract class CustomerRestaurantListDtoOutputSectionsInner
    implements
        Built<
          CustomerRestaurantListDtoOutputSectionsInner,
          CustomerRestaurantListDtoOutputSectionsInnerBuilder
        > {
  /// «البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section under its title.
  @BuiltValueField(wireName: r'kind')
  CustomerRestaurantListDtoOutputSectionsInnerKindEnum get kind;
  // enum kindEnum {  banners,  categories,  nearest,  most_ordered,  new,  offers,  custom,  };

  /// A custom section's title; null otherwise.
  @BuiltValueField(wireName: r'title')
  String? get title;

  /// The cards of `restaurants` it shows, in its order (open first, closed last); empty for banners and categories, which the app fills.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  CustomerRestaurantListDtoOutputSectionsInner._();

  factory CustomerRestaurantListDtoOutputSectionsInner([
    void updates(CustomerRestaurantListDtoOutputSectionsInnerBuilder b),
  ]) = _$CustomerRestaurantListDtoOutputSectionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerRestaurantListDtoOutputSectionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutputSectionsInner>
  get serializer => _$CustomerRestaurantListDtoOutputSectionsInnerSerializer();
}

class _$CustomerRestaurantListDtoOutputSectionsInnerSerializer
    implements
        PrimitiveSerializer<CustomerRestaurantListDtoOutputSectionsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantListDtoOutputSectionsInner,
    _$CustomerRestaurantListDtoOutputSectionsInner,
  ];

  @override
  final String wireName = r'CustomerRestaurantListDtoOutputSectionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutputSectionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        CustomerRestaurantListDtoOutputSectionsInnerKindEnum,
      ),
    );
    yield r'title';
    yield object.title == null
        ? null
        : serializers.serialize(
            object.title,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurantIds';
    yield serializers.serialize(
      object.restaurantIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputSectionsInner object, {
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
    required CustomerRestaurantListDtoOutputSectionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerRestaurantListDtoOutputSectionsInnerKindEnum,
                    ),
                  )
                  as CustomerRestaurantListDtoOutputSectionsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'restaurantIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.restaurantIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantListDtoOutputSectionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantListDtoOutputSectionsInnerBuilder();
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

/// «البانرات», «التصنيفات», «الأقرب إليك», «الأكثر طلباً», «جديد على FOX DROP», «العروض», or a custom section under its title.
class CustomerRestaurantListDtoOutputSectionsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'banners')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum banners =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_banners;
  @BuiltValueEnumConst(wireName: r'categories')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum categories =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_categories;
  @BuiltValueEnumConst(wireName: r'nearest')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum nearest =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_nearest;
  @BuiltValueEnumConst(wireName: r'most_ordered')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
  mostOrdered =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_mostOrdered;
  @BuiltValueEnumConst(wireName: r'new')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum new_ =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_new_;
  @BuiltValueEnumConst(wireName: r'offers')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum offers =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_offers;
  @BuiltValueEnumConst(wireName: r'custom')
  static const CustomerRestaurantListDtoOutputSectionsInnerKindEnum custom =
      _$customerRestaurantListDtoOutputSectionsInnerKindEnum_custom;

  static Serializer<CustomerRestaurantListDtoOutputSectionsInnerKindEnum>
  get serializer =>
      _$customerRestaurantListDtoOutputSectionsInnerKindEnumSerializer;

  const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<CustomerRestaurantListDtoOutputSectionsInnerKindEnum>
  get values => _$customerRestaurantListDtoOutputSectionsInnerKindEnumValues;
  static CustomerRestaurantListDtoOutputSectionsInnerKindEnum valueOf(
    String name,
  ) => _$customerRestaurantListDtoOutputSectionsInnerKindEnumValueOf(name);
}
