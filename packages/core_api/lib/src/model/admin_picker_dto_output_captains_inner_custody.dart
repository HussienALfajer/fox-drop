//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_picker_dto_output_captains_inner_custody_limit.dart';
import 'package:core_api/src/model/admin_picker_dto_output_captains_inner_custody_usage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_picker_dto_output_captains_inner_custody.g.dart';

/// Cash-limit usage.
///
/// Properties:
/// * [usage]
/// * [limit]
@BuiltValue()
abstract class AdminPickerDtoOutputCaptainsInnerCustody
    implements
        Built<
          AdminPickerDtoOutputCaptainsInnerCustody,
          AdminPickerDtoOutputCaptainsInnerCustodyBuilder
        > {
  @BuiltValueField(wireName: r'usage')
  AdminPickerDtoOutputCaptainsInnerCustodyUsage get usage;

  @BuiltValueField(wireName: r'limit')
  AdminPickerDtoOutputCaptainsInnerCustodyLimit? get limit;

  AdminPickerDtoOutputCaptainsInnerCustody._();

  factory AdminPickerDtoOutputCaptainsInnerCustody([
    void updates(AdminPickerDtoOutputCaptainsInnerCustodyBuilder b),
  ]) = _$AdminPickerDtoOutputCaptainsInnerCustody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPickerDtoOutputCaptainsInnerCustodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPickerDtoOutputCaptainsInnerCustody> get serializer =>
      _$AdminPickerDtoOutputCaptainsInnerCustodySerializer();
}

class _$AdminPickerDtoOutputCaptainsInnerCustodySerializer
    implements PrimitiveSerializer<AdminPickerDtoOutputCaptainsInnerCustody> {
  @override
  final Iterable<Type> types = const [
    AdminPickerDtoOutputCaptainsInnerCustody,
    _$AdminPickerDtoOutputCaptainsInnerCustody,
  ];

  @override
  final String wireName = r'AdminPickerDtoOutputCaptainsInnerCustody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPickerDtoOutputCaptainsInnerCustody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(
        AdminPickerDtoOutputCaptainsInnerCustodyUsage,
      ),
    );
    yield r'limit';
    yield object.limit == null
        ? null
        : serializers.serialize(
            object.limit,
            specifiedType: const FullType.nullable(
              AdminPickerDtoOutputCaptainsInnerCustodyLimit,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPickerDtoOutputCaptainsInnerCustody object, {
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
    required AdminPickerDtoOutputCaptainsInnerCustodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPickerDtoOutputCaptainsInnerCustodyUsage,
                    ),
                  )
                  as AdminPickerDtoOutputCaptainsInnerCustodyUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminPickerDtoOutputCaptainsInnerCustodyLimit,
                    ),
                  )
                  as AdminPickerDtoOutputCaptainsInnerCustodyLimit?;
          if (valueDes == null) continue;
          result.limit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPickerDtoOutputCaptainsInnerCustody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPickerDtoOutputCaptainsInnerCustodyBuilder();
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
