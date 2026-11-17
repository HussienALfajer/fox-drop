//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_close_dto.g.dart';

/// AdminTicketCloseDto
///
/// Properties:
/// * [cityId]
/// * [reason] - Internal.
@BuiltValue()
abstract class AdminTicketCloseDto
    implements Built<AdminTicketCloseDto, AdminTicketCloseDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Internal.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminTicketCloseDto._();

  factory AdminTicketCloseDto([void updates(AdminTicketCloseDtoBuilder b)]) =
      _$AdminTicketCloseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketCloseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketCloseDto> get serializer =>
      _$AdminTicketCloseDtoSerializer();
}

class _$AdminTicketCloseDtoSerializer
    implements PrimitiveSerializer<AdminTicketCloseDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketCloseDto,
    _$AdminTicketCloseDto,
  ];

  @override
  final String wireName = r'AdminTicketCloseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketCloseDto object, {
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
    AdminTicketCloseDto object, {
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
    required AdminTicketCloseDtoBuilder result,
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
  AdminTicketCloseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketCloseDtoBuilder();
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
