//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_table_preview_dto_output_in_force_total.g.dart';

/// The order pay and the waiting pay.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminPayTablePreviewDtoOutputInForceTotal
    implements
        Built<
          AdminPayTablePreviewDtoOutputInForceTotal,
          AdminPayTablePreviewDtoOutputInForceTotalBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminPayTablePreviewDtoOutputInForceTotal._();

  factory AdminPayTablePreviewDtoOutputInForceTotal([
    void updates(AdminPayTablePreviewDtoOutputInForceTotalBuilder b),
  ]) = _$AdminPayTablePreviewDtoOutputInForceTotal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablePreviewDtoOutputInForceTotalBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablePreviewDtoOutputInForceTotal> get serializer =>
      _$AdminPayTablePreviewDtoOutputInForceTotalSerializer();
}

class _$AdminPayTablePreviewDtoOutputInForceTotalSerializer
    implements PrimitiveSerializer<AdminPayTablePreviewDtoOutputInForceTotal> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablePreviewDtoOutputInForceTotal,
    _$AdminPayTablePreviewDtoOutputInForceTotal,
  ];

  @override
  final String wireName = r'AdminPayTablePreviewDtoOutputInForceTotal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablePreviewDtoOutputInForceTotal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablePreviewDtoOutputInForceTotal object, {
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
    required AdminPayTablePreviewDtoOutputInForceTotalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablePreviewDtoOutputInForceTotal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablePreviewDtoOutputInForceTotalBuilder();
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
