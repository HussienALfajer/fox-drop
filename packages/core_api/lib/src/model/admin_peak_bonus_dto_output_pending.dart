//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_peak_bonus_dto_output_pending.g.dart';

/// A lowering or disabling waiting for the end of the current window.
///
/// Properties:
/// * [enabled]
/// * [currency]
/// * [effectiveFrom]
/// * [windows]
@BuiltValue()
abstract class AdminPeakBonusDtoOutputPending
    implements
        Built<
          AdminPeakBonusDtoOutputPending,
          AdminPeakBonusDtoOutputPendingBuilder
        > {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'windows')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInner> get windows;

  AdminPeakBonusDtoOutputPending._();

  factory AdminPeakBonusDtoOutputPending([
    void updates(AdminPeakBonusDtoOutputPendingBuilder b),
  ]) = _$AdminPeakBonusDtoOutputPending;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPeakBonusDtoOutputPendingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPeakBonusDtoOutputPending> get serializer =>
      _$AdminPeakBonusDtoOutputPendingSerializer();
}

class _$AdminPeakBonusDtoOutputPendingSerializer
    implements PrimitiveSerializer<AdminPeakBonusDtoOutputPending> {
  @override
  final Iterable<Type> types = const [
    AdminPeakBonusDtoOutputPending,
    _$AdminPeakBonusDtoOutputPending,
  ];

  @override
  final String wireName = r'AdminPeakBonusDtoOutputPending';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPeakBonusDtoOutputPending object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'windows';
    yield serializers.serialize(
      object.windows,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPeakBonusDtoOutputInForceWindowsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPeakBonusDtoOutputPending object, {
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
    required AdminPeakBonusDtoOutputPendingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.enabled = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'windows':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPeakBonusDtoOutputInForceWindowsInner),
                    ]),
                  )
                  as BuiltList<AdminPeakBonusDtoOutputInForceWindowsInner>;
          result.windows.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPeakBonusDtoOutputPending deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPeakBonusDtoOutputPendingBuilder();
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
