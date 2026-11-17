//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_dto_output_parties_inner.g.dart';

/// AdminCostReportDtoOutputPartiesInner
///
/// Properties:
/// * [party] - Who operations named responsible; null where nobody was named.
/// * [orders]
/// * [amount]
@BuiltValue()
abstract class AdminCostReportDtoOutputPartiesInner
    implements
        Built<
          AdminCostReportDtoOutputPartiesInner,
          AdminCostReportDtoOutputPartiesInnerBuilder
        > {
  /// Who operations named responsible; null where nobody was named.
  @BuiltValueField(wireName: r'party')
  AdminCostReportDtoOutputPartiesInnerPartyEnum? get party;
  // enum partyEnum {  restaurant,  captain,  customer,  platform,  };

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminCostReportDtoOutputPartiesInner._();

  factory AdminCostReportDtoOutputPartiesInner([
    void updates(AdminCostReportDtoOutputPartiesInnerBuilder b),
  ]) = _$AdminCostReportDtoOutputPartiesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCostReportDtoOutputPartiesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportDtoOutputPartiesInner> get serializer =>
      _$AdminCostReportDtoOutputPartiesInnerSerializer();
}

class _$AdminCostReportDtoOutputPartiesInnerSerializer
    implements PrimitiveSerializer<AdminCostReportDtoOutputPartiesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportDtoOutputPartiesInner,
    _$AdminCostReportDtoOutputPartiesInner,
  ];

  @override
  final String wireName = r'AdminCostReportDtoOutputPartiesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportDtoOutputPartiesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'party';
    yield object.party == null
        ? null
        : serializers.serialize(
            object.party,
            specifiedType: const FullType.nullable(
              AdminCostReportDtoOutputPartiesInnerPartyEnum,
            ),
          );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportDtoOutputPartiesInner object, {
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
    required AdminCostReportDtoOutputPartiesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCostReportDtoOutputPartiesInnerPartyEnum,
                    ),
                  )
                  as AdminCostReportDtoOutputPartiesInnerPartyEnum?;
          if (valueDes == null) continue;
          result.party = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCostReportDtoOutputPartiesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportDtoOutputPartiesInnerBuilder();
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

/// Who operations named responsible; null where nobody was named.
class AdminCostReportDtoOutputPartiesInnerPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminCostReportDtoOutputPartiesInnerPartyEnum restaurant =
      _$adminCostReportDtoOutputPartiesInnerPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCostReportDtoOutputPartiesInnerPartyEnum captain =
      _$adminCostReportDtoOutputPartiesInnerPartyEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminCostReportDtoOutputPartiesInnerPartyEnum customer =
      _$adminCostReportDtoOutputPartiesInnerPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminCostReportDtoOutputPartiesInnerPartyEnum platform =
      _$adminCostReportDtoOutputPartiesInnerPartyEnum_platform;

  static Serializer<AdminCostReportDtoOutputPartiesInnerPartyEnum>
  get serializer => _$adminCostReportDtoOutputPartiesInnerPartyEnumSerializer;

  const AdminCostReportDtoOutputPartiesInnerPartyEnum._(String name)
    : super(name);

  static BuiltSet<AdminCostReportDtoOutputPartiesInnerPartyEnum> get values =>
      _$adminCostReportDtoOutputPartiesInnerPartyEnumValues;
  static AdminCostReportDtoOutputPartiesInnerPartyEnum valueOf(String name) =>
      _$adminCostReportDtoOutputPartiesInnerPartyEnumValueOf(name);
}
