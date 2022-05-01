import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:allbert_cms/domain/helpers/customer_review_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/paginated_list.dart';
import 'package:allbert_cms/domain/helpers/pagination_data.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_customer_review_widget.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/utils/pagination_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeRatingsTab extends StatefulWidget {
  EmployeeRatingsTab({Key key, @required this.employeeId}) : super(key: key);

  final String employeeId;
  final IApiDataSource apiDataSource = ApiDataSource();

  final List<String> customerReviewRatingOrderByList = [
    "dateDescending",
    "dateAscending",
    "ratingDescending",
    "ratingAscending",
  ];

  final PresentationHelper presentationHelper = PresentationHelper();

  @override
  State<EmployeeRatingsTab> createState() => _EmployeeRatingsTabState();
}

class _EmployeeRatingsTabState extends State<EmployeeRatingsTab> {
  bool _isLoading;

  String _errorMessage;

  PagedList<CustomerReview> _customerReviews;

  int _selectedPageSize;
  String _selectedOrderBy;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _customerReviews = PagedList.empty();

    _selectedPageSize = 10;
    _selectedOrderBy = widget.customerReviewRatingOrderByList.first;

    _loadCustomerReviewsAsync();
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      width: 1200,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getCurrentStateWidget(),
        ],
      ),
    );
  }

  Widget buildCustomerReviewList() {
    if (_customerReviews == null || _customerReviews.items.isEmpty) {
      return Text("This customer does not have any reviews.");
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text("Total: ${_customerReviews.paginationData.totalCount}"),
              SizedBox(
                width: 20,
              ),
              Text(
                  "Current page: ${(_customerReviews.paginationData.currentPage * _customerReviews.paginationData.pageSize) - _customerReviews.paginationData.pageSize + 1} - ${widget.presentationHelper.getCurrentPageLimit(_customerReviews.paginationData)}"),
              /*  SizedBox(
                width: 20,
              ),
              Text("Page size:"),
              SizedBox(
                width: 6,
              ),
              Container(
                height: 20,
                child: DropdownButton(
                  underline: SizedBox(),
                  value: _selectedPageSize,
                  items: [10, 50, 100, 200]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (_selectedPageSize != value) {
                      setState(() {
                        _selectedPageSize = value;
                      });
                      _loadCustomerReviewsAsync();
                    }
                  },
                ),
              ), */
              SizedBox(
                width: 20,
              ),
              Text("Order by:"),
              SizedBox(
                width: 6,
              ),
              Container(
                height: 20,
                child: DropdownButton(
                  underline: SizedBox(),
                  value: _selectedOrderBy,
                  items: widget.customerReviewRatingOrderByList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            mapOrderByToText(e),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (_selectedOrderBy != value) {
                      setState(() {
                        _selectedOrderBy = value;
                      });
                      _loadCustomerReviewsAsync();
                    }
                  },
                ),
              ),
              Spacer(),
              ApplicationTextButton(
                label: "Előző oldal",
                disabled:
                    _customerReviews.paginationData.previousPageLink == null,
                onPress: () {
                  _loadCustomerReviewsAsync(
                      pageUrl:
                          _customerReviews.paginationData.previousPageLink);
                },
              ),
              SizedBox(
                width: 12,
              ),
              ApplicationTextButton(
                label: "Következő oldal",
                disabled: _customerReviews.paginationData.nextPageLink == null,
                onPress: () {
                  _loadCustomerReviewsAsync(
                      pageUrl: _customerReviews.paginationData.nextPageLink);
                },
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: Container(
              width: defaultColumnWidth,
              child: ListView.builder(
                itemCount: _customerReviews.items.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 6, left: 12, right: 12, top: 6),
                    child: ApplicationCustomerReviewWidget(
                      review: _customerReviews.items[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCurrentStateWidget() {
    if (_isLoading) {
      return ApplicationLoadingIndicator(
        type: IndicatorType.JumpingDots,
      );
    }
    if (_errorMessage != null) {
      return Text(_errorMessage);
    }
    return buildCustomerReviewList();
  }

  Future<void> _loadCustomerReviewsAsync({String pageUrl}) async {
    final parameters = getParameters();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _customerReviews = await widget.apiDataSource
          .GetCustomerReviewListAsync(parameters: parameters, pageUrl: pageUrl);
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    setState(() {
      _isLoading = false;
    });
  }

  CustomerReviewQueryParameters getParameters() {
    return CustomerReviewQueryParameters(
      employeeId: widget.employeeId,
      pageSize: _selectedPageSize,
      orderBy: _selectedOrderBy,
    );
  }

  String mapOrderByToText(String value) {
    switch (value) {
      case "dateDescending":
        return "Rendezés legújabb szerint";
      case "dateAscending":
        return "Rendezés legrégebbi szerint";
      case "ratingDescending":
        return "Értékelés szerint csökkenő";
      case "ratingAscending":
        return "Értékelés szerint növekvő";
    }
  }
}
