//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_faq_dto_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_faq_dto.g.dart';

/// AdminFaqDto
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AdminFaqDto implements Built<AdminFaqDto, AdminFaqDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminFaqDtoItemsInner> get items;

  AdminFaqDto._();

  factory AdminFaqDto([void updates(AdminFaqDtoBuilder b)]) = _$AdminFaqDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFaqDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFaqDto> get serializer => _$AdminFaqDtoSerializer();
}

class _$AdminFaqDtoSerializer implements PrimitiveSerializer<AdminFaqDto> {
  @override
  final Iterable<Type> types = const [AdminFaqDto, _$AdminFaqDto];

  @override
  final String wireName = r'AdminFaqDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFaqDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminFaqDtoItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminFaqDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminFaqDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminFaqDtoItemsInner)]),
          ) as BuiltList<AdminFaqDtoItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminFaqDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFaqDtoBuilder();
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


