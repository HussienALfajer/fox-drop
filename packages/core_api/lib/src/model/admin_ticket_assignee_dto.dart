//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_assignee_dto.g.dart';

/// AdminTicketAssigneeDto
///
/// Properties:
/// * [cityId]
/// * [assigneeId]
@BuiltValue()
abstract class AdminTicketAssigneeDto
    implements Built<AdminTicketAssigneeDto, AdminTicketAssigneeDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'assigneeId')
  String? get assigneeId;

  AdminTicketAssigneeDto._();

  factory AdminTicketAssigneeDto([
    void updates(AdminTicketAssigneeDtoBuilder b),
  ]) = _$AdminTicketAssigneeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketAssigneeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketAssigneeDto> get serializer =>
      _$AdminTicketAssigneeDtoSerializer();
}

class _$AdminTicketAssigneeDtoSerializer
    implements PrimitiveSerializer<AdminTicketAssigneeDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketAssigneeDto,
    _$AdminTicketAssigneeDto,
  ];

  @override
  final String wireName = r'AdminTicketAssigneeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketAssigneeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'assigneeId';
    yield object.assigneeId == null
        ? null
        : serializers.serialize(
            object.assigneeId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketAssigneeDto object, {
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
    required AdminTicketAssigneeDtoBuilder result,
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
        case r'assigneeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.assigneeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketAssigneeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketAssigneeDtoBuilder();
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
