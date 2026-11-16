//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_codes_dto_output_codes_inner_ended.g.dart';

/// null in «متاحة»; else «منتهية», used or expired.
///
/// Properties:
/// * [reason]
/// * [at]
@BuiltValue()
abstract class CustomerCodesDtoOutputCodesInnerEnded
    implements
        Built<
          CustomerCodesDtoOutputCodesInnerEnded,
          CustomerCodesDtoOutputCodesInnerEndedBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  CustomerCodesDtoOutputCodesInnerEndedReasonEnum get reason;
  // enum reasonEnum {  used,  expired,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CustomerCodesDtoOutputCodesInnerEnded._();

  factory CustomerCodesDtoOutputCodesInnerEnded([
    void updates(CustomerCodesDtoOutputCodesInnerEndedBuilder b),
  ]) = _$CustomerCodesDtoOutputCodesInnerEnded;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCodesDtoOutputCodesInnerEndedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCodesDtoOutputCodesInnerEnded> get serializer =>
      _$CustomerCodesDtoOutputCodesInnerEndedSerializer();
}

class _$CustomerCodesDtoOutputCodesInnerEndedSerializer
    implements PrimitiveSerializer<CustomerCodesDtoOutputCodesInnerEnded> {
  @override
  final Iterable<Type> types = const [
    CustomerCodesDtoOutputCodesInnerEnded,
    _$CustomerCodesDtoOutputCodesInnerEnded,
  ];

  @override
  final String wireName = r'CustomerCodesDtoOutputCodesInnerEnded';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInnerEnded object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(
        CustomerCodesDtoOutputCodesInnerEndedReasonEnum,
      ),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInnerEnded object, {
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
    required CustomerCodesDtoOutputCodesInnerEndedBuilder result,
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
                    specifiedType: const FullType(
                      CustomerCodesDtoOutputCodesInnerEndedReasonEnum,
                    ),
                  )
                  as CustomerCodesDtoOutputCodesInnerEndedReasonEnum;
          result.reason = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCodesDtoOutputCodesInnerEnded deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCodesDtoOutputCodesInnerEndedBuilder();
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

class CustomerCodesDtoOutputCodesInnerEndedReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'used')
  static const CustomerCodesDtoOutputCodesInnerEndedReasonEnum used =
      _$customerCodesDtoOutputCodesInnerEndedReasonEnum_used;
  @BuiltValueEnumConst(wireName: r'expired')
  static const CustomerCodesDtoOutputCodesInnerEndedReasonEnum expired =
      _$customerCodesDtoOutputCodesInnerEndedReasonEnum_expired;

  static Serializer<CustomerCodesDtoOutputCodesInnerEndedReasonEnum>
  get serializer => _$customerCodesDtoOutputCodesInnerEndedReasonEnumSerializer;

  const CustomerCodesDtoOutputCodesInnerEndedReasonEnum._(String name)
    : super(name);

  static BuiltSet<CustomerCodesDtoOutputCodesInnerEndedReasonEnum> get values =>
      _$customerCodesDtoOutputCodesInnerEndedReasonEnumValues;
  static CustomerCodesDtoOutputCodesInnerEndedReasonEnum valueOf(String name) =>
      _$customerCodesDtoOutputCodesInnerEndedReasonEnumValueOf(name);
}
