//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_price_log_dto_output_entries_inner.g.dart';

/// MerchantPriceLogDtoOutputEntriesInner
///
/// Properties:
/// * [id]
/// * [targetType]
/// * [targetId]
/// * [name] - The item's name, or the option's.
/// * [groupName] - An option's group; null for an item.
/// * [oldPrice]
/// * [newPrice]
/// * [byType] - admin and system are «FOX DROP» (RA §9.4).
/// * [byName] - The restaurant user's name; null for FOX DROP or when unknown.
/// * [at]
@BuiltValue()
abstract class MerchantPriceLogDtoOutputEntriesInner
    implements
        Built<
          MerchantPriceLogDtoOutputEntriesInner,
          MerchantPriceLogDtoOutputEntriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'targetType')
  MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum get targetType;
  // enum targetTypeEnum {  item,  option,  };

  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  /// The item's name, or the option's.
  @BuiltValueField(wireName: r'name')
  String get name;

  /// An option's group; null for an item.
  @BuiltValueField(wireName: r'groupName')
  String? get groupName;

  @BuiltValueField(wireName: r'oldPrice')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice get oldPrice;

  @BuiltValueField(wireName: r'newPrice')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice get newPrice;

  /// admin and system are «FOX DROP» (RA §9.4).
  @BuiltValueField(wireName: r'byType')
  MerchantPriceLogDtoOutputEntriesInnerByTypeEnum get byType;
  // enum byTypeEnum {  admin,  merchant,  system,  };

  /// The restaurant user's name; null for FOX DROP or when unknown.
  @BuiltValueField(wireName: r'byName')
  String? get byName;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  MerchantPriceLogDtoOutputEntriesInner._();

  factory MerchantPriceLogDtoOutputEntriesInner([
    void updates(MerchantPriceLogDtoOutputEntriesInnerBuilder b),
  ]) = _$MerchantPriceLogDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPriceLogDtoOutputEntriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPriceLogDtoOutputEntriesInner> get serializer =>
      _$MerchantPriceLogDtoOutputEntriesInnerSerializer();
}

class _$MerchantPriceLogDtoOutputEntriesInnerSerializer
    implements PrimitiveSerializer<MerchantPriceLogDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantPriceLogDtoOutputEntriesInner,
    _$MerchantPriceLogDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'MerchantPriceLogDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPriceLogDtoOutputEntriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'targetType';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(
        MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum,
      ),
    );
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'groupName';
    yield object.groupName == null
        ? null
        : serializers.serialize(
            object.groupName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'oldPrice';
    yield serializers.serialize(
      object.oldPrice,
      specifiedType: const FullType(
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
      ),
    );
    yield r'newPrice';
    yield serializers.serialize(
      object.newPrice,
      specifiedType: const FullType(
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
      ),
    );
    yield r'byType';
    yield serializers.serialize(
      object.byType,
      specifiedType: const FullType(
        MerchantPriceLogDtoOutputEntriesInnerByTypeEnum,
      ),
    );
    yield r'byName';
    yield object.byName == null
        ? null
        : serializers.serialize(
            object.byName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPriceLogDtoOutputEntriesInner object, {
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
    required MerchantPriceLogDtoOutputEntriesInnerBuilder result,
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
        case r'targetType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum,
                    ),
                  )
                  as MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum;
          result.targetType = valueDes;
          break;
        case r'targetId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.targetId = valueDes;
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
        case r'groupName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.groupName = valueDes;
          break;
        case r'oldPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
          result.oldPrice.replace(valueDes);
          break;
        case r'newPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
          result.newPrice.replace(valueDes);
          break;
        case r'byType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantPriceLogDtoOutputEntriesInnerByTypeEnum,
                    ),
                  )
                  as MerchantPriceLogDtoOutputEntriesInnerByTypeEnum;
          result.byType = valueDes;
          break;
        case r'byName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.byName = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPriceLogDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPriceLogDtoOutputEntriesInnerBuilder();
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

class MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'item')
  static const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum item =
      _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item;
  @BuiltValueEnumConst(wireName: r'option')
  static const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum option =
      _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option;

  static Serializer<MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
  get serializer =>
      _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer;

  const MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum._(String name)
    : super(name);

  static BuiltSet<MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
  get values => _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnumValues;
  static MerchantPriceLogDtoOutputEntriesInnerTargetTypeEnum valueOf(
    String name,
  ) => _$merchantPriceLogDtoOutputEntriesInnerTargetTypeEnumValueOf(name);
}

/// admin and system are «FOX DROP» (RA §9.4).
class MerchantPriceLogDtoOutputEntriesInnerByTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum admin =
      _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum merchant =
      _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant;
  @BuiltValueEnumConst(wireName: r'system')
  static const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum system =
      _$merchantPriceLogDtoOutputEntriesInnerByTypeEnum_system;

  static Serializer<MerchantPriceLogDtoOutputEntriesInnerByTypeEnum>
  get serializer => _$merchantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer;

  const MerchantPriceLogDtoOutputEntriesInnerByTypeEnum._(String name)
    : super(name);

  static BuiltSet<MerchantPriceLogDtoOutputEntriesInnerByTypeEnum> get values =>
      _$merchantPriceLogDtoOutputEntriesInnerByTypeEnumValues;
  static MerchantPriceLogDtoOutputEntriesInnerByTypeEnum valueOf(String name) =>
      _$merchantPriceLogDtoOutputEntriesInnerByTypeEnumValueOf(name);
}
