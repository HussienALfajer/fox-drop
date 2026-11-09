//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_preview_answer_dto_output_entries_inner_party.g.dart';

/// AdminCancelPreviewAnswerDtoOutputEntriesInnerParty
///
/// Properties:
/// * [kind]
/// * [id]
/// * [name]
@BuiltValue()
abstract class AdminCancelPreviewAnswerDtoOutputEntriesInnerParty
    implements
        Built<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerParty,
          AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum get kind;
  // enum kindEnum {  merchant,  captain,  platform,  };

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  AdminCancelPreviewAnswerDtoOutputEntriesInnerParty._();

  factory AdminCancelPreviewAnswerDtoOutputEntriesInnerParty([
    void updates(AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder b),
  ]) = _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelPreviewAnswerDtoOutputEntriesInnerParty>
  get serializer =>
      _$AdminCancelPreviewAnswerDtoOutputEntriesInnerPartySerializer();
}

class _$AdminCancelPreviewAnswerDtoOutputEntriesInnerPartySerializer
    implements
        PrimitiveSerializer<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerParty
        > {
  @override
  final Iterable<Type> types = const [
    AdminCancelPreviewAnswerDtoOutputEntriesInnerParty,
    _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty,
  ];

  @override
  final String wireName = r'AdminCancelPreviewAnswerDtoOutputEntriesInnerParty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutputEntriesInnerParty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
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
    AdminCancelPreviewAnswerDtoOutputEntriesInnerParty object, {
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
    required AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder result,
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
                      AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
                    ),
                  )
                  as AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum;
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
  AdminCancelPreviewAnswerDtoOutputEntriesInnerParty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder();
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

class AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  merchant =
      _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  captain =
      _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
  platform =
      _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform;

  static Serializer<AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
  get serializer =>
      _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer;

  const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
  get values =>
      _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValues;
  static AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum valueOf(
    String name,
  ) =>
      _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValueOf(name);
}
