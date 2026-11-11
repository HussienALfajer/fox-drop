//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_set_peak_bonus_dto_windows_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_peak_bonus_dto.g.dart';

/// AdminSetPeakBonusDto
///
/// Properties:
/// * [cityId]
/// * [enabled]
/// * [windows]
@BuiltValue()
abstract class AdminSetPeakBonusDto
    implements Built<AdminSetPeakBonusDto, AdminSetPeakBonusDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'windows')
  BuiltList<AdminSetPeakBonusDtoWindowsInner> get windows;

  AdminSetPeakBonusDto._();

  factory AdminSetPeakBonusDto([void updates(AdminSetPeakBonusDtoBuilder b)]) =
      _$AdminSetPeakBonusDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetPeakBonusDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetPeakBonusDto> get serializer =>
      _$AdminSetPeakBonusDtoSerializer();
}

class _$AdminSetPeakBonusDtoSerializer
    implements PrimitiveSerializer<AdminSetPeakBonusDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetPeakBonusDto,
    _$AdminSetPeakBonusDto,
  ];

  @override
  final String wireName = r'AdminSetPeakBonusDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetPeakBonusDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'windows';
    yield serializers.serialize(
      object.windows,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSetPeakBonusDtoWindowsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetPeakBonusDto object, {
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
    required AdminSetPeakBonusDtoBuilder result,
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
        case r'enabled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.enabled = valueDes;
          break;
        case r'windows':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSetPeakBonusDtoWindowsInner),
                    ]),
                  )
                  as BuiltList<AdminSetPeakBonusDtoWindowsInner>;
          result.windows.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetPeakBonusDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetPeakBonusDtoBuilder();
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
