//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_content_dto_output_reasons_merchant_rejection_inner.g.dart';

/// MerchantContentDtoOutputReasonsMerchantRejectionInner
///
/// Properties:
/// * [code] - Stable: sent back with a choice, kept by the order.
/// * [label]
/// * [note] - Whether the choice takes a note: none, optional or required («أخرى»).
@BuiltValue()
abstract class MerchantContentDtoOutputReasonsMerchantRejectionInner
    implements
        Built<
          MerchantContentDtoOutputReasonsMerchantRejectionInner,
          MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
        > {
  /// Stable: sent back with a choice, kept by the order.
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  /// Whether the choice takes a note: none, optional or required («أخرى»).
  @BuiltValueField(wireName: r'note')
  MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum get note;
  // enum noteEnum {  none,  optional,  required,  };

  MerchantContentDtoOutputReasonsMerchantRejectionInner._();

  factory MerchantContentDtoOutputReasonsMerchantRejectionInner([
    void updates(
      MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder b,
    ),
  ]) = _$MerchantContentDtoOutputReasonsMerchantRejectionInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get serializer =>
      _$MerchantContentDtoOutputReasonsMerchantRejectionInnerSerializer();
}

class _$MerchantContentDtoOutputReasonsMerchantRejectionInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantContentDtoOutputReasonsMerchantRejectionInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantContentDtoOutputReasonsMerchantRejectionInner,
    _$MerchantContentDtoOutputReasonsMerchantRejectionInner,
  ];

  @override
  final String wireName =
      r'MerchantContentDtoOutputReasonsMerchantRejectionInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantContentDtoOutputReasonsMerchantRejectionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(
        MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantContentDtoOutputReasonsMerchantRejectionInner object, {
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
    required MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum,
                    ),
                  )
                  as MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder();
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

/// Whether the choice takes a note: none, optional or required («أخرى»).
class MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
  none = _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_none;
  @BuiltValueEnumConst(wireName: r'optional')
  static const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
  optional =
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_optional;
  @BuiltValueEnumConst(wireName: r'required')
  static const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
  required_ =
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum_required_;

  static Serializer<
    MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum
  >
  get serializer =>
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumSerializer;

  const MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum._(
    String name,
  ) : super(name);

  static BuiltSet<MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum>
  get values =>
      _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumValues;
  static MerchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnum valueOf(
    String name,
  ) => _$merchantContentDtoOutputReasonsMerchantRejectionInnerNoteEnumValueOf(
    name,
  );
}
