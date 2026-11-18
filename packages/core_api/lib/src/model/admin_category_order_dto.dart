//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_category_order_dto.g.dart';

/// AdminCategoryOrderDto
///
/// Properties:
/// * [ids] - Every category once, removed ones too.
@BuiltValue()
abstract class AdminCategoryOrderDto
    implements Built<AdminCategoryOrderDto, AdminCategoryOrderDtoBuilder> {
  /// Every category once, removed ones too.
  @BuiltValueField(wireName: r'ids')
  BuiltList<String> get ids;

  AdminCategoryOrderDto._();

  factory AdminCategoryOrderDto([
    void updates(AdminCategoryOrderDtoBuilder b),
  ]) = _$AdminCategoryOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCategoryOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCategoryOrderDto> get serializer =>
      _$AdminCategoryOrderDtoSerializer();
}

class _$AdminCategoryOrderDtoSerializer
    implements PrimitiveSerializer<AdminCategoryOrderDto> {
  @override
  final Iterable<Type> types = const [
    AdminCategoryOrderDto,
    _$AdminCategoryOrderDto,
  ];

  @override
  final String wireName = r'AdminCategoryOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCategoryOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCategoryOrderDto object, {
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
    required AdminCategoryOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ids':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.ids.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCategoryOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCategoryOrderDtoBuilder();
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
