//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_manual_account_dto_output_entries_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_account_dto_output.g.dart';

/// AdminManualAccountDtoOutput
///
/// Properties:
/// * [partyId]
/// * [partyName]
/// * [balances]
/// * [currencies] - What an adjustment takes: custody any enabled currency, the others the base.
/// * [entries]
@BuiltValue()
abstract class AdminManualAccountDtoOutput
    implements
        Built<AdminManualAccountDtoOutput, AdminManualAccountDtoOutputBuilder> {
  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'partyName')
  String get partyName;

  @BuiltValueField(wireName: r'balances')
  BuiltList<AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner>
  get balances;

  /// What an adjustment takes: custody any enabled currency, the others the base.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminManualAccountDtoOutputEntriesInner> get entries;

  AdminManualAccountDtoOutput._();

  factory AdminManualAccountDtoOutput([
    void updates(AdminManualAccountDtoOutputBuilder b),
  ]) = _$AdminManualAccountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualAccountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualAccountDtoOutput> get serializer =>
      _$AdminManualAccountDtoOutputSerializer();
}

class _$AdminManualAccountDtoOutputSerializer
    implements PrimitiveSerializer<AdminManualAccountDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminManualAccountDtoOutput,
    _$AdminManualAccountDtoOutput,
  ];

  @override
  final String wireName = r'AdminManualAccountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    yield r'partyName';
    yield serializers.serialize(
      object.partyName,
      specifiedType: const FullType(String),
    );
    yield r'balances';
    yield serializers.serialize(
      object.balances,
      specifiedType: const FullType(BuiltList, [
        FullType(
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
        ),
      ]),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminManualAccountDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualAccountDtoOutput object, {
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
    required AdminManualAccountDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'partyId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyId = valueDes;
          break;
        case r'partyName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyName = valueDes;
          break;
        case r'balances':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
                  >;
          result.balances.replace(valueDes);
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.currencies.replace(valueDes);
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminManualAccountDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminManualAccountDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualAccountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualAccountDtoOutputBuilder();
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
