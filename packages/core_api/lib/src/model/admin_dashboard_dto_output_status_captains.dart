//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_status_captains.g.dart';

/// AdminDashboardDtoOutputStatusCaptains
///
/// Properties:
/// * [online]
/// * [available]
/// * [busy]
/// * [cashBlocked]
@BuiltValue()
abstract class AdminDashboardDtoOutputStatusCaptains
    implements
        Built<
          AdminDashboardDtoOutputStatusCaptains,
          AdminDashboardDtoOutputStatusCaptainsBuilder
        > {
  @BuiltValueField(wireName: r'online')
  int get online;

  @BuiltValueField(wireName: r'available')
  int get available;

  @BuiltValueField(wireName: r'busy')
  int get busy;

  @BuiltValueField(wireName: r'cashBlocked')
  int get cashBlocked;

  AdminDashboardDtoOutputStatusCaptains._();

  factory AdminDashboardDtoOutputStatusCaptains([
    void updates(AdminDashboardDtoOutputStatusCaptainsBuilder b),
  ]) = _$AdminDashboardDtoOutputStatusCaptains;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputStatusCaptainsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputStatusCaptains> get serializer =>
      _$AdminDashboardDtoOutputStatusCaptainsSerializer();
}

class _$AdminDashboardDtoOutputStatusCaptainsSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputStatusCaptains> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputStatusCaptains,
    _$AdminDashboardDtoOutputStatusCaptains,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputStatusCaptains';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputStatusCaptains object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'online';
    yield serializers.serialize(
      object.online,
      specifiedType: const FullType(int),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(int),
    );
    yield r'busy';
    yield serializers.serialize(
      object.busy,
      specifiedType: const FullType(int),
    );
    yield r'cashBlocked';
    yield serializers.serialize(
      object.cashBlocked,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputStatusCaptains object, {
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
    required AdminDashboardDtoOutputStatusCaptainsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'online':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.online = valueDes;
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.available = valueDes;
          break;
        case r'busy':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.busy = valueDes;
          break;
        case r'cashBlocked':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.cashBlocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputStatusCaptains deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputStatusCaptainsBuilder();
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
