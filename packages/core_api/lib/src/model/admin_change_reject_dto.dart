//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_reject_dto.g.dart';

/// AdminChangeRejectDto
///
/// Properties:
/// * [reason] - Required; the restaurant sees it.
@BuiltValue()
abstract class AdminChangeRejectDto
    implements Built<AdminChangeRejectDto, AdminChangeRejectDtoBuilder> {
  /// Required; the restaurant sees it.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminChangeRejectDto._();

  factory AdminChangeRejectDto([void updates(AdminChangeRejectDtoBuilder b)]) =
      _$AdminChangeRejectDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeRejectDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeRejectDto> get serializer =>
      _$AdminChangeRejectDtoSerializer();
}

class _$AdminChangeRejectDtoSerializer
    implements PrimitiveSerializer<AdminChangeRejectDto> {
  @override
  final Iterable<Type> types = const [
    AdminChangeRejectDto,
    _$AdminChangeRejectDto,
  ];

  @override
  final String wireName = r'AdminChangeRejectDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeRejectDto object, {
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
    AdminChangeRejectDto object, {
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
    required AdminChangeRejectDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  AdminChangeRejectDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeRejectDtoBuilder();
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
