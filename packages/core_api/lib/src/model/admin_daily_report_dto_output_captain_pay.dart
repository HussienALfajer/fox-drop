//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_captain_pay.g.dart';

/// AdminDailyReportDtoOutputCaptainPay
///
/// Properties:
/// * [base_]
/// * [distance]
/// * [waiting]
/// * [peak]
/// * [bonuses]
/// * [total]
@BuiltValue()
abstract class AdminDailyReportDtoOutputCaptainPay
    implements
        Built<
          AdminDailyReportDtoOutputCaptainPay,
          AdminDailyReportDtoOutputCaptainPayBuilder
        > {
  @BuiltValueField(wireName: r'base')
  String get base_;

  @BuiltValueField(wireName: r'distance')
  String get distance;

  @BuiltValueField(wireName: r'waiting')
  String get waiting;

  @BuiltValueField(wireName: r'peak')
  String get peak;

  @BuiltValueField(wireName: r'bonuses')
  String get bonuses;

  @BuiltValueField(wireName: r'total')
  String get total;

  AdminDailyReportDtoOutputCaptainPay._();

  factory AdminDailyReportDtoOutputCaptainPay([
    void updates(AdminDailyReportDtoOutputCaptainPayBuilder b),
  ]) = _$AdminDailyReportDtoOutputCaptainPay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputCaptainPayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputCaptainPay> get serializer =>
      _$AdminDailyReportDtoOutputCaptainPaySerializer();
}

class _$AdminDailyReportDtoOutputCaptainPaySerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputCaptainPay> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputCaptainPay,
    _$AdminDailyReportDtoOutputCaptainPay,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputCaptainPay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputCaptainPay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(String),
    );
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(String),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(String),
    );
    yield r'peak';
    yield serializers.serialize(
      object.peak,
      specifiedType: const FullType(String),
    );
    yield r'bonuses';
    yield serializers.serialize(
      object.bonuses,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputCaptainPay object, {
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
    required AdminDailyReportDtoOutputCaptainPayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'base':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.base_ = valueDes;
          break;
        case r'distance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.distance = valueDes;
          break;
        case r'waiting':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.waiting = valueDes;
          break;
        case r'peak':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.peak = valueDes;
          break;
        case r'bonuses':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.bonuses = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputCaptainPay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputCaptainPayBuilder();
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
