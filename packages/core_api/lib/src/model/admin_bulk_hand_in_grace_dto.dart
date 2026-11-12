//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_bulk_hand_in_grace_dto.g.dart';

/// AdminBulkHandInGraceDto
///
/// Properties:
/// * [cityId]
/// * [reason] - Why, such as «المكتب كان مغلقاً»; kept in the audit log (AP §8.5.4).
@BuiltValue()
abstract class AdminBulkHandInGraceDto
    implements Built<AdminBulkHandInGraceDto, AdminBulkHandInGraceDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Why, such as «المكتب كان مغلقاً»; kept in the audit log (AP §8.5.4).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminBulkHandInGraceDto._();

  factory AdminBulkHandInGraceDto([
    void updates(AdminBulkHandInGraceDtoBuilder b),
  ]) = _$AdminBulkHandInGraceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBulkHandInGraceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBulkHandInGraceDto> get serializer =>
      _$AdminBulkHandInGraceDtoSerializer();
}

class _$AdminBulkHandInGraceDtoSerializer
    implements PrimitiveSerializer<AdminBulkHandInGraceDto> {
  @override
  final Iterable<Type> types = const [
    AdminBulkHandInGraceDto,
    _$AdminBulkHandInGraceDto,
  ];

  @override
  final String wireName = r'AdminBulkHandInGraceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBulkHandInGraceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBulkHandInGraceDto object, {
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
    required AdminBulkHandInGraceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
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
  AdminBulkHandInGraceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBulkHandInGraceDtoBuilder();
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
