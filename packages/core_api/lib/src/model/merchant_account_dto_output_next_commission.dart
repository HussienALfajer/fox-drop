//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account_dto_output_next_commission.g.dart';

/// A change scheduled for new orders (AP D16), or null.
///
/// Properties:
/// * [rateBp]
/// * [from]
@BuiltValue()
abstract class MerchantAccountDtoOutputNextCommission
    implements
        Built<
          MerchantAccountDtoOutputNextCommission,
          MerchantAccountDtoOutputNextCommissionBuilder
        > {
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'from')
  DateTime get from;

  MerchantAccountDtoOutputNextCommission._();

  factory MerchantAccountDtoOutputNextCommission([
    void updates(MerchantAccountDtoOutputNextCommissionBuilder b),
  ]) = _$MerchantAccountDtoOutputNextCommission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountDtoOutputNextCommissionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccountDtoOutputNextCommission> get serializer =>
      _$MerchantAccountDtoOutputNextCommissionSerializer();
}

class _$MerchantAccountDtoOutputNextCommissionSerializer
    implements PrimitiveSerializer<MerchantAccountDtoOutputNextCommission> {
  @override
  final Iterable<Type> types = const [
    MerchantAccountDtoOutputNextCommission,
    _$MerchantAccountDtoOutputNextCommission,
  ];

  @override
  final String wireName = r'MerchantAccountDtoOutputNextCommission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccountDtoOutputNextCommission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAccountDtoOutputNextCommission object, {
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
    required MerchantAccountDtoOutputNextCommissionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rateBp = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAccountDtoOutputNextCommission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountDtoOutputNextCommissionBuilder();
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
