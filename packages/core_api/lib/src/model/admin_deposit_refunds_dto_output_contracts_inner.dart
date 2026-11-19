//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_deposit_refunds_dto_output_contracts_inner_held.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposit_refunds_dto_output_contracts_inner.g.dart';

/// AdminDepositRefundsDtoOutputContractsInner
///
/// Properties:
/// * [applicationId]
/// * [captainId]
/// * [fullName]
/// * [terminatedAt]
/// * [earlyExit] - Ended in «فترة التزام»: «خروج مبكر».
/// * [kitReturned] - The checklist’s step 1; null until OPS checked the kit.
/// * [held]
@BuiltValue()
abstract class AdminDepositRefundsDtoOutputContractsInner
    implements
        Built<
          AdminDepositRefundsDtoOutputContractsInner,
          AdminDepositRefundsDtoOutputContractsInnerBuilder
        > {
  @BuiltValueField(wireName: r'applicationId')
  String get applicationId;

  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'terminatedAt')
  DateTime get terminatedAt;

  /// Ended in «فترة التزام»: «خروج مبكر».
  @BuiltValueField(wireName: r'earlyExit')
  bool get earlyExit;

  /// The checklist’s step 1; null until OPS checked the kit.
  @BuiltValueField(wireName: r'kitReturned')
  bool? get kitReturned;

  @BuiltValueField(wireName: r'held')
  AdminDepositRefundsDtoOutputContractsInnerHeld get held;

  AdminDepositRefundsDtoOutputContractsInner._();

  factory AdminDepositRefundsDtoOutputContractsInner([
    void updates(AdminDepositRefundsDtoOutputContractsInnerBuilder b),
  ]) = _$AdminDepositRefundsDtoOutputContractsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDepositRefundsDtoOutputContractsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositRefundsDtoOutputContractsInner>
  get serializer => _$AdminDepositRefundsDtoOutputContractsInnerSerializer();
}

class _$AdminDepositRefundsDtoOutputContractsInnerSerializer
    implements PrimitiveSerializer<AdminDepositRefundsDtoOutputContractsInner> {
  @override
  final Iterable<Type> types = const [
    AdminDepositRefundsDtoOutputContractsInner,
    _$AdminDepositRefundsDtoOutputContractsInner,
  ];

  @override
  final String wireName = r'AdminDepositRefundsDtoOutputContractsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositRefundsDtoOutputContractsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applicationId';
    yield serializers.serialize(
      object.applicationId,
      specifiedType: const FullType(String),
    );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'terminatedAt';
    yield serializers.serialize(
      object.terminatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'earlyExit';
    yield serializers.serialize(
      object.earlyExit,
      specifiedType: const FullType(bool),
    );
    yield r'kitReturned';
    yield object.kitReturned == null
        ? null
        : serializers.serialize(
            object.kitReturned,
            specifiedType: const FullType.nullable(bool),
          );
    yield r'held';
    yield serializers.serialize(
      object.held,
      specifiedType: const FullType(
        AdminDepositRefundsDtoOutputContractsInnerHeld,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDepositRefundsDtoOutputContractsInner object, {
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
    required AdminDepositRefundsDtoOutputContractsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'applicationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.applicationId = valueDes;
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
        case r'fullName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fullName = valueDes;
          break;
        case r'terminatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.terminatedAt = valueDes;
          break;
        case r'earlyExit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.earlyExit = valueDes;
          break;
        case r'kitReturned':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.kitReturned = valueDes;
          break;
        case r'held':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDepositRefundsDtoOutputContractsInnerHeld,
                    ),
                  )
                  as AdminDepositRefundsDtoOutputContractsInnerHeld;
          result.held.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDepositRefundsDtoOutputContractsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositRefundsDtoOutputContractsInnerBuilder();
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
