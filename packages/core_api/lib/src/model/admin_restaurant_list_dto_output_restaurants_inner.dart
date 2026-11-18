//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_list_dto_output_restaurants_inner.g.dart';

/// AdminRestaurantListDtoOutputRestaurantsInner
///
/// Properties:
/// * [id]
/// * [nameAr]
/// * [nameEn]
/// * [categories]
/// * [accountStatus]
/// * [state] - The operating state in test mode or active; null otherwise.
/// * [visible]
/// * [sortWeight]
/// * [zoneName] - The zone the pin is in.
/// * [ratingAverage]
/// * [ratingCount]
/// * [ordersToday] - Placed since today’s cutoff, test orders left out.
/// * [acceptanceBp7d] - Accepted of those accepted, rejected or never answered over 7 business days, in basis points.
/// * [commissionBp] - In force now.
/// * [balance] - Minor units in the base: + the restaurant owes, − the platform owes it.
/// * [lastOrderAt]
@BuiltValue()
abstract class AdminRestaurantListDtoOutputRestaurantsInner
    implements
        Built<
          AdminRestaurantListDtoOutputRestaurantsInner,
          AdminRestaurantListDtoOutputRestaurantsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'nameEn')
  String? get nameEn;

  @BuiltValueField(wireName: r'categories')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get categories;

  @BuiltValueField(wireName: r'accountStatus')
  AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  get accountStatus;
  // enum accountStatusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// The operating state in test mode or active; null otherwise.
  @BuiltValueField(wireName: r'state')
  AdminRestaurantListDtoOutputRestaurantsInnerStateEnum? get state;
  // enum stateEnum {  open,  busy,  paused,  closed,  };

  @BuiltValueField(wireName: r'visible')
  bool get visible;

  @BuiltValueField(wireName: r'sortWeight')
  int get sortWeight;

  /// The zone the pin is in.
  @BuiltValueField(wireName: r'zoneName')
  String? get zoneName;

  @BuiltValueField(wireName: r'ratingAverage')
  num? get ratingAverage;

  @BuiltValueField(wireName: r'ratingCount')
  int get ratingCount;

  /// Placed since today’s cutoff, test orders left out.
  @BuiltValueField(wireName: r'ordersToday')
  int get ordersToday;

  /// Accepted of those accepted, rejected or never answered over 7 business days, in basis points.
  @BuiltValueField(wireName: r'acceptanceBp7d')
  int? get acceptanceBp7d;

  /// In force now.
  @BuiltValueField(wireName: r'commissionBp')
  int? get commissionBp;

  /// Minor units in the base: + the restaurant owes, − the platform owes it.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'lastOrderAt')
  DateTime? get lastOrderAt;

  AdminRestaurantListDtoOutputRestaurantsInner._();

  factory AdminRestaurantListDtoOutputRestaurantsInner([
    void updates(AdminRestaurantListDtoOutputRestaurantsInnerBuilder b),
  ]) = _$AdminRestaurantListDtoOutputRestaurantsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantListDtoOutputRestaurantsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantListDtoOutputRestaurantsInner>
  get serializer => _$AdminRestaurantListDtoOutputRestaurantsInnerSerializer();
}

class _$AdminRestaurantListDtoOutputRestaurantsInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantListDtoOutputRestaurantsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantListDtoOutputRestaurantsInner,
    _$AdminRestaurantListDtoOutputRestaurantsInner,
  ];

  @override
  final String wireName = r'AdminRestaurantListDtoOutputRestaurantsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantListDtoOutputRestaurantsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'nameEn';
    yield object.nameEn == null
        ? null
        : serializers.serialize(
            object.nameEn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
      ]),
    );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(
        AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum,
      ),
    );
    yield r'state';
    yield object.state == null
        ? null
        : serializers.serialize(
            object.state,
            specifiedType: const FullType.nullable(
              AdminRestaurantListDtoOutputRestaurantsInnerStateEnum,
            ),
          );
    yield r'visible';
    yield serializers.serialize(
      object.visible,
      specifiedType: const FullType(bool),
    );
    yield r'sortWeight';
    yield serializers.serialize(
      object.sortWeight,
      specifiedType: const FullType(int),
    );
    yield r'zoneName';
    yield object.zoneName == null
        ? null
        : serializers.serialize(
            object.zoneName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ratingAverage';
    yield object.ratingAverage == null
        ? null
        : serializers.serialize(
            object.ratingAverage,
            specifiedType: const FullType.nullable(num),
          );
    yield r'ratingCount';
    yield serializers.serialize(
      object.ratingCount,
      specifiedType: const FullType(int),
    );
    yield r'ordersToday';
    yield serializers.serialize(
      object.ordersToday,
      specifiedType: const FullType(int),
    );
    yield r'acceptanceBp7d';
    yield object.acceptanceBp7d == null
        ? null
        : serializers.serialize(
            object.acceptanceBp7d,
            specifiedType: const FullType.nullable(int),
          );
    yield r'commissionBp';
    yield object.commissionBp == null
        ? null
        : serializers.serialize(
            object.commissionBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'lastOrderAt';
    yield object.lastOrderAt == null
        ? null
        : serializers.serialize(
            object.lastOrderAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantListDtoOutputRestaurantsInner object, {
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
    required AdminRestaurantListDtoOutputRestaurantsInnerBuilder result,
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
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'nameEn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.nameEn = valueDes;
          break;
        case r'categories':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>;
          result.categories.replace(valueDes);
          break;
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum,
                    ),
                  )
                  as AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantListDtoOutputRestaurantsInnerStateEnum,
                    ),
                  )
                  as AdminRestaurantListDtoOutputRestaurantsInnerStateEnum?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'visible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.visible = valueDes;
          break;
        case r'sortWeight':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sortWeight = valueDes;
          break;
        case r'zoneName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneName = valueDes;
          break;
        case r'ratingAverage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.ratingAverage = valueDes;
          break;
        case r'ratingCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ratingCount = valueDes;
          break;
        case r'ordersToday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ordersToday = valueDes;
          break;
        case r'acceptanceBp7d':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.acceptanceBp7d = valueDes;
          break;
        case r'commissionBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.commissionBp = valueDes;
          break;
        case r'balance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.balance = valueDes;
          break;
        case r'lastOrderAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.lastOrderAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantListDtoOutputRestaurantsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantListDtoOutputRestaurantsInnerBuilder();
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

class AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  draft = _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  test = _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  active =
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  suspended =
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  terminated =
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_terminated;

  static Serializer<
    AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  >
  get serializer =>
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumSerializer;

  const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum>
  get values =>
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumValues;
  static AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum valueOf(
    String name,
  ) => _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumValueOf(
    name,
  );
}

/// The operating state in test mode or active; null otherwise.
class AdminRestaurantListDtoOutputRestaurantsInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum open =
      _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_open;
  @BuiltValueEnumConst(wireName: r'busy')
  static const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum busy =
      _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_busy;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum paused =
      _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum closed =
      _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_closed;

  static Serializer<AdminRestaurantListDtoOutputRestaurantsInnerStateEnum>
  get serializer =>
      _$adminRestaurantListDtoOutputRestaurantsInnerStateEnumSerializer;

  const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantListDtoOutputRestaurantsInnerStateEnum>
  get values => _$adminRestaurantListDtoOutputRestaurantsInnerStateEnumValues;
  static AdminRestaurantListDtoOutputRestaurantsInnerStateEnum valueOf(
    String name,
  ) => _$adminRestaurantListDtoOutputRestaurantsInnerStateEnumValueOf(name);
}
