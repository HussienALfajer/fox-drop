//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_picker_dto_output_captains_inner_custody_usage.g.dart';

/// AdminPickerDtoOutputCaptainsInnerCustodyUsage
///
/// Properties:
/// * [amount] - Minor units of the currency, as a string.
/// * [currency] 
@BuiltValue()
abstract class AdminPickerDtoOutputCaptainsInnerCustodyUsage implements Built<AdminPickerDtoOutputCaptainsInnerCustodyUsage, AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder> {
  /// Minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminPickerDtoOutputCaptainsInnerCustodyUsage._();

  factory AdminPickerDtoOutputCaptainsInnerCustodyUsage([void updates(AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder b)]) = _$AdminPickerDtoOutputCaptainsInnerCustodyUsage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPickerDtoOutputCaptainsInnerCustodyUsage> get serializer => _$AdminPickerDtoOutputCaptainsInnerCustodyUsageSerializer();
}

class _$AdminPickerDtoOutputCaptainsInnerCustodyUsageSerializer implements PrimitiveSerializer<AdminPickerDtoOutputCaptainsInnerCustodyUsage> {
  @override
  final Iterable<Type> types = const [AdminPickerDtoOutputCaptainsInnerCustodyUsage, _$AdminPickerDtoOutputCaptainsInnerCustodyUsage];

  @override
  final String wireName = r'AdminPickerDtoOutputCaptainsInnerCustodyUsage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPickerDtoOutputCaptainsInnerCustodyUsage object, {
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
    AdminPickerDtoOutputCaptainsInnerCustodyUsage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AdminPickerDtoOutputCaptainsInnerCustodyUsage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder();
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


