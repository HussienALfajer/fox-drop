//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_staff_dto_output_staff_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_staff_dto_output.g.dart';

/// MerchantStaffDtoOutput
///
/// Properties:
/// * [staff] - Owners first (read-only in the app, RA §5.1), then cashiers, oldest first.
@BuiltValue()
abstract class MerchantStaffDtoOutput
    implements Built<MerchantStaffDtoOutput, MerchantStaffDtoOutputBuilder> {
  /// Owners first (read-only in the app, RA §5.1), then cashiers, oldest first.
  @BuiltValueField(wireName: r'staff')
  BuiltList<MerchantStaffDtoOutputStaffInner> get staff;

  MerchantStaffDtoOutput._();

  factory MerchantStaffDtoOutput([
    void updates(MerchantStaffDtoOutputBuilder b),
  ]) = _$MerchantStaffDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStaffDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStaffDtoOutput> get serializer =>
      _$MerchantStaffDtoOutputSerializer();
}

class _$MerchantStaffDtoOutputSerializer
    implements PrimitiveSerializer<MerchantStaffDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantStaffDtoOutput,
    _$MerchantStaffDtoOutput,
  ];

  @override
  final String wireName = r'MerchantStaffDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStaffDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'staff';
    yield serializers.serialize(
      object.staff,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantStaffDtoOutputStaffInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStaffDtoOutput object, {
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
    required MerchantStaffDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'staff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantStaffDtoOutputStaffInner),
                    ]),
                  )
                  as BuiltList<MerchantStaffDtoOutputStaffInner>;
          result.staff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStaffDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStaffDtoOutputBuilder();
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
