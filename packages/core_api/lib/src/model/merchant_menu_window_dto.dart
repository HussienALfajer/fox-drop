//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_window_dto_window.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_window_dto.g.dart';

/// MerchantMenuWindowDto
///
/// Properties:
/// * [window]
@BuiltValue()
abstract class MerchantMenuWindowDto
    implements Built<MerchantMenuWindowDto, MerchantMenuWindowDtoBuilder> {
  @BuiltValueField(wireName: r'window')
  MerchantMenuWindowDtoWindow? get window;

  MerchantMenuWindowDto._();

  factory MerchantMenuWindowDto([
    void updates(MerchantMenuWindowDtoBuilder b),
  ]) = _$MerchantMenuWindowDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuWindowDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuWindowDto> get serializer =>
      _$MerchantMenuWindowDtoSerializer();
}

class _$MerchantMenuWindowDtoSerializer
    implements PrimitiveSerializer<MerchantMenuWindowDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuWindowDto,
    _$MerchantMenuWindowDto,
  ];

  @override
  final String wireName = r'MerchantMenuWindowDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuWindowDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'window';
    yield object.window == null
        ? null
        : serializers.serialize(
            object.window,
            specifiedType: const FullType.nullable(MerchantMenuWindowDtoWindow),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuWindowDto object, {
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
    required MerchantMenuWindowDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'window':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantMenuWindowDtoWindow,
                    ),
                  )
                  as MerchantMenuWindowDtoWindow?;
          if (valueDes == null) continue;
          result.window.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuWindowDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuWindowDtoBuilder();
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
