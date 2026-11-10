//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_edits_inner_changes_inner.g.dart';

/// MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner
///
/// Properties:
/// * [kind] - A line whose options changed is removed and added again.
/// * [name]
/// * [options]
/// * [quantity]
/// * [quantityBefore] - quantity: the quantity before.
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner,
          MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder
        > {
  /// A line whose options changed is removed and added again.
  @BuiltValueField(wireName: r'kind')
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum get kind;
  // enum kindEnum {  added,  removed,  quantity,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'options')
  BuiltList<String> get options;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  /// quantity: the quantity before.
  @BuiltValueField(wireName: r'quantityBefore')
  int? get quantityBefore;

  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner._();

  factory MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner([
    void updates(
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder b,
    ),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>
  get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner,
    _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner,
  ];

  @override
  final String wireName =
      r'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum,
      ),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    if (object.quantityBefore != null) {
      yield r'quantityBefore';
      yield serializers.serialize(
        object.quantityBefore,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner object, {
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
    required MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder
    result,
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
                      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum;
          result.kind = valueDes;
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
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.options.replace(valueDes);
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        case r'quantityBefore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.quantityBefore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder();
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

/// A line whose options changed is removed and added again.
class MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'added')
  static const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
  added =
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_added;
  @BuiltValueEnumConst(wireName: r'removed')
  static const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
  removed =
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_removed;
  @BuiltValueEnumConst(wireName: r'quantity')
  static const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
  quantity =
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_quantity;

  static Serializer<
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
  >
  get serializer =>
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumSerializer;

  const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
  >
  get values =>
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumValues;
  static MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
  valueOf(String name) =>
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumValueOf(
        name,
      );
}
