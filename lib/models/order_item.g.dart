// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderItemAdapter extends TypeAdapter<OrderItem> {
  @override
  final int typeId = 2;

  @override
  OrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItem(
      menuItem: fields[0] as MenuItem,
      quantity: fields[1] as int,
      milk: fields[2] as Milk?,
      sweetness: fields[3] as Sweetness?,
      comments: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.menuItem)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.milk)
      ..writeByte(3)
      ..write(obj.sweetness)
      ..writeByte(4)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SweetnessAdapter extends TypeAdapter<Sweetness> {
  @override
  final int typeId = 4;

  @override
  Sweetness read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Sweetness.sweet;
      case 1:
        return Sweetness.medium;
      case 2:
        return Sweetness.slight;
      case 3:
        return Sweetness.none;
      default:
        return Sweetness.none;
    }
  }

  @override
  void write(BinaryWriter writer, Sweetness obj) {
    switch (obj) {
      case Sweetness.sweet:
        writer.writeByte(0);
        break;
      case Sweetness.medium:
        writer.writeByte(1);
        break;
      case Sweetness.slight:
        writer.writeByte(2);
        break;
      case Sweetness.none:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SweetnessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MilkAdapter extends TypeAdapter<Milk> {
  @override
  final int typeId = 5;

  @override
  Milk read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Milk.fresh;
      case 1:
        return Milk.canned;
      case 2:
        return Milk.almond;
      case 3:
        return Milk.none;
      default:
        return Milk.none;
    }
  }

  @override
  void write(BinaryWriter writer, Milk obj) {
    switch (obj) {
      case Milk.fresh:
        writer.writeByte(0);
        break;
      case Milk.canned:
        writer.writeByte(1);
        break;
      case Milk.almond:
        writer.writeByte(2);
        break;
      case Milk.none:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
