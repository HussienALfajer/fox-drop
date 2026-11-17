//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_linked_accounts_inner.g.dart';

/// AdminCustomerDtoOutputLinkedAccountsInner
///
/// Properties:
/// * [id]
/// * [status]
/// * [createdAt]
/// * [closedAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputLinkedAccountsInner
    implements
        Built<
          AdminCustomerDtoOutputLinkedAccountsInner,
          AdminCustomerDtoOutputLinkedAccountsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum get status;
  // enum statusEnum {  active,  closed,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  AdminCustomerDtoOutputLinkedAccountsInner._();

  factory AdminCustomerDtoOutputLinkedAccountsInner([
    void updates(AdminCustomerDtoOutputLinkedAccountsInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputLinkedAccountsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputLinkedAccountsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputLinkedAccountsInner> get serializer =>
      _$AdminCustomerDtoOutputLinkedAccountsInnerSerializer();
}

class _$AdminCustomerDtoOutputLinkedAccountsInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputLinkedAccountsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputLinkedAccountsInner,
    _$AdminCustomerDtoOutputLinkedAccountsInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputLinkedAccountsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputLinkedAccountsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum,
      ),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closedAt';
    yield object.closedAt == null
        ? null
        : serializers.serialize(
            object.closedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputLinkedAccountsInner object, {
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
    required AdminCustomerDtoOutputLinkedAccountsInnerBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'closedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputLinkedAccountsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputLinkedAccountsInnerBuilder();
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

class AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum active =
      _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum closed =
      _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_closed;

  static Serializer<AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum>
  get serializer =>
      _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnumSerializer;

  const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum>
  get values => _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnumValues;
  static AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnumValueOf(name);
}
