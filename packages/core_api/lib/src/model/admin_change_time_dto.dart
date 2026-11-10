//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_time_dto.g.dart';

/// AdminChangeTimeDto
///
/// Properties:
/// * [addMin] - Whole minutes added, from 1 to order.eta_change_max_min (owner decision 2026-11-10); 400 invalid_time_change otherwise.
/// * [reason] - Operations' optional note (AP §9.3.2).
@BuiltValue()
abstract class AdminChangeTimeDto
    implements Built<AdminChangeTimeDto, AdminChangeTimeDtoBuilder> {
  /// Whole minutes added, from 1 to order.eta_change_max_min (owner decision 2026-11-10); 400 invalid_time_change otherwise.
  @BuiltValueField(wireName: r'addMin')
  int get addMin;

  /// Operations' optional note (AP §9.3.2).
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminChangeTimeDto._();

  factory AdminChangeTimeDto([void updates(AdminChangeTimeDtoBuilder b)]) =
      _$AdminChangeTimeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeTimeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeTimeDto> get serializer =>
      _$AdminChangeTimeDtoSerializer();
}

class _$AdminChangeTimeDtoSerializer
    implements PrimitiveSerializer<AdminChangeTimeDto> {
  @override
  final Iterable<Type> types = const [AdminChangeTimeDto, _$AdminChangeTimeDto];

  @override
  final String wireName = r'AdminChangeTimeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeTimeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'addMin';
    yield serializers.serialize(
      object.addMin,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeTimeDto object, {
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
    required AdminChangeTimeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'addMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.addMin = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  AdminChangeTimeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeTimeDtoBuilder();
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
