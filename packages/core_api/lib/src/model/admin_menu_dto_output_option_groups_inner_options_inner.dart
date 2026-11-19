//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_money_output.dart';
import 'package:core_api/src/model/admin_menu_switched_off_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_dto_output_option_groups_inner_options_inner.g.dart';

/// AdminMenuDtoOutputOptionGroupsInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta]
/// * [switchedOff] - Its own switch off (RA §9.3); null while on.
@BuiltValue()
abstract class AdminMenuDtoOutputOptionGroupsInnerOptionsInner
    implements
        Built<
          AdminMenuDtoOutputOptionGroupsInnerOptionsInner,
          AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  AdminMenuMoneyOutput get priceDelta;

  /// Its own switch off (RA §9.3); null while on.
  @BuiltValueField(wireName: r'switchedOff')
  AdminMenuSwitchedOffOutput? get switchedOff;

  AdminMenuDtoOutputOptionGroupsInnerOptionsInner._();

  factory AdminMenuDtoOutputOptionGroupsInnerOptionsInner([
    void updates(AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder b),
  ]) = _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuDtoOutputOptionGroupsInnerOptionsInner>
  get serializer =>
      _$AdminMenuDtoOutputOptionGroupsInnerOptionsInnerSerializer();
}

class _$AdminMenuDtoOutputOptionGroupsInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<AdminMenuDtoOutputOptionGroupsInnerOptionsInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuDtoOutputOptionGroupsInnerOptionsInner,
    _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner,
  ];

  @override
  final String wireName = r'AdminMenuDtoOutputOptionGroupsInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuDtoOutputOptionGroupsInnerOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(AdminMenuMoneyOutput),
    );
    yield r'switchedOff';
    yield object.switchedOff == null
        ? null
        : serializers.serialize(
            object.switchedOff,
            specifiedType: const FullType.nullable(AdminMenuSwitchedOffOutput),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutputOptionGroupsInnerOptionsInner object, {
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
    required AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
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
                    specifiedType: const FullType(AdminMenuMoneyOutput),
                  )
                  as AdminMenuMoneyOutput;
          result.priceDelta.replace(valueDes);
          break;
        case r'switchedOff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuSwitchedOffOutput,
                    ),
                  )
                  as AdminMenuSwitchedOffOutput?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuDtoOutputOptionGroupsInnerOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder();
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
