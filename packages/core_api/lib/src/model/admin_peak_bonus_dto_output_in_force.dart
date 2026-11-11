//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_peak_bonus_dto_output_in_force.g.dart';

/// Null until the owner first saves it: off (D15).
///
/// Properties:
/// * [id]
/// * [enabled]
/// * [currency]
/// * [effectiveFrom]
/// * [windows]
@BuiltValue()
abstract class AdminPeakBonusDtoOutputInForce
    implements
        Built<
          AdminPeakBonusDtoOutputInForce,
          AdminPeakBonusDtoOutputInForceBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'windows')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInner> get windows;

  AdminPeakBonusDtoOutputInForce._();

  factory AdminPeakBonusDtoOutputInForce([
    void updates(AdminPeakBonusDtoOutputInForceBuilder b),
  ]) = _$AdminPeakBonusDtoOutputInForce;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPeakBonusDtoOutputInForceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPeakBonusDtoOutputInForce> get serializer =>
      _$AdminPeakBonusDtoOutputInForceSerializer();
}

class _$AdminPeakBonusDtoOutputInForceSerializer
    implements PrimitiveSerializer<AdminPeakBonusDtoOutputInForce> {
  @override
  final Iterable<Type> types = const [
    AdminPeakBonusDtoOutputInForce,
    _$AdminPeakBonusDtoOutputInForce,
  ];

  @override
  final String wireName = r'AdminPeakBonusDtoOutputInForce';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPeakBonusDtoOutputInForce object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    AdminPeakBonusDtoOutputInForce object, {
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
    required AdminPeakBonusDtoOutputInForceBuilder result,
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
  AdminPeakBonusDtoOutputInForce deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPeakBonusDtoOutputInForceBuilder();
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
