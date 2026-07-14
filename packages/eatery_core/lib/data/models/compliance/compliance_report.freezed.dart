// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compliance_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComplianceReport {

 int? get id; String get reportType;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get generatedAt; String get generatedBy;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get periodStart;@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime get periodEnd; String get reportNumber; double get grossSales; double get netSales; double get taxCollected; int get transactionCount; double get averageTicket; double get totalDiscounts; int get discountCount; int get voidCount; double get voidAmount; int get refundCount; double get refundAmount; double get openingBalance; double get closingBalance; double? get expectedCash; double? get actualCash; double? get cashVariance; String? get paymentBreakdownJson; String? get taxBreakdownJson;
/// Create a copy of ComplianceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplianceReportCopyWith<ComplianceReport> get copyWith => _$ComplianceReportCopyWithImpl<ComplianceReport>(this as ComplianceReport, _$identity);

  /// Serializes this ComplianceReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplianceReport&&(identical(other.id, id) || other.id == id)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.generatedBy, generatedBy) || other.generatedBy == generatedBy)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.reportNumber, reportNumber) || other.reportNumber == reportNumber)&&(identical(other.grossSales, grossSales) || other.grossSales == grossSales)&&(identical(other.netSales, netSales) || other.netSales == netSales)&&(identical(other.taxCollected, taxCollected) || other.taxCollected == taxCollected)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.averageTicket, averageTicket) || other.averageTicket == averageTicket)&&(identical(other.totalDiscounts, totalDiscounts) || other.totalDiscounts == totalDiscounts)&&(identical(other.discountCount, discountCount) || other.discountCount == discountCount)&&(identical(other.voidCount, voidCount) || other.voidCount == voidCount)&&(identical(other.voidAmount, voidAmount) || other.voidAmount == voidAmount)&&(identical(other.refundCount, refundCount) || other.refundCount == refundCount)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.closingBalance, closingBalance) || other.closingBalance == closingBalance)&&(identical(other.expectedCash, expectedCash) || other.expectedCash == expectedCash)&&(identical(other.actualCash, actualCash) || other.actualCash == actualCash)&&(identical(other.cashVariance, cashVariance) || other.cashVariance == cashVariance)&&(identical(other.paymentBreakdownJson, paymentBreakdownJson) || other.paymentBreakdownJson == paymentBreakdownJson)&&(identical(other.taxBreakdownJson, taxBreakdownJson) || other.taxBreakdownJson == taxBreakdownJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,reportType,generatedAt,generatedBy,periodStart,periodEnd,reportNumber,grossSales,netSales,taxCollected,transactionCount,averageTicket,totalDiscounts,discountCount,voidCount,voidAmount,refundCount,refundAmount,openingBalance,closingBalance,expectedCash,actualCash,cashVariance,paymentBreakdownJson,taxBreakdownJson]);

@override
String toString() {
  return 'ComplianceReport(id: $id, reportType: $reportType, generatedAt: $generatedAt, generatedBy: $generatedBy, periodStart: $periodStart, periodEnd: $periodEnd, reportNumber: $reportNumber, grossSales: $grossSales, netSales: $netSales, taxCollected: $taxCollected, transactionCount: $transactionCount, averageTicket: $averageTicket, totalDiscounts: $totalDiscounts, discountCount: $discountCount, voidCount: $voidCount, voidAmount: $voidAmount, refundCount: $refundCount, refundAmount: $refundAmount, openingBalance: $openingBalance, closingBalance: $closingBalance, expectedCash: $expectedCash, actualCash: $actualCash, cashVariance: $cashVariance, paymentBreakdownJson: $paymentBreakdownJson, taxBreakdownJson: $taxBreakdownJson)';
}


}

