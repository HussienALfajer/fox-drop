//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_change_log_dto_output_entries_inner_changes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_change_log_dto_output_entries_inner.g.dart';

/// AdminRestaurantChangeLogDtoOutputEntriesInner
///
/// Properties:
/// * [id]
/// * [at]
/// * [action] - The audit action, such as restaurant.operations or restaurant.commission.
/// * [actorType]
/// * [actorName] - The admin or the restaurant user; null for the system.
/// * [actorRole]
/// * [account] - The restaurant user an account change is about, by name.
/// * [changes] - The changed fields only.
/// * [reason]
@BuiltValue()
abstract class AdminRestaurantChangeLogDtoOutputEntriesInner
    implements
        Built<
          AdminRestaurantChangeLogDtoOutputEntriesInner,
          AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The audit action, such as restaurant.operations or restaurant.commission.
  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'actorType')
  AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum get actorType;
  // enum actorTypeEnum {  admin,  merchant,  captain,  customer,  system,  };

  /// The admin or the restaurant user; null for the system.
  @BuiltValueField(wireName: r'actorName')
  String? get actorName;

  @BuiltValueField(wireName: r'actorRole')
  String? get actorRole;

  /// The restaurant user an account change is about, by name.
  @BuiltValueField(wireName: r'account')
  String? get account;

  /// The changed fields only.
  @BuiltValueField(wireName: r'changes')
  BuiltList<AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner>
  get changes;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminRestaurantChangeLogDtoOutputEntriesInner._();

  factory AdminRestaurantChangeLogDtoOutputEntriesInner([
    void updates(AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminRestaurantChangeLogDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantChangeLogDtoOutputEntriesInner>
  get serializer => _$AdminRestaurantChangeLogDtoOutputEntriesInnerSerializer();
}

class _$AdminRestaurantChangeLogDtoOutputEntriesInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantChangeLogDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantChangeLogDtoOutputEntriesInner,
    _$AdminRestaurantChangeLogDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantChangeLogDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantChangeLogDtoOutputEntriesInner object, {
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
        AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum,
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
    yield r'account';
    yield object.account == null
        ? null
        : serializers.serialize(
            object.account,
            specifiedType: const FullType.nullable(String),
          );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner),
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
    AdminRestaurantChangeLogDtoOutputEntriesInner object, {
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
    required AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder result,
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
                      AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum,
                    ),
                  )
                  as AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum;
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
        case r'account':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.account = valueDes;
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantChangeLogDtoOutputEntriesInnerChangesInner
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
  AdminRestaurantChangeLogDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantChangeLogDtoOutputEntriesInnerBuilder();
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

class AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
  admin = _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
  merchant =
      _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
  captain =
      _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
  customer =
      _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_customer;
  @BuiltValueEnumConst(wireName: r'system')
  static const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum
  system = _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum_system;

  static Serializer<AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum>
  get serializer =>
      _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumSerializer;

  const AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum>
  get values =>
      _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumValues;
  static AdminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnum valueOf(
    String name,
  ) =>
      _$adminRestaurantChangeLogDtoOutputEntriesInnerActorTypeEnumValueOf(name);
}
