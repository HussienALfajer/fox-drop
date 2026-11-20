//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_signed_in_dto_output.g.dart';

/// MerchantPortalSignedInDtoOutput
///
/// Properties:
/// * [accountId]
/// * [restaurantId]
/// * [name]
/// * [expiresAt]
@BuiltValue()
abstract class MerchantPortalSignedInDtoOutput
    implements
        Built<
          MerchantPortalSignedInDtoOutput,
          MerchantPortalSignedInDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  MerchantPortalSignedInDtoOutput._();

  factory MerchantPortalSignedInDtoOutput([
    void updates(MerchantPortalSignedInDtoOutputBuilder b),
  ]) = _$MerchantPortalSignedInDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalSignedInDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalSignedInDtoOutput> get serializer =>
      _$MerchantPortalSignedInDtoOutputSerializer();
}

class _$MerchantPortalSignedInDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPortalSignedInDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalSignedInDtoOutput,
    _$MerchantPortalSignedInDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPortalSignedInDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalSignedInDtoOutput object, {
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
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSignedInDtoOutput object, {
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
    required MerchantPortalSignedInDtoOutputBuilder result,
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
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPortalSignedInDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalSignedInDtoOutputBuilder();
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
