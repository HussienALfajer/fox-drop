//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_handover_handovers_inner.g.dart';

/// AdminOrderDtoOutputOrderHandoverHandoversInner
///
/// Properties:
/// * [openedAt]
/// * [fromCaptainId]
/// * [fromCaptainName]
/// * [toCaptainId]
/// * [toCaptainName]
/// * [offered] - Sent as an offer «استلام من كابتن», else assigned.
/// * [assignedAt] - The second captain has it (accepted or assigned).
/// * [receivedAt] - «استلمت الطلب من الكابتن {الاسم}».
/// * [closedAt]
/// * [closeReason] - Why it closed without the receipt: the offer declined, expired or withdrawn, or the order ended first.
/// * [note] - Operations' internal note.
/// * [adminId]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderHandoverHandoversInner
    implements
        Built<
          AdminOrderDtoOutputOrderHandoverHandoversInner,
          AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder
        > {
  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  @BuiltValueField(wireName: r'fromCaptainId')
  String get fromCaptainId;

  @BuiltValueField(wireName: r'fromCaptainName')
  String? get fromCaptainName;

  @BuiltValueField(wireName: r'toCaptainId')
  String get toCaptainId;

  @BuiltValueField(wireName: r'toCaptainName')
  String? get toCaptainName;

  /// Sent as an offer «استلام من كابتن», else assigned.
  @BuiltValueField(wireName: r'offered')
  bool get offered;

  /// The second captain has it (accepted or assigned).
  @BuiltValueField(wireName: r'assignedAt')
  DateTime? get assignedAt;

  /// «استلمت الطلب من الكابتن {الاسم}».
  @BuiltValueField(wireName: r'receivedAt')
  DateTime? get receivedAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  /// Why it closed without the receipt: the offer declined, expired or withdrawn, or the order ended first.
  @BuiltValueField(wireName: r'closeReason')
  AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum?
  get closeReason;
  // enum closeReasonEnum {  declined,  expired,  withdrawn,  ended,  };

  /// Operations' internal note.
  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'adminId')
  String get adminId;

  AdminOrderDtoOutputOrderHandoverHandoversInner._();

  factory AdminOrderDtoOutputOrderHandoverHandoversInner([
    void updates(AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderHandoverHandoversInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderHandoverHandoversInner>
  get serializer =>
      _$AdminOrderDtoOutputOrderHandoverHandoversInnerSerializer();
}

class _$AdminOrderDtoOutputOrderHandoverHandoversInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderHandoverHandoversInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderHandoverHandoversInner,
    _$AdminOrderDtoOutputOrderHandoverHandoversInner,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderHandoverHandoversInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderHandoverHandoversInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'fromCaptainId';
    yield serializers.serialize(
      object.fromCaptainId,
      specifiedType: const FullType(String),
    );
    yield r'fromCaptainName';
    yield object.fromCaptainName == null
        ? null
        : serializers.serialize(
            object.fromCaptainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'toCaptainId';
    yield serializers.serialize(
      object.toCaptainId,
      specifiedType: const FullType(String),
    );
    yield r'toCaptainName';
    yield object.toCaptainName == null
        ? null
        : serializers.serialize(
            object.toCaptainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'offered';
    yield serializers.serialize(
      object.offered,
      specifiedType: const FullType(bool),
    );
    yield r'assignedAt';
    yield object.assignedAt == null
        ? null
        : serializers.serialize(
            object.assignedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'receivedAt';
    yield object.receivedAt == null
        ? null
        : serializers.serialize(
            object.receivedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'closedAt';
    yield object.closedAt == null
        ? null
        : serializers.serialize(
            object.closedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'closeReason';
    yield object.closeReason == null
        ? null
        : serializers.serialize(
            object.closeReason,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum,
            ),
          );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'adminId';
    yield serializers.serialize(
      object.adminId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderHandoverHandoversInner object, {
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
    required AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        case r'fromCaptainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fromCaptainId = valueDes;
          break;
        case r'fromCaptainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.fromCaptainName = valueDes;
          break;
        case r'toCaptainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.toCaptainId = valueDes;
          break;
        case r'toCaptainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.toCaptainName = valueDes;
          break;
        case r'offered':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.offered = valueDes;
          break;
        case r'assignedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.assignedAt = valueDes;
          break;
        case r'receivedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.receivedAt = valueDes;
          break;
        case r'closedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'closeReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum?;
          if (valueDes == null) continue;
          result.closeReason = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        case r'adminId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adminId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderHandoverHandoversInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder();
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

/// Why it closed without the receipt: the offer declined, expired or withdrawn, or the order ended first.
class AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'declined')
  static const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
  declined =
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
  expired =
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_expired;
  @BuiltValueEnumConst(wireName: r'withdrawn')
  static const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
  withdrawn =
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_withdrawn;
  @BuiltValueEnumConst(wireName: r'ended')
  static const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
  ended = _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_ended;

  static Serializer<
    AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
  >
  get serializer =>
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumSerializer;

  const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum>
  get values =>
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumValues;
  static AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumValueOf(
    name,
  );
}
