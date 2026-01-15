import 'package:apexo/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

class UnifiedButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final double elevation;
  final Gradient? gradient;
  final double size;

  const UnifiedButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.elevation = 1,
    this.size = 14,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(5),
        color: FluentTheme.of(context).menuColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 1.0),
            blurRadius: 2,
            spreadRadius: 0.5,
            color: Colors.grey.withAlpha(90),
          )
        ]
      ),
      child: IconButton(
        focusable: true,
        autofocus: true,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size,
              color: FluentTheme.of(context).inactiveColor,
            ),
            if (text.isNotEmpty) ...[
              const SizedBox(width: 5),
              Txt(
                text,
                style: TextStyle(fontSize: size),
              )
            ]
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
