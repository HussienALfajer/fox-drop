//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_handover_captain_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_handover_captain.g.dart';

/// CaptainActiveOrderDtoOutputOrderHandoverCaptain
///
/// Properties:
/// * [name]
/// * [phone] - «اتصال» dials it.
/// * [location]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderHandoverCaptain
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderHandoverCaptain,
          CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// «اتصال» dials it.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'location')
  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation? get location;

  CaptainActiveOrderDtoOutputOrderHandoverCaptain._();

  factory CaptainActiveOrderDtoOutputOrderHandoverCaptain([
    void updates(CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderHandoverCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderHandoverCaptain>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderHandoverCaptainSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderHandoverCaptainSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderHandoverCaptain> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderHandoverCaptain,
    _$CaptainActiveOrderDtoOutputOrderHandoverCaptain,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderHandoverCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderHandoverCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'location';
    yield object.location == null
        ? null
        : serializers.serialize(
            object.location,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderHandoverCaptain object, {
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
    required CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation?;
          if (valueDes == null) continue;
          result.location.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderHandoverCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderHandoverCaptainBuilder();
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
