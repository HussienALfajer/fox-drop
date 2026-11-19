//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_contract_dto.g.dart';

/// AdminCaptainApplicationContractDto
///
/// Properties:
/// * [signedOn] - Not after today on the city's clock.
/// * [startsOn] - Not before the signing.
/// * [uploadIds] - The scan’s pages, from POST /v1/admin/uploads (captain_document).
@BuiltValue()
abstract class AdminCaptainApplicationContractDto
    implements
        Built<
          AdminCaptainApplicationContractDto,
          AdminCaptainApplicationContractDtoBuilder
        > {
  /// Not after today on the city's clock.
  @BuiltValueField(wireName: r'signedOn')
  Date get signedOn;

  /// Not before the signing.
  @BuiltValueField(wireName: r'startsOn')
  Date get startsOn;

  /// The scan’s pages, from POST /v1/admin/uploads (captain_document).
  @BuiltValueField(wireName: r'uploadIds')
  BuiltList<String> get uploadIds;

  AdminCaptainApplicationContractDto._();

  factory AdminCaptainApplicationContractDto([
    void updates(AdminCaptainApplicationContractDtoBuilder b),
  ]) = _$AdminCaptainApplicationContractDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationContractDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationContractDto> get serializer =>
      _$AdminCaptainApplicationContractDtoSerializer();
}

class _$AdminCaptainApplicationContractDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationContractDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationContractDto,
    _$AdminCaptainApplicationContractDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationContractDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationContractDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedOn';
    yield serializers.serialize(
      object.signedOn,
      specifiedType: const FullType(Date),
    );
    yield r'startsOn';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(Date),
    );
    yield r'uploadIds';
    yield serializers.serialize(
      object.uploadIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationContractDto object, {
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
    required AdminCaptainApplicationContractDtoBuilder result,
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
        case r'startsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.startsOn = valueDes;
          break;
        case r'uploadIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.uploadIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationContractDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationContractDtoBuilder();
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
