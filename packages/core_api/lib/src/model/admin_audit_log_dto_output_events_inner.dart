//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_audit_log_dto_output_events_inner_changes_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_log_dto_output_events_inner.g.dart';

/// AdminAuditLogDtoOutputEventsInner
///
/// Properties:
/// * [id]
/// * [at]
/// * [kind] - view: a sensitive view, without changes.
/// * [cityId] - None for an action on the whole platform (D28).
/// * [actorType]
/// * [actorId] - None for the system.
/// * [actorName] - An admin's name; null for the others.
/// * [actorRole] - The role when it acted (D27).
/// * [action]
/// * [targetType]
/// * [targetId]
/// * [changes] - The changed fields of a write.
/// * [reason]
/// * [ipAddress]
/// * [device]
@BuiltValue()
abstract class AdminAuditLogDtoOutputEventsInner
    implements
        Built<
          AdminAuditLogDtoOutputEventsInner,
          AdminAuditLogDtoOutputEventsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// view: a sensitive view, without changes.
  @BuiltValueField(wireName: r'kind')
  AdminAuditLogDtoOutputEventsInnerKindEnum get kind;
  // enum kindEnum {  write,  view,  };

  /// None for an action on the whole platform (D28).
  @BuiltValueField(wireName: r'cityId')
  String? get cityId;

  @BuiltValueField(wireName: r'actorType')
  AdminAuditLogDtoOutputEventsInnerActorTypeEnum get actorType;
  // enum actorTypeEnum {  admin,  merchant,  captain,  customer,  system,  };

  /// None for the system.
  @BuiltValueField(wireName: r'actorId')
  String? get actorId;

  /// An admin's name; null for the others.
  @BuiltValueField(wireName: r'actorName')
  String? get actorName;

  /// The role when it acted (D27).
  @BuiltValueField(wireName: r'actorRole')
  String? get actorRole;

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'targetType')
  String get targetType;

  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  /// The changed fields of a write.
  @BuiltValueField(wireName: r'changes')
  BuiltList<AdminAuditLogDtoOutputEventsInnerChangesInner> get changes;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'ipAddress')
  String? get ipAddress;

  @BuiltValueField(wireName: r'device')
  String? get device;

  AdminAuditLogDtoOutputEventsInner._();

  factory AdminAuditLogDtoOutputEventsInner([
    void updates(AdminAuditLogDtoOutputEventsInnerBuilder b),
  ]) = _$AdminAuditLogDtoOutputEventsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditLogDtoOutputEventsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditLogDtoOutputEventsInner> get serializer =>
      _$AdminAuditLogDtoOutputEventsInnerSerializer();
}

class _$AdminAuditLogDtoOutputEventsInnerSerializer
    implements PrimitiveSerializer<AdminAuditLogDtoOutputEventsInner> {
  @override
  final Iterable<Type> types = const [
    AdminAuditLogDtoOutputEventsInner,
    _$AdminAuditLogDtoOutputEventsInner,
  ];

  @override
  final String wireName = r'AdminAuditLogDtoOutputEventsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditLogDtoOutputEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminAuditLogDtoOutputEventsInnerKindEnum),
    );
    yield r'cityId';
    yield object.cityId == null
        ? null
        : serializers.serialize(
            object.cityId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'actorType';
    yield serializers.serialize(
      object.actorType,
      specifiedType: const FullType(
        AdminAuditLogDtoOutputEventsInnerActorTypeEnum,
      ),
    );
    yield r'actorId';
    yield object.actorId == null
        ? null
        : serializers.serialize(
            object.actorId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'actorName';
    yield object.actorName == null
        ? null
        : serializers.serialize(
            object.actorName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'actorRole';
    yield object.actorRole == null
        ? null
        : serializers.serialize(
            object.actorRole,
            specifiedType: const FullType.nullable(String),
          );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'targetType';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(String),
    );
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminAuditLogDtoOutputEventsInnerChangesInner),
      ]),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ipAddress';
    yield object.ipAddress == null
        ? null
        : serializers.serialize(
            object.ipAddress,
            specifiedType: const FullType.nullable(String),
          );
    yield r'device';
    yield object.device == null
        ? null
        : serializers.serialize(
            object.device,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogDtoOutputEventsInner object, {
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
    required AdminAuditLogDtoOutputEventsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAuditLogDtoOutputEventsInnerKindEnum,
                    ),
                  )
                  as AdminAuditLogDtoOutputEventsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cityId = valueDes;
          break;
        case r'actorType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminAuditLogDtoOutputEventsInnerActorTypeEnum,
                    ),
                  )
                  as AdminAuditLogDtoOutputEventsInnerActorTypeEnum;
          result.actorType = valueDes;
          break;
        case r'actorId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.actorId = valueDes;
          break;
        case r'actorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.actorName = valueDes;
          break;
        case r'actorRole':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        case r'action':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.action = valueDes;
          break;
        case r'targetType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.targetType = valueDes;
          break;
        case r'targetId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.targetId = valueDes;
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminAuditLogDtoOutputEventsInnerChangesInner),
                    ]),
                  )
                  as BuiltList<AdminAuditLogDtoOutputEventsInnerChangesInner>;
          result.changes.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'ipAddress':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.ipAddress = valueDes;
          break;
        case r'device':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.device = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditLogDtoOutputEventsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditLogDtoOutputEventsInnerBuilder();
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

/// view: a sensitive view, without changes.
class AdminAuditLogDtoOutputEventsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'write')
  static const AdminAuditLogDtoOutputEventsInnerKindEnum write =
      _$adminAuditLogDtoOutputEventsInnerKindEnum_write;
  @BuiltValueEnumConst(wireName: r'view')
  static const AdminAuditLogDtoOutputEventsInnerKindEnum view =
      _$adminAuditLogDtoOutputEventsInnerKindEnum_view;

  static Serializer<AdminAuditLogDtoOutputEventsInnerKindEnum> get serializer =>
      _$adminAuditLogDtoOutputEventsInnerKindEnumSerializer;

  const AdminAuditLogDtoOutputEventsInnerKindEnum._(String name) : super(name);

  static BuiltSet<AdminAuditLogDtoOutputEventsInnerKindEnum> get values =>
      _$adminAuditLogDtoOutputEventsInnerKindEnumValues;
  static AdminAuditLogDtoOutputEventsInnerKindEnum valueOf(String name) =>
      _$adminAuditLogDtoOutputEventsInnerKindEnumValueOf(name);
}

class AdminAuditLogDtoOutputEventsInnerActorTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const AdminAuditLogDtoOutputEventsInnerActorTypeEnum admin =
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminAuditLogDtoOutputEventsInnerActorTypeEnum merchant =
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminAuditLogDtoOutputEventsInnerActorTypeEnum captain =
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminAuditLogDtoOutputEventsInnerActorTypeEnum customer =
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_customer;
  @BuiltValueEnumConst(wireName: r'system')
  static const AdminAuditLogDtoOutputEventsInnerActorTypeEnum system =
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnum_system;

  static Serializer<AdminAuditLogDtoOutputEventsInnerActorTypeEnum>
  get serializer => _$adminAuditLogDtoOutputEventsInnerActorTypeEnumSerializer;

  const AdminAuditLogDtoOutputEventsInnerActorTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminAuditLogDtoOutputEventsInnerActorTypeEnum> get values =>
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnumValues;
  static AdminAuditLogDtoOutputEventsInnerActorTypeEnum valueOf(String name) =>
      _$adminAuditLogDtoOutputEventsInnerActorTypeEnumValueOf(name);
}
