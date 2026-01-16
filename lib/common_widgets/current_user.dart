import 'package:apexo/common_widgets/button_styles.dart';
import 'package:apexo/services/localization/locale.dart';
import 'package:apexo/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../services/login.dart';

class CurrentUser extends StatelessWidget {
  const CurrentUser({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(FluentIcons.contact),
        const SizedBox(width: 5),
        StreamBuilder(stream: login.stream, builder: (context, _) => Txt(login.email)),
        const SizedBox(width: 5),
        Button(
          key: WK.btnLogout,
          onPressed: login.logout,
          child: ButtonContent(FluentIcons.sign_out, txt("logout")),
        ),
      ],
    );
  }
}
