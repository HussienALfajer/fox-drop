//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_desk_custody_dto_output_usage.g.dart';

/// AdminDeskCustodyDtoOutputUsage
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminDeskCustodyDtoOutputUsage
    implements
        Built<
          AdminDeskCustodyDtoOutputUsage,
          AdminDeskCustodyDtoOutputUsageBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminDeskCustodyDtoOutputUsage._();

  factory AdminDeskCustodyDtoOutputUsage([
    void updates(AdminDeskCustodyDtoOutputUsageBuilder b),
  ]) = _$AdminDeskCustodyDtoOutputUsage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeskCustodyDtoOutputUsageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeskCustodyDtoOutputUsage> get serializer =>
      _$AdminDeskCustodyDtoOutputUsageSerializer();
}

class _$AdminDeskCustodyDtoOutputUsageSerializer
    implements PrimitiveSerializer<AdminDeskCustodyDtoOutputUsage> {
  @override
  final Iterable<Type> types = const [
    AdminDeskCustodyDtoOutputUsage,
    _$AdminDeskCustodyDtoOutputUsage,
  ];

  @override
  final String wireName = r'AdminDeskCustodyDtoOutputUsage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeskCustodyDtoOutputUsage object, {
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
    AdminDeskCustodyDtoOutputUsage object, {
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
    required AdminDeskCustodyDtoOutputUsageBuilder result,
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
  AdminDeskCustodyDtoOutputUsage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeskCustodyDtoOutputUsageBuilder();
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
