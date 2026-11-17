//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output_tickets_inner_sla.g.dart';

/// AdminOrderTicketsDtoOutputTicketsInnerSla
///
/// Properties:
/// * [kind]
/// * [startedAt]
/// * [dueAt]
/// * [stoppedAt] - The first response once given.
@BuiltValue()
abstract class AdminOrderTicketsDtoOutputTicketsInnerSla
    implements
        Built<
          AdminOrderTicketsDtoOutputTicketsInnerSla,
          AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum get kind;
  // enum kindEnum {  first_response,  resolution,  };

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'dueAt')
  DateTime get dueAt;

  /// The first response once given.
  @BuiltValueField(wireName: r'stoppedAt')
  DateTime? get stoppedAt;

  AdminOrderTicketsDtoOutputTicketsInnerSla._();

  factory AdminOrderTicketsDtoOutputTicketsInnerSla([
    void updates(AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder b),
  ]) = _$AdminOrderTicketsDtoOutputTicketsInnerSla;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerSla> get serializer =>
      _$AdminOrderTicketsDtoOutputTicketsInnerSlaSerializer();
}

class _$AdminOrderTicketsDtoOutputTicketsInnerSlaSerializer
    implements PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInnerSla> {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutputTicketsInnerSla,
    _$AdminOrderTicketsDtoOutputTicketsInnerSla,
  ];

  @override
  final String wireName = r'AdminOrderTicketsDtoOutputTicketsInnerSla';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerSla object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum,
      ),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'dueAt';
    yield serializers.serialize(
      object.dueAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'stoppedAt';
    yield object.stoppedAt == null
        ? null
        : serializers.serialize(
            object.stoppedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerSla object, {
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
    required AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum;
          result.kind = valueDes;
          break;
        case r'startedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.startedAt = valueDes;
          break;
        case r'dueAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.dueAt = valueDes;
          break;
        case r'stoppedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.stoppedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerSla deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderTicketsDtoOutputTicketsInnerSlaBuilder();
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

class AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'first_response')
  static const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum firstResponse =
      _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_firstResponse;
  @BuiltValueEnumConst(wireName: r'resolution')
  static const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum resolution =
      _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnum_resolution;

  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum>
  get serializer =>
      _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnumSerializer;

  const AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum>
  get values => _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnumValues;
  static AdminOrderTicketsDtoOutputTicketsInnerSlaKindEnum valueOf(
    String name,
  ) => _$adminOrderTicketsDtoOutputTicketsInnerSlaKindEnumValueOf(name);
}
