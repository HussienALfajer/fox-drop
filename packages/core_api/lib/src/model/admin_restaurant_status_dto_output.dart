//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_status_dto_output_pickup_base_currency.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_status_dto_output_busy_mode.dart';
import 'package:core_api/src/model/merchant_status_dto_output_holiday.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_status_dto_output.g.dart';

/// AdminRestaurantStatusDtoOutput
///
/// Properties:
/// * [state] - The operating state now (RA §7.1).
/// * [pauseSource] - Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).
/// * [stateUntil] - When a holiday close or a pause ends.
/// * [closesAt] - Inside an opening period, when it ends: «يغلق اليوم 11:30 م» (RA §7.2).
/// * [opensAt] - Closed by the schedule, when it next opens.
/// * [busyMode]
/// * [activeOrders] - Orders in placed, accepted or ready, counted only against a maximum (RA §7.4).
/// * [maxActiveOrders]
/// * [holiday]
/// * [nameAr]
/// * [accountStatus]
/// * [heldPauseSource] - The pause in force, whatever the state: an operations or auto pause holds while closed too (AP §9.6.5); null without one.
/// * [heldPauseUntil] - Its end; null until resumed, or without one.
/// * [pauseMessage] - An operations pause’s, to customers (CU §9.2).
/// * [pauseReason] - An operations pause’s reason.
/// * [pauseChoicesMin] - «15 د», «30 د», «60 د» (AP §9.6.5).
/// * [pickupBaseCurrency]
/// * [pickupCurrencies] - The other currencies switched on, in the city’s display order.
/// * [pickupCurrencyChoices] - Every other currency the city has enabled, in its display order.
@BuiltValue()
abstract class AdminRestaurantStatusDtoOutput
    implements
        Built<
          AdminRestaurantStatusDtoOutput,
          AdminRestaurantStatusDtoOutputBuilder
        > {
  /// The operating state now (RA §7.1).
  @BuiltValueField(wireName: r'state')
  AdminRestaurantStatusDtoOutputStateEnum get state;
  // enum stateEnum {  draft,  suspended,  terminated,  holiday,  closed,  paused,  busy,  open,  };

  /// Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).
  @BuiltValueField(wireName: r'pauseSource')
  AdminRestaurantStatusDtoOutputPauseSourceEnum? get pauseSource;
  // enum pauseSourceEnum {  restaurant,  ops,  auto,  };

  /// When a holiday close or a pause ends.
  @BuiltValueField(wireName: r'stateUntil')
  DateTime? get stateUntil;

  /// Inside an opening period, when it ends: «يغلق اليوم 11:30 م» (RA §7.2).
  @BuiltValueField(wireName: r'closesAt')
  DateTime? get closesAt;

  /// Closed by the schedule, when it next opens.
  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  @BuiltValueField(wireName: r'busyMode')
  MerchantStatusDtoOutputBusyMode? get busyMode;

  /// Orders in placed, accepted or ready, counted only against a maximum (RA §7.4).
  @BuiltValueField(wireName: r'activeOrders')
  int? get activeOrders;

  @BuiltValueField(wireName: r'maxActiveOrders')
  int? get maxActiveOrders;

  @BuiltValueField(wireName: r'holiday')
  MerchantStatusDtoOutputHoliday? get holiday;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'accountStatus')
  AdminRestaurantStatusDtoOutputAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// The pause in force, whatever the state: an operations or auto pause holds while closed too (AP §9.6.5); null without one.
  @BuiltValueField(wireName: r'heldPauseSource')
  AdminRestaurantStatusDtoOutputHeldPauseSourceEnum? get heldPauseSource;
  // enum heldPauseSourceEnum {  restaurant,  ops,  auto,  };

  /// Its end; null until resumed, or without one.
  @BuiltValueField(wireName: r'heldPauseUntil')
  DateTime? get heldPauseUntil;

  /// An operations pause’s, to customers (CU §9.2).
  @BuiltValueField(wireName: r'pauseMessage')
  String? get pauseMessage;

  /// An operations pause’s reason.
  @BuiltValueField(wireName: r'pauseReason')
  String? get pauseReason;

  /// «15 د», «30 د», «60 د» (AP §9.6.5).
  @BuiltValueField(wireName: r'pauseChoicesMin')
  BuiltList<int> get pauseChoicesMin;

  @BuiltValueField(wireName: r'pickupBaseCurrency')
  AdminRestaurantStatusDtoOutputPickupBaseCurrency? get pickupBaseCurrency;

  /// The other currencies switched on, in the city’s display order.
  @BuiltValueField(wireName: r'pickupCurrencies')
  BuiltList<String> get pickupCurrencies;

  /// Every other currency the city has enabled, in its display order.
  @BuiltValueField(wireName: r'pickupCurrencyChoices')
  BuiltList<AdminRestaurantStatusDtoOutputPickupBaseCurrency?>
  get pickupCurrencyChoices;

  AdminRestaurantStatusDtoOutput._();

  factory AdminRestaurantStatusDtoOutput([
    void updates(AdminRestaurantStatusDtoOutputBuilder b),
  ]) = _$AdminRestaurantStatusDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantStatusDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantStatusDtoOutput> get serializer =>
      _$AdminRestaurantStatusDtoOutputSerializer();
}

