//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_tickets_inner.g.dart';

/// AdminCustomerDtoOutputTicketsInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [typeLabel]
/// * [status]
/// * [orderNumber]
/// * [openedAt]
@BuiltValue()
abstract class AdminCustomerDtoOutputTicketsInner
    implements
        Built<
          AdminCustomerDtoOutputTicketsInner,
          AdminCustomerDtoOutputTicketsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'typeLabel')
  String get typeLabel;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  AdminCustomerDtoOutputTicketsInner._();

  factory AdminCustomerDtoOutputTicketsInner([
    void updates(AdminCustomerDtoOutputTicketsInnerBuilder b),
  ]) = _$AdminCustomerDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputTicketsInner> get serializer =>
      _$AdminCustomerDtoOutputTicketsInnerSerializer();
}

class _$AdminCustomerDtoOutputTicketsInnerSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputTicketsInner,
    _$AdminCustomerDtoOutputTicketsInner,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'typeLabel';
    yield serializers.serialize(
      object.typeLabel,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputTicketsInner object, {
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
    required AdminCustomerDtoOutputTicketsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'typeLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeLabel = valueDes;
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
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputTicketsInnerBuilder();
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
