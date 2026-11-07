//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shortfalls_dto_output_shortfalls_inner.g.dart';

/// AdminShortfallsDtoOutputShortfallsInner
///
/// Properties:
/// * [orderId]
/// * [number]
/// * [captainId]
/// * [amountDue]
/// * [netReceived]
/// * [shortfall]
/// * [reason] - The captain's reason (K16), its code in Content.
/// * [label] - Its label as chosen.
/// * [note]
/// * [recordedAt]
@BuiltValue()
abstract class AdminShortfallsDtoOutputShortfallsInner
    implements
        Built<
          AdminShortfallsDtoOutputShortfallsInner,
          AdminShortfallsDtoOutputShortfallsInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'amountDue')
  CaptainWentOfflineDtoOutputHandIn? get amountDue;

  @BuiltValueField(wireName: r'netReceived')
  CaptainWentOfflineDtoOutputHandIn? get netReceived;

  @BuiltValueField(wireName: r'shortfall')
  CaptainWentOfflineDtoOutputHandIn? get shortfall;

  /// The captain's reason (K16), its code in Content.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// Its label as chosen.
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  AdminShortfallsDtoOutputShortfallsInner._();

  factory AdminShortfallsDtoOutputShortfallsInner([
    void updates(AdminShortfallsDtoOutputShortfallsInnerBuilder b),
  ]) = _$AdminShortfallsDtoOutputShortfallsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminShortfallsDtoOutputShortfallsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminShortfallsDtoOutputShortfallsInner> get serializer =>
      _$AdminShortfallsDtoOutputShortfallsInnerSerializer();
}

class _$AdminShortfallsDtoOutputShortfallsInnerSerializer
    implements PrimitiveSerializer<AdminShortfallsDtoOutputShortfallsInner> {
  @override
  final Iterable<Type> types = const [
    AdminShortfallsDtoOutputShortfallsInner,
    _$AdminShortfallsDtoOutputShortfallsInner,
  ];

  @override
  final String wireName = r'AdminShortfallsDtoOutputShortfallsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminShortfallsDtoOutputShortfallsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'amountDue';
    yield object.amountDue == null
        ? null
        : serializers.serialize(
            object.amountDue,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'netReceived';
    yield object.netReceived == null
        ? null
        : serializers.serialize(
            object.netReceived,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'shortfall';
    yield object.shortfall == null
        ? null
        : serializers.serialize(
            object.shortfall,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'recordedAt';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminShortfallsDtoOutputShortfallsInner object, {
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
    required AdminShortfallsDtoOutputShortfallsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
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
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'amountDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.amountDue.replace(valueDes);
          break;
        case r'netReceived':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.netReceived.replace(valueDes);
          break;
        case r'shortfall':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.shortfall.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
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
        case r'recordedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminShortfallsDtoOutputShortfallsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminShortfallsDtoOutputShortfallsInnerBuilder();
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
