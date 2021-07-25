import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/title_and_description.dart';
import '../widgets/rounded_button.dart';
import 'home_screen_model.dart';
import 'widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenModel(
        context: context,
        purchaseStatusNotifier: Provider.of(context),
      ),
      child: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<HomeScreenModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: IgnorePointer(
        ignoring: notifier.isLoading,
        child: Stack(
          children: [
            if (notifier.isLoading)
              Opacity(
                opacity: notifier.isLoading ? 1.0 : 0,
                child: const Center(
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ColoredBox(
              color: Colors.white,
              child: Opacity(
                opacity: notifier.isLoading ? 0.3 : 1.0,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    ...buildPurchaseSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPurchaseSection(BuildContext context) {
    final notifier = Provider.of<HomeScreenModel>(context, listen: false);
    return [
      const SectionTitle(title: 'アプリ内課金'),
      TitleAndDescription(
        title: 'アイテム名称',
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return _buildPurchaseDialog(
                context: context,
                positiveButtonString: '購入する',
                negativeButtonString: 'キャンセル',
                onPressedPositiveButton: () {
                  Navigator.of(context).pop();
                  notifier.checkPurchaseStatus();
                },
                onPressedNegativeButton: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      ),
      TitleAndDescription(
        title: '購入情報復元',
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return _buildPurchaseDialog(
                context: context,
                positiveButtonString: '復元に進む',
                negativeButtonString: 'キャンセル',
                onPressedPositiveButton: () {
                  // 復元処理開始
                  notifier.restoreTransactions();
                  Navigator.of(context).pop();
                },
                onPressedNegativeButton: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      ),
    ];
  }

  /// 購入開始、復元開始ダイアログ
  Widget _buildPurchaseDialog({
    required BuildContext context,
    required String positiveButtonString,
    required String negativeButtonString,
    required VoidCallback onPressedPositiveButton,
    required VoidCallback onPressedNegativeButton,
  }) {
    final size = MediaQuery.of(context).size;
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: RoundedButton(
                  title: positiveButtonString,
                  onPressed: onPressedPositiveButton,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: RoundedButton(
                  title: negativeButtonString,
                  onPressed: onPressedNegativeButton,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
