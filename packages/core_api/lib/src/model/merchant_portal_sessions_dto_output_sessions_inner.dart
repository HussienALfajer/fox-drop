//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_sessions_dto_output_sessions_inner.g.dart';

/// MerchantPortalSessionsDtoOutputSessionsInner
///
/// Properties:
/// * [sessionId]
/// * [ownerName]
/// * [userAgent] - The browser as it named itself at the sign-in; null when it did not.
/// * [signedInAt]
/// * [expiresAt]
/// * [thisSession] - The portal session making the request.
@BuiltValue()
abstract class MerchantPortalSessionsDtoOutputSessionsInner
    implements
        Built<
          MerchantPortalSessionsDtoOutputSessionsInner,
          MerchantPortalSessionsDtoOutputSessionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'ownerName')
  String get ownerName;

  /// The browser as it named itself at the sign-in; null when it did not.
  @BuiltValueField(wireName: r'userAgent')
  String? get userAgent;

  @BuiltValueField(wireName: r'signedInAt')
  DateTime get signedInAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  /// The portal session making the request.
  @BuiltValueField(wireName: r'thisSession')
  bool get thisSession;

  MerchantPortalSessionsDtoOutputSessionsInner._();

  factory MerchantPortalSessionsDtoOutputSessionsInner([
    void updates(MerchantPortalSessionsDtoOutputSessionsInnerBuilder b),
  ]) = _$MerchantPortalSessionsDtoOutputSessionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantPortalSessionsDtoOutputSessionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalSessionsDtoOutputSessionsInner>
  get serializer => _$MerchantPortalSessionsDtoOutputSessionsInnerSerializer();
}

class _$MerchantPortalSessionsDtoOutputSessionsInnerSerializer
    implements
        PrimitiveSerializer<MerchantPortalSessionsDtoOutputSessionsInner> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalSessionsDtoOutputSessionsInner,
    _$MerchantPortalSessionsDtoOutputSessionsInner,
  ];

  @override
  final String wireName = r'MerchantPortalSessionsDtoOutputSessionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalSessionsDtoOutputSessionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'ownerName';
    yield serializers.serialize(
      object.ownerName,
      specifiedType: const FullType(String),
    );
    yield r'userAgent';
    yield object.userAgent == null
        ? null
        : serializers.serialize(
            object.userAgent,
            specifiedType: const FullType.nullable(String),
          );
    yield r'signedInAt';
    yield serializers.serialize(
      object.signedInAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'thisSession';
    yield serializers.serialize(
      object.thisSession,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSessionsDtoOutputSessionsInner object, {
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
    required MerchantPortalSessionsDtoOutputSessionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sessionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sessionId = valueDes;
          break;
        case r'ownerName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ownerName = valueDes;
          break;
        case r'userAgent':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.userAgent = valueDes;
          break;
        case r'signedInAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.signedInAt = valueDes;
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
        case r'thisSession':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.thisSession = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPortalSessionsDtoOutputSessionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalSessionsDtoOutputSessionsInnerBuilder();
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
