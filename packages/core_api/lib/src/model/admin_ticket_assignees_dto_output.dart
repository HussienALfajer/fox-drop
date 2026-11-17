//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_assignees_dto_output.g.dart';

/// AdminTicketAssigneesDtoOutput
///
/// Properties:
/// * [assignees]
@BuiltValue()
abstract class AdminTicketAssigneesDtoOutput
    implements
        Built<
          AdminTicketAssigneesDtoOutput,
          AdminTicketAssigneesDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'assignees')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get assignees;

  AdminTicketAssigneesDtoOutput._();

  factory AdminTicketAssigneesDtoOutput([
    void updates(AdminTicketAssigneesDtoOutputBuilder b),
  ]) = _$AdminTicketAssigneesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketAssigneesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketAssigneesDtoOutput> get serializer =>
      _$AdminTicketAssigneesDtoOutputSerializer();
}

class _$AdminTicketAssigneesDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketAssigneesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketAssigneesDtoOutput,
    _$AdminTicketAssigneesDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketAssigneesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketAssigneesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assignees';
    yield serializers.serialize(
      object.assignees,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketAssigneesDtoOutput object, {
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
    required AdminTicketAssigneesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assignees':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>;
          result.assignees.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketAssigneesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketAssigneesDtoOutputBuilder();
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
