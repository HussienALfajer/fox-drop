//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_devices_inner_accounts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_devices_inner_lift.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_devices_inner.g.dart';

/// AdminCustomerDtoOutputDevicesInner
///
/// Properties:
/// * [deviceId]
/// * [firstSeenAt]
/// * [lastSeenAt]
/// * [ipAddress] - The latest sign-in's; a signal only.
/// * [userAgent]
/// * [blocked] - An account signed in on it since its latest lift is blocked or owes dues: «فك حظر الجهاز».
/// * [accounts] - The other accounts signed in on it since its latest lift.
/// * [lift]
@BuiltValue()
abstract class AdminCustomerDtoOutputDevicesInner
    implements
        Built<
          AdminCustomerDtoOutputDevicesInner,
          AdminCustomerDtoOutputDevicesInnerBuilder
        > {
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'firstSeenAt')
  DateTime get firstSeenAt;

  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime get lastSeenAt;

  /// The latest sign-in's; a signal only.
  @BuiltValueField(wireName: r'ipAddress')
  String? get ipAddress;

  @BuiltValueField(wireName: r'userAgent')
  String? get userAgent;

  /// An account signed in on it since its latest lift is blocked or owes dues: «فك حظر الجهاز».
  @BuiltValueField(wireName: r'blocked')
  bool get blocked;

  /// The other accounts signed in on it since its latest lift.
  @BuiltValueField(wireName: r'accounts')
  BuiltList<AdminCustomerDtoOutputDevicesInnerAccountsInner> get accounts;

  @BuiltValueField(wireName: r'lift')
  AdminCustomerDtoOutputDevicesInnerLift? get lift;

  AdminCustomerDtoOutputDevicesInner._();

  factory AdminCustomerDtoOutputDevicesInner([
    void updates(AdminCustomerDtoOutputDevicesInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputDevicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputDevicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputDevicesInner> get serializer =>
      _$AdminCustomerDtoOutputDevicesInnerSerializer();
}

class _$AdminCustomerDtoOutputDevicesInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputDevicesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputDevicesInner,
    _$AdminCustomerDtoOutputDevicesInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputDevicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputDevicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'firstSeenAt';
    yield serializers.serialize(
      object.firstSeenAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastSeenAt';
    yield serializers.serialize(
      object.lastSeenAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'ipAddress';
    yield object.ipAddress == null
        ? null
        : serializers.serialize(
            object.ipAddress,
            specifiedType: const FullType.nullable(String),
          );
    yield r'userAgent';
    yield object.userAgent == null
        ? null
        : serializers.serialize(
            object.userAgent,
            specifiedType: const FullType.nullable(String),
          );
    yield r'blocked';
    yield serializers.serialize(
      object.blocked,
      specifiedType: const FullType(bool),
    );
    yield r'accounts';
    yield serializers.serialize(
      object.accounts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputDevicesInnerAccountsInner),
      ]),
    );
    yield r'lift';
    yield object.lift == null
        ? null
        : serializers.serialize(
            object.lift,
            specifiedType: const FullType.nullable(
              AdminCustomerDtoOutputDevicesInnerLift,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputDevicesInner object, {
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
    required AdminCustomerDtoOutputDevicesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deviceId = valueDes;
          break;
        case r'firstSeenAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.firstSeenAt = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastSeenAt = valueDes;
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
        case r'userAgent':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.userAgent = valueDes;
          break;
        case r'blocked':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.blocked = valueDes;
          break;
        case r'accounts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputDevicesInnerAccountsInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputDevicesInnerAccountsInner>;
          result.accounts.replace(valueDes);
          break;
        case r'lift':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCustomerDtoOutputDevicesInnerLift,
                    ),
                  )
                  as AdminCustomerDtoOutputDevicesInnerLift?;
          if (valueDes == null) continue;
          result.lift.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputDevicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputDevicesInnerBuilder();
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
