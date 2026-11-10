//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_preview_answer_dto_output_entries_inner_party.g.dart';

/// AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty
///
/// Properties:
/// * [kind]
/// * [id]
/// * [name]
@BuiltValue()
abstract class AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty
    implements
        Built<
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty,
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum get kind;
  // enum kindEnum {  merchant,  captain,  customer,  platform,  };

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty._();

  factory AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty([
    void updates(AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder b),
  ]) = _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty>
  get serializer =>
      _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartySerializer();
}

class _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartySerializer
    implements
        PrimitiveSerializer<
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty
        > {
  @override
  final Iterable<Type> types = const [
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty,
    _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty,
  ];

  @override
  final String wireName =
      r'AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
      ),
    );
    yield r'id';
    yield object.id == null
        ? null
        : serializers.serialize(
            object.id,
            specifiedType: const FullType.nullable(String),
          );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty object, {
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
    required AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
                    ),
                  )
                  as AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum;
          result.kind = valueDes;
          break;
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder();
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

class AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  merchant =
      _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  captain =
      _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  customer =
      _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  platform =
      _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform;

  static Serializer<AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
  get serializer =>
      _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer;

  const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
  get values =>
      _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumValues;
  static AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum valueOf(
    String name,
  ) => _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumValueOf(
    name,
  );
}
