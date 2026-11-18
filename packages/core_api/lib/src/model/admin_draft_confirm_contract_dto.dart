//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_confirm_contract_dto.g.dart';

/// AdminDraftConfirmContractDto
///
/// Properties:
/// * [parityPledge] - The price-parity pledge: in-app prices at most the in-store ones.
@BuiltValue()
abstract class AdminDraftConfirmContractDto
    implements
        Built<
          AdminDraftConfirmContractDto,
          AdminDraftConfirmContractDtoBuilder
        > {
  /// The price-parity pledge: in-app prices at most the in-store ones.
  @BuiltValueField(wireName: r'parityPledge')
  AdminDraftConfirmContractDtoParityPledgeEnum get parityPledge;
  // enum parityPledgeEnum {  true,  };

  AdminDraftConfirmContractDto._();

  factory AdminDraftConfirmContractDto([
    void updates(AdminDraftConfirmContractDtoBuilder b),
  ]) = _$AdminDraftConfirmContractDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftConfirmContractDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftConfirmContractDto> get serializer =>
      _$AdminDraftConfirmContractDtoSerializer();
}

class _$AdminDraftConfirmContractDtoSerializer
    implements PrimitiveSerializer<AdminDraftConfirmContractDto> {
  @override
  final Iterable<Type> types = const [
    AdminDraftConfirmContractDto,
    _$AdminDraftConfirmContractDto,
  ];

  @override
  final String wireName = r'AdminDraftConfirmContractDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftConfirmContractDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'parityPledge';
    yield serializers.serialize(
      object.parityPledge,
      specifiedType: const FullType(
        AdminDraftConfirmContractDtoParityPledgeEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftConfirmContractDto object, {
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
    required AdminDraftConfirmContractDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'parityPledge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDraftConfirmContractDtoParityPledgeEnum,
                    ),
                  )
                  as AdminDraftConfirmContractDtoParityPledgeEnum;
          result.parityPledge = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftConfirmContractDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftConfirmContractDtoBuilder();
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

/// The price-parity pledge: in-app prices at most the in-store ones.
class AdminDraftConfirmContractDtoParityPledgeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const AdminDraftConfirmContractDtoParityPledgeEnum true_ =
      _$adminDraftConfirmContractDtoParityPledgeEnum_true_;

  static Serializer<AdminDraftConfirmContractDtoParityPledgeEnum>
  get serializer => _$adminDraftConfirmContractDtoParityPledgeEnumSerializer;

  const AdminDraftConfirmContractDtoParityPledgeEnum._(String name)
    : super(name);

  static BuiltSet<AdminDraftConfirmContractDtoParityPledgeEnum> get values =>
      _$adminDraftConfirmContractDtoParityPledgeEnumValues;
  static AdminDraftConfirmContractDtoParityPledgeEnum valueOf(String name) =>
      _$adminDraftConfirmContractDtoParityPledgeEnumValueOf(name);
}
