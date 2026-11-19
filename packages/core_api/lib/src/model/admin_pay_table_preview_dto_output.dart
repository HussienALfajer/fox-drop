//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_pay_table_preview_dto_output_draft.dart';
import 'package:core_api/src/model/admin_pay_table_preview_dto_output_announced_inner.dart';
import 'package:core_api/src/model/admin_pay_table_preview_dto_output_in_force.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_pay_table_preview_dto_output.g.dart';

/// AdminPayTablePreviewDtoOutput
///
/// Properties:
/// * [waitingThresholdMin]
/// * [inForce]
/// * [announced] - By each version announced, soonest first.
/// * [draft]
@BuiltValue()
abstract class AdminPayTablePreviewDtoOutput
    implements
        Built<
          AdminPayTablePreviewDtoOutput,
          AdminPayTablePreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'waitingThresholdMin')
  int get waitingThresholdMin;

  @BuiltValueField(wireName: r'inForce')
  AdminPayTablePreviewDtoOutputInForce? get inForce;

  /// By each version announced, soonest first.
  @BuiltValueField(wireName: r'announced')
  BuiltList<AdminPayTablePreviewDtoOutputAnnouncedInner> get announced;

  @BuiltValueField(wireName: r'draft')
  AdminPayTablePreviewDtoOutputDraft? get draft;

  AdminPayTablePreviewDtoOutput._();

  factory AdminPayTablePreviewDtoOutput([
    void updates(AdminPayTablePreviewDtoOutputBuilder b),
  ]) = _$AdminPayTablePreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayTablePreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayTablePreviewDtoOutput> get serializer =>
      _$AdminPayTablePreviewDtoOutputSerializer();
}

class _$AdminPayTablePreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminPayTablePreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminPayTablePreviewDtoOutput,
    _$AdminPayTablePreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminPayTablePreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayTablePreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'waitingThresholdMin';
    yield serializers.serialize(
      object.waitingThresholdMin,
      specifiedType: const FullType(int),
    );
    yield r'inForce';
    yield object.inForce == null
        ? null
        : serializers.serialize(
            object.inForce,
            specifiedType: const FullType.nullable(
              AdminPayTablePreviewDtoOutputInForce,
            ),
          );
    yield r'announced';
    yield serializers.serialize(
      object.announced,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminPayTablePreviewDtoOutputAnnouncedInner),
      ]),
    );
    yield r'draft';
    yield object.draft == null
        ? null
        : serializers.serialize(
            object.draft,
            specifiedType: const FullType.nullable(
              AdminPayTablePreviewDtoOutputDraft,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablePreviewDtoOutput object, {
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
    required AdminPayTablePreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'waitingThresholdMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.waitingThresholdMin = valueDes;
          break;
        case r'inForce':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminPayTablePreviewDtoOutputInForce,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForce?;
          if (valueDes == null) continue;
          result.inForce.replace(valueDes);
          break;
        case r'announced':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminPayTablePreviewDtoOutputAnnouncedInner),
                    ]),
                  )
                  as BuiltList<AdminPayTablePreviewDtoOutputAnnouncedInner>;
          result.announced.replace(valueDes);
          break;
        case r'draft':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminPayTablePreviewDtoOutputDraft,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputDraft?;
          if (valueDes == null) continue;
          result.draft.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayTablePreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayTablePreviewDtoOutputBuilder();
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
