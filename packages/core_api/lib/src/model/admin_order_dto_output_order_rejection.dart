//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_rejection.g.dart';

/// While rejected (AP §9.3.1 «rejected (with reason)»).
///
/// Properties:
/// * [at] 
/// * [reason] - The code of the restaurant rejection list.
/// * [label] - Its label as chosen (AP Appendix B).
/// * [customerText] - What the customer sees (CU Appendix C).
/// * [itemIds] - The items switched off for item_unavailable.
/// * [byOperations] - Rejected by operations on the restaurant's behalf.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderRejection implements Built<AdminOrderDtoOutputOrderRejection, AdminOrderDtoOutputOrderRejectionBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The code of the restaurant rejection list.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// Its label as chosen (AP Appendix B).
  @BuiltValueField(wireName: r'label')
  String get label;

  /// What the customer sees (CU Appendix C).
  @BuiltValueField(wireName: r'customerText')
  String get customerText;

  /// The items switched off for item_unavailable.
  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String> get itemIds;

  /// Rejected by operations on the restaurant's behalf.
  @BuiltValueField(wireName: r'byOperations')
  bool get byOperations;

  AdminOrderDtoOutputOrderRejection._();

  factory AdminOrderDtoOutputOrderRejection([void updates(AdminOrderDtoOutputOrderRejectionBuilder b)]) = _$AdminOrderDtoOutputOrderRejection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderRejectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderRejection> get serializer => _$AdminOrderDtoOutputOrderRejectionSerializer();
}

class _$AdminOrderDtoOutputOrderRejectionSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderRejection> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderRejection, _$AdminOrderDtoOutputOrderRejection];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderRejection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderRejection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'customerText';
    yield serializers.serialize(
      object.customerText,
      specifiedType: const FullType(String),
    );
    yield r'itemIds';
    yield serializers.serialize(
      object.itemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'byOperations';
    yield serializers.serialize(
      object.byOperations,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderRejection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderRejectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'customerText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.customerText = valueDes;
          break;
        case r'itemIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.itemIds.replace(valueDes);
          break;
        case r'byOperations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.byOperations = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderRejection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderRejectionBuilder();
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


