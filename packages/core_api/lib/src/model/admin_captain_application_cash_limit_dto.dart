//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_application_cash_limit_dto_cash_limit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_cash_limit_dto.g.dart';

/// AdminCaptainApplicationCashLimitDto
///
/// Properties:
/// * [cashLimit]
@BuiltValue()
abstract class AdminCaptainApplicationCashLimitDto
    implements
        Built<
          AdminCaptainApplicationCashLimitDto,
          AdminCaptainApplicationCashLimitDtoBuilder
        > {
  @BuiltValueField(wireName: r'cashLimit')
  AdminCaptainApplicationCashLimitDtoCashLimit get cashLimit;

  AdminCaptainApplicationCashLimitDto._();

  factory AdminCaptainApplicationCashLimitDto([
    void updates(AdminCaptainApplicationCashLimitDtoBuilder b),
  ]) = _$AdminCaptainApplicationCashLimitDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationCashLimitDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationCashLimitDto> get serializer =>
      _$AdminCaptainApplicationCashLimitDtoSerializer();
}

class _$AdminCaptainApplicationCashLimitDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationCashLimitDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationCashLimitDto,
    _$AdminCaptainApplicationCashLimitDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationCashLimitDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationCashLimitDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cashLimit';
    yield serializers.serialize(
      object.cashLimit,
      specifiedType: const FullType(
        AdminCaptainApplicationCashLimitDtoCashLimit,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationCashLimitDto object, {
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
    required AdminCaptainApplicationCashLimitDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cashLimit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationCashLimitDtoCashLimit,
                    ),
                  )
                  as AdminCaptainApplicationCashLimitDtoCashLimit;
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
  AdminCaptainApplicationCashLimitDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationCashLimitDtoBuilder();
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
