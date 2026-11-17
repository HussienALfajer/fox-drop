//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_block_customer_dto.g.dart';

/// AdminBlockCustomerDto
///
/// Properties:
/// * [cityId]
/// * [kind] - «لمدة» until a moment, «حتى إشعار آخر», or «حتى دفع مستحق» of an amount.
/// * [until] - The duration kind: when the block ends.
/// * [amount] - The dues kind: the amount in minor units of the city's base.
/// * [reason] - A code of Content's customer_block list (AP Appendix B).
/// * [note] - The internal reason (AP §9.8: required).
@BuiltValue()
abstract class AdminBlockCustomerDto
    implements Built<AdminBlockCustomerDto, AdminBlockCustomerDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// «لمدة» until a moment, «حتى إشعار آخر», or «حتى دفع مستحق» of an amount.
  @BuiltValueField(wireName: r'kind')
  AdminBlockCustomerDtoKindEnum get kind;
  // enum kindEnum {  until,  indefinite,  dues,  };

  /// The duration kind: when the block ends.
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  /// The dues kind: the amount in minor units of the city's base.
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  /// A code of Content's customer_block list (AP Appendix B).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The internal reason (AP §9.8: required).
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminBlockCustomerDto._();

  factory AdminBlockCustomerDto([
    void updates(AdminBlockCustomerDtoBuilder b),
  ]) = _$AdminBlockCustomerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBlockCustomerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBlockCustomerDto> get serializer =>
      _$AdminBlockCustomerDtoSerializer();
}

class _$AdminBlockCustomerDtoSerializer
    implements PrimitiveSerializer<AdminBlockCustomerDto> {
  @override
  final Iterable<Type> types = const [
    AdminBlockCustomerDto,
    _$AdminBlockCustomerDto,
  ];

  @override
  final String wireName = r'AdminBlockCustomerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBlockCustomerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminBlockCustomerDtoKindEnum),
    );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBlockCustomerDto object, {
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
    required AdminBlockCustomerDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminBlockCustomerDtoKindEnum,
                    ),
                  )
                  as AdminBlockCustomerDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBlockCustomerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBlockCustomerDtoBuilder();
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

/// «لمدة» until a moment, «حتى إشعار آخر», or «حتى دفع مستحق» of an amount.
class AdminBlockCustomerDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'until')
  static const AdminBlockCustomerDtoKindEnum until =
      _$adminBlockCustomerDtoKindEnum_until;
  @BuiltValueEnumConst(wireName: r'indefinite')
  static const AdminBlockCustomerDtoKindEnum indefinite =
      _$adminBlockCustomerDtoKindEnum_indefinite;
  @BuiltValueEnumConst(wireName: r'dues')
  static const AdminBlockCustomerDtoKindEnum dues =
      _$adminBlockCustomerDtoKindEnum_dues;

  static Serializer<AdminBlockCustomerDtoKindEnum> get serializer =>
      _$adminBlockCustomerDtoKindEnumSerializer;

  const AdminBlockCustomerDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminBlockCustomerDtoKindEnum> get values =>
      _$adminBlockCustomerDtoKindEnumValues;
  static AdminBlockCustomerDtoKindEnum valueOf(String name) =>
      _$adminBlockCustomerDtoKindEnumValueOf(name);
}
