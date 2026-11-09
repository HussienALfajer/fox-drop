//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_acceptance.g.dart';

/// AdminOrderDtoOutputOrderAcceptance
///
/// Properties:
/// * [at]
/// * [prepMin]
/// * [prepDueAt]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderAcceptance
    implements
        Built<
          AdminOrderDtoOutputOrderAcceptance,
          AdminOrderDtoOutputOrderAcceptanceBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'prepMin')
  int get prepMin;

  @BuiltValueField(wireName: r'prepDueAt')
  DateTime get prepDueAt;

  AdminOrderDtoOutputOrderAcceptance._();

  factory AdminOrderDtoOutputOrderAcceptance([
    void updates(AdminOrderDtoOutputOrderAcceptanceBuilder b),
  ]) = _$AdminOrderDtoOutputOrderAcceptance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderAcceptanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderAcceptance> get serializer =>
      _$AdminOrderDtoOutputOrderAcceptanceSerializer();
}

class _$AdminOrderDtoOutputOrderAcceptanceSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderAcceptance> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderAcceptance,
    _$AdminOrderDtoOutputOrderAcceptance,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderAcceptance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'prepMin';
    yield serializers.serialize(
      object.prepMin,
      specifiedType: const FullType(int),
    );
    yield r'prepDueAt';
    yield serializers.serialize(
      object.prepDueAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderAcceptance object, {
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
    required AdminOrderDtoOutputOrderAcceptanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'prepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepMin = valueDes;
          break;
        case r'prepDueAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.prepDueAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderAcceptance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderAcceptanceBuilder();
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
