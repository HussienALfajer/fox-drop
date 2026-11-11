//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_picker_dto_output_captains_inner_custody_limit.g.dart';

/// The order pay plus the peak bonus if it would apply now, the largest text; «قد يُضاف أجر انتظار». Null without a pay table.
///
/// Properties:
/// * [amount] - Minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class AdminPickerDtoOutputCaptainsInnerCustodyLimit
    implements
        Built<
          AdminPickerDtoOutputCaptainsInnerCustodyLimit,
          AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder
        > {
  /// Minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminPickerDtoOutputCaptainsInnerCustodyLimit._();

  factory AdminPickerDtoOutputCaptainsInnerCustodyLimit([
    void updates(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder b),
  ]) = _$AdminPickerDtoOutputCaptainsInnerCustodyLimit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPickerDtoOutputCaptainsInnerCustodyLimit>
  get serializer => _$AdminPickerDtoOutputCaptainsInnerCustodyLimitSerializer();
}

class _$AdminPickerDtoOutputCaptainsInnerCustodyLimitSerializer
    implements
        PrimitiveSerializer<AdminPickerDtoOutputCaptainsInnerCustodyLimit> {
  @override
  final Iterable<Type> types = const [
    AdminPickerDtoOutputCaptainsInnerCustodyLimit,
    _$AdminPickerDtoOutputCaptainsInnerCustodyLimit,
  ];

  @override
  final String wireName = r'AdminPickerDtoOutputCaptainsInnerCustodyLimit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPickerDtoOutputCaptainsInnerCustodyLimit object, {
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
    AdminPickerDtoOutputCaptainsInnerCustodyLimit object, {
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
    required AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder result,
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
  AdminPickerDtoOutputCaptainsInnerCustodyLimit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder();
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
