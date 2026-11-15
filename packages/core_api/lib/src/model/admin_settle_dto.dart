//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_settle_dto_payout.dart';
import 'package:core_api/src/model/admin_settle_dto_custody_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settle_dto.g.dart';

/// AdminSettleDto
///
/// Properties:
/// * [captainId]
/// * [custody] - The custody the preview showed, every currency settled to zero.
/// * [earnings] - The earnings the preview showed.
/// * [payout]
/// * [reason] - Required off the payout day (OWN only).
@BuiltValue()
abstract class AdminSettleDto
    implements Built<AdminSettleDto, AdminSettleDtoBuilder> {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// The custody the preview showed, every currency settled to zero.
  @BuiltValueField(wireName: r'custody')
  BuiltList<AdminSettleDtoCustodyInner> get custody;

  /// The earnings the preview showed.
  @BuiltValueField(wireName: r'earnings')
  String get earnings;

  @BuiltValueField(wireName: r'payout')
  AdminSettleDtoPayout? get payout;

  /// Required off the payout day (OWN only).
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminSettleDto._();

  factory AdminSettleDto([void updates(AdminSettleDtoBuilder b)]) =
      _$AdminSettleDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettleDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettleDto> get serializer =>
      _$AdminSettleDtoSerializer();
}

class _$AdminSettleDtoSerializer
    implements PrimitiveSerializer<AdminSettleDto> {
  @override
  final Iterable<Type> types = const [AdminSettleDto, _$AdminSettleDto];

  @override
  final String wireName = r'AdminSettleDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSettleDtoCustodyInner),
      ]),
    );
    yield r'earnings';
    yield serializers.serialize(
      object.earnings,
      specifiedType: const FullType(String),
    );
    yield r'payout';
    yield object.payout == null
        ? null
        : serializers.serialize(
            object.payout,
            specifiedType: const FullType.nullable(AdminSettleDtoPayout),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettleDto object, {
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
    required AdminSettleDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'custody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSettleDtoCustodyInner),
                    ]),
                  )
                  as BuiltList<AdminSettleDtoCustodyInner>;
          result.custody.replace(valueDes);
          break;
        case r'earnings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.earnings = valueDes;
          break;
        case r'payout':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminSettleDtoPayout,
                    ),
                  )
                  as AdminSettleDtoPayout?;
          if (valueDes == null) continue;
          result.payout.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettleDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettleDtoBuilder();
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
