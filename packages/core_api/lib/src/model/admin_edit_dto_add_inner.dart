//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_dto_add_inner.g.dart';

/// AdminEditDtoAddInner
///
/// Properties:
/// * [itemId]
/// * [optionIds]
/// * [quantity]
@BuiltValue()
abstract class AdminEditDtoAddInner
    implements Built<AdminEditDtoAddInner, AdminEditDtoAddInnerBuilder> {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'optionIds')
  BuiltList<String> get optionIds;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminEditDtoAddInner._();

  factory AdminEditDtoAddInner([void updates(AdminEditDtoAddInnerBuilder b)]) =
      _$AdminEditDtoAddInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditDtoAddInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditDtoAddInner> get serializer =>
      _$AdminEditDtoAddInnerSerializer();
}

class _$AdminEditDtoAddInnerSerializer
    implements PrimitiveSerializer<AdminEditDtoAddInner> {
  @override
  final Iterable<Type> types = const [
    AdminEditDtoAddInner,
    _$AdminEditDtoAddInner,
  ];

  @override
  final String wireName = r'AdminEditDtoAddInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditDtoAddInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'optionIds';
    yield serializers.serialize(
      object.optionIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditDtoAddInner object, {
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
    required AdminEditDtoAddInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemId = valueDes;
          break;
        case r'optionIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.optionIds.replace(valueDes);
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditDtoAddInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditDtoAddInnerBuilder();
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
