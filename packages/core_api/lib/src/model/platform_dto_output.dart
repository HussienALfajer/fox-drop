//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_dto_output.g.dart';

/// PlatformDtoOutput
///
/// Properties:
/// * [update] - required: below app.<app>.min_version, the blocking update screen; suggested: below app.<app>.latest_version, a dismissible banner.
/// * [updateMessage] - app.<app>.update_message, when set.
/// * [maintenance] - app.<app>.maintenance: the blocking maintenance screen.
/// * [maintenanceMessage] - The maintenance message, when set.
@BuiltValue()
abstract class PlatformDtoOutput
    implements Built<PlatformDtoOutput, PlatformDtoOutputBuilder> {
  /// required: below app.<app>.min_version, the blocking update screen; suggested: below app.<app>.latest_version, a dismissible banner.
  @BuiltValueField(wireName: r'update')
  PlatformDtoOutputUpdateEnum get update;
  // enum updateEnum {  required,  suggested,  none,  };

  /// app.<app>.update_message, when set.
  @BuiltValueField(wireName: r'updateMessage')
  String? get updateMessage;

  /// app.<app>.maintenance: the blocking maintenance screen.
  @BuiltValueField(wireName: r'maintenance')
  bool get maintenance;

  /// The maintenance message, when set.
  @BuiltValueField(wireName: r'maintenanceMessage')
  String? get maintenanceMessage;

  PlatformDtoOutput._();

  factory PlatformDtoOutput([void updates(PlatformDtoOutputBuilder b)]) =
      _$PlatformDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformDtoOutput> get serializer =>
      _$PlatformDtoOutputSerializer();
}

class _$PlatformDtoOutputSerializer
    implements PrimitiveSerializer<PlatformDtoOutput> {
  @override
  final Iterable<Type> types = const [PlatformDtoOutput, _$PlatformDtoOutput];

  @override
  final String wireName = r'PlatformDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'update';
    yield serializers.serialize(
      object.update,
      specifiedType: const FullType(PlatformDtoOutputUpdateEnum),
    );
    if (object.updateMessage != null) {
      yield r'updateMessage';
      yield serializers.serialize(
        object.updateMessage,
        specifiedType: const FullType(String),
      );
    }
    yield r'maintenance';
    yield serializers.serialize(
      object.maintenance,
      specifiedType: const FullType(bool),
    );
    if (object.maintenanceMessage != null) {
      yield r'maintenanceMessage';
      yield serializers.serialize(
        object.maintenanceMessage,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformDtoOutput object, {
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
    required PlatformDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'update':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(PlatformDtoOutputUpdateEnum),
                  )
                  as PlatformDtoOutputUpdateEnum;
          result.update = valueDes;
          break;
        case r'updateMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.updateMessage = valueDes;
          break;
        case r'maintenance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.maintenance = valueDes;
          break;
        case r'maintenanceMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maintenanceMessage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformDtoOutputBuilder();
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

/// required: below app.<app>.min_version, the blocking update screen; suggested: below app.<app>.latest_version, a dismissible banner.
class PlatformDtoOutputUpdateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'required')
  static const PlatformDtoOutputUpdateEnum required_ =
      _$platformDtoOutputUpdateEnum_required_;
  @BuiltValueEnumConst(wireName: r'suggested')
  static const PlatformDtoOutputUpdateEnum suggested =
      _$platformDtoOutputUpdateEnum_suggested;
  @BuiltValueEnumConst(wireName: r'none')
  static const PlatformDtoOutputUpdateEnum none =
      _$platformDtoOutputUpdateEnum_none;

  static Serializer<PlatformDtoOutputUpdateEnum> get serializer =>
      _$platformDtoOutputUpdateEnumSerializer;

  const PlatformDtoOutputUpdateEnum._(String name) : super(name);

  static BuiltSet<PlatformDtoOutputUpdateEnum> get values =>
      _$platformDtoOutputUpdateEnumValues;
  static PlatformDtoOutputUpdateEnum valueOf(String name) =>
      _$platformDtoOutputUpdateEnumValueOf(name);
}
