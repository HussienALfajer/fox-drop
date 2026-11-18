//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_banners_order_dto.g.dart';

/// AdminBannersOrderDto
///
/// Properties:
/// * [cityId]
/// * [ids] - Every banner of the city once (ended ones included), in the new order.
@BuiltValue()
abstract class AdminBannersOrderDto
    implements Built<AdminBannersOrderDto, AdminBannersOrderDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Every banner of the city once (ended ones included), in the new order.
  @BuiltValueField(wireName: r'ids')
  BuiltList<String> get ids;

  AdminBannersOrderDto._();

  factory AdminBannersOrderDto([void updates(AdminBannersOrderDtoBuilder b)]) =
      _$AdminBannersOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBannersOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBannersOrderDto> get serializer =>
      _$AdminBannersOrderDtoSerializer();
}

class _$AdminBannersOrderDtoSerializer
    implements PrimitiveSerializer<AdminBannersOrderDto> {
  @override
  final Iterable<Type> types = const [
    AdminBannersOrderDto,
    _$AdminBannersOrderDto,
  ];

  @override
  final String wireName = r'AdminBannersOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBannersOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'ids';
    yield serializers.serialize(
      object.ids,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBannersOrderDto object, {
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
    required AdminBannersOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
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
  AdminBannersOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBannersOrderDtoBuilder();
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
