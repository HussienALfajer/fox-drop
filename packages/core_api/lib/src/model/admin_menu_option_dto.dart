//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_money.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_option_dto.g.dart';

/// AdminMenuOptionDto
///
/// Properties:
/// * [name]
/// * [priceDelta] - 0 or more, in the city's base currency.
/// * [removed] - true removes the option for good.
@BuiltValue()
abstract class AdminMenuOptionDto
    implements Built<AdminMenuOptionDto, AdminMenuOptionDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// 0 or more, in the city's base currency.
  @BuiltValueField(wireName: r'priceDelta')
  AdminMenuMoney get priceDelta;

  /// true removes the option for good.
  @BuiltValueField(wireName: r'removed')
  bool get removed;

  AdminMenuOptionDto._();

  factory AdminMenuOptionDto([void updates(AdminMenuOptionDtoBuilder b)]) =
      _$AdminMenuOptionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuOptionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuOptionDto> get serializer =>
      _$AdminMenuOptionDtoSerializer();
}

class _$AdminMenuOptionDtoSerializer
    implements PrimitiveSerializer<AdminMenuOptionDto> {
  @override
  final Iterable<Type> types = const [AdminMenuOptionDto, _$AdminMenuOptionDto];

  @override
  final String wireName = r'AdminMenuOptionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuOptionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(AdminMenuMoney),
    );
    yield r'removed';
    yield serializers.serialize(
      object.removed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuOptionDto object, {
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
    required AdminMenuOptionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminMenuMoney),
                  )
                  as AdminMenuMoney;
          result.priceDelta.replace(valueDes);
          break;
        case r'removed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.removed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuOptionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuOptionDtoBuilder();
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
