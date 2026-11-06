//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_delivery_dto_shortfall.g.dart';

/// Needed when the net received is short beyond rounding: «الزبون لا يملك المبلغ كاملاً», «خطأ في العد», «أخرى».
///
/// Properties:
/// * [reason]
/// * [note] - The text of «أخرى» only.
@BuiltValue()
abstract class AdminRecordDeliveryDtoShortfall
    implements
        Built<
          AdminRecordDeliveryDtoShortfall,
          AdminRecordDeliveryDtoShortfallBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  AdminRecordDeliveryDtoShortfallReasonEnum get reason;
  // enum reasonEnum {  customer_short,  counting_error,  other,  };

  /// The text of «أخرى» only.
  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminRecordDeliveryDtoShortfall._();

  factory AdminRecordDeliveryDtoShortfall([
    void updates(AdminRecordDeliveryDtoShortfallBuilder b),
  ]) = _$AdminRecordDeliveryDtoShortfall;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordDeliveryDtoShortfallBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordDeliveryDtoShortfall> get serializer =>
      _$AdminRecordDeliveryDtoShortfallSerializer();
}

class _$AdminRecordDeliveryDtoShortfallSerializer
    implements PrimitiveSerializer<AdminRecordDeliveryDtoShortfall> {
  @override
  final Iterable<Type> types = const [
    AdminRecordDeliveryDtoShortfall,
    _$AdminRecordDeliveryDtoShortfall,
  ];

  @override
  final String wireName = r'AdminRecordDeliveryDtoShortfall';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordDeliveryDtoShortfall object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(AdminRecordDeliveryDtoShortfallReasonEnum),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDeliveryDtoShortfall object, {
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
    required AdminRecordDeliveryDtoShortfallBuilder result,
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
                      AdminRecordDeliveryDtoShortfallReasonEnum,
                    ),
                  )
                  as AdminRecordDeliveryDtoShortfallReasonEnum;
          result.reason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRecordDeliveryDtoShortfall deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordDeliveryDtoShortfallBuilder();
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

class AdminRecordDeliveryDtoShortfallReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer_short')
  static const AdminRecordDeliveryDtoShortfallReasonEnum customerShort =
      _$adminRecordDeliveryDtoShortfallReasonEnum_customerShort;
  @BuiltValueEnumConst(wireName: r'counting_error')
  static const AdminRecordDeliveryDtoShortfallReasonEnum countingError =
      _$adminRecordDeliveryDtoShortfallReasonEnum_countingError;
  @BuiltValueEnumConst(wireName: r'other')
  static const AdminRecordDeliveryDtoShortfallReasonEnum other =
      _$adminRecordDeliveryDtoShortfallReasonEnum_other;

  static Serializer<AdminRecordDeliveryDtoShortfallReasonEnum> get serializer =>
      _$adminRecordDeliveryDtoShortfallReasonEnumSerializer;

  const AdminRecordDeliveryDtoShortfallReasonEnum._(String name) : super(name);

  static BuiltSet<AdminRecordDeliveryDtoShortfallReasonEnum> get values =>
      _$adminRecordDeliveryDtoShortfallReasonEnumValues;
  static AdminRecordDeliveryDtoShortfallReasonEnum valueOf(String name) =>
      _$adminRecordDeliveryDtoShortfallReasonEnumValueOf(name);
}
