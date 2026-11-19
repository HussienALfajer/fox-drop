//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_kit_return_dto.g.dart';

/// AdminCaptainApplicationKitReturnDto
///
/// Properties:
/// * [returned] - In good condition; false withholds the deposit.
@BuiltValue()
abstract class AdminCaptainApplicationKitReturnDto
    implements
        Built<
          AdminCaptainApplicationKitReturnDto,
          AdminCaptainApplicationKitReturnDtoBuilder
        > {
  /// In good condition; false withholds the deposit.
  @BuiltValueField(wireName: r'returned')
  bool get returned;

  AdminCaptainApplicationKitReturnDto._();

  factory AdminCaptainApplicationKitReturnDto([
    void updates(AdminCaptainApplicationKitReturnDtoBuilder b),
  ]) = _$AdminCaptainApplicationKitReturnDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationKitReturnDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationKitReturnDto> get serializer =>
      _$AdminCaptainApplicationKitReturnDtoSerializer();
}

class _$AdminCaptainApplicationKitReturnDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationKitReturnDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationKitReturnDto,
    _$AdminCaptainApplicationKitReturnDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationKitReturnDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationKitReturnDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'returned';
    yield serializers.serialize(
      object.returned,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationKitReturnDto object, {
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
    required AdminCaptainApplicationKitReturnDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'returned':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.returned = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationKitReturnDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationKitReturnDtoBuilder();
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
