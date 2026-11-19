//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_bulk_price_dto.g.dart';

/// AdminMenuBulkPriceDto
///
/// Properties:
/// * [categoryId] - One category; null: the whole menu.
/// * [kind]
/// * [direction]
/// * [value] - Basis points for a percentage (1000 is 10%); minor units of the base for an amount.
@BuiltValue()
abstract class AdminMenuBulkPriceDto
    implements Built<AdminMenuBulkPriceDto, AdminMenuBulkPriceDtoBuilder> {
  /// One category; null: the whole menu.
  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'kind')
  AdminMenuBulkPriceDtoKindEnum get kind;
  // enum kindEnum {  percent,  amount,  };

  @BuiltValueField(wireName: r'direction')
  AdminMenuBulkPriceDtoDirectionEnum get direction;
  // enum directionEnum {  up,  down,  };

  /// Basis points for a percentage (1000 is 10%); minor units of the base for an amount.
  @BuiltValueField(wireName: r'value')
  String get value;

  AdminMenuBulkPriceDto._();

  factory AdminMenuBulkPriceDto([
    void updates(AdminMenuBulkPriceDtoBuilder b),
  ]) = _$AdminMenuBulkPriceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuBulkPriceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuBulkPriceDto> get serializer =>
      _$AdminMenuBulkPriceDtoSerializer();
}

class _$AdminMenuBulkPriceDtoSerializer
    implements PrimitiveSerializer<AdminMenuBulkPriceDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuBulkPriceDto,
    _$AdminMenuBulkPriceDto,
  ];

  @override
  final String wireName = r'AdminMenuBulkPriceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuBulkPriceDto object, {
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
      specifiedType: const FullType(AdminMenuBulkPriceDtoKindEnum),
    );
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(AdminMenuBulkPriceDtoDirectionEnum),
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
    AdminMenuBulkPriceDto object, {
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
    required AdminMenuBulkPriceDtoBuilder result,
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
                      AdminMenuBulkPriceDtoKindEnum,
                    ),
                  )
                  as AdminMenuBulkPriceDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'direction':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMenuBulkPriceDtoDirectionEnum,
                    ),
                  )
                  as AdminMenuBulkPriceDtoDirectionEnum;
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
  AdminMenuBulkPriceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuBulkPriceDtoBuilder();
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

class AdminMenuBulkPriceDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percent')
  static const AdminMenuBulkPriceDtoKindEnum percent =
      _$adminMenuBulkPriceDtoKindEnum_percent;
  @BuiltValueEnumConst(wireName: r'amount')
  static const AdminMenuBulkPriceDtoKindEnum amount =
      _$adminMenuBulkPriceDtoKindEnum_amount;

  static Serializer<AdminMenuBulkPriceDtoKindEnum> get serializer =>
      _$adminMenuBulkPriceDtoKindEnumSerializer;

  const AdminMenuBulkPriceDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminMenuBulkPriceDtoKindEnum> get values =>
      _$adminMenuBulkPriceDtoKindEnumValues;
  static AdminMenuBulkPriceDtoKindEnum valueOf(String name) =>
      _$adminMenuBulkPriceDtoKindEnumValueOf(name);
}

class AdminMenuBulkPriceDtoDirectionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'up')
  static const AdminMenuBulkPriceDtoDirectionEnum up =
      _$adminMenuBulkPriceDtoDirectionEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const AdminMenuBulkPriceDtoDirectionEnum down =
      _$adminMenuBulkPriceDtoDirectionEnum_down;

  static Serializer<AdminMenuBulkPriceDtoDirectionEnum> get serializer =>
      _$adminMenuBulkPriceDtoDirectionEnumSerializer;

  const AdminMenuBulkPriceDtoDirectionEnum._(String name) : super(name);

  static BuiltSet<AdminMenuBulkPriceDtoDirectionEnum> get values =>
      _$adminMenuBulkPriceDtoDirectionEnumValues;
  static AdminMenuBulkPriceDtoDirectionEnum valueOf(String name) =>
      _$adminMenuBulkPriceDtoDirectionEnumValueOf(name);
}
