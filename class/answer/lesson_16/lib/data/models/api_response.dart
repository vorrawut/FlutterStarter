import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends Equatable {
  final String status;
  final int? totalResults;
  final List<T> articles;
  final String? code;
  final String? message;

  const ApiResponse({
    required this.status,
    this.totalResults,
    required this.articles,
    this.code,
    this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  bool get isSuccess => status == 'ok';
  bool get hasError => status == 'error';
  bool get hasResults => totalResults != null && totalResults! > 0;
  bool get isEmpty => articles.isEmpty;

  String get errorMessage {
    if (hasError) {
      return message ?? 'Unknown error occurred';
    }
    return '';
  }

  ApiResponse<T> copyWith({
    String? status,
    int? totalResults,
    List<T>? articles,
    String? code,
    String? message,
  }) {
    return ApiResponse<T>(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, totalResults, articles, code, message];

  @override
  String toString() {
    return 'ApiResponse(status: $status, totalResults: $totalResults, articlesCount: ${articles.length})';
  }
}

@JsonSerializable()
class ErrorResponse extends Equatable {
  final String status;
  final String code;
  final String message;

  const ErrorResponse({
    required this.status,
    required this.code,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  List<Object> get props => [status, code, message];

  @override
  String toString() {
    return 'ErrorResponse(status: $status, code: $code, message: $message)';
  }
}

@JsonSerializable()
class PaginatedResponse<T> extends Equatable {
  final String status;
  final int totalResults;
  final int page;
  final int pageSize;
  final int totalPages;
  final List<T> articles;

  const PaginatedResponse({
    required this.status,
    required this.totalResults,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.articles,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
  bool get isFirstPage => page == 1;
  bool get isLastPage => page == totalPages;

  PaginatedResponse<T> copyWith({
    String? status,
    int? totalResults,
    int? page,
    int? pageSize,
    int? totalPages,
    List<T>? articles,
  }) {
    return PaginatedResponse<T>(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object> get props => [
        status,
        totalResults,
        page,
        pageSize,
        totalPages,
        articles,
      ];

  @override
  String toString() {
    return 'PaginatedResponse(page: $page/$totalPages, totalResults: $totalResults, articlesCount: ${articles.length})';
  }
}