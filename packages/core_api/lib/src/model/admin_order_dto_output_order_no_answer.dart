//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_no_answer_pings_inner.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_no_answer_reports_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_no_answer.g.dart';

/// CA §9.9 (slice 2.13d): the customer not answering at the door.
///
/// Properties:
/// * [pings] - Every «تنبيه الزبون» of the order, oldest first.
/// * [reports] - Every «الزبون لا يستجيب», oldest first, with operations' «انتظر».
/// * [waitAllowed] - «انتظر» is open: the order's captain at the door has a report waiting.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderNoAnswer
    implements
        Built<
          AdminOrderDtoOutputOrderNoAnswer,
          AdminOrderDtoOutputOrderNoAnswerBuilder
        > {
  /// Every «تنبيه الزبون» of the order, oldest first.
  @BuiltValueField(wireName: r'pings')
  BuiltList<AdminOrderDtoOutputOrderNoAnswerPingsInner> get pings;

  /// Every «الزبون لا يستجيب», oldest first, with operations' «انتظر».
  @BuiltValueField(wireName: r'reports')
  BuiltList<AdminOrderDtoOutputOrderNoAnswerReportsInner> get reports;

  /// «انتظر» is open: the order's captain at the door has a report waiting.
  @BuiltValueField(wireName: r'waitAllowed')
  bool get waitAllowed;

  AdminOrderDtoOutputOrderNoAnswer._();

  factory AdminOrderDtoOutputOrderNoAnswer([
    void updates(AdminOrderDtoOutputOrderNoAnswerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderNoAnswer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderNoAnswerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderNoAnswer> get serializer =>
      _$AdminOrderDtoOutputOrderNoAnswerSerializer();
}

class _$AdminOrderDtoOutputOrderNoAnswerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderNoAnswer> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderNoAnswer,
    _$AdminOrderDtoOutputOrderNoAnswer,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderNoAnswer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pings';
    yield serializers.serialize(
      object.pings,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderNoAnswerPingsInner),
      ]),
    );
    yield r'reports';
    yield serializers.serialize(
      object.reports,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderNoAnswerReportsInner),
      ]),
    );
    yield r'waitAllowed';
    yield serializers.serialize(
      object.waitAllowed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderNoAnswer object, {
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
    required AdminOrderDtoOutputOrderNoAnswerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderNoAnswerPingsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderNoAnswerPingsInner>;
          result.pings.replace(valueDes);
          break;
        case r'reports':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderNoAnswerReportsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderNoAnswerReportsInner>;
          result.reports.replace(valueDes);
          break;
        case r'waitAllowed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.waitAllowed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderNoAnswer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderNoAnswerBuilder();
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
