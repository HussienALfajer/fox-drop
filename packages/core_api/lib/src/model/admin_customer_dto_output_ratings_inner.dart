//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_ratings_inner_reasons_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_ratings_inner.g.dart';

/// AdminCustomerDtoOutputRatingsInner
///
/// Properties:
/// * [orderId]
/// * [orderNumber]
/// * [party]
/// * [restaurantName]
/// * [captainName] - The captain rated; null on the restaurant's part.
/// * [stars]
/// * [reasons]
/// * [comment]
/// * [at]
@BuiltValue()
abstract class AdminCustomerDtoOutputRatingsInner
    implements
        Built<
          AdminCustomerDtoOutputRatingsInner,
          AdminCustomerDtoOutputRatingsInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String get orderNumber;

  @BuiltValueField(wireName: r'party')
  AdminCustomerDtoOutputRatingsInnerPartyEnum get party;
  // enum partyEnum {  restaurant,  captain,  };

  @BuiltValueField(wireName: r'restaurantName')
  String? get restaurantName;

  /// The captain rated; null on the restaurant's part.
  @BuiltValueField(wireName: r'captainName')
  String? get captainName;

  @BuiltValueField(wireName: r'stars')
  int get stars;

  @BuiltValueField(wireName: r'reasons')
  BuiltList<AdminCustomerDtoOutputRatingsInnerReasonsInner?> get reasons;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminCustomerDtoOutputRatingsInner._();

  factory AdminCustomerDtoOutputRatingsInner([
    void updates(AdminCustomerDtoOutputRatingsInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputRatingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputRatingsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputRatingsInner> get serializer =>
      _$AdminCustomerDtoOutputRatingsInnerSerializer();
}

class _$AdminCustomerDtoOutputRatingsInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputRatingsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputRatingsInner,
    _$AdminCustomerDtoOutputRatingsInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputRatingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputRatingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield serializers.serialize(
      object.orderNumber,
      specifiedType: const FullType(String),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(
        AdminCustomerDtoOutputRatingsInnerPartyEnum,
      ),
    );
    yield r'restaurantName';
    yield object.restaurantName == null
        ? null
        : serializers.serialize(
            object.restaurantName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'captainName';
    yield object.captainName == null
        ? null
        : serializers.serialize(
            object.captainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminCustomerDtoOutputRatingsInnerReasonsInner),
      ]),
    );
    yield r'comment';
    yield object.comment == null
        ? null
        : serializers.serialize(
            object.comment,
            specifiedType: const FullType.nullable(String),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputRatingsInner object, {
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
    required AdminCustomerDtoOutputRatingsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderNumber = valueDes;
          break;
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputRatingsInnerPartyEnum,
                    ),
                  )
                  as AdminCustomerDtoOutputRatingsInnerPartyEnum;
          result.party = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantName = valueDes;
          break;
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainName = valueDes;
          break;
        case r'stars':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.stars = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminCustomerDtoOutputRatingsInnerReasonsInner,
                      ),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputRatingsInnerReasonsInner?>;
          result.reasons.replace(valueDes);
          break;
        case r'comment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputRatingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputRatingsInnerBuilder();
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

class AdminCustomerDtoOutputRatingsInnerPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminCustomerDtoOutputRatingsInnerPartyEnum restaurant =
      _$adminCustomerDtoOutputRatingsInnerPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCustomerDtoOutputRatingsInnerPartyEnum captain =
      _$adminCustomerDtoOutputRatingsInnerPartyEnum_captain;

  static Serializer<AdminCustomerDtoOutputRatingsInnerPartyEnum>
  get serializer => _$adminCustomerDtoOutputRatingsInnerPartyEnumSerializer;

  const AdminCustomerDtoOutputRatingsInnerPartyEnum._(String name)
    : super(name);

  static BuiltSet<AdminCustomerDtoOutputRatingsInnerPartyEnum> get values =>
      _$adminCustomerDtoOutputRatingsInnerPartyEnumValues;
  static AdminCustomerDtoOutputRatingsInnerPartyEnum valueOf(String name) =>
      _$adminCustomerDtoOutputRatingsInnerPartyEnumValueOf(name);
}
