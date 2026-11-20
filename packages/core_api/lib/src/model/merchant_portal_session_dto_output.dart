//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_session_dto_output.g.dart';

/// MerchantPortalSessionDtoOutput
///
/// Properties:
/// * [accountId]
/// * [restaurantId]
/// * [name]
/// * [sessionId]
/// * [restaurantName]
/// * [timeZone] - The restaurant's city clock (IANA), for the times the portal shows and takes.
@BuiltValue()
abstract class MerchantPortalSessionDtoOutput
    implements
        Built<
          MerchantPortalSessionDtoOutput,
          MerchantPortalSessionDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  /// The restaurant's city clock (IANA), for the times the portal shows and takes.
  @BuiltValueField(wireName: r'timeZone')
  String get timeZone;

  MerchantPortalSessionDtoOutput._();

  factory MerchantPortalSessionDtoOutput([
    void updates(MerchantPortalSessionDtoOutputBuilder b),
  ]) = _$MerchantPortalSessionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalSessionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalSessionDtoOutput> get serializer =>
      _$MerchantPortalSessionDtoOutputSerializer();
}

class _$MerchantPortalSessionDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPortalSessionDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalSessionDtoOutput,
    _$MerchantPortalSessionDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPortalSessionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'timeZone';
    yield serializers.serialize(
      object.timeZone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSessionDtoOutput object, {
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
    required MerchantPortalSessionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accountId = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'sessionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sessionId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'timeZone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.timeZone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPortalSessionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalSessionDtoOutputBuilder();
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
