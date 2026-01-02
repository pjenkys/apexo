import 'package:apexo/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

class NoItemsFound extends StatelessWidget {
  const NoItemsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Acrylic(
          elevation: 20,
          child: InfoBar(
            isIconVisible: true,
            severity: InfoBarSeverity.warning,
            title: Txt(txt("noItemsFound")),
          ),
        ),
      ),
    );
  }
}