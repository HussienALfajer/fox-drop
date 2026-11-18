//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_contract_dto.g.dart';

/// AdminDraftContractDto
///
/// Properties:
/// * [signedOn]
/// * [durationMonths]
/// * [contractUploadId] - An upload of restaurant_contract to replace the scan; null keeps it.
/// * [licenceUploadId] - An upload of restaurant_licence to replace the scan; null keeps it.
@BuiltValue()
abstract class AdminDraftContractDto
    implements Built<AdminDraftContractDto, AdminDraftContractDtoBuilder> {
  @BuiltValueField(wireName: r'signedOn')
  Date get signedOn;

  @BuiltValueField(wireName: r'durationMonths')
  int get durationMonths;

  /// An upload of restaurant_contract to replace the scan; null keeps it.
  @BuiltValueField(wireName: r'contractUploadId')
  String? get contractUploadId;

  /// An upload of restaurant_licence to replace the scan; null keeps it.
  @BuiltValueField(wireName: r'licenceUploadId')
  String? get licenceUploadId;

  AdminDraftContractDto._();

  factory AdminDraftContractDto([
    void updates(AdminDraftContractDtoBuilder b),
  ]) = _$AdminDraftContractDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftContractDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftContractDto> get serializer =>
      _$AdminDraftContractDtoSerializer();
}

class _$AdminDraftContractDtoSerializer
    implements PrimitiveSerializer<AdminDraftContractDto> {
  @override
  final Iterable<Type> types = const [
    AdminDraftContractDto,
    _$AdminDraftContractDto,
  ];

  @override
  final String wireName = r'AdminDraftContractDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftContractDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedOn';
    yield serializers.serialize(
      object.signedOn,
      specifiedType: const FullType(Date),
    );
    yield r'durationMonths';
    yield serializers.serialize(
      object.durationMonths,
      specifiedType: const FullType(int),
    );
    yield r'contractUploadId';
    yield object.contractUploadId == null
        ? null
        : serializers.serialize(
            object.contractUploadId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'licenceUploadId';
    yield object.licenceUploadId == null
        ? null
        : serializers.serialize(
            object.licenceUploadId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftContractDto object, {
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
    required AdminDraftContractDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.signedOn = valueDes;
          break;
        case r'durationMonths':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.durationMonths = valueDes;
          break;
        case r'contractUploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.contractUploadId = valueDes;
          break;
        case r'licenceUploadId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.licenceUploadId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftContractDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftContractDtoBuilder();
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
