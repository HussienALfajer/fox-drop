//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_pickup_dispute_dto_received_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_confirm_pickup_dto.g.dart';

/// AdminConfirmPickupDto
///
/// Properties:
/// * [lines] - The agreed lines, prefilled from the captain's last request.
/// * [reason] - Required (AP §9.3.2).
@BuiltValue()
abstract class AdminConfirmPickupDto implements Built<AdminConfirmPickupDto, AdminConfirmPickupDtoBuilder> {
  /// The agreed lines, prefilled from the captain's last request.
  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> get lines;

  /// Required (AP §9.3.2).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminConfirmPickupDto._();

  factory AdminConfirmPickupDto([void updates(AdminConfirmPickupDtoBuilder b)]) = _$AdminConfirmPickupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfirmPickupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfirmPickupDto> get serializer => _$AdminConfirmPickupDtoSerializer();
}

class _$AdminConfirmPickupDtoSerializer implements PrimitiveSerializer<AdminConfirmPickupDto> {
  @override
  final Iterable<Type> types = const [AdminConfirmPickupDto, _$AdminConfirmPickupDto];

  @override
  final String wireName = r'AdminConfirmPickupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfirmPickupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(MerchantPickupDisputeDtoReceivedLinesInner)]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfirmPickupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfirmPickupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantPickupDisputeDtoReceivedLinesInner)]),
          ) as BuiltList<MerchantPickupDisputeDtoReceivedLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfirmPickupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfirmPickupDtoBuilder();
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


