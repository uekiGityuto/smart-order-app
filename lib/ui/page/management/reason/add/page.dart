import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_order_app/ui/component/form_error_message.dart';
import 'package:smart_order_app/ui/component/simple_checkbox_list_tile.dart';
import 'package:smart_order_app/ui/error_handler_mixin.dart';
import 'package:smart_order_app/ui/layout/default_layout.dart';
import 'package:smart_order_app/ui/page/management/reason/add/form/add_reason_form_controller.dart';
import 'package:smart_order_app/usecase/state/reasons.dart';

class ReasonAddPage extends ConsumerWidget with ErrorHandlerMixin {
  const ReasonAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasonForm = ref.watch(addReasonFormControllerProvider);
    final navigator = Navigator.of(context);
    return DefaultLayout(
      title: "理由登録",
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '理由を入力してください',
                    ),
                    onChanged: ref
                        .read(addReasonFormControllerProvider.notifier)
                        .onChangeReason,
                  ),
                  FormErrorMessage(
                    errorMessage:
                        reasonForm.reasonInput.displayError?.errorMessage,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              SimpleCheckboxListTile(
                value: reasonForm.isDefault,
                onChanged: (bool? newValue) {
                  ref
                      .read(addReasonFormControllerProvider.notifier)
                      .onChangeIsDefault(newValue);
                },
                title: "デフォルトとして登録",
              ),
              Visibility(
                visible: reasonForm.isDefault,
                child: Text(
                  "既にデフォルトとして登録されている理由がある場合、その理由は、自動的にデフォルトではなくなります。",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: reasonForm.isValid
              ? () async {
                  action() =>
                      ref.read(reasonsNotifierProvider.notifier).addReason(
                          reasonForm.reasonInput.value, reasonForm.isDefault);
                  await execute(
                    context,
                    action,
                    successMessage: "登録しました",
                  );
                  navigator.pop();
                }
              : null,
          child: const Text('登録'),
        ),
      ]),
    );
  }
}
