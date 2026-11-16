//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_statement_list_dto_output_statements_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_statement_list_dto_output.g.dart';

/// MerchantStatementListDtoOutput
///
/// Properties:
/// * [statements] - The latest statements (a year), newest first.
@BuiltValue()
abstract class MerchantStatementListDtoOutput
    implements
        Built<
          MerchantStatementListDtoOutput,
          MerchantStatementListDtoOutputBuilder
        > {
  /// The latest statements (a year), newest first.
  @BuiltValueField(wireName: r'statements')
  BuiltList<MerchantStatementListDtoOutputStatementsInner> get statements;

  MerchantStatementListDtoOutput._();

  factory MerchantStatementListDtoOutput([
    void updates(MerchantStatementListDtoOutputBuilder b),
  ]) = _$MerchantStatementListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatementListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatementListDtoOutput> get serializer =>
      _$MerchantStatementListDtoOutputSerializer();
}

class _$MerchantStatementListDtoOutputSerializer
    implements PrimitiveSerializer<MerchantStatementListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantStatementListDtoOutput,
    _$MerchantStatementListDtoOutput,
  ];

  @override
  final String wireName = r'MerchantStatementListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatementListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'statements';
    yield serializers.serialize(
      object.statements,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantStatementListDtoOutputStatementsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementListDtoOutput object, {
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
    required MerchantStatementListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'statements':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantStatementListDtoOutputStatementsInner),
                    ]),
                  )
                  as BuiltList<MerchantStatementListDtoOutputStatementsInner>;
          result.statements.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatementListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatementListDtoOutputBuilder();
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
