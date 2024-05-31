import 'dart:convert';

class PolicyModel {
  final List<Content> content;
  final Pageable pageable;
  final int totalPages;
  final int totalElements;
  final bool last;
  final int size;
  final int number;
  final Sort sort;
  final int numberOfElements;
  final bool first;
  final bool empty;

  PolicyModel.fromJson(Map<String, dynamic> json)
      : content = (json['content'] as List)
            .map((item) => Content.fromJson(item))
            .toList(),
        pageable = Pageable.fromJson(json['pageable']),
        totalPages = json['totalPages'],
        totalElements = json['totalElements'],
        last = json['last'],
        size = json['size'],
        number = json['number'],
        sort = Sort.fromJson(json['sort']),
        numberOfElements = json['numberOfElements'],
        first = json['first'],
        empty = json['empty'];
}

class Content {
  final String id;
  final String deadlineForApplication;
  final String title;
  final String businessOverview;
  final String amount;
  final String url;
  final String institutionName;
  final String supplyLocation;

  Content.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deadlineForApplication = json['deadlineForApplication'],
        title = json['title'],
        businessOverview = json['businessOverview'],
        amount = json['amount'],
        url = json['url'],
        institutionName = json['institutionName'],
        supplyLocation = json['supplyLocation'];
}

class Pageable {
  final int pageNumber;
  final int pageSize;
  final Sort sort;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable.fromJson(Map<String, dynamic> json)
      : pageNumber = json['pageNumber'],
        pageSize = json['pageSize'],
        sort = Sort.fromJson(json['sort']),
        offset = json['offset'],
        paged = json['paged'],
        unpaged = json['unpaged'];
}

class Sort {
  final bool sorted;
  final bool empty;
  final bool unsorted;

  Sort.fromJson(Map<String, dynamic> json)
      : sorted = json['sorted'],
        empty = json['empty'],
        unsorted = json['unsorted'];
}
