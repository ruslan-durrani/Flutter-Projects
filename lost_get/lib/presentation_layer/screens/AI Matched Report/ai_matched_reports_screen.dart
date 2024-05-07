import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_get/business_logic_layer/AIMatchedReport/bloc/ai_matched_reports_bloc.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/AI%20Matched%20Report/widgets/AIReportedItemCard.dart';
import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';

class AIMatchedReportsScreen extends StatefulWidget {
  const AIMatchedReportsScreen({super.key});
  static const routeName = '/ai_matched_reports_screen';

  @override
  State<AIMatchedReportsScreen> createState() => _AIMatchedReportsScreenState();
}

class _AIMatchedReportsScreenState extends State<AIMatchedReportsScreen> {
  AiMatchedReportsBloc aiReportBloc = AiMatchedReportsBloc();

  @override
  void initState() {
    super.initState();
    aiReportBloc.add(AIMatchedReportLoadEvent());
  }

  Future<void> _onRefresh() async {
    aiReportBloc.add(AIMatchedReportLoadEvent());
  }

  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("AI Matched Reports",
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<AiMatchedReportsBloc, AiMatchedReportsState>(
            bloc: aiReportBloc,
            listenWhen: (previous, current) =>
                current is AiMatchedReportsActionState,
            buildWhen: (previous, current) =>
                current is! AiMatchedReportsActionState,
            listener: (context, state) {
              // if (state is ReportDeactivatedSuccessfully) {
              //   hideCustomLoadingDialog(context);
              //   createToast(description: "Report deactivated successfully");
              //   aiReportBloc.add(MyReportsLoadEvent());
              // }

              // if (state is StartAIMatchMakingState) {
              //   createToast(
              //       description: "AI Auto Match Maker started successfully");
              //   aiReportBloc.add(MyReportsLoadEvent());
              // }

              // if (state is ReportDeactivationError) {
              //   hideCustomLoadingDialog(context);
              //   createToast(description: "Report deactivated successfully");
              // }

              if (state is LoadingState) {
                showCustomLoadingDialog(context, "Please Wait..");
              }

              if (state is AIMatchReportAcceptedState) {
                hideCustomLoadingDialog(context);
                aiReportBloc.add(AIMatchedReportLoadEvent());
              }

              if (state is AIMatchReportDeclineState) {
                hideCustomLoadingDialog(context);
                aiReportBloc.add(AIMatchedReportLoadEvent());
              }

              // if (state is ReportMarkedAsRecoveredSuccessfullyState) {
              //   hideCustomLoadingDialog(context);
              //   createToast(description: "Report marked as Recovered");
              //   aiReportBloc.add(MyReportsLoadEvent());
              // }
              // if (state is ReportMarkedAsRecoveredErrorState) {
              //   hideCustomLoadingDialog(context);
              //   createToast(
              //       description: "Error: Report is not marked as recovered.");
              // }
            },
            builder: (context, state) {
              if (state is AIMatchedReportsLoadedState) {
                return ListView.builder(
                  itemCount: state.reportItems.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AIReportedItemCard(
                        item: state.reportItems[index],
                        onTap: () => onItemTapped(state.reportItems[index]),
                        aiBloc: aiReportBloc),
                  ),
                );
              } else if (state is AIMatchReportsEmptyState) {
                return Center(
                  child: Text(
                    "There are no matched reports at the moment!",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              } else if (state is AIMatchReportsLoadingState) {
                return const SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                  size: 50,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
