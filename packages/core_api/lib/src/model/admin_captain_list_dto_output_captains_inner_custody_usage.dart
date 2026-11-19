//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_list_dto_output_captains_inner_custody_usage.g.dart';

/// The positive positions at current rates, in the base.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminCaptainListDtoOutputCaptainsInnerCustodyUsage
    implements
        Built<
          AdminCaptainListDtoOutputCaptainsInnerCustodyUsage,
          AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminCaptainListDtoOutputCaptainsInnerCustodyUsage._();

  factory AdminCaptainListDtoOutputCaptainsInnerCustodyUsage([
    void updates(AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder b),
  ]) = _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainListDtoOutputCaptainsInnerCustodyUsage>
  get serializer =>
      _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsageSerializer();
}

class _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsageSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainListDtoOutputCaptainsInnerCustodyUsage
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainListDtoOutputCaptainsInnerCustodyUsage,
    _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage,
  ];

  @override
  final String wireName = r'AdminCaptainListDtoOutputCaptainsInnerCustodyUsage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerCustodyUsage object, {
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
    AdminCaptainListDtoOutputCaptainsInnerCustodyUsage object, {
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
    required AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder result,
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
  AdminCaptainListDtoOutputCaptainsInnerCustodyUsage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder();
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
