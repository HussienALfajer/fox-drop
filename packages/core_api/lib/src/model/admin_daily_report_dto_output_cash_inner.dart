//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_cash_inner.g.dart';

/// AdminDailyReportDtoOutputCashInner
///
/// Properties:
/// * [currency]
/// * [custodyCreated]
/// * [handedIn]
/// * [reimbursed]
/// * [openCustody]
/// * [owedToCaptains]
/// * [captainPayouts]
/// * [restaurantPayments]
@BuiltValue()
abstract class AdminDailyReportDtoOutputCashInner
    implements
        Built<
          AdminDailyReportDtoOutputCashInner,
          AdminDailyReportDtoOutputCashInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'custodyCreated')
  String get custodyCreated;

  @BuiltValueField(wireName: r'handedIn')
  String get handedIn;

  @BuiltValueField(wireName: r'reimbursed')
  String get reimbursed;

  @BuiltValueField(wireName: r'openCustody')
  String get openCustody;

  @BuiltValueField(wireName: r'owedToCaptains')
  String get owedToCaptains;

  @BuiltValueField(wireName: r'captainPayouts')
  String get captainPayouts;

  @BuiltValueField(wireName: r'restaurantPayments')
  String get restaurantPayments;

  AdminDailyReportDtoOutputCashInner._();

  factory AdminDailyReportDtoOutputCashInner([
    void updates(AdminDailyReportDtoOutputCashInnerBuilder b),
  ]) = _$AdminDailyReportDtoOutputCashInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputCashInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputCashInner> get serializer =>
      _$AdminDailyReportDtoOutputCashInnerSerializer();
}

class _$AdminDailyReportDtoOutputCashInnerSerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputCashInner> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputCashInner,
    _$AdminDailyReportDtoOutputCashInner,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputCashInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputCashInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'custodyCreated';
    yield serializers.serialize(
      object.custodyCreated,
      specifiedType: const FullType(String),
    );
    yield r'handedIn';
    yield serializers.serialize(
      object.handedIn,
      specifiedType: const FullType(String),
    );
    yield r'reimbursed';
    yield serializers.serialize(
      object.reimbursed,
      specifiedType: const FullType(String),
    );
    yield r'openCustody';
    yield serializers.serialize(
      object.openCustody,
      specifiedType: const FullType(String),
    );
    yield r'owedToCaptains';
    yield serializers.serialize(
      object.owedToCaptains,
      specifiedType: const FullType(String),
    );
    yield r'captainPayouts';
    yield serializers.serialize(
      object.captainPayouts,
      specifiedType: const FullType(String),
    );
    yield r'restaurantPayments';
    yield serializers.serialize(
      object.restaurantPayments,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputCashInner object, {
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
    required AdminDailyReportDtoOutputCashInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'custodyCreated':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.custodyCreated = valueDes;
          break;
        case r'handedIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.handedIn = valueDes;
          break;
        case r'reimbursed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reimbursed = valueDes;
          break;
        case r'openCustody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.openCustody = valueDes;
          break;
        case r'owedToCaptains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.owedToCaptains = valueDes;
          break;
        case r'captainPayouts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainPayouts = valueDes;
          break;
        case r'restaurantPayments':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantPayments = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputCashInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputCashInnerBuilder();
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
