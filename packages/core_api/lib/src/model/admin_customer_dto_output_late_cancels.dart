//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_late_cancels.g.dart';

/// AdminCustomerDtoOutputLateCancels
///
/// Properties:
/// * [inWindow]
/// * [total]
/// * [limit]
/// * [windowDays]
@BuiltValue()
abstract class AdminCustomerDtoOutputLateCancels
    implements
        Built<
          AdminCustomerDtoOutputLateCancels,
          AdminCustomerDtoOutputLateCancelsBuilder
        > {
  @BuiltValueField(wireName: r'inWindow')
  int get inWindow;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'limit')
  int get limit;

  @BuiltValueField(wireName: r'windowDays')
  int get windowDays;

  AdminCustomerDtoOutputLateCancels._();

  factory AdminCustomerDtoOutputLateCancels([
    void updates(AdminCustomerDtoOutputLateCancelsBuilder b),
  ]) = _$AdminCustomerDtoOutputLateCancels;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputLateCancelsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputLateCancels> get serializer =>
      _$AdminCustomerDtoOutputLateCancelsSerializer();
}

class _$AdminCustomerDtoOutputLateCancelsSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputLateCancels> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputLateCancels,
    _$AdminCustomerDtoOutputLateCancels,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputLateCancels';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputLateCancels object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inWindow';
    yield serializers.serialize(
      object.inWindow,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
    yield r'windowDays';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputLateCancels object, {
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
    required AdminCustomerDtoOutputLateCancelsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inWindow':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.inWindow = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.total = valueDes;
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.limit = valueDes;
          break;
        case r'windowDays':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.windowDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputLateCancels deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputLateCancelsBuilder();
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