class _$AdminRestaurantStatusDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantStatusDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantStatusDtoOutput,
    _$AdminRestaurantStatusDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantStatusDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantStatusDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminRestaurantStatusDtoOutputStateEnum),
    );
    yield r'pauseSource';
    yield object.pauseSource == null
        ? null
        : serializers.serialize(
            object.pauseSource,
            specifiedType: const FullType.nullable(
              AdminRestaurantStatusDtoOutputPauseSourceEnum,
            ),
          );
    yield r'stateUntil';
    yield object.stateUntil == null
        ? null
        : serializers.serialize(
            object.stateUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'closesAt';
    yield object.closesAt == null
        ? null
        : serializers.serialize(
            object.closesAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'busyMode';
    yield object.busyMode == null
        ? null
        : serializers.serialize(
            object.busyMode,
            specifiedType: const FullType.nullable(
              MerchantStatusDtoOutputBusyMode,
            ),
          );
    yield r'activeOrders';
    yield object.activeOrders == null
        ? null
        : serializers.serialize(
            object.activeOrders,
            specifiedType: const FullType.nullable(int),
          );
    yield r'maxActiveOrders';
    yield object.maxActiveOrders == null
        ? null
        : serializers.serialize(
            object.maxActiveOrders,
            specifiedType: const FullType.nullable(int),
          );
    yield r'holiday';
    yield object.holiday == null
        ? null
        : serializers.serialize(
            object.holiday,
            specifiedType: const FullType.nullable(
              MerchantStatusDtoOutputHoliday,
            ),
          );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(
        AdminRestaurantStatusDtoOutputAccountStatusEnum,
      ),
    );
    yield r'heldPauseSource';
    yield object.heldPauseSource == null
        ? null
        : serializers.serialize(
            object.heldPauseSource,
            specifiedType: const FullType.nullable(
              AdminRestaurantStatusDtoOutputHeldPauseSourceEnum,
            ),
          );
    yield r'heldPauseUntil';
    yield object.heldPauseUntil == null
        ? null
        : serializers.serialize(
            object.heldPauseUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'pauseMessage';
    yield object.pauseMessage == null
        ? null
        : serializers.serialize(
            object.pauseMessage,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pauseReason';
    yield object.pauseReason == null
        ? null
        : serializers.serialize(
            object.pauseReason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pauseChoicesMin';
    yield serializers.serialize(
      object.pauseChoicesMin,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'pickupBaseCurrency';
    yield object.pickupBaseCurrency == null
        ? null
        : serializers.serialize(
            object.pickupBaseCurrency,
            specifiedType: const FullType.nullable(
              AdminRestaurantStatusDtoOutputPickupBaseCurrency,
            ),
          );
    yield r'pickupCurrencies';
    yield serializers.serialize(
      object.pickupCurrencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'pickupCurrencyChoices';
    yield serializers.serialize(
      object.pickupCurrencyChoices,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminRestaurantStatusDtoOutputPickupBaseCurrency),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantStatusDtoOutput object, {
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
    required AdminRestaurantStatusDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantStatusDtoOutputStateEnum,
                    ),
                  )
                  as AdminRestaurantStatusDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'pauseSource':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantStatusDtoOutputPauseSourceEnum,
                    ),
                  )
                  as AdminRestaurantStatusDtoOutputPauseSourceEnum?;
          if (valueDes == null) continue;
          result.pauseSource = valueDes;
          break;
        case r'stateUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.stateUntil = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'busyMode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatusDtoOutputBusyMode,
                    ),
                  )
                  as MerchantStatusDtoOutputBusyMode?;
          if (valueDes == null) continue;
          result.busyMode.replace(valueDes);
          break;
        case r'activeOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.activeOrders = valueDes;
          break;
        case r'maxActiveOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxActiveOrders = valueDes;
          break;
        case r'holiday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatusDtoOutputHoliday,
                    ),
                  )
                  as MerchantStatusDtoOutputHoliday?;
          if (valueDes == null) continue;
          result.holiday.replace(valueDes);
          break;
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantStatusDtoOutputAccountStatusEnum,
                    ),
                  )
                  as AdminRestaurantStatusDtoOutputAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'heldPauseSource':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantStatusDtoOutputHeldPauseSourceEnum,
                    ),
                  )
                  as AdminRestaurantStatusDtoOutputHeldPauseSourceEnum?;
          if (valueDes == null) continue;
          result.heldPauseSource = valueDes;
          break;
        case r'heldPauseUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.heldPauseUntil = valueDes;
          break;
        case r'pauseMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.pauseMessage = valueDes;
          break;
        case r'pauseReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.pauseReason = valueDes;
          break;
        case r'pauseChoicesMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [FullType(int)]),
                  )
                  as BuiltList<int>;
          result.pauseChoicesMin.replace(valueDes);
          break;
        case r'pickupBaseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantStatusDtoOutputPickupBaseCurrency,
                    ),
                  )
                  as AdminRestaurantStatusDtoOutputPickupBaseCurrency?;
          if (valueDes == null) continue;
          result.pickupBaseCurrency.replace(valueDes);
          break;
        case r'pickupCurrencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.pickupCurrencies.replace(valueDes);
          break;
        case r'pickupCurrencyChoices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminRestaurantStatusDtoOutputPickupBaseCurrency,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantStatusDtoOutputPickupBaseCurrency?
                  >;
          result.pickupCurrencyChoices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantStatusDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantStatusDtoOutputBuilder();
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

