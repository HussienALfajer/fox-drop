//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_extend_promo_code_dto.g.dart';

/// AdminExtendPromoCodeDto
///
/// Properties:
/// * [cityId]
/// * [validTo] - The new end.
@BuiltValue()
abstract class AdminExtendPromoCodeDto
    implements Built<AdminExtendPromoCodeDto, AdminExtendPromoCodeDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The new end.
  @BuiltValueField(wireName: r'validTo')
  DateTime get validTo;

  AdminExtendPromoCodeDto._();

  factory AdminExtendPromoCodeDto([
    void updates(AdminExtendPromoCodeDtoBuilder b),
  ]) = _$AdminExtendPromoCodeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminExtendPromoCodeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminExtendPromoCodeDto> get serializer =>
      _$AdminExtendPromoCodeDtoSerializer();
}

class _$AdminExtendPromoCodeDtoSerializer
    implements PrimitiveSerializer<AdminExtendPromoCodeDto> {
  @override
  final Iterable<Type> types = const [
    AdminExtendPromoCodeDto,
    _$AdminExtendPromoCodeDto,
  ];

  @override
  final String wireName = r'AdminExtendPromoCodeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminExtendPromoCodeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'validTo';
    yield serializers.serialize(
      object.validTo,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminExtendPromoCodeDto object, {
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
    required AdminExtendPromoCodeDtoBuilder result,
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
        case r'validTo':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.validTo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminExtendPromoCodeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminExtendPromoCodeDtoBuilder();
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
