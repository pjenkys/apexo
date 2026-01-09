import 'package:apexo/common_widgets/dialog_with_text_box.dart';
import 'package:apexo/core/multi_stream_builder.dart';
import 'package:apexo/features/expenses/expense_model.dart';
import 'package:apexo/features/expenses/folder_widget.dart';
import 'package:apexo/features/expenses/supplier_window_widget.dart';
import 'package:apexo/features/settings/settings_stores.dart';
import 'package:apexo/services/archived.dart';
import 'package:apexo/services/localization/locale.dart';
import 'package:apexo/common_widgets/archive_toggle.dart';
import 'package:apexo/features/expenses/expenses_store.dart';
import 'package:apexo/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      key: WK.expensesScreen,
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      content: Column(
        children: [
          Expanded(
            child: MStreamBuilder(
                streams: [expenses.observableMap.stream, showArchived.stream],
                builder: (context, snapshot) {
                  return SuppliersAndOrders();
                }),
          ),
        ],
      ),
    );
  }
}

class SuppliersAndOrders extends StatefulWidget {
  const SuppliersAndOrders({super.key});

  @override
  State<SuppliersAndOrders> createState() => _SuppliersAndOrdersState();
}

class _SuppliersAndOrdersState extends State<SuppliersAndOrders> {
  Expense? selectedSupplier;
  FlyoutController addOrderFlyout = FlyoutController();

  @override
  Widget build(BuildContext context) {
    final suppliers =
        expenses.present.values.where((e) => e.isSupplier).toList();

    return Column(
      children: [
        _buildCommandBar(),
        _buildSuppliersFolders(context, suppliers),
        if (selectedSupplier != null) _buildInvoicesWindow(),
      ],
    );
  }

  Expanded _buildInvoicesWindow() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.fromLTRB(0, selectedSupplier != null ? 0 : 500, 0, 0),
      child: SupplierWindow(
        orders: expenses.present.values
            .where(
                (o) => (!o.isSupplier) && o.supplierId == selectedSupplier?.id)
            .toList(),
        supplier: selectedSupplier!,
        onClose: () {
          setState(() {
            selectedSupplier = null;
          });
        },
      ),
    ));
  }

  SizedBox _buildSuppliersFolders(
      BuildContext context, List<Expense> suppliers) {
    return SizedBox(
      height: selectedSupplier == null
          ? MediaQuery.of(context).size.height - 200
          : 1,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(15),
          itemCount: suppliers.length,
          itemBuilder: (ctx, i) {
            final supplier = suppliers[i];
            return Folder(
              key: Key(supplier.id),
              isArchived: supplier.archived ?? false,
              icon: FluentIcons.shop,
              title: supplier.supplierName,
              subtitle:
                  "${supplier.duePayments} ${globalSettings.get("currency_______").value}",
              color: supplier.archived == true
                  ? Colors.grey.toAccentColor().lightest.toAccentColor()
                  : supplier.duePayments > 0
                      ? Colors.yellow.toAccentColor().lightest.toAccentColor()
                      : Colors.yellow
                          .toAccentColor()
                          .lightest
                          .toAccentColor()
                          .lightest
                          .toAccentColor(),
              onOpen: () => setState(() => selectedSupplier = supplier),
              onRename: (newName) {
                setState(() {
                  expenses.set(supplier..supplierName = newName);
                });
              },
              onArchive: () => setState(() {
                expenses
                    .set(supplier..archived = !(supplier.archived ?? false));
              }),
            );
          }),
    );
  }

  Acrylic _buildCommandBar() {
    return Acrylic(
      elevation: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectedSupplier == null
                ? _buildAddSupplierButton()
                : _buildAddOrderButton(),
            const ArchiveToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOrderButton() {
    return FlyoutTarget(
      controller: addOrderFlyout,
      child: IconButton(
        onPressed: () {
          addOrderFlyout.showFlyout(builder: (context) {
            return MenuFlyout(
              items: [
                MenuFlyoutItem(
                  text: Txt(txt("unpaid")),
                  leading: const Icon(FluentIcons.file_request),
                  onPressed: () {
                    expenses.set(Expense.fromJson({
                      "supplierId": selectedSupplier!.id,
                      "processed": false,
                    }));
                  },
                ),
                MenuFlyoutItem(
                  text: Txt(txt("paid")),
                  leading: const Icon(FluentIcons.fabric_folder_confirm),
                  onPressed: () {
                    expenses.set(Expense.fromJson({
                      "supplierId": selectedSupplier!.id,
                      "processed": true,
                    }));
                  },
                ),
              ],
            );
          });
        },
        icon: Row(
          children: [
            const Icon(
              FluentIcons.add_notes,
              size: 17,
            ),
            const SizedBox(width: 10),
            Txt(txt("addOrder"))
          ],
        ),
      ),
    );
  }

  Widget _buildAddSupplierButton() {
    return IconButton(
      onPressed: () {
        showDialog(
          barrierDismissible: true,
          dismissWithEsc: true,
          context: context,
          builder: (context) {
            return DialogWithTextBox(
              title: "${txt("addSupplier")}: ${txt("name")}",
              onSave: (supplierNewName) {
                expenses.set(
                  Expense.fromJson({
                    "isSupplier": true,
                    "supplierName": supplierNewName,
                  }),
                );
              },
              icon: FluentIcons.fabric_new_folder,
            );
          },
        );
      },
      icon: Row(
        children: [
          const Icon(
            FluentIcons.fabric_new_folder,
            size: 17,
          ),
          const SizedBox(width: 10),
          Txt(txt("addSupplier"))
        ],
      ),
    );
  }
}
