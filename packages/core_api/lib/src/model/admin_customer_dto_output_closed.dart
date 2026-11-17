//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_closed.g.dart';

/// «مغلق» (D19): when, by whom and why; null while open.
///
/// Properties:
/// * [at]
/// * [byName] - null when the customer closed it from the app.
/// * [reason]
@BuiltValue()
abstract class AdminCustomerDtoOutputClosed
    implements
        Built<
          AdminCustomerDtoOutputClosed,
          AdminCustomerDtoOutputClosedBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// null when the customer closed it from the app.
  @BuiltValueField(wireName: r'byName')
  String? get byName;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminCustomerDtoOutputClosed._();

  factory AdminCustomerDtoOutputClosed([
    void updates(AdminCustomerDtoOutputClosedBuilder b),
  ]) = _$AdminCustomerDtoOutputClosed;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputClosedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputClosed> get serializer =>
      _$AdminCustomerDtoOutputClosedSerializer();
}

class _$AdminCustomerDtoOutputClosedSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputClosed> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputClosed,
    _$AdminCustomerDtoOutputClosed,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputClosed';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputClosed object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'byName';
    yield object.byName == null
        ? null
        : serializers.serialize(
            object.byName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputClosed object, {
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
    required AdminCustomerDtoOutputClosedBuilder result,
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
        case r'byName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.byName = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputClosed deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputClosedBuilder();
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
