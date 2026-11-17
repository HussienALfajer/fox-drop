//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_report_ticket_dto_output_ticket.g.dart';

/// CaptainReportTicketDtoOutputTicket
///
/// Properties:
/// * [id]
/// * [number] - Shown as `T-{number}`.
/// * [typeLabel]
/// * [orderId]
/// * [orderNumber]
/// * [description] - The note sent.
/// * [status] - AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
/// * [openedAt]
/// * [openedBy] - Who opened it: the captain, or the panel.
/// * [replyWithinMinutes] - «سنرد عليك خلال {المدة}»: the ticket's timer from its opening.
/// * [message] - The resolution message, once resolved.
/// * [resolvedAt]
@BuiltValue()
abstract class CaptainReportTicketDtoOutputTicket
    implements
        Built<
          CaptainReportTicketDtoOutputTicket,
          CaptainReportTicketDtoOutputTicketBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as `T-{number}`.
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'typeLabel')
  String get typeLabel;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// The note sent.
  @BuiltValueField(wireName: r'description')
  String get description;

  /// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
  @BuiltValueField(wireName: r'status')
  CaptainReportTicketDtoOutputTicketStatusEnum get status;
  // enum statusEnum {  new,  in_progress,  waiting,  resolved,  closed,  };

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  /// Who opened it: the captain, or the panel.
  @BuiltValueField(wireName: r'openedBy')
  CaptainReportTicketDtoOutputTicketOpenedByEnum get openedBy;
  // enum openedByEnum {  me,  operations,  };

  /// «سنرد عليك خلال {المدة}»: the ticket's timer from its opening.
  @BuiltValueField(wireName: r'replyWithinMinutes')
  int get replyWithinMinutes;

  /// The resolution message, once resolved.
  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  CaptainReportTicketDtoOutputTicket._();

  factory CaptainReportTicketDtoOutputTicket([
    void updates(CaptainReportTicketDtoOutputTicketBuilder b),
  ]) = _$CaptainReportTicketDtoOutputTicket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainReportTicketDtoOutputTicketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainReportTicketDtoOutputTicket> get serializer =>
      _$CaptainReportTicketDtoOutputTicketSerializer();
}

class _$CaptainReportTicketDtoOutputTicketSerializer
    implements PrimitiveSerializer<CaptainReportTicketDtoOutputTicket> {
  @override
  final Iterable<Type> types = const [
    CaptainReportTicketDtoOutputTicket,
    _$CaptainReportTicketDtoOutputTicket,
  ];

  @override
  final String wireName = r'CaptainReportTicketDtoOutputTicket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainReportTicketDtoOutputTicket object, {
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
        CaptainReportTicketDtoOutputTicketStatusEnum,
      ),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'openedBy';
    yield serializers.serialize(
      object.openedBy,
      specifiedType: const FullType(
        CaptainReportTicketDtoOutputTicketOpenedByEnum,
      ),
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
    CaptainReportTicketDtoOutputTicket object, {
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
    required CaptainReportTicketDtoOutputTicketBuilder result,
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
                      CaptainReportTicketDtoOutputTicketStatusEnum,
                    ),
                  )
                  as CaptainReportTicketDtoOutputTicketStatusEnum;
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
        case r'openedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainReportTicketDtoOutputTicketOpenedByEnum,
                    ),
                  )
                  as CaptainReportTicketDtoOutputTicketOpenedByEnum;
          result.openedBy = valueDes;
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
  CaptainReportTicketDtoOutputTicket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainReportTicketDtoOutputTicketBuilder();
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

/// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
class CaptainReportTicketDtoOutputTicketStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const CaptainReportTicketDtoOutputTicketStatusEnum new_ =
      _$captainReportTicketDtoOutputTicketStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const CaptainReportTicketDtoOutputTicketStatusEnum inProgress =
      _$captainReportTicketDtoOutputTicketStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const CaptainReportTicketDtoOutputTicketStatusEnum waiting =
      _$captainReportTicketDtoOutputTicketStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const CaptainReportTicketDtoOutputTicketStatusEnum resolved =
      _$captainReportTicketDtoOutputTicketStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const CaptainReportTicketDtoOutputTicketStatusEnum closed =
      _$captainReportTicketDtoOutputTicketStatusEnum_closed;

  static Serializer<CaptainReportTicketDtoOutputTicketStatusEnum>
  get serializer => _$captainReportTicketDtoOutputTicketStatusEnumSerializer;

  const CaptainReportTicketDtoOutputTicketStatusEnum._(String name)
    : super(name);

  static BuiltSet<CaptainReportTicketDtoOutputTicketStatusEnum> get values =>
      _$captainReportTicketDtoOutputTicketStatusEnumValues;
  static CaptainReportTicketDtoOutputTicketStatusEnum valueOf(String name) =>
      _$captainReportTicketDtoOutputTicketStatusEnumValueOf(name);
}

/// Who opened it: the captain, or the panel.
class CaptainReportTicketDtoOutputTicketOpenedByEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'me')
  static const CaptainReportTicketDtoOutputTicketOpenedByEnum me =
      _$captainReportTicketDtoOutputTicketOpenedByEnum_me;
  @BuiltValueEnumConst(wireName: r'operations')
  static const CaptainReportTicketDtoOutputTicketOpenedByEnum operations =
      _$captainReportTicketDtoOutputTicketOpenedByEnum_operations;

  static Serializer<CaptainReportTicketDtoOutputTicketOpenedByEnum>
  get serializer => _$captainReportTicketDtoOutputTicketOpenedByEnumSerializer;

  const CaptainReportTicketDtoOutputTicketOpenedByEnum._(String name)
    : super(name);

  static BuiltSet<CaptainReportTicketDtoOutputTicketOpenedByEnum> get values =>
      _$captainReportTicketDtoOutputTicketOpenedByEnumValues;
  static CaptainReportTicketDtoOutputTicketOpenedByEnum valueOf(String name) =>
      _$captainReportTicketDtoOutputTicketOpenedByEnumValueOf(name);
}
