import 'package:flutter/material.dart';

class PesananOrderCard extends StatelessWidget {
  final String orderId;
  final String dateLabel;
  final String serviceTitle;
  final String totalLabel;
  final VoidCallback? onTap;

  const PesananOrderCard({
    super.key,
    required this.orderId,
    required this.dateLabel,
    required this.serviceTitle,
    required this.totalLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        // 🧊 BORDER TIPIS
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            child: Row(
              children: [
                // 🔵 ICON (SOFT BLUE)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF), // soft blue bg
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_laundry_service_rounded,
                    size: 20,
                    color: Color.fromARGB(255, 40, 66, 107), // soft blue icon
                  ),
                ),

                const SizedBox(width: 12),

                // 📄 CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ORDER ID + DATE
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              orderId,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            dateLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // SERVICE
                      Text(
                        serviceTitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // TOTAL + ARROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            totalLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 16, 47, 113), // 🔵 highlight
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: Color.fromARGB(255, 43, 104, 174), // soft blue hint
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}