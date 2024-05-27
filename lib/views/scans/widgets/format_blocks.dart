import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techable/configs/provider/scan_provider.dart';
import 'package:techable/objects/text_group.dart';

class FormatBlocks extends ConsumerWidget {
  const FormatBlocks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanPro = ref.watch(scanProvider);
    return Scaffold(
      body: Column(
        children: [
          scanPro.listKeyValues.isEmpty
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.all(2),
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          List.generate(scanPro.listKeyValues.length, (index) {
                        KeyValueFilter value =
                            scanPro.listKeyValues.elementAt(index);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IntrinsicWidth(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent)),
                                child: Text(
                                  "${value.keyTG.index}: ${value.keyTG.text}",
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 10),
                                ),
                              ),
                            ),
                            value.valueTG.isEmpty
                                ? const SizedBox()
                                : Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: List.generate(
                                          value.valueTG.length,
                                          (indexChild) => Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.blueAccent)),
                                                child: Text(
                                                  value.valueTG
                                                      .elementAt(indexChild)
                                                      .text,
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 10),
                                                ),
                                              )),
                                    ),
                                  ),
                          ],
                        );
                      }),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
