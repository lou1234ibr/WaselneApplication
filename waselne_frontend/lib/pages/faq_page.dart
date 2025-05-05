import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final List<Map<String, String>> faqs = [
      {
        'question': l10n.howToBook,
        'answer': l10n.bookingProcess,
      },
      {
        'question': l10n.busLocation,
        'answer': l10n.busLocationAnswer,
      },
      {
        'question': l10n.paymentMethod,
        'answer': l10n.paymentMethodAnswer,
      },
      {
        'question': l10n.confirmationEmail,
        'answer': l10n.confirmationEmailAnswer,
      },
      {
        'question': l10n.contactSupport,
        'answer': l10n.contactSupportAnswer,
      },
      {
        'question': l10n.cancelReservation,
        'answer': l10n.cancelReservationAnswer,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.faq,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...faqs.map((faq) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: ExpansionTile(
                  leading: Icon(Icons.question_answer, color: Colors.green[700]),
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
} 