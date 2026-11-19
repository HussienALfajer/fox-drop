//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_application_kit_dto_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_kit_dto.g.dart';

/// AdminCaptainApplicationKitDto
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class AdminCaptainApplicationKitDto
    implements
        Built<
          AdminCaptainApplicationKitDto,
          AdminCaptainApplicationKitDtoBuilder
        > {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminCaptainApplicationKitDtoItemsInner> get items;

  AdminCaptainApplicationKitDto._();

  factory AdminCaptainApplicationKitDto([
    void updates(AdminCaptainApplicationKitDtoBuilder b),
  ]) = _$AdminCaptainApplicationKitDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationKitDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationKitDto> get serializer =>
      _$AdminCaptainApplicationKitDtoSerializer();
}

class _$AdminCaptainApplicationKitDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationKitDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationKitDto,
    _$AdminCaptainApplicationKitDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationKitDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationKitDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationKitDtoItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationKitDto object, {
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
    required AdminCaptainApplicationKitDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainApplicationKitDtoItemsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainApplicationKitDtoItemsInner>;
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
  AdminCaptainApplicationKitDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationKitDtoBuilder();
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
