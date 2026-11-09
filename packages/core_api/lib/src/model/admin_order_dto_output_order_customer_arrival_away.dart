//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_customer_arrival_away.g.dart';

/// The reason given beyond captain.customer_radius_m (CA §9.6).
///
/// Properties:
/// * [reason]
/// * [label]
/// * [note]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCustomerArrivalAway
    implements
        Built<
          AdminOrderDtoOutputOrderCustomerArrivalAway,
          AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminOrderDtoOutputOrderCustomerArrivalAway._();

  factory AdminOrderDtoOutputOrderCustomerArrivalAway([
    void updates(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCustomerArrivalAway;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCustomerArrivalAway>
  get serializer => _$AdminOrderDtoOutputOrderCustomerArrivalAwaySerializer();
}

class _$AdminOrderDtoOutputOrderCustomerArrivalAwaySerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderCustomerArrivalAway> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCustomerArrivalAway,
    _$AdminOrderDtoOutputOrderCustomerArrivalAway,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCustomerArrivalAway';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerArrivalAway object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerArrivalAway object, {
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
    required AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder result,
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderCustomerArrivalAway deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCustomerArrivalAwayBuilder();
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
