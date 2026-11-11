//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_force_offline_dto.g.dart';

/// AdminForceOfflineDto
///
/// Properties:
/// * [reason] - Shown to the captain and kept in the audit log (AP §9.7.5).
@BuiltValue()
abstract class AdminForceOfflineDto
    implements Built<AdminForceOfflineDto, AdminForceOfflineDtoBuilder> {
  /// Shown to the captain and kept in the audit log (AP §9.7.5).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminForceOfflineDto._();

  factory AdminForceOfflineDto([void updates(AdminForceOfflineDtoBuilder b)]) =
      _$AdminForceOfflineDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminForceOfflineDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminForceOfflineDto> get serializer =>
      _$AdminForceOfflineDtoSerializer();
}

class _$AdminForceOfflineDtoSerializer
    implements PrimitiveSerializer<AdminForceOfflineDto> {
  @override
  final Iterable<Type> types = const [
    AdminForceOfflineDto,
    _$AdminForceOfflineDto,
  ];

  @override
  final String wireName = r'AdminForceOfflineDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminForceOfflineDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminForceOfflineDto object, {
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
    required AdminForceOfflineDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminForceOfflineDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminForceOfflineDtoBuilder();
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
