import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_order_app/ui/component/error_message.dart';
import 'package:smart_order_app/ui/component/list_tile_navigation.dart';
import 'package:smart_order_app/ui/component/loader.dart';
import 'package:smart_order_app/ui/page/order/select/page.dart';
import 'package:smart_order_app/usecase/state/scenes.dart';

class SimpleDrawer extends ConsumerWidget {
  const SimpleDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenesFuture = ref.watch(scenesNotifierProvider);
    return Drawer(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12.0, 32.0, 12.0, 16.0),
          child: ListView(
            children: [
              const Text("◼️場面選択"),
              scenesFuture.when(
                error: (e, s) => const ErrorMessage(),
                loading: () => const Loader(),
                data: (scenes) {
                  return Column(
                    children: scenes.map((scene) {
                      return ListTileNavigation(
                        option: ListTileOption(
                          title: scene.scene,
                          nextPage: OrderSelectPage(sceneName: scene.scene),
                          navigateType: NavigationType.pushReplacement,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
