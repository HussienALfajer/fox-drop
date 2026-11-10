//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_preview_answer_dto_output_before.g.dart';

/// AdminEditPreviewAnswerDtoOutputBefore
///
/// Properties:
/// * [itemsValue] - Also the pickup payment (D26).
/// * [deliveryFee] - Integer minor units (AP §8.6).
/// * [discount] - Integer minor units (AP §8.6).
/// * [rounding]
/// * [total] - Integer minor units (AP §8.6).
/// * [commission] - Integer minor units (AP §8.6).
/// * [merchantNet] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class AdminEditPreviewAnswerDtoOutputBefore
    implements
        Built<
          AdminEditPreviewAnswerDtoOutputBefore,
          AdminEditPreviewAnswerDtoOutputBeforeBuilder
        > {
  /// Also the pickup payment (D26).
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'deliveryFee')
  String get deliveryFee;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'discount')
  String get discount;

  @BuiltValueField(wireName: r'rounding')
  String get rounding;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'total')
  String get total;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'commission')
  String get commission;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'merchantNet')
  String get merchantNet;

  AdminEditPreviewAnswerDtoOutputBefore._();

  factory AdminEditPreviewAnswerDtoOutputBefore([
    void updates(AdminEditPreviewAnswerDtoOutputBeforeBuilder b),
  ]) = _$AdminEditPreviewAnswerDtoOutputBefore;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditPreviewAnswerDtoOutputBeforeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditPreviewAnswerDtoOutputBefore> get serializer =>
      _$AdminEditPreviewAnswerDtoOutputBeforeSerializer();
}

class _$AdminEditPreviewAnswerDtoOutputBeforeSerializer
    implements PrimitiveSerializer<AdminEditPreviewAnswerDtoOutputBefore> {
  @override
  final Iterable<Type> types = const [
    AdminEditPreviewAnswerDtoOutputBefore,
    _$AdminEditPreviewAnswerDtoOutputBefore,
  ];

  @override
  final String wireName = r'AdminEditPreviewAnswerDtoOutputBefore';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputBefore object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'deliveryFee';
    yield serializers.serialize(
      object.deliveryFee,
      specifiedType: const FullType(String),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(String),
    );
    yield r'rounding';
    yield serializers.serialize(
      object.rounding,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'merchantNet';
    yield serializers.serialize(
      object.merchantNet,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputBefore object, {
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
    required AdminEditPreviewAnswerDtoOutputBeforeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'deliveryFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deliveryFee = valueDes;
          break;
        case r'discount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discount = valueDes;
          break;
        case r'rounding':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.rounding = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'merchantNet':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.merchantNet = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditPreviewAnswerDtoOutputBefore deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditPreviewAnswerDtoOutputBeforeBuilder();
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
