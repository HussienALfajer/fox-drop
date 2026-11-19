//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_bulk_price_dto.g.dart';

/// MerchantMenuBulkPriceDto
///
/// Properties:
/// * [categoryId] - One category; null: the whole menu.
/// * [kind]
/// * [direction]
/// * [value] - Basis points for a percentage (1000 is 10%); minor units of the base for an amount.
@BuiltValue()
abstract class MerchantMenuBulkPriceDto
    implements
        Built<MerchantMenuBulkPriceDto, MerchantMenuBulkPriceDtoBuilder> {
  /// One category; null: the whole menu.
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'kind')
  MerchantMenuBulkPriceDtoKindEnum get kind;
  // enum kindEnum {  percent,  amount,  };

  @BuiltValueField(wireName: r'direction')
  MerchantMenuBulkPriceDtoDirectionEnum get direction;
  // enum directionEnum {  up,  down,  };

  /// Basis points for a percentage (1000 is 10%); minor units of the base for an amount.
  @BuiltValueField(wireName: r'value')
  String get value;

  MerchantMenuBulkPriceDto._();

  factory MerchantMenuBulkPriceDto([
    void updates(MerchantMenuBulkPriceDtoBuilder b),
  ]) = _$MerchantMenuBulkPriceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuBulkPriceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuBulkPriceDto> get serializer =>
      _$MerchantMenuBulkPriceDtoSerializer();
}

class _$MerchantMenuBulkPriceDtoSerializer
    implements PrimitiveSerializer<MerchantMenuBulkPriceDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuBulkPriceDto,
    _$MerchantMenuBulkPriceDto,
  ];

  @override
  final String wireName = r'MerchantMenuBulkPriceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuBulkPriceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield object.categoryId == null
        ? null
        : serializers.serialize(
            object.categoryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(MerchantMenuBulkPriceDtoKindEnum),
    );
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(MerchantMenuBulkPriceDtoDirectionEnum),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuBulkPriceDto object, {
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
    required MerchantMenuBulkPriceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuBulkPriceDtoKindEnum,
                    ),
                  )
                  as MerchantMenuBulkPriceDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'direction':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuBulkPriceDtoDirectionEnum,
                    ),
                  )
                  as MerchantMenuBulkPriceDtoDirectionEnum;
          result.direction = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuBulkPriceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuBulkPriceDtoBuilder();
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

class MerchantMenuBulkPriceDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percent')
  static const MerchantMenuBulkPriceDtoKindEnum percent =
      _$merchantMenuBulkPriceDtoKindEnum_percent;
  @BuiltValueEnumConst(wireName: r'amount')
  static const MerchantMenuBulkPriceDtoKindEnum amount =
      _$merchantMenuBulkPriceDtoKindEnum_amount;

  static Serializer<MerchantMenuBulkPriceDtoKindEnum> get serializer =>
      _$merchantMenuBulkPriceDtoKindEnumSerializer;

  const MerchantMenuBulkPriceDtoKindEnum._(String name) : super(name);

  static BuiltSet<MerchantMenuBulkPriceDtoKindEnum> get values =>
      _$merchantMenuBulkPriceDtoKindEnumValues;
  static MerchantMenuBulkPriceDtoKindEnum valueOf(String name) =>
      _$merchantMenuBulkPriceDtoKindEnumValueOf(name);
}

class MerchantMenuBulkPriceDtoDirectionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'up')
  static const MerchantMenuBulkPriceDtoDirectionEnum up =
      _$merchantMenuBulkPriceDtoDirectionEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const MerchantMenuBulkPriceDtoDirectionEnum down =
      _$merchantMenuBulkPriceDtoDirectionEnum_down;

  static Serializer<MerchantMenuBulkPriceDtoDirectionEnum> get serializer =>
      _$merchantMenuBulkPriceDtoDirectionEnumSerializer;

  const MerchantMenuBulkPriceDtoDirectionEnum._(String name) : super(name);

  static BuiltSet<MerchantMenuBulkPriceDtoDirectionEnum> get values =>
      _$merchantMenuBulkPriceDtoDirectionEnumValues;
  static MerchantMenuBulkPriceDtoDirectionEnum valueOf(String name) =>
      _$merchantMenuBulkPriceDtoDirectionEnumValueOf(name);
}
