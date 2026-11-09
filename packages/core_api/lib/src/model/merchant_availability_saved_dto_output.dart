//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_switched_off.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_availability_saved_dto_output.g.dart';

/// MerchantAvailabilitySavedDtoOutput
///
/// Properties:
/// * [switchedOff] 
@BuiltValue()
abstract class MerchantAvailabilitySavedDtoOutput implements Built<MerchantAvailabilitySavedDtoOutput, MerchantAvailabilitySavedDtoOutputBuilder> {
  @BuiltValueField(wireName: r'switchedOff')
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff? get switchedOff;

  MerchantAvailabilitySavedDtoOutput._();

  factory MerchantAvailabilitySavedDtoOutput([void updates(MerchantAvailabilitySavedDtoOutputBuilder b)]) = _$MerchantAvailabilitySavedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAvailabilitySavedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAvailabilitySavedDtoOutput> get serializer => _$MerchantAvailabilitySavedDtoOutputSerializer();
}

class _$MerchantAvailabilitySavedDtoOutputSerializer implements PrimitiveSerializer<MerchantAvailabilitySavedDtoOutput> {
  @override
  final Iterable<Type> types = const [MerchantAvailabilitySavedDtoOutput, _$MerchantAvailabilitySavedDtoOutput];

  @override
  final String wireName = r'MerchantAvailabilitySavedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAvailabilitySavedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'switchedOff';
    yield object.switchedOff == null ? null : serializers.serialize(
      object.switchedOff,
      specifiedType: const FullType.nullable(MerchantMenuDtoOutputCategoriesInnerSwitchedOff),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAvailabilitySavedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantAvailabilitySavedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'switchedOff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantMenuDtoOutputCategoriesInnerSwitchedOff),
          ) as MerchantMenuDtoOutputCategoriesInnerSwitchedOff?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAvailabilitySavedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAvailabilitySavedDtoOutputBuilder();
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


