//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_emergency_stop_dto_output.g.dart';

/// CustomerEmergencyStopDtoOutput
///
/// Properties:
/// * [active]
/// * [startedAt]
/// * [browseMessage] - The banner while browsing (CU §4.7).
/// * [delayNotice] - The banner on an active order (CU §11.6), its reason filled in.
@BuiltValue()
abstract class CustomerEmergencyStopDtoOutput
    implements
        Built<
          CustomerEmergencyStopDtoOutput,
          CustomerEmergencyStopDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'active')
  bool get active;

  @BuiltValueField(wireName: r'startedAt')
  DateTime? get startedAt;

  /// The banner while browsing (CU §4.7).
  @BuiltValueField(wireName: r'browseMessage')
  String? get browseMessage;

  /// The banner on an active order (CU §11.6), its reason filled in.
  @BuiltValueField(wireName: r'delayNotice')
  String? get delayNotice;

  CustomerEmergencyStopDtoOutput._();

  factory CustomerEmergencyStopDtoOutput([
    void updates(CustomerEmergencyStopDtoOutputBuilder b),
  ]) = _$CustomerEmergencyStopDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerEmergencyStopDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerEmergencyStopDtoOutput> get serializer =>
      _$CustomerEmergencyStopDtoOutputSerializer();
}

class _$CustomerEmergencyStopDtoOutputSerializer
    implements PrimitiveSerializer<CustomerEmergencyStopDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerEmergencyStopDtoOutput,
    _$CustomerEmergencyStopDtoOutput,
  ];

  @override
  final String wireName = r'CustomerEmergencyStopDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerEmergencyStopDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    yield r'startedAt';
    yield object.startedAt == null
        ? null
        : serializers.serialize(
            object.startedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'browseMessage';
    yield object.browseMessage == null
        ? null
        : serializers.serialize(
            object.browseMessage,
            specifiedType: const FullType.nullable(String),
          );
    yield r'delayNotice';
    yield object.delayNotice == null
        ? null
        : serializers.serialize(
            object.delayNotice,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerEmergencyStopDtoOutput object, {
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
    required CustomerEmergencyStopDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        case r'startedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'browseMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.browseMessage = valueDes;
          break;
        case r'delayNotice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.delayNotice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerEmergencyStopDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerEmergencyStopDtoOutputBuilder();
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