/// @nodoc
abstract mixin class $ComplianceReportCopyWith<$Res>  {
  factory $ComplianceReportCopyWith(ComplianceReport value, $Res Function(ComplianceReport) _then) = _$ComplianceReportCopyWithImpl;
@useResult
$Res call({
 int? id, String reportType,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime generatedAt, String generatedBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime periodStart,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime periodEnd, String reportNumber, double grossSales, double netSales, double taxCollected, int transactionCount, double averageTicket, double totalDiscounts, int discountCount, int voidCount, double voidAmount, int refundCount, double refundAmount, double openingBalance, double closingBalance, double? expectedCash, double? actualCash, double? cashVariance, String? paymentBreakdownJson, String? taxBreakdownJson
});




}
/// @nodoc
class _$ComplianceReportCopyWithImpl<$Res>
    implements $ComplianceReportCopyWith<$Res> {
  _$ComplianceReportCopyWithImpl(this._self, this._then);

  final ComplianceReport _self;
  final $Res Function(ComplianceReport) _then;

/// Create a copy of ComplianceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reportType = null,Object? generatedAt = null,Object? generatedBy = null,Object? periodStart = null,Object? periodEnd = null,Object? reportNumber = null,Object? grossSales = null,Object? netSales = null,Object? taxCollected = null,Object? transactionCount = null,Object? averageTicket = null,Object? totalDiscounts = null,Object? discountCount = null,Object? voidCount = null,Object? voidAmount = null,Object? refundCount = null,Object? refundAmount = null,Object? openingBalance = null,Object? closingBalance = null,Object? expectedCash = freezed,Object? actualCash = freezed,Object? cashVariance = freezed,Object? paymentBreakdownJson = freezed,Object? taxBreakdownJson = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,generatedBy: null == generatedBy ? _self.generatedBy : generatedBy // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,reportNumber: null == reportNumber ? _self.reportNumber : reportNumber // ignore: cast_nullable_to_non_nullable
as String,grossSales: null == grossSales ? _self.grossSales : grossSales // ignore: cast_nullable_to_non_nullable
as double,netSales: null == netSales ? _self.netSales : netSales // ignore: cast_nullable_to_non_nullable
as double,taxCollected: null == taxCollected ? _self.taxCollected : taxCollected // ignore: cast_nullable_to_non_nullable
as double,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,averageTicket: null == averageTicket ? _self.averageTicket : averageTicket // ignore: cast_nullable_to_non_nullable
as double,totalDiscounts: null == totalDiscounts ? _self.totalDiscounts : totalDiscounts // ignore: cast_nullable_to_non_nullable
as double,discountCount: null == discountCount ? _self.discountCount : discountCount // ignore: cast_nullable_to_non_nullable
as int,voidCount: null == voidCount ? _self.voidCount : voidCount // ignore: cast_nullable_to_non_nullable
as int,voidAmount: null == voidAmount ? _self.voidAmount : voidAmount // ignore: cast_nullable_to_non_nullable
as double,refundCount: null == refundCount ? _self.refundCount : refundCount // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as double,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as double,closingBalance: null == closingBalance ? _self.closingBalance : closingBalance // ignore: cast_nullable_to_non_nullable
as double,expectedCash: freezed == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as double?,actualCash: freezed == actualCash ? _self.actualCash : actualCash // ignore: cast_nullable_to_non_nullable
as double?,cashVariance: freezed == cashVariance ? _self.cashVariance : cashVariance // ignore: cast_nullable_to_non_nullable
as double?,paymentBreakdownJson: freezed == paymentBreakdownJson ? _self.paymentBreakdownJson : paymentBreakdownJson // ignore: cast_nullable_to_non_nullable
as String?,taxBreakdownJson: freezed == taxBreakdownJson ? _self.taxBreakdownJson : taxBreakdownJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplianceReport].
extension ComplianceReportPatterns on ComplianceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplianceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplianceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplianceReport value)  $default,){
final _that = this;
switch (_that) {
case _ComplianceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplianceReport value)?  $default,){
final _that = this;
switch (_that) {
case _ComplianceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String reportType, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime generatedAt,  String generatedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime periodStart, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime periodEnd,  String reportNumber,  double grossSales,  double netSales,  double taxCollected,  int transactionCount,  double averageTicket,  double totalDiscounts,  int discountCount,  int voidCount,  double voidAmount,  int refundCount,  double refundAmount,  double openingBalance,  double closingBalance,  double? expectedCash,  double? actualCash,  double? cashVariance,  String? paymentBreakdownJson,  String? taxBreakdownJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplianceReport() when $default != null:
return $default(_that.id,_that.reportType,_that.generatedAt,_that.generatedBy,_that.periodStart,_that.periodEnd,_that.reportNumber,_that.grossSales,_that.netSales,_that.taxCollected,_that.transactionCount,_that.averageTicket,_that.totalDiscounts,_that.discountCount,_that.voidCount,_that.voidAmount,_that.refundCount,_that.refundAmount,_that.openingBalance,_that.closingBalance,_that.expectedCash,_that.actualCash,_that.cashVariance,_that.paymentBreakdownJson,_that.taxBreakdownJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String reportType, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime generatedAt,  String generatedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime periodStart, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime periodEnd,  String reportNumber,  double grossSales,  double netSales,  double taxCollected,  int transactionCount,  double averageTicket,  double totalDiscounts,  int discountCount,  int voidCount,  double voidAmount,  int refundCount,  double refundAmount,  double openingBalance,  double closingBalance,  double? expectedCash,  double? actualCash,  double? cashVariance,  String? paymentBreakdownJson,  String? taxBreakdownJson)  $default,) {final _that = this;
switch (_that) {
case _ComplianceReport():
return $default(_that.id,_that.reportType,_that.generatedAt,_that.generatedBy,_that.periodStart,_that.periodEnd,_that.reportNumber,_that.grossSales,_that.netSales,_that.taxCollected,_that.transactionCount,_that.averageTicket,_that.totalDiscounts,_that.discountCount,_that.voidCount,_that.voidAmount,_that.refundCount,_that.refundAmount,_that.openingBalance,_that.closingBalance,_that.expectedCash,_that.actualCash,_that.cashVariance,_that.paymentBreakdownJson,_that.taxBreakdownJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String reportType, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime generatedAt,  String generatedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime periodStart, @JsonKey(fromJson: epochFromJson, toJson: epochToJson)  DateTime periodEnd,  String reportNumber,  double grossSales,  double netSales,  double taxCollected,  int transactionCount,  double averageTicket,  double totalDiscounts,  int discountCount,  int voidCount,  double voidAmount,  int refundCount,  double refundAmount,  double openingBalance,  double closingBalance,  double? expectedCash,  double? actualCash,  double? cashVariance,  String? paymentBreakdownJson,  String? taxBreakdownJson)?  $default,) {final _that = this;
switch (_that) {
case _ComplianceReport() when $default != null:
return $default(_that.id,_that.reportType,_that.generatedAt,_that.generatedBy,_that.periodStart,_that.periodEnd,_that.reportNumber,_that.grossSales,_that.netSales,_that.taxCollected,_that.transactionCount,_that.averageTicket,_that.totalDiscounts,_that.discountCount,_that.voidCount,_that.voidAmount,_that.refundCount,_that.refundAmount,_that.openingBalance,_that.closingBalance,_that.expectedCash,_that.actualCash,_that.cashVariance,_that.paymentBreakdownJson,_that.taxBreakdownJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplianceReport implements ComplianceReport {
  const _ComplianceReport({this.id, required this.reportType, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.generatedAt, required this.generatedBy, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.periodStart, @JsonKey(fromJson: epochFromJson, toJson: epochToJson) required this.periodEnd, required this.reportNumber, required this.grossSales, required this.netSales, required this.taxCollected, required this.transactionCount, required this.averageTicket, this.totalDiscounts = 0, this.discountCount = 0, this.voidCount = 0, this.voidAmount = 0, this.refundCount = 0, this.refundAmount = 0, required this.openingBalance, required this.closingBalance, this.expectedCash, this.actualCash, this.cashVariance, this.paymentBreakdownJson, this.taxBreakdownJson});
  factory _ComplianceReport.fromJson(Map<String, dynamic> json) => _$ComplianceReportFromJson(json);

@override final  int? id;
@override final  String reportType;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime generatedAt;
@override final  String generatedBy;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime periodStart;
@override@JsonKey(fromJson: epochFromJson, toJson: epochToJson) final  DateTime periodEnd;
@override final  String reportNumber;
@override final  double grossSales;
@override final  double netSales;
@override final  double taxCollected;
@override final  int transactionCount;
@override final  double averageTicket;
@override@JsonKey() final  double totalDiscounts;
@override@JsonKey() final  int discountCount;
@override@JsonKey() final  int voidCount;
@override@JsonKey() final  double voidAmount;
@override@JsonKey() final  int refundCount;
@override@JsonKey() final  double refundAmount;
@override final  double openingBalance;
@override final  double closingBalance;
@override final  double? expectedCash;
@override final  double? actualCash;
@override final  double? cashVariance;
@override final  String? paymentBreakdownJson;
@override final  String? taxBreakdownJson;

/// Create a copy of ComplianceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplianceReportCopyWith<_ComplianceReport> get copyWith => __$ComplianceReportCopyWithImpl<_ComplianceReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplianceReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplianceReport&&(identical(other.id, id) || other.id == id)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.generatedBy, generatedBy) || other.generatedBy == generatedBy)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.reportNumber, reportNumber) || other.reportNumber == reportNumber)&&(identical(other.grossSales, grossSales) || other.grossSales == grossSales)&&(identical(other.netSales, netSales) || other.netSales == netSales)&&(identical(other.taxCollected, taxCollected) || other.taxCollected == taxCollected)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.averageTicket, averageTicket) || other.averageTicket == averageTicket)&&(identical(other.totalDiscounts, totalDiscounts) || other.totalDiscounts == totalDiscounts)&&(identical(other.discountCount, discountCount) || other.discountCount == discountCount)&&(identical(other.voidCount, voidCount) || other.voidCount == voidCount)&&(identical(other.voidAmount, voidAmount) || other.voidAmount == voidAmount)&&(identical(other.refundCount, refundCount) || other.refundCount == refundCount)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.closingBalance, closingBalance) || other.closingBalance == closingBalance)&&(identical(other.expectedCash, expectedCash) || other.expectedCash == expectedCash)&&(identical(other.actualCash, actualCash) || other.actualCash == actualCash)&&(identical(other.cashVariance, cashVariance) || other.cashVariance == cashVariance)&&(identical(other.paymentBreakdownJson, paymentBreakdownJson) || other.paymentBreakdownJson == paymentBreakdownJson)&&(identical(other.taxBreakdownJson, taxBreakdownJson) || other.taxBreakdownJson == taxBreakdownJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,reportType,generatedAt,generatedBy,periodStart,periodEnd,reportNumber,grossSales,netSales,taxCollected,transactionCount,averageTicket,totalDiscounts,discountCount,voidCount,voidAmount,refundCount,refundAmount,openingBalance,closingBalance,expectedCash,actualCash,cashVariance,paymentBreakdownJson,taxBreakdownJson]);

@override
String toString() {
  return 'ComplianceReport(id: $id, reportType: $reportType, generatedAt: $generatedAt, generatedBy: $generatedBy, periodStart: $periodStart, periodEnd: $periodEnd, reportNumber: $reportNumber, grossSales: $grossSales, netSales: $netSales, taxCollected: $taxCollected, transactionCount: $transactionCount, averageTicket: $averageTicket, totalDiscounts: $totalDiscounts, discountCount: $discountCount, voidCount: $voidCount, voidAmount: $voidAmount, refundCount: $refundCount, refundAmount: $refundAmount, openingBalance: $openingBalance, closingBalance: $closingBalance, expectedCash: $expectedCash, actualCash: $actualCash, cashVariance: $cashVariance, paymentBreakdownJson: $paymentBreakdownJson, taxBreakdownJson: $taxBreakdownJson)';
}


}

/// @nodoc
abstract mixin class _$ComplianceReportCopyWith<$Res> implements $ComplianceReportCopyWith<$Res> {
  factory _$ComplianceReportCopyWith(_ComplianceReport value, $Res Function(_ComplianceReport) _then) = __$ComplianceReportCopyWithImpl;
@override @useResult
$Res call({
 int? id, String reportType,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime generatedAt, String generatedBy,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime periodStart,@JsonKey(fromJson: epochFromJson, toJson: epochToJson) DateTime periodEnd, String reportNumber, double grossSales, double netSales, double taxCollected, int transactionCount, double averageTicket, double totalDiscounts, int discountCount, int voidCount, double voidAmount, int refundCount, double refundAmount, double openingBalance, double closingBalance, double? expectedCash, double? actualCash, double? cashVariance, String? paymentBreakdownJson, String? taxBreakdownJson
});




}
/// @nodoc
class __$ComplianceReportCopyWithImpl<$Res>
    implements _$ComplianceReportCopyWith<$Res> {
  __$ComplianceReportCopyWithImpl(this._self, this._then);

  final _ComplianceReport _self;
  final $Res Function(_ComplianceReport) _then;

/// Create a copy of ComplianceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reportType = null,Object? generatedAt = null,Object? generatedBy = null,Object? periodStart = null,Object? periodEnd = null,Object? reportNumber = null,Object? grossSales = null,Object? netSales = null,Object? taxCollected = null,Object? transactionCount = null,Object? averageTicket = null,Object? totalDiscounts = null,Object? discountCount = null,Object? voidCount = null,Object? voidAmount = null,Object? refundCount = null,Object? refundAmount = null,Object? openingBalance = null,Object? closingBalance = null,Object? expectedCash = freezed,Object? actualCash = freezed,Object? cashVariance = freezed,Object? paymentBreakdownJson = freezed,Object? taxBreakdownJson = freezed,}) {
  return _then(_ComplianceReport(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,generatedBy: null == generatedBy ? _self.generatedBy : generatedBy // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,reportNumber: null == reportNumber ? _self.reportNumber : reportNumber // ignore: cast_nullable_to_non_nullable
as String,grossSales: null == grossSales ? _self.grossSales : grossSales // ignore: cast_nullable_to_non_nullable
as double,netSales: null == netSales ? _self.netSales : netSales // ignore: cast_nullable_to_non_nullable
as double,taxCollected: null == taxCollected ? _self.taxCollected : taxCollected // ignore: cast_nullable_to_non_nullable
as double,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,averageTicket: null == averageTicket ? _self.averageTicket : averageTicket // ignore: cast_nullable_to_non_nullable
as double,totalDiscounts: null == totalDiscounts ? _self.totalDiscounts : totalDiscounts // ignore: cast_nullable_to_non_nullable
as double,discountCount: null == discountCount ? _self.discountCount : discountCount // ignore: cast_nullable_to_non_nullable
as int,voidCount: null == voidCount ? _self.voidCount : voidCount // ignore: cast_nullable_to_non_nullable
as int,voidAmount: null == voidAmount ? _self.voidAmount : voidAmount // ignore: cast_nullable_to_non_nullable
as double,refundCount: null == refundCount ? _self.refundCount : refundCount // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as double,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as double,closingBalance: null == closingBalance ? _self.closingBalance : closingBalance // ignore: cast_nullable_to_non_nullable
as double,expectedCash: freezed == expectedCash ? _self.expectedCash : expectedCash // ignore: cast_nullable_to_non_nullable
as double?,actualCash: freezed == actualCash ? _self.actualCash : actualCash // ignore: cast_nullable_to_non_nullable
as double?,cashVariance: freezed == cashVariance ? _self.cashVariance : cashVariance // ignore: cast_nullable_to_non_nullable
as double?,paymentBreakdownJson: freezed == paymentBreakdownJson ? _self.paymentBreakdownJson : paymentBreakdownJson // ignore: cast_nullable_to_non_nullable
as String?,taxBreakdownJson: freezed == taxBreakdownJson ? _self.taxBreakdownJson : taxBreakdownJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
