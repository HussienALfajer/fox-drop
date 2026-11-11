//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_save_profile_dto.g.dart';

/// CustomerSaveProfileDto
///
/// Properties:
/// * [firstName] - «الاسم»: 2 to 30 Arabic or Latin letters, spaces and «-».
/// * [lastName] - «الكنية», optional, the same rule.
/// * [gender] - «ذكر» male or «أنثى» female.
/// * [birthday] - «تاريخ الميلاد», optional, a past date.
/// * [acceptTerms] - «أوافق على الشروط وسياسة الخصوصية»: needed the first time only.
@BuiltValue()
abstract class CustomerSaveProfileDto
    implements Built<CustomerSaveProfileDto, CustomerSaveProfileDtoBuilder> {
  /// «الاسم»: 2 to 30 Arabic or Latin letters, spaces and «-».
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  /// «الكنية», optional, the same rule.
  @BuiltValueField(wireName: r'lastName')
  String? get lastName;

  /// «ذكر» male or «أنثى» female.
  @BuiltValueField(wireName: r'gender')
  CustomerSaveProfileDtoGenderEnum get gender;
  // enum genderEnum {  male,  female,  };

  /// «تاريخ الميلاد», optional, a past date.
  @BuiltValueField(wireName: r'birthday')
  Date? get birthday;

  /// «أوافق على الشروط وسياسة الخصوصية»: needed the first time only.
  @BuiltValueField(wireName: r'acceptTerms')
  bool get acceptTerms;

  CustomerSaveProfileDto._();

  factory CustomerSaveProfileDto([
    void updates(CustomerSaveProfileDtoBuilder b),
  ]) = _$CustomerSaveProfileDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSaveProfileDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSaveProfileDto> get serializer =>
      _$CustomerSaveProfileDtoSerializer();
}

class _$CustomerSaveProfileDtoSerializer
    implements PrimitiveSerializer<CustomerSaveProfileDto> {
  @override
  final Iterable<Type> types = const [
    CustomerSaveProfileDto,
    _$CustomerSaveProfileDto,
  ];

  @override
  final String wireName = r'CustomerSaveProfileDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSaveProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield object.lastName == null
        ? null
        : serializers.serialize(
            object.lastName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'gender';
    yield serializers.serialize(
      object.gender,
      specifiedType: const FullType(CustomerSaveProfileDtoGenderEnum),
    );
    yield r'birthday';
    yield object.birthday == null
        ? null
        : serializers.serialize(
            object.birthday,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'acceptTerms';
    yield serializers.serialize(
      object.acceptTerms,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSaveProfileDto object, {
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
    required CustomerSaveProfileDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.lastName = valueDes;
          break;
        case r'gender':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerSaveProfileDtoGenderEnum,
                    ),
                  )
                  as CustomerSaveProfileDtoGenderEnum;
          result.gender = valueDes;
          break;
        case r'birthday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.birthday = valueDes;
          break;
        case r'acceptTerms':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.acceptTerms = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSaveProfileDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSaveProfileDtoBuilder();
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

/// «ذكر» male or «أنثى» female.
class CustomerSaveProfileDtoGenderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'male')
  static const CustomerSaveProfileDtoGenderEnum male =
      _$customerSaveProfileDtoGenderEnum_male;
  @BuiltValueEnumConst(wireName: r'female')
  static const CustomerSaveProfileDtoGenderEnum female =
      _$customerSaveProfileDtoGenderEnum_female;

  static Serializer<CustomerSaveProfileDtoGenderEnum> get serializer =>
      _$customerSaveProfileDtoGenderEnumSerializer;

  const CustomerSaveProfileDtoGenderEnum._(String name) : super(name);

  static BuiltSet<CustomerSaveProfileDtoGenderEnum> get values =>
      _$customerSaveProfileDtoGenderEnumValues;
  static CustomerSaveProfileDtoGenderEnum valueOf(String name) =>
      _$customerSaveProfileDtoGenderEnumValueOf(name);
}
