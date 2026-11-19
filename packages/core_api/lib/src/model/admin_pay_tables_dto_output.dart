//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_pay_tables_dto_output_max_distance_km_inner.dart';
import 'package:core_api/src/model/admin_pay_tables_dto_output_versions_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_tables_dto_output.g.dart';

/// AdminPayTablesDtoOutput
///
/// Properties:
/// * [baseCurrency] - The amounts are typed in it; null while the city has none.
/// * [waitingThresholdMin] - captain.waiting_threshold_min
/// * [noticeDays] - A change takes effect this many days after it is published.
/// * [earliestStart] - The earliest start of a version published now: now for the first.
/// * [maxDistanceKm] - The setting dispatch.max_distance_km of each vehicle, changed at once.
/// * [versions] - Newest first, the latest 50.
@BuiltValue()
abstract class AdminPayTablesDtoOutput
    implements Built<AdminPayTablesDtoOutput, AdminPayTablesDtoOutputBuilder> {
  /// The amounts are typed in it; null while the city has none.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  /// captain.waiting_threshold_min
  @BuiltValueField(wireName: r'waitingThresholdMin')
  int get waitingThresholdMin;

  /// A change takes effect this many days after it is published.
  @BuiltValueField(wireName: r'noticeDays')
  int get noticeDays;

  /// The earliest start of a version published now: now for the first.
  @BuiltValueField(wireName: r'earliestStart')
  DateTime get earliestStart;

  /// The setting dispatch.max_distance_km of each vehicle, changed at once.
  @BuiltValueField(wireName: r'maxDistanceKm')
  BuiltList<AdminPayTablesDtoOutputMaxDistanceKmInner> get maxDistanceKm;

  /// Newest first, the latest 50.
  @BuiltValueField(wireName: r'versions')
  BuiltList<AdminPayTablesDtoOutputVersionsInner> get versions;

  AdminPayTablesDtoOutput._();

  factory AdminPayTablesDtoOutput([
    void updates(AdminPayTablesDtoOutputBuilder b),
  ]) = _$AdminPayTablesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablesDtoOutput> get serializer =>
      _$AdminPayTablesDtoOutputSerializer();
}

class _$AdminPayTablesDtoOutputSerializer
    implements PrimitiveSerializer<AdminPayTablesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablesDtoOutput,
    _$AdminPayTablesDtoOutput,
  ];

  @override
  final String wireName = r'AdminPayTablesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'waitingThresholdMin';
    yield serializers.serialize(
      object.waitingThresholdMin,
      specifiedType: const FullType(int),
    );
    yield r'noticeDays';
    yield serializers.serialize(
      object.noticeDays,
      specifiedType: const FullType(int),
    );
    yield r'earliestStart';
    yield serializers.serialize(
      object.earliestStart,
      specifiedType: const FullType(DateTime),
    );
    yield r'maxDistanceKm';
    yield serializers.serialize(
      object.maxDistanceKm,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPayTablesDtoOutputMaxDistanceKmInner),
      ]),
    );
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPayTablesDtoOutputVersionsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutput object, {
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
    required AdminPayTablesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.baseCurrency = valueDes;
          break;
        case r'waitingThresholdMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.waitingThresholdMin = valueDes;
          break;
        case r'noticeDays':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.noticeDays = valueDes;
          break;
        case r'earliestStart':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.earliestStart = valueDes;
          break;
        case r'maxDistanceKm':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPayTablesDtoOutputMaxDistanceKmInner),
                    ]),
                  )
                  as BuiltList<AdminPayTablesDtoOutputMaxDistanceKmInner>;
          result.maxDistanceKm.replace(valueDes);
          break;
        case r'versions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPayTablesDtoOutputVersionsInner),
                    ]),
                  )
                  as BuiltList<AdminPayTablesDtoOutputVersionsInner>;
          result.versions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablesDtoOutputBuilder();
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
