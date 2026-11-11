//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_restaurant.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_offers_dto_output_offers_inner.g.dart';

/// AdminOrderOffersDtoOutputOffersInner
///
/// Properties:
/// * [id]
/// * [captain]
/// * [kind] - Operations’ («تعيين من العمليات») or the automatic dispatcher’s.
/// * [handover] - «استلام من كابتن» (AP §9.3.2, CA §9.10.1).
/// * [offeredAt]
/// * [expiresAt]
/// * [status] - The answer: accepted, declined, expired («انتهت المهلة»), withdrawn.
/// * [respondedAt]
/// * [responseSec] - Seconds to an acceptance or a decline; null otherwise.
@BuiltValue()
abstract class AdminOrderOffersDtoOutputOffersInner
    implements
        Built<
          AdminOrderOffersDtoOutputOffersInner,
          AdminOrderOffersDtoOutputOffersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'captain')
  AdminOrderCardDtoOutputOrderRestaurant get captain;

  /// Operations’ («تعيين من العمليات») or the automatic dispatcher’s.
  @BuiltValueField(wireName: r'kind')
  AdminOrderOffersDtoOutputOffersInnerKindEnum get kind;
  // enum kindEnum {  manual,  auto,  };

  /// «استلام من كابتن» (AP §9.3.2, CA §9.10.1).
  @BuiltValueField(wireName: r'handover')
  bool get handover;

  @BuiltValueField(wireName: r'offeredAt')
  DateTime get offeredAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  /// The answer: accepted, declined, expired («انتهت المهلة»), withdrawn.
  @BuiltValueField(wireName: r'status')
  AdminOrderOffersDtoOutputOffersInnerStatusEnum get status;
  // enum statusEnum {  open,  accepted,  declined,  expired,  withdrawn,  };

  @BuiltValueField(wireName: r'respondedAt')
  DateTime? get respondedAt;

  /// Seconds to an acceptance or a decline; null otherwise.
  @BuiltValueField(wireName: r'responseSec')
  int? get responseSec;

  AdminOrderOffersDtoOutputOffersInner._();

  factory AdminOrderOffersDtoOutputOffersInner([
    void updates(AdminOrderOffersDtoOutputOffersInnerBuilder b),
  ]) = _$AdminOrderOffersDtoOutputOffersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderOffersDtoOutputOffersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderOffersDtoOutputOffersInner> get serializer =>
      _$AdminOrderOffersDtoOutputOffersInnerSerializer();
}

class _$AdminOrderOffersDtoOutputOffersInnerSerializer
    implements PrimitiveSerializer<AdminOrderOffersDtoOutputOffersInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderOffersDtoOutputOffersInner,
    _$AdminOrderOffersDtoOutputOffersInner,
  ];

  @override
  final String wireName = r'AdminOrderOffersDtoOutputOffersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderOffersDtoOutputOffersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'captain';
    yield serializers.serialize(
      object.captain,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderRestaurant),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminOrderOffersDtoOutputOffersInnerKindEnum,
      ),
    );
    yield r'handover';
    yield serializers.serialize(
      object.handover,
      specifiedType: const FullType(bool),
    );
    yield r'offeredAt';
    yield serializers.serialize(
      object.offeredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOrderOffersDtoOutputOffersInnerStatusEnum,
      ),
    );
    yield r'respondedAt';
    yield object.respondedAt == null
        ? null
        : serializers.serialize(
            object.respondedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'responseSec';
    yield object.responseSec == null
        ? null
        : serializers.serialize(
            object.responseSec,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderOffersDtoOutputOffersInner object, {
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
    required AdminOrderOffersDtoOutputOffersInnerBuilder result,
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
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderRestaurant,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderRestaurant;
          result.captain.replace(valueDes);
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderOffersDtoOutputOffersInnerKindEnum,
                    ),
                  )
                  as AdminOrderOffersDtoOutputOffersInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'handover':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.handover = valueDes;
          break;
        case r'offeredAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.offeredAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderOffersDtoOutputOffersInnerStatusEnum,
                    ),
                  )
                  as AdminOrderOffersDtoOutputOffersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'respondedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.respondedAt = valueDes;
          break;
        case r'responseSec':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.responseSec = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderOffersDtoOutputOffersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderOffersDtoOutputOffersInnerBuilder();
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

/// Operations’ («تعيين من العمليات») or the automatic dispatcher’s.
class AdminOrderOffersDtoOutputOffersInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminOrderOffersDtoOutputOffersInnerKindEnum manual =
      _$adminOrderOffersDtoOutputOffersInnerKindEnum_manual;
  @BuiltValueEnumConst(wireName: r'auto')
  static const AdminOrderOffersDtoOutputOffersInnerKindEnum auto =
      _$adminOrderOffersDtoOutputOffersInnerKindEnum_auto;

  static Serializer<AdminOrderOffersDtoOutputOffersInnerKindEnum>
  get serializer => _$adminOrderOffersDtoOutputOffersInnerKindEnumSerializer;

  const AdminOrderOffersDtoOutputOffersInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderOffersDtoOutputOffersInnerKindEnum> get values =>
      _$adminOrderOffersDtoOutputOffersInnerKindEnumValues;
  static AdminOrderOffersDtoOutputOffersInnerKindEnum valueOf(String name) =>
      _$adminOrderOffersDtoOutputOffersInnerKindEnumValueOf(name);
}

/// The answer: accepted, declined, expired («انتهت المهلة»), withdrawn.
class AdminOrderOffersDtoOutputOffersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminOrderOffersDtoOutputOffersInnerStatusEnum open =
      _$adminOrderOffersDtoOutputOffersInnerStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderOffersDtoOutputOffersInnerStatusEnum accepted =
      _$adminOrderOffersDtoOutputOffersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const AdminOrderOffersDtoOutputOffersInnerStatusEnum declined =
      _$adminOrderOffersDtoOutputOffersInnerStatusEnum_declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminOrderOffersDtoOutputOffersInnerStatusEnum expired =
      _$adminOrderOffersDtoOutputOffersInnerStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'withdrawn')
  static const AdminOrderOffersDtoOutputOffersInnerStatusEnum withdrawn =
      _$adminOrderOffersDtoOutputOffersInnerStatusEnum_withdrawn;

  static Serializer<AdminOrderOffersDtoOutputOffersInnerStatusEnum>
  get serializer => _$adminOrderOffersDtoOutputOffersInnerStatusEnumSerializer;

  const AdminOrderOffersDtoOutputOffersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderOffersDtoOutputOffersInnerStatusEnum> get values =>
      _$adminOrderOffersDtoOutputOffersInnerStatusEnumValues;
  static AdminOrderOffersDtoOutputOffersInnerStatusEnum valueOf(String name) =>
      _$adminOrderOffersDtoOutputOffersInnerStatusEnumValueOf(name);
}
