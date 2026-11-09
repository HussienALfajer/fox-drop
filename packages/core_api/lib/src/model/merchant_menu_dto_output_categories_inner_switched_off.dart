//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_switched_off.g.dart';

/// The row's own switch (RA §9.3): null while on.
///
/// Properties:
/// * [until] - «حتى الغد»: on again at this time; null: «حتى أعيده».
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerSwitchedOff implements Built<MerchantMenuDtoOutputCategoriesInnerSwitchedOff, MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder> {
  /// «حتى الغد»: on again at this time; null: «حتى أعيده».
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  MerchantMenuDtoOutputCategoriesInnerSwitchedOff._();

  factory MerchantMenuDtoOutputCategoriesInnerSwitchedOff([void updates(MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder b)]) = _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutputCategoriesInnerSwitchedOff> get serializer => _$MerchantMenuDtoOutputCategoriesInnerSwitchedOffSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerSwitchedOffSerializer implements PrimitiveSerializer<MerchantMenuDtoOutputCategoriesInnerSwitchedOff> {
  @override
  final Iterable<Type> types = const [MerchantMenuDtoOutputCategoriesInnerSwitchedOff, _$MerchantMenuDtoOutputCategoriesInnerSwitchedOff];

  @override
  final String wireName = r'MerchantMenuDtoOutputCategoriesInnerSwitchedOff';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerSwitchedOff object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'until';
    yield object.until == null ? null : serializers.serialize(
      object.until,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerSwitchedOff object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder();
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


