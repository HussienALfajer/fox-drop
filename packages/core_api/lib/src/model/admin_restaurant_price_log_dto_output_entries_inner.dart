//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_price_log_money_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_price_log_dto_output_entries_inner.g.dart';

/// AdminRestaurantPriceLogDtoOutputEntriesInner
///
/// Properties:
/// * [id]
/// * [targetType]
/// * [targetId]
/// * [name] - The item's name, or the option's.
/// * [groupName] - An option's group; null for an item.
/// * [oldPrice]
/// * [newPrice]
/// * [byType]
/// * [byName] - The admin's name, or the restaurant user's; null when unknown.
/// * [at]
@BuiltValue()
abstract class AdminRestaurantPriceLogDtoOutputEntriesInner
    implements
        Built<
          AdminRestaurantPriceLogDtoOutputEntriesInner,
          AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'targetType')
  AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum get targetType;
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
  AdminPriceLogMoneyOutput get oldPrice;

  @BuiltValueField(wireName: r'newPrice')
  AdminPriceLogMoneyOutput get newPrice;

  @BuiltValueField(wireName: r'byType')
  AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum get byType;
  // enum byTypeEnum {  admin,  merchant,  system,  };

  /// The admin's name, or the restaurant user's; null when unknown.
  @BuiltValueField(wireName: r'byName')
  String? get byName;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminRestaurantPriceLogDtoOutputEntriesInner._();

  factory AdminRestaurantPriceLogDtoOutputEntriesInner([
    void updates(AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminRestaurantPriceLogDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantPriceLogDtoOutputEntriesInner>
  get serializer => _$AdminRestaurantPriceLogDtoOutputEntriesInnerSerializer();
}

class _$AdminRestaurantPriceLogDtoOutputEntriesInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantPriceLogDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantPriceLogDtoOutputEntriesInner,
    _$AdminRestaurantPriceLogDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantPriceLogDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantPriceLogDtoOutputEntriesInner object, {
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
        AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum,
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
      specifiedType: const FullType(AdminPriceLogMoneyOutput),
    );
    yield r'newPrice';
    yield serializers.serialize(
      object.newPrice,
      specifiedType: const FullType(AdminPriceLogMoneyOutput),
    );
    yield r'byType';
    yield serializers.serialize(
      object.byType,
      specifiedType: const FullType(
        AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum,
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
    AdminRestaurantPriceLogDtoOutputEntriesInner object, {
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
    required AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder result,
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
                      AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum,
                    ),
                  )
                  as AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum;
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
                    specifiedType: const FullType(AdminPriceLogMoneyOutput),
                  )
                  as AdminPriceLogMoneyOutput;
          result.oldPrice.replace(valueDes);
          break;
        case r'newPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminPriceLogMoneyOutput),
                  )
                  as AdminPriceLogMoneyOutput;
          result.newPrice.replace(valueDes);
          break;
        case r'byType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum,
                    ),
                  )
                  as AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum;
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
  AdminRestaurantPriceLogDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantPriceLogDtoOutputEntriesInnerBuilder();
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

class AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'item')
  static const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum item =
      _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_item;
  @BuiltValueEnumConst(wireName: r'option')
  static const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum
  option = _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum_option;

  static Serializer<AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
  get serializer =>
      _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumSerializer;

  const AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum>
  get values =>
      _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumValues;
  static AdminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnum valueOf(
    String name,
  ) =>
      _$adminRestaurantPriceLogDtoOutputEntriesInnerTargetTypeEnumValueOf(name);
}

class AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum admin =
      _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum merchant =
      _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_merchant;
  @BuiltValueEnumConst(wireName: r'system')
  static const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum system =
      _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum_system;

  static Serializer<AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum>
  get serializer =>
      _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumSerializer;

  const AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum>
  get values => _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumValues;
  static AdminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnum valueOf(
    String name,
  ) => _$adminRestaurantPriceLogDtoOutputEntriesInnerByTypeEnumValueOf(name);
}
