//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_arrival_dto.g.dart';

/// AdminRecordArrivalDto
///
/// Properties:
/// * [reason] - Required (AP §9.3.2).
@BuiltValue()
abstract class AdminRecordArrivalDto implements Built<AdminRecordArrivalDto, AdminRecordArrivalDtoBuilder> {
  /// Required (AP §9.3.2).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRecordArrivalDto._();

  factory AdminRecordArrivalDto([void updates(AdminRecordArrivalDtoBuilder b)]) = _$AdminRecordArrivalDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordArrivalDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordArrivalDto> get serializer => _$AdminRecordArrivalDtoSerializer();
}

class _$AdminRecordArrivalDtoSerializer implements PrimitiveSerializer<AdminRecordArrivalDto> {
  @override
  final Iterable<Type> types = const [AdminRecordArrivalDto, _$AdminRecordArrivalDto];

  @override
  final String wireName = r'AdminRecordArrivalDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordArrivalDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordArrivalDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRecordArrivalDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AdminRecordArrivalDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordArrivalDtoBuilder();
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


