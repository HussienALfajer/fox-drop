//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_terms_dto_output_customer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_terms_dto_output.g.dart';

/// AdminTermsDtoOutput
///
/// Properties:
/// * [customer] 
/// * [captain] 
/// * [merchant] 
@BuiltValue()
abstract class AdminTermsDtoOutput implements Built<AdminTermsDtoOutput, AdminTermsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'customer')
  AdminTermsDtoOutputCustomer get customer;

  @BuiltValueField(wireName: r'captain')
  AdminTermsDtoOutputCustomer get captain;

  @BuiltValueField(wireName: r'merchant')
  AdminTermsDtoOutputCustomer get merchant;

  AdminTermsDtoOutput._();

  factory AdminTermsDtoOutput([void updates(AdminTermsDtoOutputBuilder b)]) = _$AdminTermsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTermsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTermsDtoOutput> get serializer => _$AdminTermsDtoOutputSerializer();
}

class _$AdminTermsDtoOutputSerializer implements PrimitiveSerializer<AdminTermsDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminTermsDtoOutput, _$AdminTermsDtoOutput];

  @override
  final String wireName = r'AdminTermsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTermsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(AdminTermsDtoOutputCustomer),
    );
    yield r'captain';
    yield serializers.serialize(
      object.captain,
      specifiedType: const FullType(AdminTermsDtoOutputCustomer),
    );
    yield r'merchant';
    yield serializers.serialize(
      object.merchant,
      specifiedType: const FullType(AdminTermsDtoOutputCustomer),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTermsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTermsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTermsDtoOutputCustomer),
          ) as AdminTermsDtoOutputCustomer;
          result.customer.replace(valueDes);
          break;
        case r'captain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTermsDtoOutputCustomer),
          ) as AdminTermsDtoOutputCustomer;
          result.captain.replace(valueDes);
          break;
        case r'merchant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminTermsDtoOutputCustomer),
          ) as AdminTermsDtoOutputCustomer;
          result.merchant.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTermsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTermsDtoOutputBuilder();
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


