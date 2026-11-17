//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_report_ticket_dto_output_ticket.g.dart';

/// MerchantReportTicketDtoOutputTicket
///
/// Properties:
/// * [id]
/// * [number] - Shown as `T-{number}`.
/// * [typeLabel]
/// * [subject] - «طلب تعديل بيانات»: what it asks.
/// * [orderId]
/// * [orderNumber]
/// * [description] - The note sent.
/// * [status] - AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
/// * [openedAt]
/// * [openedByMe] - Opened by the session's user.
/// * [replyWithinMinutes] - «سنرد عليك خلال {المدة}»: the ticket's timer from its opening.
/// * [message] - The resolution message, once resolved.
/// * [resolvedAt]
@BuiltValue()
abstract class MerchantReportTicketDtoOutputTicket
    implements
        Built<
          MerchantReportTicketDtoOutputTicket,
          MerchantReportTicketDtoOutputTicketBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as `T-{number}`.
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'typeLabel')
  String get typeLabel;

  /// «طلب تعديل بيانات»: what it asks.
  @BuiltValueField(wireName: r'subject')
  MerchantReportTicketDtoOutputTicketSubjectEnum? get subject;
  // enum subjectEnum {  min_order,  coverage,  owners,  owner_phone,  };

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// The note sent.
  @BuiltValueField(wireName: r'description')
  String get description;

  /// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
  @BuiltValueField(wireName: r'status')
  MerchantReportTicketDtoOutputTicketStatusEnum get status;
  // enum statusEnum {  new,  in_progress,  waiting,  resolved,  closed,  };

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  /// Opened by the session's user.
  @BuiltValueField(wireName: r'openedByMe')
  bool get openedByMe;

  /// «سنرد عليك خلال {المدة}»: the ticket's timer from its opening.
  @BuiltValueField(wireName: r'replyWithinMinutes')
  int get replyWithinMinutes;

  /// The resolution message, once resolved.
  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  MerchantReportTicketDtoOutputTicket._();

  factory MerchantReportTicketDtoOutputTicket([
    void updates(MerchantReportTicketDtoOutputTicketBuilder b),
  ]) = _$MerchantReportTicketDtoOutputTicket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReportTicketDtoOutputTicketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReportTicketDtoOutputTicket> get serializer =>
      _$MerchantReportTicketDtoOutputTicketSerializer();
}

class _$MerchantReportTicketDtoOutputTicketSerializer
    implements PrimitiveSerializer<MerchantReportTicketDtoOutputTicket> {
  @override
  final Iterable<Type> types = const [
    MerchantReportTicketDtoOutputTicket,
    _$MerchantReportTicketDtoOutputTicket,
  ];

  @override
  final String wireName = r'MerchantReportTicketDtoOutputTicket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReportTicketDtoOutputTicket object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'typeLabel';
    yield serializers.serialize(
      object.typeLabel,
      specifiedType: const FullType(String),
    );
    yield r'subject';
    yield object.subject == null
        ? null
        : serializers.serialize(
            object.subject,
            specifiedType: const FullType.nullable(
              MerchantReportTicketDtoOutputTicketSubjectEnum,
            ),
          );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        MerchantReportTicketDtoOutputTicketStatusEnum,
      ),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'openedByMe';
    yield serializers.serialize(
      object.openedByMe,
      specifiedType: const FullType(bool),
    );
    yield r'replyWithinMinutes';
    yield serializers.serialize(
      object.replyWithinMinutes,
      specifiedType: const FullType(int),
    );
    yield r'message';
    yield object.message == null
        ? null
        : serializers.serialize(
            object.message,
            specifiedType: const FullType.nullable(String),
          );
    yield r'resolvedAt';
    yield object.resolvedAt == null
        ? null
        : serializers.serialize(
            object.resolvedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportTicketDtoOutputTicket object, {
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
    required MerchantReportTicketDtoOutputTicketBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'typeLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeLabel = valueDes;
          break;
        case r'subject':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantReportTicketDtoOutputTicketSubjectEnum,
                    ),
                  )
                  as MerchantReportTicketDtoOutputTicketSubjectEnum?;
          if (valueDes == null) continue;
          result.subject = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.description = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantReportTicketDtoOutputTicketStatusEnum,
                    ),
                  )
                  as MerchantReportTicketDtoOutputTicketStatusEnum;
          result.status = valueDes;
          break;
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        case r'openedByMe':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.openedByMe = valueDes;
          break;
        case r'replyWithinMinutes':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.replyWithinMinutes = valueDes;
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        case r'resolvedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReportTicketDtoOutputTicket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReportTicketDtoOutputTicketBuilder();
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

/// «طلب تعديل بيانات»: what it asks.
class MerchantReportTicketDtoOutputTicketSubjectEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'min_order')
  static const MerchantReportTicketDtoOutputTicketSubjectEnum minOrder =
      _$merchantReportTicketDtoOutputTicketSubjectEnum_minOrder;
  @BuiltValueEnumConst(wireName: r'coverage')
  static const MerchantReportTicketDtoOutputTicketSubjectEnum coverage =
      _$merchantReportTicketDtoOutputTicketSubjectEnum_coverage;
  @BuiltValueEnumConst(wireName: r'owners')
  static const MerchantReportTicketDtoOutputTicketSubjectEnum owners =
      _$merchantReportTicketDtoOutputTicketSubjectEnum_owners;
  @BuiltValueEnumConst(wireName: r'owner_phone')
  static const MerchantReportTicketDtoOutputTicketSubjectEnum ownerPhone =
      _$merchantReportTicketDtoOutputTicketSubjectEnum_ownerPhone;

  static Serializer<MerchantReportTicketDtoOutputTicketSubjectEnum>
  get serializer => _$merchantReportTicketDtoOutputTicketSubjectEnumSerializer;

  const MerchantReportTicketDtoOutputTicketSubjectEnum._(String name)
    : super(name);

  static BuiltSet<MerchantReportTicketDtoOutputTicketSubjectEnum> get values =>
      _$merchantReportTicketDtoOutputTicketSubjectEnumValues;
  static MerchantReportTicketDtoOutputTicketSubjectEnum valueOf(String name) =>
      _$merchantReportTicketDtoOutputTicketSubjectEnumValueOf(name);
}

/// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
class MerchantReportTicketDtoOutputTicketStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const MerchantReportTicketDtoOutputTicketStatusEnum new_ =
      _$merchantReportTicketDtoOutputTicketStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const MerchantReportTicketDtoOutputTicketStatusEnum inProgress =
      _$merchantReportTicketDtoOutputTicketStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const MerchantReportTicketDtoOutputTicketStatusEnum waiting =
      _$merchantReportTicketDtoOutputTicketStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const MerchantReportTicketDtoOutputTicketStatusEnum resolved =
      _$merchantReportTicketDtoOutputTicketStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const MerchantReportTicketDtoOutputTicketStatusEnum closed =
      _$merchantReportTicketDtoOutputTicketStatusEnum_closed;

  static Serializer<MerchantReportTicketDtoOutputTicketStatusEnum>
  get serializer => _$merchantReportTicketDtoOutputTicketStatusEnumSerializer;

  const MerchantReportTicketDtoOutputTicketStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantReportTicketDtoOutputTicketStatusEnum> get values =>
      _$merchantReportTicketDtoOutputTicketStatusEnumValues;
  static MerchantReportTicketDtoOutputTicketStatusEnum valueOf(String name) =>
      _$merchantReportTicketDtoOutputTicketStatusEnumValueOf(name);
}