/// The operating state now (RA §7.1).
class AdminRestaurantStatusDtoOutputStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminRestaurantStatusDtoOutputStateEnum draft =
      _$adminRestaurantStatusDtoOutputStateEnum_draft;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminRestaurantStatusDtoOutputStateEnum suspended =
      _$adminRestaurantStatusDtoOutputStateEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminRestaurantStatusDtoOutputStateEnum terminated =
      _$adminRestaurantStatusDtoOutputStateEnum_terminated;
  @BuiltValueEnumConst(wireName: r'holiday')
  static const AdminRestaurantStatusDtoOutputStateEnum holiday =
      _$adminRestaurantStatusDtoOutputStateEnum_holiday;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminRestaurantStatusDtoOutputStateEnum closed =
      _$adminRestaurantStatusDtoOutputStateEnum_closed;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminRestaurantStatusDtoOutputStateEnum paused =
      _$adminRestaurantStatusDtoOutputStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminRestaurantStatusDtoOutputStateEnum busy =
      _$adminRestaurantStatusDtoOutputStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminRestaurantStatusDtoOutputStateEnum open =
      _$adminRestaurantStatusDtoOutputStateEnum_open;

  static Serializer<AdminRestaurantStatusDtoOutputStateEnum> get serializer =>
      _$adminRestaurantStatusDtoOutputStateEnumSerializer;

  const AdminRestaurantStatusDtoOutputStateEnum._(String name) : super(name);

  static BuiltSet<AdminRestaurantStatusDtoOutputStateEnum> get values =>
      _$adminRestaurantStatusDtoOutputStateEnumValues;
  static AdminRestaurantStatusDtoOutputStateEnum valueOf(String name) =>
      _$adminRestaurantStatusDtoOutputStateEnumValueOf(name);
}

