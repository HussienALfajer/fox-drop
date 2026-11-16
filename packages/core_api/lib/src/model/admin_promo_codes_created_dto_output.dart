//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_promo_codes_dto_output_codes_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_promo_codes_created_dto_output.g.dart';

/// AdminPromoCodesCreatedDtoOutput
///
/// Properties:
/// * [codes]
@BuiltValue()
abstract class AdminPromoCodesCreatedDtoOutput
    implements
        Built<
          AdminPromoCodesCreatedDtoOutput,
          AdminPromoCodesCreatedDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'codes')
  BuiltList<AdminPromoCodesDtoOutputCodesInner> get codes;

  AdminPromoCodesCreatedDtoOutput._();

  factory AdminPromoCodesCreatedDtoOutput([
    void updates(AdminPromoCodesCreatedDtoOutputBuilder b),
  ]) = _$AdminPromoCodesCreatedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPromoCodesCreatedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPromoCodesCreatedDtoOutput> get serializer =>
      _$AdminPromoCodesCreatedDtoOutputSerializer();
}

class _$AdminPromoCodesCreatedDtoOutputSerializer
    implements PrimitiveSerializer<AdminPromoCodesCreatedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPromoCodesCreatedDtoOutput,
    _$AdminPromoCodesCreatedDtoOutput,
  ];

  @override
  final String wireName = r'AdminPromoCodesCreatedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPromoCodesCreatedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPromoCodesDtoOutputCodesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPromoCodesCreatedDtoOutput object, {
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
    required AdminPromoCodesCreatedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPromoCodesDtoOutputCodesInner),
                    ]),
                  )
                  as BuiltList<AdminPromoCodesDtoOutputCodesInner>;
          result.codes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPromoCodesCreatedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPromoCodesCreatedDtoOutputBuilder();
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
