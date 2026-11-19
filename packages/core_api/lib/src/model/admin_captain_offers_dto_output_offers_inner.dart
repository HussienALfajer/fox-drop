//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_offers_dto_output_offers_inner.g.dart';

/// AdminCaptainOffersDtoOutputOffersInner
///
/// Properties:
/// * [id]
/// * [orderId]
/// * [orderNumber]
/// * [kind]
/// * [handover]
/// * [offeredAt]
/// * [status]
/// * [respondedAt]
/// * [responseSeconds] - From the offer to the response.
@BuiltValue()
abstract class AdminCaptainOffersDtoOutputOffersInner
    implements
        Built<
          AdminCaptainOffersDtoOutputOffersInner,
          AdminCaptainOffersDtoOutputOffersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  @BuiltValueField(wireName: r'kind')
  AdminCaptainOffersDtoOutputOffersInnerKindEnum get kind;
  // enum kindEnum {  manual,  auto,  };

  @BuiltValueField(wireName: r'handover')
  bool get handover;

  @BuiltValueField(wireName: r'offeredAt')
  DateTime get offeredAt;

  @BuiltValueField(wireName: r'status')
  AdminCaptainOffersDtoOutputOffersInnerStatusEnum get status;
  // enum statusEnum {  open,  accepted,  declined,  expired,  withdrawn,  };

  @BuiltValueField(wireName: r'respondedAt')
  DateTime? get respondedAt;

  /// From the offer to the response.
  @BuiltValueField(wireName: r'responseSeconds')
  int? get responseSeconds;

  AdminCaptainOffersDtoOutputOffersInner._();

  factory AdminCaptainOffersDtoOutputOffersInner([
    void updates(AdminCaptainOffersDtoOutputOffersInnerBuilder b),
  ]) = _$AdminCaptainOffersDtoOutputOffersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainOffersDtoOutputOffersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainOffersDtoOutputOffersInner> get serializer =>
      _$AdminCaptainOffersDtoOutputOffersInnerSerializer();
}

class _$AdminCaptainOffersDtoOutputOffersInnerSerializer
    implements PrimitiveSerializer<AdminCaptainOffersDtoOutputOffersInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainOffersDtoOutputOffersInner,
    _$AdminCaptainOffersDtoOutputOffersInner,
  ];

  @override
  final String wireName = r'AdminCaptainOffersDtoOutputOffersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainOffersDtoOutputOffersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCaptainOffersDtoOutputOffersInnerKindEnum,
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminCaptainOffersDtoOutputOffersInnerStatusEnum,
      ),
    );
    yield r'respondedAt';
    yield object.respondedAt == null
        ? null
        : serializers.serialize(
            object.respondedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'responseSeconds';
    yield object.responseSeconds == null
        ? null
        : serializers.serialize(
            object.responseSeconds,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainOffersDtoOutputOffersInner object, {
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
    required AdminCaptainOffersDtoOutputOffersInnerBuilder result,
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
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainOffersDtoOutputOffersInnerKindEnum,
                    ),
                  )
                  as AdminCaptainOffersDtoOutputOffersInnerKindEnum;
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainOffersDtoOutputOffersInnerStatusEnum,
                    ),
                  )
                  as AdminCaptainOffersDtoOutputOffersInnerStatusEnum;
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
        case r'responseSeconds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.responseSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainOffersDtoOutputOffersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainOffersDtoOutputOffersInnerBuilder();
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

class AdminCaptainOffersDtoOutputOffersInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminCaptainOffersDtoOutputOffersInnerKindEnum manual =
      _$adminCaptainOffersDtoOutputOffersInnerKindEnum_manual;
  @BuiltValueEnumConst(wireName: r'auto')
  static const AdminCaptainOffersDtoOutputOffersInnerKindEnum auto =
      _$adminCaptainOffersDtoOutputOffersInnerKindEnum_auto;

  static Serializer<AdminCaptainOffersDtoOutputOffersInnerKindEnum>
  get serializer => _$adminCaptainOffersDtoOutputOffersInnerKindEnumSerializer;

  const AdminCaptainOffersDtoOutputOffersInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainOffersDtoOutputOffersInnerKindEnum> get values =>
      _$adminCaptainOffersDtoOutputOffersInnerKindEnumValues;
  static AdminCaptainOffersDtoOutputOffersInnerKindEnum valueOf(String name) =>
      _$adminCaptainOffersDtoOutputOffersInnerKindEnumValueOf(name);
}

class AdminCaptainOffersDtoOutputOffersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const AdminCaptainOffersDtoOutputOffersInnerStatusEnum open =
      _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminCaptainOffersDtoOutputOffersInnerStatusEnum accepted =
      _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const AdminCaptainOffersDtoOutputOffersInnerStatusEnum declined =
      _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminCaptainOffersDtoOutputOffersInnerStatusEnum expired =
      _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'withdrawn')
  static const AdminCaptainOffersDtoOutputOffersInnerStatusEnum withdrawn =
      _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_withdrawn;

  static Serializer<AdminCaptainOffersDtoOutputOffersInnerStatusEnum>
  get serializer =>
      _$adminCaptainOffersDtoOutputOffersInnerStatusEnumSerializer;

  const AdminCaptainOffersDtoOutputOffersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainOffersDtoOutputOffersInnerStatusEnum>
  get values => _$adminCaptainOffersDtoOutputOffersInnerStatusEnumValues;
  static AdminCaptainOffersDtoOutputOffersInnerStatusEnum valueOf(
    String name,
  ) => _$adminCaptainOffersDtoOutputOffersInnerStatusEnumValueOf(name);
}
