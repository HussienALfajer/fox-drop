//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_deposit_cash_limit_dto_cash_limit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_deposit_cash_limit_dto.g.dart';

/// AdminDepositCashLimitDto
///
/// Properties:
/// * [cityId]
/// * [cashLimit]
@BuiltValue()
abstract class AdminDepositCashLimitDto
    implements
        Built<AdminDepositCashLimitDto, AdminDepositCashLimitDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'cashLimit')
  AdminDepositCashLimitDtoCashLimit get cashLimit;

  AdminDepositCashLimitDto._();

  factory AdminDepositCashLimitDto([
    void updates(AdminDepositCashLimitDtoBuilder b),
  ]) = _$AdminDepositCashLimitDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDepositCashLimitDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDepositCashLimitDto> get serializer =>
      _$AdminDepositCashLimitDtoSerializer();
}

class _$AdminDepositCashLimitDtoSerializer
    implements PrimitiveSerializer<AdminDepositCashLimitDto> {
  @override
  final Iterable<Type> types = const [
    AdminDepositCashLimitDto,
    _$AdminDepositCashLimitDto,
  ];

  @override
  final String wireName = r'AdminDepositCashLimitDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDepositCashLimitDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'cashLimit';
    yield serializers.serialize(
      object.cashLimit,
      specifiedType: const FullType(AdminDepositCashLimitDtoCashLimit),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDepositCashLimitDto object, {
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
    required AdminDepositCashLimitDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'cashLimit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDepositCashLimitDtoCashLimit,
                    ),
                  )
                  as AdminDepositCashLimitDtoCashLimit;
          result.cashLimit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDepositCashLimitDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDepositCashLimitDtoBuilder();
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
