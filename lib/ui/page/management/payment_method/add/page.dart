import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_order_app/ui/error_handler_mixin.dart';
import 'package:smart_order_app/ui/layout/default_layout.dart';
import 'package:smart_order_app/ui/page/management/payment_method/add/form/payment_method_add_form_controller.dart';
import 'package:smart_order_app/ui/page/management/payment_method/component/payment_method_default_checkbox_form.dart';
import 'package:smart_order_app/ui/page/management/payment_method/component/payment_method_input_form.dart';
import 'package:smart_order_app/usecase/state/payment_methods.dart';

class PaymentMethodAddPage extends HookConsumerWidget with ErrorHandlerMixin {
  const PaymentMethodAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 登録後にTextFieldをクリアするためだけに使う。それ以外で使わないこと。
    final paymentMethodEditingController = useTextEditingController();
    final paymentMethodForm = ref.watch(paymentMethodAddFormControllerProvider);
    return DefaultLayout(
      title: "支払方法の登録",
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              PaymentMethodInputField(
                description: '注文時に表示する支払方法を入力して下さい。\nなお、支払方法は複数登録可能です。',
                controller: paymentMethodEditingController,
                onChanged: ref
                    .read(paymentMethodAddFormControllerProvider.notifier)
                    .onChangeMethod,
                errorMessage:
                    paymentMethodForm.methodInput.displayError?.errorMessage,
              ),
              const SizedBox(
                height: 24,
              ),
              PaymentMethodDefaultCheckboxField(
                value: paymentMethodForm.isDefault,
                onChanged: (bool? newValue) {
                  ref
                      .read(paymentMethodAddFormControllerProvider.notifier)
                      .onChangeIsDefault(newValue);
                },
                additionalMessage:
                    _getIsDefaultAdditionalMessage(paymentMethodForm.isDefault),
              )
            ],
          ),
        ),
        ElevatedButton(
          onPressed: paymentMethodForm.isValid
              ? () async {
                  action() async {
                    await ref
                        .read(paymentMethodsNotifierProvider.notifier)
                        .addPaymentMethod(
                          paymentMethodForm.methodInput.value,
                          paymentMethodForm.isDefault,
                        );
                    paymentMethodEditingController.clear();
                  }

                  await execute(
                    context,
                    action,
                    successMessage: "登録しました",
                  );
                }
              : null,
          child: const Text('登録'),
        ),
      ]),
    );
  }

  String _getIsDefaultAdditionalMessage(bool isDefault) {
    return isDefault
        ? "既にデフォルトとして登録されている支払方法がある場合、その支払方法は、自動的にデフォルトではなくなります。"
        : "";
  }
}
