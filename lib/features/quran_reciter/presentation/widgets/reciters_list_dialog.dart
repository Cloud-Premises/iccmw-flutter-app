import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iccmw/features/quran_reciter/presentation/providers/reciters_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ReciterDropdownWidget extends StatelessWidget {
  const ReciterDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReciterProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()));
        }

        if (provider.reciterList == null || provider.reciterList!.isEmpty) {
          return const Center(child: Text('No Reciters Available'));
        }

        return SizedBox(
          height: 300, // Fixed height for the SizedBox
          child: ListView.builder(
            itemCount: provider.reciterList!.length,
            itemBuilder: (context, index) {
              final reciter = provider.reciterList![index];
              final isSelected = reciter == provider.selectedReciter;

              return ListTile(
                leading: Text(
                  (index + 1)
                      .toString(), // Display sequential numbers starting from 1
                  style: const TextStyle(fontSize: 16),
                ),
                title: Text(
                  reciter.reciterNameEng,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  // Select the reciter in the provider
                  provider.selectReciter(reciter);

                  // Print the selected reciter's name and audio path
                  // print('Selected Reciter: ${reciter.reciterNameEng}');
                  // print('Audio Path: ${reciter.audioPath}');
                },
              );
            },
          ),
        );
      },
    );
  }
}
