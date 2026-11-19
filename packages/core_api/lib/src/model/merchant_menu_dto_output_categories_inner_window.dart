//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_window.g.dart';

/// A category's daily window, minutes after midnight on the city's clock (breakfast until 12:00 is 0 to 720); an end not after the start crosses midnight; null all day (RA §9.1).
///
/// Properties:
/// * [startsAt]
/// * [endsAt]
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerWindow
    implements
        Built<
          MerchantMenuDtoOutputCategoriesInnerWindow,
          MerchantMenuDtoOutputCategoriesInnerWindowBuilder
        > {
  @BuiltValueField(wireName: r'startsAt')
  int get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  int get endsAt;

  MerchantMenuDtoOutputCategoriesInnerWindow._();

  factory MerchantMenuDtoOutputCategoriesInnerWindow([
    void updates(MerchantMenuDtoOutputCategoriesInnerWindowBuilder b),
  ]) = _$MerchantMenuDtoOutputCategoriesInnerWindow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuDtoOutputCategoriesInnerWindowBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutputCategoriesInnerWindow>
  get serializer => _$MerchantMenuDtoOutputCategoriesInnerWindowSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerWindowSerializer
    implements PrimitiveSerializer<MerchantMenuDtoOutputCategoriesInnerWindow> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputCategoriesInnerWindow,
    _$MerchantMenuDtoOutputCategoriesInnerWindow,
  ];

  @override
  final String wireName = r'MerchantMenuDtoOutputCategoriesInnerWindow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerWindow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(int),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerWindow object, {
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
    required MerchantMenuDtoOutputCategoriesInnerWindowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.endsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerWindow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuDtoOutputCategoriesInnerWindowBuilder();
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
