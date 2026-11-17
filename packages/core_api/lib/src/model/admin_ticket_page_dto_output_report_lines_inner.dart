//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_report_lines_inner.g.dart';

/// AdminTicketPageDtoOutputReportLinesInner
///
/// Properties:
/// * [position]
/// * [name]
/// * [quantity]
@BuiltValue()
abstract class AdminTicketPageDtoOutputReportLinesInner
    implements
        Built<
          AdminTicketPageDtoOutputReportLinesInner,
          AdminTicketPageDtoOutputReportLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminTicketPageDtoOutputReportLinesInner._();

  factory AdminTicketPageDtoOutputReportLinesInner([
    void updates(AdminTicketPageDtoOutputReportLinesInnerBuilder b),
  ]) = _$AdminTicketPageDtoOutputReportLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputReportLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputReportLinesInner> get serializer =>
      _$AdminTicketPageDtoOutputReportLinesInnerSerializer();
}

class _$AdminTicketPageDtoOutputReportLinesInnerSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputReportLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputReportLinesInner,
    _$AdminTicketPageDtoOutputReportLinesInner,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputReportLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputReportLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputReportLinesInner object, {
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
    required AdminTicketPageDtoOutputReportLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputReportLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputReportLinesInnerBuilder();
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
