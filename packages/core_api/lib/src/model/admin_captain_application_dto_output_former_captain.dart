//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_former_captain.g.dart';

/// A former captain applying again on the same account.
///
/// Properties:
/// * [captainId]
/// * [earlyExit] - Flagged «خروج مبكر»: OWN activates (C17).
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputFormerCaptain
    implements
        Built<
          AdminCaptainApplicationDtoOutputFormerCaptain,
          AdminCaptainApplicationDtoOutputFormerCaptainBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// Flagged «خروج مبكر»: OWN activates (C17).
  @BuiltValueField(wireName: r'earlyExit')
  bool get earlyExit;

  AdminCaptainApplicationDtoOutputFormerCaptain._();

  factory AdminCaptainApplicationDtoOutputFormerCaptain([
    void updates(AdminCaptainApplicationDtoOutputFormerCaptainBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputFormerCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputFormerCaptainBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputFormerCaptain>
  get serializer => _$AdminCaptainApplicationDtoOutputFormerCaptainSerializer();
}

class _$AdminCaptainApplicationDtoOutputFormerCaptainSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputFormerCaptain> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputFormerCaptain,
    _$AdminCaptainApplicationDtoOutputFormerCaptain,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputFormerCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputFormerCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'earlyExit';
    yield serializers.serialize(
      object.earlyExit,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputFormerCaptain object, {
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
    required AdminCaptainApplicationDtoOutputFormerCaptainBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'earlyExit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.earlyExit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputFormerCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputFormerCaptainBuilder();
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
