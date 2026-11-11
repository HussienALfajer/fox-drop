//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_handover_dto.g.dart';

/// AdminHandoverDto
///
/// Properties:
/// * [captainId] - An eligible captain from the picker, measured from the first.
/// * [reason] - Operations’ internal note (AP §9.3.2: required; never shown to the apps).
/// * [captainFault] - AP §9.7.6 (slice 2.13b): «بخطأ من الكابتن» (true) or «دون خطأ» (false), kept only while the first captain's «لا أستطيع إكمال الطلب» is open (the detail's cannotComplete), where null counts as true; ignored otherwise.
@BuiltValue()
abstract class AdminHandoverDto
    implements Built<AdminHandoverDto, AdminHandoverDtoBuilder> {
  /// An eligible captain from the picker, measured from the first.
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// Operations’ internal note (AP §9.3.2: required; never shown to the apps).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// AP §9.7.6 (slice 2.13b): «بخطأ من الكابتن» (true) or «دون خطأ» (false), kept only while the first captain's «لا أستطيع إكمال الطلب» is open (the detail's cannotComplete), where null counts as true; ignored otherwise.
  @BuiltValueField(wireName: r'captainFault')
  bool? get captainFault;

  AdminHandoverDto._();

  factory AdminHandoverDto([void updates(AdminHandoverDtoBuilder b)]) =
      _$AdminHandoverDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandoverDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandoverDto> get serializer =>
      _$AdminHandoverDtoSerializer();
}

class _$AdminHandoverDtoSerializer
    implements PrimitiveSerializer<AdminHandoverDto> {
  @override
  final Iterable<Type> types = const [AdminHandoverDto, _$AdminHandoverDto];

  @override
  final String wireName = r'AdminHandoverDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandoverDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.captainFault != null) {
      yield r'captainFault';
      yield serializers.serialize(
        object.captainFault,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandoverDto object, {
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
    required AdminHandoverDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'captainFault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.captainFault = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHandoverDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandoverDtoBuilder();
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
