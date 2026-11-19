//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_change_log_dto_output_entries_inner_changes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_change_log_dto_output_entries_inner.g.dart';

/// AdminCaptainChangeLogDtoOutputEntriesInner
///
/// Properties:
/// * [id]
/// * [at]
/// * [action] - The audit action, such as captain.status.
/// * [actorType]
/// * [actorName] - The admin; null for the others.
/// * [actorRole]
/// * [changes]
/// * [reason]
@BuiltValue()
abstract class AdminCaptainChangeLogDtoOutputEntriesInner
    implements
        Built<
          AdminCaptainChangeLogDtoOutputEntriesInner,
          AdminCaptainChangeLogDtoOutputEntriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The audit action, such as captain.status.
  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'actorType')
  AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum get actorType;
  // enum actorTypeEnum {  admin,  merchant,  captain,  customer,  system,  };

  /// The admin; null for the others.
  @BuiltValueField(wireName: r'actorName')
  String? get actorName;

  @BuiltValueField(wireName: r'actorRole')
  String? get actorRole;

  @BuiltValueField(wireName: r'changes')
  BuiltList<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner> get changes;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminCaptainChangeLogDtoOutputEntriesInner._();

  factory AdminCaptainChangeLogDtoOutputEntriesInner([
    void updates(AdminCaptainChangeLogDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminCaptainChangeLogDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainChangeLogDtoOutputEntriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainChangeLogDtoOutputEntriesInner>
  get serializer => _$AdminCaptainChangeLogDtoOutputEntriesInnerSerializer();
}

class _$AdminCaptainChangeLogDtoOutputEntriesInnerSerializer
    implements PrimitiveSerializer<AdminCaptainChangeLogDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainChangeLogDtoOutputEntriesInner,
    _$AdminCaptainChangeLogDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminCaptainChangeLogDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainChangeLogDtoOutputEntriesInner object, {
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
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'actorType';
    yield serializers.serialize(
      object.actorType,
      specifiedType: const FullType(
        AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum,
      ),
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
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner),
      ]),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainChangeLogDtoOutputEntriesInner object, {
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
    required AdminCaptainChangeLogDtoOutputEntriesInnerBuilder result,
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
        case r'action':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.action = valueDes;
          break;
        case r'actorType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum,
                    ),
                  )
                  as AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum;
          result.actorType = valueDes;
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
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner
                  >;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainChangeLogDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainChangeLogDtoOutputEntriesInnerBuilder();
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

class AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum admin =
      _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
  merchant = _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum captain =
      _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum
  customer = _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_customer;
  @BuiltValueEnumConst(wireName: r'system')
  static const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum system =
      _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum_system;

  static Serializer<AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum>
  get serializer =>
      _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer;

  const AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum>
  get values => _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumValues;
  static AdminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnum valueOf(
    String name,
  ) => _$adminCaptainChangeLogDtoOutputEntriesInnerActorTypeEnumValueOf(name);
}
