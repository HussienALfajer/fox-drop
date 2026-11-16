//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_closed_due.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_usage.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_remit_tolerance.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_availability_dto_output_custody.g.dart';

/// CaptainAvailabilityDtoOutputCustody
///
/// Properties:
/// * [usage]
/// * [limit]
/// * [warn] - At captain.custody_warn_pct of the limit or more.
/// * [closedDue]
/// * [lastCutoff]
/// * [remitTolerance]
/// * [handInGraceUntil] - AP §8.5.4, CA §10.3: the end of the hand-in grace running now («مُنحت مهلة حتى {الساعة}»), or null.
/// * [remitBy] - AP §8.5.4, CA §10.3: online across the last cutoff with cash due from closed days, the moment offers stop unless the captain hands in («سلّم نقد أمس قبل {الساعة} لتستمر العروض»); null otherwise.
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputCustody
    implements
        Built<
          CaptainAvailabilityDtoOutputCustody,
          CaptainAvailabilityDtoOutputCustodyBuilder
        > {
  @BuiltValueField(wireName: r'usage')
  CaptainAvailabilityDtoOutputCustodyUsage get usage;

  @BuiltValueField(wireName: r'limit')
  CaptainAvailabilityDtoOutputCustodyLimit get limit;

  /// At captain.custody_warn_pct of the limit or more.
  @BuiltValueField(wireName: r'warn')
  bool get warn;

  @BuiltValueField(wireName: r'closedDue')
  CaptainAvailabilityDtoOutputCustodyClosedDue get closedDue;

  @BuiltValueField(wireName: r'lastCutoff')
  DateTime get lastCutoff;

  @BuiltValueField(wireName: r'remitTolerance')
  CaptainAvailabilityDtoOutputCustodyRemitTolerance get remitTolerance;

  /// AP §8.5.4, CA §10.3: the end of the hand-in grace running now («مُنحت مهلة حتى {الساعة}»), or null.
  @BuiltValueField(wireName: r'handInGraceUntil')
  DateTime? get handInGraceUntil;

  /// AP §8.5.4, CA §10.3: online across the last cutoff with cash due from closed days, the moment offers stop unless the captain hands in («سلّم نقد أمس قبل {الساعة} لتستمر العروض»); null otherwise.
  @BuiltValueField(wireName: r'remitBy')
  DateTime? get remitBy;

  CaptainAvailabilityDtoOutputCustody._();

  factory CaptainAvailabilityDtoOutputCustody([
    void updates(CaptainAvailabilityDtoOutputCustodyBuilder b),
  ]) = _$CaptainAvailabilityDtoOutputCustody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAvailabilityDtoOutputCustodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputCustody> get serializer =>
      _$CaptainAvailabilityDtoOutputCustodySerializer();
}

class _$CaptainAvailabilityDtoOutputCustodySerializer
    implements PrimitiveSerializer<CaptainAvailabilityDtoOutputCustody> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputCustody,
    _$CaptainAvailabilityDtoOutputCustody,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputCustody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputCustody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyUsage),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
    );
    yield r'warn';
    yield serializers.serialize(
      object.warn,
      specifiedType: const FullType(bool),
    );
    yield r'closedDue';
    yield serializers.serialize(
      object.closedDue,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputCustodyClosedDue,
      ),
    );
    yield r'lastCutoff';
    yield serializers.serialize(
      object.lastCutoff,
      specifiedType: const FullType(DateTime),
    );
    yield r'remitTolerance';
    yield serializers.serialize(
      object.remitTolerance,
      specifiedType: const FullType(
        CaptainAvailabilityDtoOutputCustodyRemitTolerance,
      ),
    );
    yield r'handInGraceUntil';
    yield object.handInGraceUntil == null
        ? null
        : serializers.serialize(
            object.handInGraceUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'remitBy';
    yield object.remitBy == null
        ? null
        : serializers.serialize(
            object.remitBy,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputCustody object, {
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
    required CaptainAvailabilityDtoOutputCustodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyUsage,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyLimit,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyLimit;
          result.limit.replace(valueDes);
          break;
        case r'warn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.warn = valueDes;
          break;
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyClosedDue,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyClosedDue;
          result.closedDue.replace(valueDes);
          break;
        case r'lastCutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastCutoff = valueDes;
          break;
        case r'remitTolerance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyRemitTolerance,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyRemitTolerance;
          result.remitTolerance.replace(valueDes);
          break;
        case r'handInGraceUntil':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.handInGraceUntil = valueDes;
          break;
        case r'remitBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.remitBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainAvailabilityDtoOutputCustody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputCustodyBuilder();
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
