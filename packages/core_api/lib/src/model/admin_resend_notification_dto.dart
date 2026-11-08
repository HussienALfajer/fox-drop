//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_resend_notification_dto.g.dart';

/// AdminResendNotificationDto
///
/// Properties:
/// * [to] - The customer, the restaurant's devices or the assigned captain.
@BuiltValue()
abstract class AdminResendNotificationDto
    implements
        Built<AdminResendNotificationDto, AdminResendNotificationDtoBuilder> {
  /// The customer, the restaurant's devices or the assigned captain.
  @BuiltValueField(wireName: r'to')
  AdminResendNotificationDtoToEnum get to;
  // enum toEnum {  customer,  merchant,  captain,  };

  AdminResendNotificationDto._();

  factory AdminResendNotificationDto([
    void updates(AdminResendNotificationDtoBuilder b),
  ]) = _$AdminResendNotificationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminResendNotificationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminResendNotificationDto> get serializer =>
      _$AdminResendNotificationDtoSerializer();
}

class _$AdminResendNotificationDtoSerializer
    implements PrimitiveSerializer<AdminResendNotificationDto> {
  @override
  final Iterable<Type> types = const [
    AdminResendNotificationDto,
    _$AdminResendNotificationDto,
  ];

  @override
  final String wireName = r'AdminResendNotificationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminResendNotificationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(AdminResendNotificationDtoToEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminResendNotificationDto object, {
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
    required AdminResendNotificationDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminResendNotificationDtoToEnum,
                    ),
                  )
                  as AdminResendNotificationDtoToEnum;
          result.to = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminResendNotificationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminResendNotificationDtoBuilder();
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

/// The customer, the restaurant's devices or the assigned captain.
class AdminResendNotificationDtoToEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminResendNotificationDtoToEnum customer =
      _$adminResendNotificationDtoToEnum_customer;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const AdminResendNotificationDtoToEnum merchant =
      _$adminResendNotificationDtoToEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminResendNotificationDtoToEnum captain =
      _$adminResendNotificationDtoToEnum_captain;

  static Serializer<AdminResendNotificationDtoToEnum> get serializer =>
      _$adminResendNotificationDtoToEnumSerializer;

  const AdminResendNotificationDtoToEnum._(String name) : super(name);

  static BuiltSet<AdminResendNotificationDtoToEnum> get values =>
      _$adminResendNotificationDtoToEnumValues;
  static AdminResendNotificationDtoToEnum valueOf(String name) =>
      _$adminResendNotificationDtoToEnumValueOf(name);
}
