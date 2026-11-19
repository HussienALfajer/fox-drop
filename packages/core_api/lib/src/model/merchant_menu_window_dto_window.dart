//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_window_dto_window.g.dart';

/// A category's daily window, minutes after midnight on the city's clock (breakfast until 12:00 is 0 to 720); an end not after the start crosses midnight; null all day (RA §9.1).
///
/// Properties:
/// * [startsAt]
/// * [endsAt]
@BuiltValue()
abstract class MerchantMenuWindowDtoWindow
    implements
        Built<MerchantMenuWindowDtoWindow, MerchantMenuWindowDtoWindowBuilder> {
  @BuiltValueField(wireName: r'startsAt')
  int get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  int get endsAt;

  MerchantMenuWindowDtoWindow._();

  factory MerchantMenuWindowDtoWindow([
    void updates(MerchantMenuWindowDtoWindowBuilder b),
  ]) = _$MerchantMenuWindowDtoWindow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuWindowDtoWindowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuWindowDtoWindow> get serializer =>
      _$MerchantMenuWindowDtoWindowSerializer();
}

class _$MerchantMenuWindowDtoWindowSerializer
    implements PrimitiveSerializer<MerchantMenuWindowDtoWindow> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuWindowDtoWindow,
    _$MerchantMenuWindowDtoWindow,
  ];

  @override
  final String wireName = r'MerchantMenuWindowDtoWindow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuWindowDtoWindow object, {
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
    MerchantMenuWindowDtoWindow object, {
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
    required MerchantMenuWindowDtoWindowBuilder result,
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
  MerchantMenuWindowDtoWindow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuWindowDtoWindowBuilder();
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
