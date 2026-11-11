//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_emergency_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_emergency.g.dart';

/// «طوارئ» (CA §9.11, slice 2.13c): the captain's open emergency, until the order leaves them or ends; «سحب وإعادة تعيين» and «تسليم لكابتن آخر» prefill «دون خطأ» while it is open (owner decision 2026-11-11). Null without one.
///
/// Properties:
/// * [captainId]
/// * [location]
/// * [at]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderEmergency
    implements
        Built<
          AdminOrderDtoOutputOrderEmergency,
          AdminOrderDtoOutputOrderEmergencyBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'location')
  AdminOrderDtoOutputOrderEmergencyLocation? get location;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminOrderDtoOutputOrderEmergency._();

  factory AdminOrderDtoOutputOrderEmergency([
    void updates(AdminOrderDtoOutputOrderEmergencyBuilder b),
  ]) = _$AdminOrderDtoOutputOrderEmergency;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderEmergencyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderEmergency> get serializer =>
      _$AdminOrderDtoOutputOrderEmergencySerializer();
}

class _$AdminOrderDtoOutputOrderEmergencySerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderEmergency> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderEmergency,
    _$AdminOrderDtoOutputOrderEmergency,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderEmergency';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderEmergency object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield object.location == null
        ? null
        : serializers.serialize(
            object.location,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderEmergencyLocation,
            ),
          );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderEmergency object, {
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
    required AdminOrderDtoOutputOrderEmergencyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderEmergencyLocation,
                    ),
                  )
                  as AdminOrderDtoOutputOrderEmergencyLocation?;
          if (valueDes == null) continue;
          result.location.replace(valueDes);
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderEmergency deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderEmergencyBuilder();
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
