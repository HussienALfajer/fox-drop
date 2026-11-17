//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_redeliveries_inner.g.dart';

/// AdminTicketPageDtoOutputRedeliveriesInner
///
/// Properties:
/// * [orderId]
/// * [number]
/// * [status]
@BuiltValue()
abstract class AdminTicketPageDtoOutputRedeliveriesInner
    implements
        Built<
          AdminTicketPageDtoOutputRedeliveriesInner,
          AdminTicketPageDtoOutputRedeliveriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  String get status;

  AdminTicketPageDtoOutputRedeliveriesInner._();

  factory AdminTicketPageDtoOutputRedeliveriesInner([
    void updates(AdminTicketPageDtoOutputRedeliveriesInnerBuilder b),
  ]) = _$AdminTicketPageDtoOutputRedeliveriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputRedeliveriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputRedeliveriesInner> get serializer =>
      _$AdminTicketPageDtoOutputRedeliveriesInnerSerializer();
}

class _$AdminTicketPageDtoOutputRedeliveriesInnerSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputRedeliveriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputRedeliveriesInner,
    _$AdminTicketPageDtoOutputRedeliveriesInner,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputRedeliveriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputRedeliveriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputRedeliveriesInner object, {
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
    required AdminTicketPageDtoOutputRedeliveriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputRedeliveriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputRedeliveriesInnerBuilder();
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
