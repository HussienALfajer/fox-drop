//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_portal_sessions_dto_output_sessions_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_portal_sessions_dto_output.g.dart';

/// MerchantPortalSessionsDtoOutput
///
/// Properties:
/// * [sessions] - The restaurant's open portal sessions, the latest sign-in first: never devices (RA §4.6).
@BuiltValue()
abstract class MerchantPortalSessionsDtoOutput
    implements
        Built<
          MerchantPortalSessionsDtoOutput,
          MerchantPortalSessionsDtoOutputBuilder
        > {
  /// The restaurant's open portal sessions, the latest sign-in first: never devices (RA §4.6).
  @BuiltValueField(wireName: r'sessions')
  BuiltList<MerchantPortalSessionsDtoOutputSessionsInner> get sessions;

  MerchantPortalSessionsDtoOutput._();

  factory MerchantPortalSessionsDtoOutput([
    void updates(MerchantPortalSessionsDtoOutputBuilder b),
  ]) = _$MerchantPortalSessionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPortalSessionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPortalSessionsDtoOutput> get serializer =>
      _$MerchantPortalSessionsDtoOutputSerializer();
}

class _$MerchantPortalSessionsDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPortalSessionsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPortalSessionsDtoOutput,
    _$MerchantPortalSessionsDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPortalSessionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPortalSessionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessions';
    yield serializers.serialize(
      object.sessions,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantPortalSessionsDtoOutputSessionsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPortalSessionsDtoOutput object, {
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
    required MerchantPortalSessionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sessions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantPortalSessionsDtoOutputSessionsInner),
                    ]),
                  )
                  as BuiltList<MerchantPortalSessionsDtoOutputSessionsInner>;
          result.sessions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPortalSessionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPortalSessionsDtoOutputBuilder();
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
