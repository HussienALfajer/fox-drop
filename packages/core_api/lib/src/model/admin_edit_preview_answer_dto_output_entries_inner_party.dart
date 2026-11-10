//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_preview_answer_dto_output_entries_inner_party.g.dart';

/// AdminEditPreviewAnswerDtoOutputEntriesInnerParty
///
/// Properties:
/// * [kind]
/// * [id]
/// * [name]
@BuiltValue()
abstract class AdminEditPreviewAnswerDtoOutputEntriesInnerParty
    implements
        Built<
          AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
          AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum get kind;
  // enum kindEnum {  merchant,  captain,  platform,  };

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  AdminEditPreviewAnswerDtoOutputEntriesInnerParty._();

  factory AdminEditPreviewAnswerDtoOutputEntriesInnerParty([
    void updates(AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder b),
  ]) = _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditPreviewAnswerDtoOutputEntriesInnerParty>
  get serializer =>
      _$AdminEditPreviewAnswerDtoOutputEntriesInnerPartySerializer();
}

class _$AdminEditPreviewAnswerDtoOutputEntriesInnerPartySerializer
    implements
        PrimitiveSerializer<AdminEditPreviewAnswerDtoOutputEntriesInnerParty> {
  @override
  final Iterable<Type> types = const [
    AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
    _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
  ];

  @override
  final String wireName = r'AdminEditPreviewAnswerDtoOutputEntriesInnerParty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputEntriesInnerParty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
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
    AdminEditPreviewAnswerDtoOutputEntriesInnerParty object, {
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
    required AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder result,
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
                      AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
                    ),
                  )
                  as AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum;
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
  AdminEditPreviewAnswerDtoOutputEntriesInnerParty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder();
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

class AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  merchant =
      _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  captain = _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  platform =
      _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform;

  static Serializer<AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
  get serializer =>
      _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer;

  const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
  get values =>
      _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValues;
  static AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum valueOf(
    String name,
  ) => _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValueOf(name);
}
