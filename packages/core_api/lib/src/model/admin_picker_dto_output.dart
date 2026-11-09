//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_picker_dto_output_captains_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_picker_dto_output.g.dart';

/// AdminPickerDtoOutput
///
/// Properties:
/// * [captains] - Every online captain of the city, nearest to the restaurant first (AP §9.3.2).
@BuiltValue()
abstract class AdminPickerDtoOutput implements Built<AdminPickerDtoOutput, AdminPickerDtoOutputBuilder> {
  /// Every online captain of the city, nearest to the restaurant first (AP §9.3.2).
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminPickerDtoOutputCaptainsInner> get captains;

  AdminPickerDtoOutput._();

  factory AdminPickerDtoOutput([void updates(AdminPickerDtoOutputBuilder b)]) = _$AdminPickerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPickerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPickerDtoOutput> get serializer => _$AdminPickerDtoOutputSerializer();
}

class _$AdminPickerDtoOutputSerializer implements PrimitiveSerializer<AdminPickerDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminPickerDtoOutput, _$AdminPickerDtoOutput];

  @override
  final String wireName = r'AdminPickerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPickerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [FullType(AdminPickerDtoOutputCaptainsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPickerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPickerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captains':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPickerDtoOutputCaptainsInner)]),
          ) as BuiltList<AdminPickerDtoOutputCaptainsInner>;
          result.captains.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPickerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPickerDtoOutputBuilder();
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


