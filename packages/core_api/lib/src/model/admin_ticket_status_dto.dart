//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_status_dto.g.dart';

/// AdminTicketStatusDto
///
/// Properties:
/// * [cityId]
/// * [status] - «بانتظار رد», or back to «قيد المعالجة»; «محلولة» only by resolving.
@BuiltValue()
abstract class AdminTicketStatusDto
    implements Built<AdminTicketStatusDto, AdminTicketStatusDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// «بانتظار رد», or back to «قيد المعالجة»; «محلولة» only by resolving.
  @BuiltValueField(wireName: r'status')
  AdminTicketStatusDtoStatusEnum get status;
  // enum statusEnum {  in_progress,  waiting,  };

  AdminTicketStatusDto._();

  factory AdminTicketStatusDto([void updates(AdminTicketStatusDtoBuilder b)]) =
      _$AdminTicketStatusDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketStatusDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketStatusDto> get serializer =>
      _$AdminTicketStatusDtoSerializer();
}

class _$AdminTicketStatusDtoSerializer
    implements PrimitiveSerializer<AdminTicketStatusDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketStatusDto,
    _$AdminTicketStatusDto,
  ];

  @override
  final String wireName = r'AdminTicketStatusDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketStatusDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminTicketStatusDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketStatusDto object, {
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
    required AdminTicketStatusDtoBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketStatusDtoStatusEnum,
                    ),
                  )
                  as AdminTicketStatusDtoStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketStatusDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketStatusDtoBuilder();
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

/// «بانتظار رد», or back to «قيد المعالجة»; «محلولة» only by resolving.
class AdminTicketStatusDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const AdminTicketStatusDtoStatusEnum inProgress =
      _$adminTicketStatusDtoStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminTicketStatusDtoStatusEnum waiting =
      _$adminTicketStatusDtoStatusEnum_waiting;

  static Serializer<AdminTicketStatusDtoStatusEnum> get serializer =>
      _$adminTicketStatusDtoStatusEnumSerializer;

  const AdminTicketStatusDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminTicketStatusDtoStatusEnum> get values =>
      _$adminTicketStatusDtoStatusEnumValues;
  static AdminTicketStatusDtoStatusEnum valueOf(String name) =>
      _$adminTicketStatusDtoStatusEnumValueOf(name);
}
