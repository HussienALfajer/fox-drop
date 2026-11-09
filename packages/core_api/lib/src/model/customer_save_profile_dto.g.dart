// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_save_profile_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerSaveProfileDtoGenderEnum _$customerSaveProfileDtoGenderEnum_male =
    const CustomerSaveProfileDtoGenderEnum._('male');
const CustomerSaveProfileDtoGenderEnum
_$customerSaveProfileDtoGenderEnum_female =
    const CustomerSaveProfileDtoGenderEnum._('female');

CustomerSaveProfileDtoGenderEnum _$customerSaveProfileDtoGenderEnumValueOf(
  String name,
) {
  switch (name) {
    case 'male':
      return _$customerSaveProfileDtoGenderEnum_male;
    case 'female':
      return _$customerSaveProfileDtoGenderEnum_female;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerSaveProfileDtoGenderEnum>
_$customerSaveProfileDtoGenderEnumValues =
    BuiltSet<CustomerSaveProfileDtoGenderEnum>(
      const <CustomerSaveProfileDtoGenderEnum>[
        _$customerSaveProfileDtoGenderEnum_male,
        _$customerSaveProfileDtoGenderEnum_female,
      ],
    );

Serializer<CustomerSaveProfileDtoGenderEnum>
_$customerSaveProfileDtoGenderEnumSerializer =
    _$CustomerSaveProfileDtoGenderEnumSerializer();

class _$CustomerSaveProfileDtoGenderEnumSerializer
    implements PrimitiveSerializer<CustomerSaveProfileDtoGenderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'male': 'male',
    'female': 'female',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'male': 'male',
    'female': 'female',
  };

  @override
  final Iterable<Type> types = const <Type>[CustomerSaveProfileDtoGenderEnum];
  @override
  final String wireName = 'CustomerSaveProfileDtoGenderEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerSaveProfileDtoGenderEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerSaveProfileDtoGenderEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerSaveProfileDtoGenderEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerSaveProfileDto extends CustomerSaveProfileDto {
  @override
  final String firstName;
  @override
  final String? lastName;
  @override
  final CustomerSaveProfileDtoGenderEnum gender;
  @override
  final Date? birthday;
  @override
  final bool acceptTerms;

  factory _$CustomerSaveProfileDto([
    void Function(CustomerSaveProfileDtoBuilder)? updates,
  ]) => (CustomerSaveProfileDtoBuilder()..update(updates))._build();

  _$CustomerSaveProfileDto._({
    required this.firstName,
    this.lastName,
    required this.gender,
    this.birthday,
    required this.acceptTerms,
  }) : super._();
  @override
  CustomerSaveProfileDto rebuild(
    void Function(CustomerSaveProfileDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSaveProfileDtoBuilder toBuilder() =>
      CustomerSaveProfileDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSaveProfileDto &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        birthday == other.birthday &&
        acceptTerms == other.acceptTerms;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, birthday.hashCode);
    _$hash = $jc(_$hash, acceptTerms.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSaveProfileDto')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('gender', gender)
          ..add('birthday', birthday)
          ..add('acceptTerms', acceptTerms))
        .toString();
  }
}

class CustomerSaveProfileDtoBuilder
    implements Builder<CustomerSaveProfileDto, CustomerSaveProfileDtoBuilder> {
  _$CustomerSaveProfileDto? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  CustomerSaveProfileDtoGenderEnum? _gender;
  CustomerSaveProfileDtoGenderEnum? get gender => _$this._gender;
  set gender(CustomerSaveProfileDtoGenderEnum? gender) =>
      _$this._gender = gender;

  Date? _birthday;
  Date? get birthday => _$this._birthday;
  set birthday(Date? birthday) => _$this._birthday = birthday;

  bool? _acceptTerms;
  bool? get acceptTerms => _$this._acceptTerms;
  set acceptTerms(bool? acceptTerms) => _$this._acceptTerms = acceptTerms;

  CustomerSaveProfileDtoBuilder() {
    CustomerSaveProfileDto._defaults(this);
  }

  CustomerSaveProfileDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _gender = $v.gender;
      _birthday = $v.birthday;
      _acceptTerms = $v.acceptTerms;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSaveProfileDto other) {
    _$v = other as _$CustomerSaveProfileDto;
  }

  @override
  void update(void Function(CustomerSaveProfileDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSaveProfileDto build() => _build();

  _$CustomerSaveProfileDto _build() {
    final _$result =
        _$v ??
        _$CustomerSaveProfileDto._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'CustomerSaveProfileDto',
            'firstName',
          ),
          lastName: lastName,
          gender: BuiltValueNullFieldError.checkNotNull(
            gender,
            r'CustomerSaveProfileDto',
            'gender',
          ),
          birthday: birthday,
          acceptTerms: BuiltValueNullFieldError.checkNotNull(
            acceptTerms,
            r'CustomerSaveProfileDto',
            'acceptTerms',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
