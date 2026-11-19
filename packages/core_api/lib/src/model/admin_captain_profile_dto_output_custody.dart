//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_custody_closed_due.dart';
import 'package:core_api/src/model/admin_captain_profile_dto_output_custody_currencies_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_custody.g.dart';

/// AdminCaptainProfileDtoOutputCustody
///
/// Properties:
/// * [usage]
/// * [limit]
/// * [closedDue]
/// * [currencies]
/// * [blocks]
/// * [handInGraceUntil]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputCustody
    implements
        Built<
          AdminCaptainProfileDtoOutputCustody,
          AdminCaptainProfileDtoOutputCustodyBuilder
        > {
  @BuiltValueField(wireName: r'usage')
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? get usage;

  @BuiltValueField(wireName: r'limit')
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? get limit;

  @BuiltValueField(wireName: r'closedDue')
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? get closedDue;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminCaptainProfileDtoOutputCustodyCurrenciesInner> get currencies;

  @BuiltValueField(wireName: r'blocks')
  BuiltList<AdminCaptainProfileDtoOutputCustodyBlocksEnum> get blocks;
  // enum blocksEnum {  closed_due,  cash_limit,  };

  @BuiltValueField(wireName: r'handInGraceUntil')
  DateTime? get handInGraceUntil;

  AdminCaptainProfileDtoOutputCustody._();

  factory AdminCaptainProfileDtoOutputCustody([
    void updates(AdminCaptainProfileDtoOutputCustodyBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputCustody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputCustodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputCustody> get serializer =>
      _$AdminCaptainProfileDtoOutputCustodySerializer();
}

class _$AdminCaptainProfileDtoOutputCustodySerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputCustody> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputCustody,
    _$AdminCaptainProfileDtoOutputCustody,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputCustody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputCustody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usage';
    yield object.usage == null
        ? null
        : serializers.serialize(
            object.usage,
            specifiedType: const FullType.nullable(
              AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
            ),
          );
    yield r'limit';
    yield object.limit == null
        ? null
        : serializers.serialize(
            object.limit,
            specifiedType: const FullType.nullable(
              AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
            ),
          );
    yield r'closedDue';
    yield object.closedDue == null
        ? null
        : serializers.serialize(
            object.closedDue,
            specifiedType: const FullType.nullable(
              AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
            ),
          );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainProfileDtoOutputCustodyCurrenciesInner),
      ]),
    );
    yield r'blocks';
    yield serializers.serialize(
      object.blocks,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainProfileDtoOutputCustodyBlocksEnum),
      ]),
    );
    yield r'handInGraceUntil';
    yield object.handInGraceUntil == null
        ? null
        : serializers.serialize(
            object.handInGraceUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputCustody object, {
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
    required AdminCaptainProfileDtoOutputCustodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue?;
          if (valueDes == null) continue;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue?;
          if (valueDes == null) continue;
          result.limit.replace(valueDes);
          break;
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue?;
          if (valueDes == null) continue;
          result.closedDue.replace(valueDes);
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainProfileDtoOutputCustodyCurrenciesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainProfileDtoOutputCustodyCurrenciesInner
                  >;
          result.currencies.replace(valueDes);
          break;
        case r'blocks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainProfileDtoOutputCustodyBlocksEnum),
                    ]),
                  )
                  as BuiltList<AdminCaptainProfileDtoOutputCustodyBlocksEnum>;
          result.blocks.replace(valueDes);
          break;
        case r'handInGraceUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.handInGraceUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutputCustody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputCustodyBuilder();
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

class AdminCaptainProfileDtoOutputCustodyBlocksEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const AdminCaptainProfileDtoOutputCustodyBlocksEnum closedDue =
      _$adminCaptainProfileDtoOutputCustodyBlocksEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const AdminCaptainProfileDtoOutputCustodyBlocksEnum cashLimit =
      _$adminCaptainProfileDtoOutputCustodyBlocksEnum_cashLimit;

  static Serializer<AdminCaptainProfileDtoOutputCustodyBlocksEnum>
  get serializer => _$adminCaptainProfileDtoOutputCustodyBlocksEnumSerializer;

  const AdminCaptainProfileDtoOutputCustodyBlocksEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainProfileDtoOutputCustodyBlocksEnum> get values =>
      _$adminCaptainProfileDtoOutputCustodyBlocksEnumValues;
  static AdminCaptainProfileDtoOutputCustodyBlocksEnum valueOf(String name) =>
      _$adminCaptainProfileDtoOutputCustodyBlocksEnumValueOf(name);
}
