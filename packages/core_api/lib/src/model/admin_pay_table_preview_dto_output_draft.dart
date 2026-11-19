//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_pay_table_preview_dto_output_in_force_base.dart';
import 'package:core_api/src/model/admin_pay_table_preview_dto_output_in_force_total.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_table_preview_dto_output_draft.g.dart';

/// By the rate typed; null without one or without a base.
///
/// Properties:
/// * [base_]
/// * [distance]
/// * [topUp]
/// * [orderPay]
/// * [waiting]
/// * [total]
@BuiltValue()
abstract class AdminPayTablePreviewDtoOutputDraft
    implements
        Built<
          AdminPayTablePreviewDtoOutputDraft,
          AdminPayTablePreviewDtoOutputDraftBuilder
        > {
  @BuiltValueField(wireName: r'base')
  AdminPayTablePreviewDtoOutputInForceBase get base_;

  @BuiltValueField(wireName: r'distance')
  AdminPayTablePreviewDtoOutputInForceBase get distance;

  @BuiltValueField(wireName: r'topUp')
  AdminPayTablePreviewDtoOutputInForceBase get topUp;

  @BuiltValueField(wireName: r'orderPay')
  AdminPayTablePreviewDtoOutputInForceBase get orderPay;

  @BuiltValueField(wireName: r'waiting')
  AdminPayTablePreviewDtoOutputInForceBase get waiting;

  @BuiltValueField(wireName: r'total')
  AdminPayTablePreviewDtoOutputInForceTotal get total;

  AdminPayTablePreviewDtoOutputDraft._();

  factory AdminPayTablePreviewDtoOutputDraft([
    void updates(AdminPayTablePreviewDtoOutputDraftBuilder b),
  ]) = _$AdminPayTablePreviewDtoOutputDraft;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablePreviewDtoOutputDraftBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablePreviewDtoOutputDraft> get serializer =>
      _$AdminPayTablePreviewDtoOutputDraftSerializer();
}

class _$AdminPayTablePreviewDtoOutputDraftSerializer
    implements PrimitiveSerializer<AdminPayTablePreviewDtoOutputDraft> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablePreviewDtoOutputDraft,
    _$AdminPayTablePreviewDtoOutputDraft,
  ];

  @override
  final String wireName = r'AdminPayTablePreviewDtoOutputDraft';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablePreviewDtoOutputDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceBase),
    );
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceBase),
    );
    yield r'topUp';
    yield serializers.serialize(
      object.topUp,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceBase),
    );
    yield r'orderPay';
    yield serializers.serialize(
      object.orderPay,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceBase),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceBase),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceTotal),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablePreviewDtoOutputDraft object, {
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
    required AdminPayTablePreviewDtoOutputDraftBuilder result,
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
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceBase,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceBase;
          result.base_.replace(valueDes);
          break;
        case r'distance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceBase,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceBase;
          result.distance.replace(valueDes);
          break;
        case r'topUp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceBase,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceBase;
          result.topUp.replace(valueDes);
          break;
        case r'orderPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceBase,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceBase;
          result.orderPay.replace(valueDes);
          break;
        case r'waiting':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceBase,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceBase;
          result.waiting.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceTotal,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceTotal;
          result.total.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablePreviewDtoOutputDraft deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablePreviewDtoOutputDraftBuilder();
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
