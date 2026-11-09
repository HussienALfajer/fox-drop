//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reject_dto_items_inner.g.dart';

/// AdminRejectDtoItemsInner
///
/// Properties:
/// * [itemId]
/// * [until] - «حتى الغد» or «حتى أعيده».
@BuiltValue()
abstract class AdminRejectDtoItemsInner
    implements
        Built<AdminRejectDtoItemsInner, AdminRejectDtoItemsInnerBuilder> {
  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  /// «حتى الغد» or «حتى أعيده».
  @BuiltValueField(wireName: r'until')
  AdminRejectDtoItemsInnerUntilEnum get until;
  // enum untilEnum {  tomorrow,  turned_back_on,  };

  AdminRejectDtoItemsInner._();

  factory AdminRejectDtoItemsInner([
    void updates(AdminRejectDtoItemsInnerBuilder b),
  ]) = _$AdminRejectDtoItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRejectDtoItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRejectDtoItemsInner> get serializer =>
      _$AdminRejectDtoItemsInnerSerializer();
}

class _$AdminRejectDtoItemsInnerSerializer
    implements PrimitiveSerializer<AdminRejectDtoItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRejectDtoItemsInner,
    _$AdminRejectDtoItemsInner,
  ];

  @override
  final String wireName = r'AdminRejectDtoItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRejectDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(AdminRejectDtoItemsInnerUntilEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRejectDtoItemsInner object, {
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
    required AdminRejectDtoItemsInnerBuilder result,
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
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRejectDtoItemsInnerUntilEnum,
                    ),
                  )
                  as AdminRejectDtoItemsInnerUntilEnum;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRejectDtoItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRejectDtoItemsInnerBuilder();
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

/// «حتى الغد» or «حتى أعيده».
class AdminRejectDtoItemsInnerUntilEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'tomorrow')
  static const AdminRejectDtoItemsInnerUntilEnum tomorrow =
      _$adminRejectDtoItemsInnerUntilEnum_tomorrow;
  @BuiltValueEnumConst(wireName: r'turned_back_on')
  static const AdminRejectDtoItemsInnerUntilEnum turnedBackOn =
      _$adminRejectDtoItemsInnerUntilEnum_turnedBackOn;

  static Serializer<AdminRejectDtoItemsInnerUntilEnum> get serializer =>
      _$adminRejectDtoItemsInnerUntilEnumSerializer;

  const AdminRejectDtoItemsInnerUntilEnum._(String name) : super(name);

  static BuiltSet<AdminRejectDtoItemsInnerUntilEnum> get values =>
      _$adminRejectDtoItemsInnerUntilEnumValues;
  static AdminRejectDtoItemsInnerUntilEnum valueOf(String name) =>
      _$adminRejectDtoItemsInnerUntilEnumValueOf(name);
}
