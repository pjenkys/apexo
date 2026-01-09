import 'package:apexo/common_widgets/dialogs/dialog_styling.dart';
import 'package:apexo/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DialogWithTextBox extends StatelessWidget {
  DialogWithTextBox({
    super.key,
    required this.title,
    required this.onSave,
    required this.icon,
    this.initialValue,
  }) {
    if (initialValue != null) input.text = initialValue!;
  }

  final TextEditingController input = TextEditingController();
  final String title;
  final void Function(String input) onSave;
  final IconData icon;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      style: dialogStyling(context, false),
      title: Row(children: [Icon(icon), const SizedBox(width: 5), Txt(title)]),
      content: SizedBox(
        height: 45,
        child: TextBox(
          controller: input,
          autofocus: true,
          expands: false,
        ),
      ),
      actions: [
        FilledButton(
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 5),
              Txt(txt("save")),
            ],
          ),
          onPressed: () {
            onSave(input.text);
            input.text = "";
            Navigator.of(context).pop();
          },
        ),
        Button(
          child: Row(
            children: [
              const Icon(FluentIcons.cancel),
              const SizedBox(width: 5),
              Txt(txt("cancel"))
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
