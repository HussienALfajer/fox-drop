//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_option_order_dto.g.dart';

/// AdminMenuOptionOrderDto
///
/// Properties:
/// * [optionIds] - Every option of the group once, in order.
@BuiltValue()
abstract class AdminMenuOptionOrderDto
    implements Built<AdminMenuOptionOrderDto, AdminMenuOptionOrderDtoBuilder> {
  /// Every option of the group once, in order.
  @BuiltValueField(wireName: r'optionIds')
  BuiltList<String> get optionIds;

  AdminMenuOptionOrderDto._();

  factory AdminMenuOptionOrderDto([
    void updates(AdminMenuOptionOrderDtoBuilder b),
  ]) = _$AdminMenuOptionOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuOptionOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuOptionOrderDto> get serializer =>
      _$AdminMenuOptionOrderDtoSerializer();
}

class _$AdminMenuOptionOrderDtoSerializer
    implements PrimitiveSerializer<AdminMenuOptionOrderDto> {
  @override
  final Iterable<Type> types = const [
    AdminMenuOptionOrderDto,
    _$AdminMenuOptionOrderDto,
  ];

  @override
  final String wireName = r'AdminMenuOptionOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuOptionOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'optionIds';
    yield serializers.serialize(
      object.optionIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuOptionOrderDto object, {
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
    required AdminMenuOptionOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuOptionOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuOptionOrderDtoBuilder();
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
