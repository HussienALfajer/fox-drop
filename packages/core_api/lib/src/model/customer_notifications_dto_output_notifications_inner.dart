//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_notifications_dto_output_notifications_inner.g.dart';

/// CustomerNotificationsDtoOutputNotificationsInner
///
/// Properties:
/// * [id] 
/// * [at] 
/// * [body] 
/// * [data] - What a tap opens: `target` (order, codes, account) and its ids.
@BuiltValue()
abstract class CustomerNotificationsDtoOutputNotificationsInner implements Built<CustomerNotificationsDtoOutputNotificationsInner, CustomerNotificationsDtoOutputNotificationsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'body')
  String get body;

  /// What a tap opens: `target` (order, codes, account) and its ids.
  @BuiltValueField(wireName: r'data')
  BuiltMap<String, String> get data;

  CustomerNotificationsDtoOutputNotificationsInner._();

  factory CustomerNotificationsDtoOutputNotificationsInner([void updates(CustomerNotificationsDtoOutputNotificationsInnerBuilder b)]) = _$CustomerNotificationsDtoOutputNotificationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerNotificationsDtoOutputNotificationsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerNotificationsDtoOutputNotificationsInner> get serializer => _$CustomerNotificationsDtoOutputNotificationsInnerSerializer();
}

class _$CustomerNotificationsDtoOutputNotificationsInnerSerializer implements PrimitiveSerializer<CustomerNotificationsDtoOutputNotificationsInner> {
  @override
  final Iterable<Type> types = const [CustomerNotificationsDtoOutputNotificationsInner, _$CustomerNotificationsDtoOutputNotificationsInner];

  @override
  final String wireName = r'CustomerNotificationsDtoOutputNotificationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerNotificationsDtoOutputNotificationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerNotificationsDtoOutputNotificationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerNotificationsDtoOutputNotificationsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerNotificationsDtoOutputNotificationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerNotificationsDtoOutputNotificationsInnerBuilder();
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


