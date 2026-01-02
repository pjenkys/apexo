import 'package:apexo/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Folder extends StatefulWidget {
  final String title;
  final String subtitle;
  final AccentColor color;
  final IconData icon;
  final VoidCallback? onOpen;
  final void Function(String newName)? onRename;
  final VoidCallback? onArchive;
  final bool? isArchived;

  const Folder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.isArchived,
    this.onOpen,
    this.onRename,
    this.onArchive,
  });

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  bool _isHovered = false;
  FlyoutController ctxMenuCtrl = FlyoutController();
  FlyoutController renameFlyoutCtrl = FlyoutController();
  TextEditingController renameTextBox = TextEditingController();
  FocusNode renameTextBoxFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onOpen,
        child: Stack(
          children: [
            _buildFolderGraphicTop(),
            _buildFolderBody(),
            _buildMoreIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreIcon() {
    return Positioned.directional(
      textDirection: Directionality.of(context),
      end: 0,
      top: 20,
      child: FlyoutTarget(
        controller: renameFlyoutCtrl,
        child: FlyoutTarget(
          controller: ctxMenuCtrl,
          child: IconButton(
            icon: const Icon(FluentIcons.more_vertical, color: Colors.grey),
            onPressed: () {
              ctxMenuCtrl.showFlyout(builder: (context) {
                return MenuFlyout(
                  items: [
                    MenuFlyoutItem(
                      text: Txt(txt("open")),
                      leading: const Icon(FluentIcons.open_folder_horizontal),
                      onPressed: widget.onOpen,
                    ),
                    MenuFlyoutItem(
                      text: Txt(txt("rename")),
                      leading: const Icon(FluentIcons.rename),
                      onPressed: () {
                        renameFlyoutCtrl.showFlyout(builder: (context) {
                          renameTextBox.text = widget.title;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            renameTextBoxFocusNode.requestFocus();
                          });
                          return FlyoutContent(child: _buildRenameDialog());
                        });
                      },
                    ),
                    MenuFlyoutItem(
                      text: widget.isArchived == true
                          ? Txt(txt("restore"))
                          : Txt(txt("archive")),
                      leading: widget.isArchived == true
                          ? const Icon(FluentIcons.archive_undo)
                          : const Icon(FluentIcons.archive),
                      onPressed: widget.onArchive,
                    ),
                  ],
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRenameDialog() {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextBox(
                focusNode: renameTextBoxFocusNode,
                controller: renameTextBox,                
              ),
            ),
          ),
          const SizedBox(width: 5),
          FilledButton(
              child: Row(
                children: [
                  const Icon(FluentIcons.rename),
                  const SizedBox(width: 5),
                  Txt(txt("rename"))
                ],
              ),
              onPressed: () {
                renameFlyoutCtrl.close();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ctxMenuCtrl.close();
                });
                if (widget.onRename != null) {
                  widget.onRename!(renameTextBox.text);
                }
              })
        ],
      ),
    );
  }

  Positioned _buildFolderBody() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color.normal,
          borderRadius: BorderRadius.circular(8),
          border: Border(top: BorderSide(color: Colors.grey.withAlpha(25))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_isHovered ? 50 : 25),
              blurRadius: _isHovered ? 12 : 8,
              offset: Offset(0, _isHovered ? 4 : 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              widget.icon,
              size: 18,
              color: Colors.grey.withAlpha(220),
            ),
            const SizedBox(height: 4),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildFolderGraphicTop() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 40,
        height: 15,
        decoration: BoxDecoration(
          color: widget.color.light,
          border: Border.all(color: Colors.grey.withAlpha(20), width: 1.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
