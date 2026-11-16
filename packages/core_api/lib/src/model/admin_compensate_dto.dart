//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_compensate_dto_reason.dart';
import 'package:core_api/src/model/admin_compensate_dto_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_compensate_dto.g.dart';

/// AdminCompensateDto
///
/// Properties:
/// * [value]
/// * [reason]
@BuiltValue()
abstract class AdminCompensateDto
    implements Built<AdminCompensateDto, AdminCompensateDtoBuilder> {
  @BuiltValueField(wireName: r'value')
  AdminCompensateDtoValue get value;

  @BuiltValueField(wireName: r'reason')
  AdminCompensateDtoReason get reason;

  AdminCompensateDto._();

  factory AdminCompensateDto([void updates(AdminCompensateDtoBuilder b)]) =
      _$AdminCompensateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCompensateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCompensateDto> get serializer =>
      _$AdminCompensateDtoSerializer();
}

class _$AdminCompensateDtoSerializer
    implements PrimitiveSerializer<AdminCompensateDto> {
  @override
  final Iterable<Type> types = const [AdminCompensateDto, _$AdminCompensateDto];

  @override
  final String wireName = r'AdminCompensateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCompensateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(AdminCompensateDtoValue),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(AdminCompensateDtoReason),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensateDto object, {
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
    required AdminCompensateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminCompensateDtoValue),
                  )
                  as AdminCompensateDtoValue;
          result.value.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminCompensateDtoReason),
                  )
                  as AdminCompensateDtoReason;
          result.reason.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCompensateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCompensateDtoBuilder();
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
