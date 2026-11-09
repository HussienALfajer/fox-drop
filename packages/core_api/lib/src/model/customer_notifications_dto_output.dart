//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_notifications_dto_output_notifications_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_notifications_dto_output.g.dart';

/// CustomerNotificationsDtoOutput
///
/// Properties:
/// * [notifications] 
@BuiltValue()
abstract class CustomerNotificationsDtoOutput implements Built<CustomerNotificationsDtoOutput, CustomerNotificationsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'notifications')
  BuiltList<CustomerNotificationsDtoOutputNotificationsInner> get notifications;

  CustomerNotificationsDtoOutput._();

  factory CustomerNotificationsDtoOutput([void updates(CustomerNotificationsDtoOutputBuilder b)]) = _$CustomerNotificationsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerNotificationsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerNotificationsDtoOutput> get serializer => _$CustomerNotificationsDtoOutputSerializer();
}

class _$CustomerNotificationsDtoOutputSerializer implements PrimitiveSerializer<CustomerNotificationsDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerNotificationsDtoOutput, _$CustomerNotificationsDtoOutput];

  @override
  final String wireName = r'CustomerNotificationsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerNotificationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'notifications';
    yield serializers.serialize(
      object.notifications,
      specifiedType: const FullType(BuiltList, [FullType(CustomerNotificationsDtoOutputNotificationsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerNotificationsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerNotificationsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'notifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CustomerNotificationsDtoOutputNotificationsInner)]),
          ) as BuiltList<CustomerNotificationsDtoOutputNotificationsInner>;
          result.notifications.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerNotificationsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerNotificationsDtoOutputBuilder();
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


