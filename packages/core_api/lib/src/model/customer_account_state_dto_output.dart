//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_account_state_dto_output_office.dart';
import 'package:core_api/src/model/customer_account_state_dto_output_dues.dart';
import 'package:core_api/src/model/customer_account_state_dto_output_block.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_account_state_dto_output.g.dart';

/// CustomerAccountStateDtoOutput
///
/// Properties:
/// * [reviewStop] - «حسابك موقوف حتى مراجعة فريق الدعم», with call and WhatsApp (CU §5.5).
/// * [block]
/// * [dues]
/// * [office]
@BuiltValue()
abstract class CustomerAccountStateDtoOutput
    implements
        Built<
          CustomerAccountStateDtoOutput,
          CustomerAccountStateDtoOutputBuilder
        > {
  /// «حسابك موقوف حتى مراجعة فريق الدعم», with call and WhatsApp (CU §5.5).
  @BuiltValueField(wireName: r'reviewStop')
  bool get reviewStop;

  @BuiltValueField(wireName: r'block')
  CustomerAccountStateDtoOutputBlock? get block;

  @BuiltValueField(wireName: r'dues')
  CustomerAccountStateDtoOutputDues? get dues;

  @BuiltValueField(wireName: r'office')
  CustomerAccountStateDtoOutputOffice? get office;

  CustomerAccountStateDtoOutput._();

  factory CustomerAccountStateDtoOutput([
    void updates(CustomerAccountStateDtoOutputBuilder b),
  ]) = _$CustomerAccountStateDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAccountStateDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAccountStateDtoOutput> get serializer =>
      _$CustomerAccountStateDtoOutputSerializer();
}

class _$CustomerAccountStateDtoOutputSerializer
    implements PrimitiveSerializer<CustomerAccountStateDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerAccountStateDtoOutput,
    _$CustomerAccountStateDtoOutput,
  ];

  @override
  final String wireName = r'CustomerAccountStateDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAccountStateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reviewStop';
    yield serializers.serialize(
      object.reviewStop,
      specifiedType: const FullType(bool),
    );
    yield r'block';
    yield object.block == null
        ? null
        : serializers.serialize(
            object.block,
            specifiedType: const FullType.nullable(
              CustomerAccountStateDtoOutputBlock,
            ),
          );
    yield r'dues';
    yield object.dues == null
        ? null
        : serializers.serialize(
            object.dues,
            specifiedType: const FullType.nullable(
              CustomerAccountStateDtoOutputDues,
            ),
          );
    yield r'office';
    yield object.office == null
        ? null
        : serializers.serialize(
            object.office,
            specifiedType: const FullType.nullable(
              CustomerAccountStateDtoOutputOffice,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAccountStateDtoOutput object, {
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
    required CustomerAccountStateDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reviewStop':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.reviewStop = valueDes;
          break;
        case r'block':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerAccountStateDtoOutputBlock,
                    ),
                  )
                  as CustomerAccountStateDtoOutputBlock?;
          if (valueDes == null) continue;
          result.block.replace(valueDes);
          break;
        case r'dues':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerAccountStateDtoOutputDues,
                    ),
                  )
                  as CustomerAccountStateDtoOutputDues?;
          if (valueDes == null) continue;
          result.dues.replace(valueDes);
          break;
        case r'office':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerAccountStateDtoOutputOffice,
                    ),
                  )
                  as CustomerAccountStateDtoOutputOffice?;
          if (valueDes == null) continue;
          result.office.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerAccountStateDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAccountStateDtoOutputBuilder();
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
