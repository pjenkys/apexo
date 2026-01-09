import 'package:apexo/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ConfirmDeleteFlyout extends StatelessWidget {
  const ConfirmDeleteFlyout(
      {super.key, required this.onConfirm, required this.controller});

  final VoidCallback onConfirm;
  final FlyoutController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Txt("${txt("delete")}?"),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () {
            controller.close();
            onConfirm();
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.errorPrimaryColor),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Row(
            children: [
              const Icon(FluentIcons.delete),
              const SizedBox(width: 5),
              Txt(txt("delete")),
            ],
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () => controller.close(),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Row(
            children: [
              const Icon(FluentIcons.cancel),
              const SizedBox(width: 5),
              Txt(txt("cancel")),
            ],
          ),
        )
      ],
    );
  }
}