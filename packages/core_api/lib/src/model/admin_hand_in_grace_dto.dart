//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_grace_dto.g.dart';

/// AdminHandInGraceDto
///
/// Properties:
/// * [reason] - Why, such as «المكتب كان مغلقاً»; kept in the audit log (AP §8.5.4).
@BuiltValue()
abstract class AdminHandInGraceDto
    implements Built<AdminHandInGraceDto, AdminHandInGraceDtoBuilder> {
  /// Why, such as «المكتب كان مغلقاً»; kept in the audit log (AP §8.5.4).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminHandInGraceDto._();

  factory AdminHandInGraceDto([void updates(AdminHandInGraceDtoBuilder b)]) =
      _$AdminHandInGraceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInGraceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInGraceDto> get serializer =>
      _$AdminHandInGraceDtoSerializer();
}

class _$AdminHandInGraceDtoSerializer
    implements PrimitiveSerializer<AdminHandInGraceDto> {
  @override
  final Iterable<Type> types = const [
    AdminHandInGraceDto,
    _$AdminHandInGraceDto,
  ];

  @override
  final String wireName = r'AdminHandInGraceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInGraceDto object, {
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
    AdminHandInGraceDto object, {
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
    required AdminHandInGraceDtoBuilder result,
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
  AdminHandInGraceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInGraceDtoBuilder();
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
