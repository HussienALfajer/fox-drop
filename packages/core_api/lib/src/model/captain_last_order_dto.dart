//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_last_order_dto.g.dart';

/// CaptainLastOrderDto
///
/// Properties:
/// * [on_] - CA §7.3: «لا أريد طلبات جديدة» on, or cancelled before the order ends.
@BuiltValue()
abstract class CaptainLastOrderDto
    implements Built<CaptainLastOrderDto, CaptainLastOrderDtoBuilder> {
  /// CA §7.3: «لا أريد طلبات جديدة» on, or cancelled before the order ends.
  @BuiltValueField(wireName: r'on')
  bool get on_;

  CaptainLastOrderDto._();

  factory CaptainLastOrderDto([void updates(CaptainLastOrderDtoBuilder b)]) =
      _$CaptainLastOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainLastOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainLastOrderDto> get serializer =>
      _$CaptainLastOrderDtoSerializer();
}

class _$CaptainLastOrderDtoSerializer
    implements PrimitiveSerializer<CaptainLastOrderDto> {
  @override
  final Iterable<Type> types = const [
    CaptainLastOrderDto,
    _$CaptainLastOrderDto,
  ];

  @override
  final String wireName = r'CaptainLastOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainLastOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'on';
    yield serializers.serialize(
      object.on_,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainLastOrderDto object, {
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
    required CaptainLastOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'on':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.on_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainLastOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainLastOrderDtoBuilder();
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
