import 'dart:ui';

/// Parses SVG path data (`M L H V C S Q T A Z`, absolute and relative) into
/// a [Path], in the units of the data. The icon set is drawn on the 24 grid
/// (architecture §9.4), so the caller scales the canvas.
Path parseSvgPath(String data) {
  final reader = _Reader(data);
  final path = Path();
  var current = Offset.zero;
  var start = Offset.zero;
  // The second control point of the last C or S, and the control point of
  // the last Q or T, which S and T reflect.
  Offset? lastCubic;
  Offset? lastQuad;
  String? command;

  while (true) {
    reader.skipSeparators();
    if (reader.done) break;
    final next = reader.peekCommand();
    if (next != null) {
      command = next;
      reader.advance();
    } else if (command == null) {
      // At the start, or after Z, which takes no numbers.
      throw FormatException('Numbers without a command', data);
    }
    final cmd = command;
    final relative = cmd == cmd.toLowerCase();
    final base = relative ? current : Offset.zero;
    Offset point() => base + Offset(reader.number(), reader.number());

    var cubic = false;
    var quad = false;
    switch (cmd.toUpperCase()) {
      case 'M':
        current = point();
        start = current;
        path.moveTo(current.dx, current.dy);
        // Pairs after the first are implicit lines.
        command = relative ? 'l' : 'L';
      case 'L':
        current = point();
        path.lineTo(current.dx, current.dy);
      case 'H':
        current = Offset(
          reader.number() + (relative ? current.dx : 0),
          current.dy,
        );
        path.lineTo(current.dx, current.dy);
      case 'V':
        current = Offset(
          current.dx,
          reader.number() + (relative ? current.dy : 0),
        );
        path.lineTo(current.dx, current.dy);
      case 'C':
        final c1 = point();
        final c2 = point();
        final end = point();
        path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
        lastCubic = c2;
        current = end;
        cubic = true;
      case 'S':
        final c1 = lastCubic == null ? current : current * 2 - lastCubic;
        final c2 = point();
        final end = point();
        path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
        lastCubic = c2;
        current = end;
        cubic = true;
      case 'Q':
        final c = point();
        final end = point();
        path.quadraticBezierTo(c.dx, c.dy, end.dx, end.dy);
        lastQuad = c;
        current = end;
        quad = true;
      case 'T':
        final c = lastQuad == null ? current : current * 2 - lastQuad;
        final end = point();
        path.quadraticBezierTo(c.dx, c.dy, end.dx, end.dy);
        lastQuad = c;
        current = end;
        quad = true;
      case 'A':
        final rx = reader.number().abs();
        final ry = reader.number().abs();
        final rotation = reader.number();
        final largeArc = reader.flag();
        final sweep = reader.flag();
        final end = point();
        if (rx == 0 || ry == 0) {
          path.lineTo(end.dx, end.dy);
        } else {
          // SVG's positive sweep runs clockwise on a y-down canvas, as
          // Flutter's `clockwise` does.
          path.arcToPoint(
            end,
            radius: Radius.elliptical(rx, ry),
            rotation: rotation,
            largeArc: largeArc,
            clockwise: sweep,
          );
        }
        current = end;
      case 'Z':
        path.close();
        current = start;
        command = null;
      default:
        throw FormatException('Unknown path command "$cmd"', data);
    }
    if (!cubic) lastCubic = null;
    if (!quad) lastQuad = null;
  }
  return path;
}

final class _Reader {
  _Reader(this.data);

  final String data;
  int index = 0;

  static final _number = RegExp(r'[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?');
  static const _commands = 'MmLlHhVvCcSsQqTtAaZz';

  bool get done => index >= data.length;

  void advance() => index++;

  void skipSeparators() {
    while (!done && ' ,\t\n\r'.contains(data[index])) {
      index++;
    }
  }

  String? peekCommand() => _commands.contains(data[index]) ? data[index] : null;

  double number() {
    skipSeparators();
    final match = _number.matchAsPrefix(data, index);
    if (match == null) {
      throw FormatException('Expected a number', data, index);
    }
    index = match.end;
    return double.parse(match[0]!);
  }

  /// An arc flag is one digit and may touch the next number (`a2 2 0 01 .7`).
  bool flag() {
    skipSeparators();
    if (done || (data[index] != '0' && data[index] != '1')) {
      throw FormatException('Expected an arc flag', data, index);
    }
    return data[index++] == '1';
  }
}
