//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_actions_dto_output_next_commission.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_actions_dto_output_commission_history_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_actions_dto_output.g.dart';

/// AdminRestaurantActionsDtoOutput
///
/// Properties:
/// * [nameAr]
/// * [accountStatus]
/// * [suspensionReason] - The latest suspension’s, while suspended.
/// * [visible] - «إخفاء أو إظهار»: customers see an active restaurant only while visible.
/// * [sortWeight] - «تثبيت»: the higher first in the customers’ lists.
/// * [sortWeightMax]
/// * [commissionBp] - The commission in force now, in basis points.
/// * [nextCommission]
/// * [commissionHistory] - Every version not withdrawn, the latest start first (D16).
@BuiltValue()
abstract class AdminRestaurantActionsDtoOutput
    implements
        Built<
          AdminRestaurantActionsDtoOutput,
          AdminRestaurantActionsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'accountStatus')
  AdminRestaurantActionsDtoOutputAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// The latest suspension’s, while suspended.
  @BuiltValueField(wireName: r'suspensionReason')
  String? get suspensionReason;

  /// «إخفاء أو إظهار»: customers see an active restaurant only while visible.
  @BuiltValueField(wireName: r'visible')
  bool get visible;

  /// «تثبيت»: the higher first in the customers’ lists.
  @BuiltValueField(wireName: r'sortWeight')
  int get sortWeight;

  @BuiltValueField(wireName: r'sortWeightMax')
  int get sortWeightMax;

  /// The commission in force now, in basis points.
  @BuiltValueField(wireName: r'commissionBp')
  int? get commissionBp;

  @BuiltValueField(wireName: r'nextCommission')
  AdminRestaurantActionsDtoOutputNextCommission? get nextCommission;

  /// Every version not withdrawn, the latest start first (D16).
  @BuiltValueField(wireName: r'commissionHistory')
  BuiltList<AdminRestaurantActionsDtoOutputCommissionHistoryInner>
  get commissionHistory;

  AdminRestaurantActionsDtoOutput._();

  factory AdminRestaurantActionsDtoOutput([
    void updates(AdminRestaurantActionsDtoOutputBuilder b),
  ]) = _$AdminRestaurantActionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantActionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantActionsDtoOutput> get serializer =>
      _$AdminRestaurantActionsDtoOutputSerializer();
}

class _$AdminRestaurantActionsDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantActionsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantActionsDtoOutput,
    _$AdminRestaurantActionsDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantActionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantActionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(
        AdminRestaurantActionsDtoOutputAccountStatusEnum,
      ),
    );
    yield r'suspensionReason';
    yield object.suspensionReason == null
        ? null
        : serializers.serialize(
            object.suspensionReason,
            specifiedType: const FullType.nullable(String),
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
    yield r'sortWeightMax';
    yield serializers.serialize(
      object.sortWeightMax,
      specifiedType: const FullType(int),
    );
    yield r'commissionBp';
    yield object.commissionBp == null
        ? null
        : serializers.serialize(
            object.commissionBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'nextCommission';
    yield object.nextCommission == null
        ? null
        : serializers.serialize(
            object.nextCommission,
            specifiedType: const FullType.nullable(
              AdminRestaurantActionsDtoOutputNextCommission,
            ),
          );
    yield r'commissionHistory';
    yield serializers.serialize(
      object.commissionHistory,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantActionsDtoOutputCommissionHistoryInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantActionsDtoOutput object, {
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
    required AdminRestaurantActionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
                      AdminRestaurantActionsDtoOutputAccountStatusEnum,
                    ),
                  )
                  as AdminRestaurantActionsDtoOutputAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'suspensionReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.suspensionReason = valueDes;
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
        case r'sortWeightMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sortWeightMax = valueDes;
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
        case r'nextCommission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantActionsDtoOutputNextCommission,
                    ),
                  )
                  as AdminRestaurantActionsDtoOutputNextCommission?;
          if (valueDes == null) continue;
          result.nextCommission.replace(valueDes);
          break;
        case r'commissionHistory':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantActionsDtoOutputCommissionHistoryInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantActionsDtoOutputCommissionHistoryInner
                  >;
          result.commissionHistory.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantActionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantActionsDtoOutputBuilder();
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

class AdminRestaurantActionsDtoOutputAccountStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminRestaurantActionsDtoOutputAccountStatusEnum draft =
      _$adminRestaurantActionsDtoOutputAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminRestaurantActionsDtoOutputAccountStatusEnum test =
      _$adminRestaurantActionsDtoOutputAccountStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminRestaurantActionsDtoOutputAccountStatusEnum active =
      _$adminRestaurantActionsDtoOutputAccountStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminRestaurantActionsDtoOutputAccountStatusEnum suspended =
      _$adminRestaurantActionsDtoOutputAccountStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminRestaurantActionsDtoOutputAccountStatusEnum terminated =
      _$adminRestaurantActionsDtoOutputAccountStatusEnum_terminated;

  static Serializer<AdminRestaurantActionsDtoOutputAccountStatusEnum>
  get serializer =>
      _$adminRestaurantActionsDtoOutputAccountStatusEnumSerializer;

  const AdminRestaurantActionsDtoOutputAccountStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantActionsDtoOutputAccountStatusEnum>
  get values => _$adminRestaurantActionsDtoOutputAccountStatusEnumValues;
  static AdminRestaurantActionsDtoOutputAccountStatusEnum valueOf(
    String name,
  ) => _$adminRestaurantActionsDtoOutputAccountStatusEnumValueOf(name);
}
