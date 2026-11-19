//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_table_preview_dto_output_in_force_base.g.dart';

/// AdminPayTablePreviewDtoOutputInForceBase
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminPayTablePreviewDtoOutputInForceBase
    implements
        Built<
          AdminPayTablePreviewDtoOutputInForceBase,
          AdminPayTablePreviewDtoOutputInForceBaseBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminPayTablePreviewDtoOutputInForceBase._();

  factory AdminPayTablePreviewDtoOutputInForceBase([
    void updates(AdminPayTablePreviewDtoOutputInForceBaseBuilder b),
  ]) = _$AdminPayTablePreviewDtoOutputInForceBase;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablePreviewDtoOutputInForceBaseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablePreviewDtoOutputInForceBase> get serializer =>
      _$AdminPayTablePreviewDtoOutputInForceBaseSerializer();
}

class _$AdminPayTablePreviewDtoOutputInForceBaseSerializer
    implements PrimitiveSerializer<AdminPayTablePreviewDtoOutputInForceBase> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablePreviewDtoOutputInForceBase,
    _$AdminPayTablePreviewDtoOutputInForceBase,
  ];

  @override
  final String wireName = r'AdminPayTablePreviewDtoOutputInForceBase';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablePreviewDtoOutputInForceBase object, {
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
    AdminPayTablePreviewDtoOutputInForceBase object, {
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
    required AdminPayTablePreviewDtoOutputInForceBaseBuilder result,
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
  AdminPayTablePreviewDtoOutputInForceBase deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablePreviewDtoOutputInForceBaseBuilder();
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
