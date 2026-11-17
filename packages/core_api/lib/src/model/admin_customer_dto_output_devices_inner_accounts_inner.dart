//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_devices_inner_accounts_inner.g.dart';

/// AdminCustomerDtoOutputDevicesInnerAccountsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [maskedPhone]
/// * [status] - «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم», «مغلق» (AP §9.8).
/// * [lastSignedInAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputDevicesInnerAccountsInner
    implements
        Built<
          AdminCustomerDtoOutputDevicesInnerAccountsInner,
          AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'maskedPhone')
  String? get maskedPhone;

  /// «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم», «مغلق» (AP §9.8).
  @BuiltValueField(wireName: r'status')
  AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum get status;
  // enum statusEnum {  active,  blocked,  dues_unpaid,  review_stop,  closed,  };

  @BuiltValueField(wireName: r'lastSignedInAt')
  DateTime get lastSignedInAt;

  AdminCustomerDtoOutputDevicesInnerAccountsInner._();

  factory AdminCustomerDtoOutputDevicesInnerAccountsInner([
    void updates(AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputDevicesInnerAccountsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputDevicesInnerAccountsInner>
  get serializer =>
      _$AdminCustomerDtoOutputDevicesInnerAccountsInnerSerializer();
}

class _$AdminCustomerDtoOutputDevicesInnerAccountsInnerSerializer
    implements
        PrimitiveSerializer<AdminCustomerDtoOutputDevicesInnerAccountsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputDevicesInnerAccountsInner,
    _$AdminCustomerDtoOutputDevicesInnerAccountsInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputDevicesInnerAccountsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputDevicesInnerAccountsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'maskedPhone';
    yield object.maskedPhone == null
        ? null
        : serializers.serialize(
            object.maskedPhone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum,
      ),
    );
    yield r'lastSignedInAt';
    yield serializers.serialize(
      object.lastSignedInAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputDevicesInnerAccountsInner object, {
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
    required AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'maskedPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maskedPhone = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'lastSignedInAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastSignedInAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputDevicesInnerAccountsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder();
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

/// «نشط», «محظور» (a block), «محظور» until the dues are paid, «موقوف حتى مراجعة الدعم», «مغلق» (AP §9.8).
class AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
  active = _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'blocked')
  static const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
  blocked = _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_blocked;
  @BuiltValueEnumConst(wireName: r'dues_unpaid')
  static const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
  duesUnpaid =
      _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_duesUnpaid;
  @BuiltValueEnumConst(wireName: r'review_stop')
  static const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
  reviewStop =
      _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_reviewStop;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
  closed = _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_closed;

  static Serializer<AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum>
  get serializer =>
      _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumSerializer;

  const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum>
  get values =>
      _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumValues;
  static AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumValueOf(name);
}
