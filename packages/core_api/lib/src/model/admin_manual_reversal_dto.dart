//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_reversal_dto.g.dart';

/// AdminManualReversalDto
///
/// Properties:
/// * [cityId]
/// * [journalId]
/// * [reason]
@BuiltValue()
abstract class AdminManualReversalDto
    implements Built<AdminManualReversalDto, AdminManualReversalDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'journalId')
  String get journalId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminManualReversalDto._();

  factory AdminManualReversalDto([
    void updates(AdminManualReversalDtoBuilder b),
  ]) = _$AdminManualReversalDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualReversalDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualReversalDto> get serializer =>
      _$AdminManualReversalDtoSerializer();
}

class _$AdminManualReversalDtoSerializer
    implements PrimitiveSerializer<AdminManualReversalDto> {
  @override
  final Iterable<Type> types = const [
    AdminManualReversalDto,
    _$AdminManualReversalDto,
  ];

  @override
  final String wireName = r'AdminManualReversalDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualReversalDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'journalId';
    yield serializers.serialize(
      object.journalId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualReversalDto object, {
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
    required AdminManualReversalDtoBuilder result,
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
        case r'journalId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.journalId = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualReversalDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualReversalDtoBuilder();
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
