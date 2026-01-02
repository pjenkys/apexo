import 'package:apexo/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AcrylicButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final double elevation;
  final Gradient? gradient;
  final double size;

  const AcrylicButton({
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
    return Acrylic(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: elevation,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(5),
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
      ),
    );
  }
}
