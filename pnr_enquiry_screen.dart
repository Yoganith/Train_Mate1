import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PNREnquiryScreen extends StatefulWidget {
  const PNREnquiryScreen({super.key});

  @override
  State<PNREnquiryScreen> createState() => _PNREnquiryScreenState();
}

class _PNREnquiryScreenState extends State<PNREnquiryScreen> {
  final TextEditingController _pnrController = TextEditingController();
  Map<String, dynamic>? passengerDetails;
  bool _isLoading = false;

  void checkPNR() {
    if (_pnrController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        // 🔹 Mock PNR details (later replace with API response)
        passengerDetails = {
          "pnr": _pnrController.text,
          "train": "Chennai Express",
          "trainNo": "12939",
          "date": "12-09-2025",
          "from": "Chennai",
          "to": "Mumbai",
          "departureTime": "10:30",
          "arrivalTime": "08:45",
          "passenger": [
            {
              "name": "Rahul",
              "age": 25,
              "gender": "Male",
              "status": "Confirmed",
              "coach": "B2",
              "berth": "23",
              "berthType": "Lower"
            },
            {
              "name": "Priya",
              "age": 23,
              "gender": "Female",
              "status": "RAC",
              "coach": "B2",
              "berth": "RAC 1",
              "berthType": "Side Lower"
            },
          ]
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('PNR Status', style: textTheme.titleLarge),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Search Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Check PNR Status',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your 10-digit PNR number',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pnrController,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'PNR Number',
                      labelStyle:
                          TextStyle(color: colorScheme.onSurfaceVariant),
                      prefixIcon: Icon(Icons.airplane_ticket,
                          color: colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : checkPNR,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isLoading ? 'Checking...' : 'Check Status'),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(),

          // Results
          if (passengerDetails != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Train Details Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.train,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        passengerDetails!['train'],
                                        style: textTheme.titleMedium,
                                      ),
                                      Text(
                                        passengerDetails!['trainNo'],
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'From',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          passengerDetails!['from'],
                                          style: textTheme.titleMedium,
                                        ),
                                        Text(
                                          passengerDetails!['departureTime'],
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                      color:
                                          colorScheme.outline.withOpacity(0.5)),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'To',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          passengerDetails!['to'],
                                          style: textTheme.titleMedium,
                                        ),
                                        Text(
                                          passengerDetails!['arrivalTime'],
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn()
                        .slideY(delay: const Duration(milliseconds: 200)),

                    const SizedBox(height: 16),

                    // Passengers Card
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Passenger Details',
                              style: textTheme.titleMedium,
                            ),
                          ),
                          const Divider(height: 1),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: passengerDetails!['passenger'].length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final p = passengerDetails!['passenger'][index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: p['gender'] == "Male"
                                      ? colorScheme.primaryContainer
                                      : colorScheme.secondaryContainer,
                                  child: Icon(
                                    p['gender'] == "Male"
                                        ? Icons.person_outline
                                        : Icons.person_outline,
                                    color: p['gender'] == "Male"
                                        ? colorScheme.primary
                                        : colorScheme.secondary,
                                  ),
                                ),
                                title: Text("${p['name']} (${p['age']})",
                                    style: textTheme.titleSmall),
                                subtitle: Text(
                                  "Coach: ${p['coach']} • Berth: ${p['berth']} (${p['berthType']})",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p['status'] == "Confirmed"
                                        ? colorScheme.primaryContainer
                                        : colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    p['status'],
                                    style: textTheme.labelSmall?.copyWith(
                                      color: p['status'] == "Confirmed"
                                          ? colorScheme.primary
                                          : colorScheme.error,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn()
                        .slideY(delay: const Duration(milliseconds: 400)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
