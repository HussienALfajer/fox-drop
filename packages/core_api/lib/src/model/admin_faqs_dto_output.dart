//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_faqs_dto_output_customer_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_faqs_dto_output.g.dart';

/// AdminFaqsDtoOutput
///
/// Properties:
/// * [customer] 
/// * [captain] 
/// * [merchant] 
@BuiltValue()
abstract class AdminFaqsDtoOutput implements Built<AdminFaqsDtoOutput, AdminFaqsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'customer')
  BuiltList<AdminFaqsDtoOutputCustomerInner> get customer;

  @BuiltValueField(wireName: r'captain')
  BuiltList<AdminFaqsDtoOutputCustomerInner> get captain;

  @BuiltValueField(wireName: r'merchant')
  BuiltList<AdminFaqsDtoOutputCustomerInner> get merchant;

  AdminFaqsDtoOutput._();

  factory AdminFaqsDtoOutput([void updates(AdminFaqsDtoOutputBuilder b)]) = _$AdminFaqsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFaqsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFaqsDtoOutput> get serializer => _$AdminFaqsDtoOutputSerializer();
}

class _$AdminFaqsDtoOutputSerializer implements PrimitiveSerializer<AdminFaqsDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminFaqsDtoOutput, _$AdminFaqsDtoOutput];

  @override
  final String wireName = r'AdminFaqsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFaqsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(BuiltList, [FullType(AdminFaqsDtoOutputCustomerInner)]),
    );
    yield r'captain';
    yield serializers.serialize(
      object.captain,
      specifiedType: const FullType(BuiltList, [FullType(AdminFaqsDtoOutputCustomerInner)]),
    );
    yield r'merchant';
    yield serializers.serialize(
      object.merchant,
      specifiedType: const FullType(BuiltList, [FullType(AdminFaqsDtoOutputCustomerInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminFaqsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminFaqsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminFaqsDtoOutputCustomerInner)]),
          ) as BuiltList<AdminFaqsDtoOutputCustomerInner>;
          result.customer.replace(valueDes);
          break;
        case r'captain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminFaqsDtoOutputCustomerInner)]),
          ) as BuiltList<AdminFaqsDtoOutputCustomerInner>;
          result.captain.replace(valueDes);
          break;
        case r'merchant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminFaqsDtoOutputCustomerInner)]),
          ) as BuiltList<AdminFaqsDtoOutputCustomerInner>;
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
  AdminFaqsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFaqsDtoOutputBuilder();
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


