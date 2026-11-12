//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_custody_dto_output_receipts_inner_lines_inner.dart';
import 'package:core_api/src/model/captain_custody_dto_output_receipts_inner_conversions_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_custody_dto_output_receipts_inner.g.dart';

/// CaptainCustodyDtoOutputReceiptsInner
///
/// Properties:
/// * [id]
/// * [number] - Such as AZ-2026-000123 (AP §4.8).
/// * [type] - captain_hand_in «تسليم نقد», captain_reimbursement «صرف للكابتن»; a later type (2.18) the app shows by its number only, so an older app still reads the rest.
/// * [at]
/// * [cashierName]
/// * [conversions]
/// * [lines]
@BuiltValue()
abstract class CaptainCustodyDtoOutputReceiptsInner
    implements
        Built<
          CaptainCustodyDtoOutputReceiptsInner,
          CaptainCustodyDtoOutputReceiptsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Such as AZ-2026-000123 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// captain_hand_in «تسليم نقد», captain_reimbursement «صرف للكابتن»; a later type (2.18) the app shows by its number only, so an older app still reads the rest.
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'cashierName')
  String? get cashierName;

  @BuiltValueField(wireName: r'conversions')
  BuiltList<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>
  get conversions;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainCustodyDtoOutputReceiptsInnerLinesInner> get lines;

  CaptainCustodyDtoOutputReceiptsInner._();

  factory CaptainCustodyDtoOutputReceiptsInner([
    void updates(CaptainCustodyDtoOutputReceiptsInnerBuilder b),
  ]) = _$CaptainCustodyDtoOutputReceiptsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCustodyDtoOutputReceiptsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustodyDtoOutputReceiptsInner> get serializer =>
      _$CaptainCustodyDtoOutputReceiptsInnerSerializer();
}

class _$CaptainCustodyDtoOutputReceiptsInnerSerializer
    implements PrimitiveSerializer<CaptainCustodyDtoOutputReceiptsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainCustodyDtoOutputReceiptsInner,
    _$CaptainCustodyDtoOutputReceiptsInner,
  ];

  @override
  final String wireName = r'CaptainCustodyDtoOutputReceiptsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustodyDtoOutputReceiptsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'cashierName';
    yield object.cashierName == null
        ? null
        : serializers.serialize(
            object.cashierName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'conversions';
    yield serializers.serialize(
      object.conversions,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainCustodyDtoOutputReceiptsInnerConversionsInner),
      ]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainCustodyDtoOutputReceiptsInnerLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustodyDtoOutputReceiptsInner object, {
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
    required CaptainCustodyDtoOutputReceiptsInnerBuilder result,
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
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.type = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'cashierName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cashierName = valueDes;
          break;
        case r'conversions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainCustodyDtoOutputReceiptsInnerConversionsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainCustodyDtoOutputReceiptsInnerConversionsInner
                  >;
          result.conversions.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainCustodyDtoOutputReceiptsInnerLinesInner),
                    ]),
                  )
                  as BuiltList<CaptainCustodyDtoOutputReceiptsInnerLinesInner>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCustodyDtoOutputReceiptsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCustodyDtoOutputReceiptsInnerBuilder();
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
