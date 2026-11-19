//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_change_money_output.dart';
import 'package:core_api/src/model/admin_change_option_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_values_output.g.dart';

/// AdminChangeValuesOutput
///
/// Properties:
/// * [name]
/// * [description]
/// * [photoKey] - In public-media, shown through /media/.
/// * [price] - A new item's price, a new option's delta.
/// * [categoryId]
/// * [groupId]
/// * [minChoices]
/// * [maxChoices]
/// * [itemIds]
/// * [options]
@BuiltValue()
abstract class AdminChangeValuesOutput
    implements Built<AdminChangeValuesOutput, AdminChangeValuesOutputBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// In public-media, shown through /media/.
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  /// A new item's price, a new option's delta.
  @BuiltValueField(wireName: r'price')
  AdminChangeMoneyOutput? get price;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'groupId')
  String? get groupId;

  @BuiltValueField(wireName: r'minChoices')
  int? get minChoices;

  @BuiltValueField(wireName: r'maxChoices')
  int? get maxChoices;

  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String>? get itemIds;

  @BuiltValueField(wireName: r'options')
  BuiltList<AdminChangeOptionOutput>? get options;

  AdminChangeValuesOutput._();

  factory AdminChangeValuesOutput([
    void updates(AdminChangeValuesOutputBuilder b),
  ]) = _$AdminChangeValuesOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeValuesOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeValuesOutput> get serializer =>
      _$AdminChangeValuesOutputSerializer();
}

class _$AdminChangeValuesOutputSerializer
    implements PrimitiveSerializer<AdminChangeValuesOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeValuesOutput,
    _$AdminChangeValuesOutput,
  ];

  @override
  final String wireName = r'AdminChangeValuesOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeValuesOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
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
    yield object.price == null
        ? null
        : serializers.serialize(
            object.price,
            specifiedType: const FullType.nullable(AdminChangeMoneyOutput),
          );
    yield r'categoryId';
    yield object.categoryId == null
        ? null
        : serializers.serialize(
            object.categoryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'groupId';
    yield object.groupId == null
        ? null
        : serializers.serialize(
            object.groupId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'minChoices';
    yield object.minChoices == null
        ? null
        : serializers.serialize(
            object.minChoices,
            specifiedType: const FullType.nullable(int),
          );
    yield r'maxChoices';
    yield object.maxChoices == null
        ? null
        : serializers.serialize(
            object.maxChoices,
            specifiedType: const FullType.nullable(int),
          );
    yield r'itemIds';
    yield object.itemIds == null
        ? null
        : serializers.serialize(
            object.itemIds,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(String),
            ]),
          );
    yield r'options';
    yield object.options == null
        ? null
        : serializers.serialize(
            object.options,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(AdminChangeOptionOutput),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeValuesOutput object, {
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
    required AdminChangeValuesOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
                    specifiedType: const FullType.nullable(
                      AdminChangeMoneyOutput,
                    ),
                  )
                  as AdminChangeMoneyOutput?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
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
        case r'groupId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.groupId = valueDes;
          break;
        case r'minChoices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.minChoices = valueDes;
          break;
        case r'maxChoices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxChoices = valueDes;
          break;
        case r'itemIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>?;
          if (valueDes == null) continue;
          result.itemIds.replace(valueDes);
          break;
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(AdminChangeOptionOutput),
                    ]),
                  )
                  as BuiltList<AdminChangeOptionOutput>?;
          if (valueDes == null) continue;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeValuesOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeValuesOutputBuilder();
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
