// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 int? get id; int? get orderId;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get date; double get amount; PaymentMode get mode; String? get reference; String? get attachment; String? get processorTransactionId; String? get processorName; String? get processorStatus; String? get cardLastFour; String? get terminalId;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.processorTransactionId, processorTransactionId) || other.processorTransactionId == processorTransactionId)&&(identical(other.processorName, processorName) || other.processorName == processorName)&&(identical(other.processorStatus, processorStatus) || other.processorStatus == processorStatus)&&(identical(other.cardLastFour, cardLastFour) || other.cardLastFour == cardLastFour)&&(identical(other.terminalId, terminalId) || other.terminalId == terminalId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,date,amount,mode,reference,attachment,processorTransactionId,processorName,processorStatus,cardLastFour,terminalId);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, date: $date, amount: $amount, mode: $mode, reference: $reference, attachment: $attachment, processorTransactionId: $processorTransactionId, processorName: $processorName, processorStatus: $processorStatus, cardLastFour: $cardLastFour, terminalId: $terminalId)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 int? id, int? orderId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime date, double amount, PaymentMode mode, String? reference, String? attachment, String? processorTransactionId, String? processorName, String? processorStatus, String? cardLastFour, String? terminalId
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orderId = freezed,Object? date = null,Object? amount = null,Object? mode = null,Object? reference = freezed,Object? attachment = freezed,Object? processorTransactionId = freezed,Object? processorName = freezed,Object? processorStatus = freezed,Object? cardLastFour = freezed,Object? terminalId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as String?,processorTransactionId: freezed == processorTransactionId ? _self.processorTransactionId : processorTransactionId // ignore: cast_nullable_to_non_nullable
as String?,processorName: freezed == processorName ? _self.processorName : processorName // ignore: cast_nullable_to_non_nullable
as String?,processorStatus: freezed == processorStatus ? _self.processorStatus : processorStatus // ignore: cast_nullable_to_non_nullable
as String?,cardLastFour: freezed == cardLastFour ? _self.cardLastFour : cardLastFour // ignore: cast_nullable_to_non_nullable
as String?,terminalId: freezed == terminalId ? _self.terminalId : terminalId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime date,  double amount,  PaymentMode mode,  String? reference,  String? attachment,  String? processorTransactionId,  String? processorName,  String? processorStatus,  String? cardLastFour,  String? terminalId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.date,_that.amount,_that.mode,_that.reference,_that.attachment,_that.processorTransactionId,_that.processorName,_that.processorStatus,_that.cardLastFour,_that.terminalId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime date,  double amount,  PaymentMode mode,  String? reference,  String? attachment,  String? processorTransactionId,  String? processorName,  String? processorStatus,  String? cardLastFour,  String? terminalId)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.orderId,_that.date,_that.amount,_that.mode,_that.reference,_that.attachment,_that.processorTransactionId,_that.processorName,_that.processorStatus,_that.cardLastFour,_that.terminalId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime date,  double amount,  PaymentMode mode,  String? reference,  String? attachment,  String? processorTransactionId,  String? processorName,  String? processorStatus,  String? cardLastFour,  String? terminalId)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.date,_that.amount,_that.mode,_that.reference,_that.attachment,_that.processorTransactionId,_that.processorName,_that.processorStatus,_that.cardLastFour,_that.terminalId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({this.id, this.orderId, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.date, required this.amount, required this.mode, this.reference, this.attachment, this.processorTransactionId, this.processorName, this.processorStatus, this.cardLastFour, this.terminalId});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  int? id;
@override final  int? orderId;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime date;
@override final  double amount;
@override final  PaymentMode mode;
@override final  String? reference;
@override final  String? attachment;
@override final  String? processorTransactionId;
@override final  String? processorName;
@override final  String? processorStatus;
@override final  String? cardLastFour;
@override final  String? terminalId;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.processorTransactionId, processorTransactionId) || other.processorTransactionId == processorTransactionId)&&(identical(other.processorName, processorName) || other.processorName == processorName)&&(identical(other.processorStatus, processorStatus) || other.processorStatus == processorStatus)&&(identical(other.cardLastFour, cardLastFour) || other.cardLastFour == cardLastFour)&&(identical(other.terminalId, terminalId) || other.terminalId == terminalId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,date,amount,mode,reference,attachment,processorTransactionId,processorName,processorStatus,cardLastFour,terminalId);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, date: $date, amount: $amount, mode: $mode, reference: $reference, attachment: $attachment, processorTransactionId: $processorTransactionId, processorName: $processorName, processorStatus: $processorStatus, cardLastFour: $cardLastFour, terminalId: $terminalId)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? orderId,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime date, double amount, PaymentMode mode, String? reference, String? attachment, String? processorTransactionId, String? processorName, String? processorStatus, String? cardLastFour, String? terminalId
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orderId = freezed,Object? date = null,Object? amount = null,Object? mode = null,Object? reference = freezed,Object? attachment = freezed,Object? processorTransactionId = freezed,Object? processorName = freezed,Object? processorStatus = freezed,Object? cardLastFour = freezed,Object? terminalId = freezed,}) {
  return _then(_Payment(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as String?,processorTransactionId: freezed == processorTransactionId ? _self.processorTransactionId : processorTransactionId // ignore: cast_nullable_to_non_nullable
as String?,processorName: freezed == processorName ? _self.processorName : processorName // ignore: cast_nullable_to_non_nullable
as String?,processorStatus: freezed == processorStatus ? _self.processorStatus : processorStatus // ignore: cast_nullable_to_non_nullable
as String?,cardLastFour: freezed == cardLastFour ? _self.cardLastFour : cardLastFour // ignore: cast_nullable_to_non_nullable
as String?,terminalId: freezed == terminalId ? _self.terminalId : terminalId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
