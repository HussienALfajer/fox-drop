//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_search_dto_output_items_inner_from_price.dart';
import 'package:core_api/src/model/customer_search_dto_output_items_inner_option_groups_inner.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_preview_dto_output_menu_inner_items_inner.g.dart';

/// AdminMenuPreviewDtoOutputMenuInnerItemsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [description]
/// * [photoKey] - Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
/// * [price]
/// * [fromPrice]
/// * [available]
/// * [unavailableReason] - «يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».
/// * [optionGroups]
@BuiltValue()
abstract class AdminMenuPreviewDtoOutputMenuInnerItemsInner
    implements
        Built<
          AdminMenuPreviewDtoOutputMenuInnerItemsInner,
          AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Its key in public-media, shown through imgproxy (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  @BuiltValueField(wireName: r'price')
  CaptainAvailabilityDtoOutputCustodyLimit get price;

  @BuiltValueField(wireName: r'fromPrice')
  CustomerSearchDtoOutputItemsInnerFromPrice? get fromPrice;

  @BuiltValueField(wireName: r'available')
  bool get available;

  /// «يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».
  @BuiltValueField(wireName: r'unavailableReason')
  AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  get unavailableReason;
  // enum unavailableReasonEnum {  tomorrow,  window,  unavailable,  };

  @BuiltValueField(wireName: r'optionGroups')
  BuiltList<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>
  get optionGroups;

  AdminMenuPreviewDtoOutputMenuInnerItemsInner._();

  factory AdminMenuPreviewDtoOutputMenuInnerItemsInner([
    void updates(AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder b),
  ]) = _$AdminMenuPreviewDtoOutputMenuInnerItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuPreviewDtoOutputMenuInnerItemsInner>
  get serializer => _$AdminMenuPreviewDtoOutputMenuInnerItemsInnerSerializer();
}

class _$AdminMenuPreviewDtoOutputMenuInnerItemsInnerSerializer
    implements
        PrimitiveSerializer<AdminMenuPreviewDtoOutputMenuInnerItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuPreviewDtoOutputMenuInnerItemsInner,
    _$AdminMenuPreviewDtoOutputMenuInnerItemsInner,
  ];

  @override
  final String wireName = r'AdminMenuPreviewDtoOutputMenuInnerItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuPreviewDtoOutputMenuInnerItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    yield r'photoKey';
    yield object.photoKey == null
        ? null
        : serializers.serialize(
            object.photoKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
    );
    yield r'fromPrice';
    yield object.fromPrice == null
        ? null
        : serializers.serialize(
            object.fromPrice,
            specifiedType: const FullType.nullable(
              CustomerSearchDtoOutputItemsInnerFromPrice,
            ),
          );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'unavailableReason';
    yield object.unavailableReason == null
        ? null
        : serializers.serialize(
            object.unavailableReason,
            specifiedType: const FullType.nullable(
              AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum,
            ),
          );
    yield r'optionGroups';
    yield serializers.serialize(
      object.optionGroups,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerSearchDtoOutputItemsInnerOptionGroupsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuPreviewDtoOutputMenuInnerItemsInner object, {
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
    required AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'photoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoKey = valueDes;
          break;
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyLimit,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyLimit;
          result.price.replace(valueDes);
          break;
        case r'fromPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerSearchDtoOutputItemsInnerFromPrice,
                    ),
                  )
                  as CustomerSearchDtoOutputItemsInnerFromPrice?;
          if (valueDes == null) continue;
          result.fromPrice.replace(valueDes);
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.available = valueDes;
          break;
        case r'unavailableReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum,
                    ),
                  )
                  as AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?;
          if (valueDes == null) continue;
          result.unavailableReason = valueDes;
          break;
        case r'optionGroups':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CustomerSearchDtoOutputItemsInnerOptionGroupsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CustomerSearchDtoOutputItemsInnerOptionGroupsInner
                  >;
          result.optionGroups.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuPreviewDtoOutputMenuInnerItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder();
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

/// «يتوفر غداً», «متوفر من {الساعة}» (its category window) or «غير متوفر حالياً».
class AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  tomorrow =
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'window')
  static const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  window =
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window;
  @BuiltValueEnumConst(wireName: r'unavailable')
  static const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  unavailable =
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable;

  static Serializer<
    AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  >
  get serializer =>
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer;

  const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  >
  get values =>
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumValues;
  static AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  valueOf(String name) =>
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumValueOf(
        name,
      );
}
