//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_reject_dto_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reject_dto.g.dart';

/// AdminRejectDto
///
/// Properties:
/// * [rejection] - A code of the restaurant rejection list (AP Appendix B): item_unavailable «صنف غير متوفر» (marks the items unavailable), restaurant_closed «المطعم مغلق» (also pauses the restaurant until it reopens), too_busy «ضغط طلبات»; 400 unknown_reason otherwise.
/// * [items] - item_unavailable: one or more of the order's items; empty for the others.
/// * [busyExtraMin] - too_busy only: busy mode with one of merchant.busy_extra_options_min, or null.
/// * [pauseMin] - too_busy only: 30 for a 30-minute pause, or null; not with busyExtraMin (400 invalid_rejection otherwise).
/// * [reason] - Required (AP §9.3.2): the internal note, never shown to the apps.
@BuiltValue()
abstract class AdminRejectDto implements Built<AdminRejectDto, AdminRejectDtoBuilder> {
  /// A code of the restaurant rejection list (AP Appendix B): item_unavailable «صنف غير متوفر» (marks the items unavailable), restaurant_closed «المطعم مغلق» (also pauses the restaurant until it reopens), too_busy «ضغط طلبات»; 400 unknown_reason otherwise.
  @BuiltValueField(wireName: r'rejection')
  String get rejection;

  /// item_unavailable: one or more of the order's items; empty for the others.
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminRejectDtoItemsInner> get items;

  /// too_busy only: busy mode with one of merchant.busy_extra_options_min, or null.
  @BuiltValueField(wireName: r'busyExtraMin')
  int? get busyExtraMin;

  /// too_busy only: 30 for a 30-minute pause, or null; not with busyExtraMin (400 invalid_rejection otherwise).
  @BuiltValueField(wireName: r'pauseMin')
  int? get pauseMin;

  /// Required (AP §9.3.2): the internal note, never shown to the apps.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRejectDto._();

  factory AdminRejectDto([void updates(AdminRejectDtoBuilder b)]) = _$AdminRejectDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRejectDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRejectDto> get serializer => _$AdminRejectDtoSerializer();
}

class _$AdminRejectDtoSerializer implements PrimitiveSerializer<AdminRejectDto> {
  @override
  final Iterable<Type> types = const [AdminRejectDto, _$AdminRejectDto];

  @override
  final String wireName = r'AdminRejectDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRejectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rejection';
    yield serializers.serialize(
      object.rejection,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminRejectDtoItemsInner)]),
    );
    yield r'busyExtraMin';
    yield object.busyExtraMin == null ? null : serializers.serialize(
      object.busyExtraMin,
      specifiedType: const FullType.nullable(int),
    );
    yield r'pauseMin';
    yield object.pauseMin == null ? null : serializers.serialize(
      object.pauseMin,
      specifiedType: const FullType.nullable(int),
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
    AdminRejectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRejectDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rejection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rejection = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRejectDtoItemsInner)]),
          ) as BuiltList<AdminRejectDtoItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'busyExtraMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.busyExtraMin = valueDes;
          break;
        case r'pauseMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.pauseMin = valueDes;
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
  AdminRejectDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRejectDtoBuilder();
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