/// Who paused it while paused: the restaurant’s own buttons work only for «restaurant» (RA §7.2).
class AdminRestaurantStatusDtoOutputPauseSourceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminRestaurantStatusDtoOutputPauseSourceEnum restaurant =
      _$adminRestaurantStatusDtoOutputPauseSourceEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'ops')
  static const AdminRestaurantStatusDtoOutputPauseSourceEnum ops =
      _$adminRestaurantStatusDtoOutputPauseSourceEnum_ops;
  @BuiltValueEnumConst(wireName: r'auto')
  static const AdminRestaurantStatusDtoOutputPauseSourceEnum auto =
      _$adminRestaurantStatusDtoOutputPauseSourceEnum_auto;

  static Serializer<AdminRestaurantStatusDtoOutputPauseSourceEnum>
  get serializer => _$adminRestaurantStatusDtoOutputPauseSourceEnumSerializer;

  const AdminRestaurantStatusDtoOutputPauseSourceEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantStatusDtoOutputPauseSourceEnum> get values =>
      _$adminRestaurantStatusDtoOutputPauseSourceEnumValues;
  static AdminRestaurantStatusDtoOutputPauseSourceEnum valueOf(String name) =>
      _$adminRestaurantStatusDtoOutputPauseSourceEnumValueOf(name);
}

class AdminRestaurantStatusDtoOutputAccountStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminRestaurantStatusDtoOutputAccountStatusEnum draft =
      _$adminRestaurantStatusDtoOutputAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminRestaurantStatusDtoOutputAccountStatusEnum test =
      _$adminRestaurantStatusDtoOutputAccountStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminRestaurantStatusDtoOutputAccountStatusEnum active =
      _$adminRestaurantStatusDtoOutputAccountStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminRestaurantStatusDtoOutputAccountStatusEnum suspended =
      _$adminRestaurantStatusDtoOutputAccountStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminRestaurantStatusDtoOutputAccountStatusEnum terminated =
      _$adminRestaurantStatusDtoOutputAccountStatusEnum_terminated;

  static Serializer<AdminRestaurantStatusDtoOutputAccountStatusEnum>
  get serializer => _$adminRestaurantStatusDtoOutputAccountStatusEnumSerializer;

  const AdminRestaurantStatusDtoOutputAccountStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantStatusDtoOutputAccountStatusEnum> get values =>
      _$adminRestaurantStatusDtoOutputAccountStatusEnumValues;
  static AdminRestaurantStatusDtoOutputAccountStatusEnum valueOf(String name) =>
      _$adminRestaurantStatusDtoOutputAccountStatusEnumValueOf(name);
}

/// The pause in force, whatever the state: an operations or auto pause holds while closed too (AP §9.6.5); null without one.
class AdminRestaurantStatusDtoOutputHeldPauseSourceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminRestaurantStatusDtoOutputHeldPauseSourceEnum restaurant =
      _$adminRestaurantStatusDtoOutputHeldPauseSourceEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'ops')
  static const AdminRestaurantStatusDtoOutputHeldPauseSourceEnum ops =
      _$adminRestaurantStatusDtoOutputHeldPauseSourceEnum_ops;
  @BuiltValueEnumConst(wireName: r'auto')
  static const AdminRestaurantStatusDtoOutputHeldPauseSourceEnum auto =
      _$adminRestaurantStatusDtoOutputHeldPauseSourceEnum_auto;

  static Serializer<AdminRestaurantStatusDtoOutputHeldPauseSourceEnum>
  get serializer =>
      _$adminRestaurantStatusDtoOutputHeldPauseSourceEnumSerializer;

  const AdminRestaurantStatusDtoOutputHeldPauseSourceEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantStatusDtoOutputHeldPauseSourceEnum>
  get values => _$adminRestaurantStatusDtoOutputHeldPauseSourceEnumValues;
  static AdminRestaurantStatusDtoOutputHeldPauseSourceEnum valueOf(
    String name,
  ) => _$adminRestaurantStatusDtoOutputHeldPauseSourceEnumValueOf(name);
}
