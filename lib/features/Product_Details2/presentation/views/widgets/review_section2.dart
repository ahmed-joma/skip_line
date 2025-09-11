import 'package:flutter/material.dart';
import '../../manager/product_details2_cubit.dart';
import '../../../data/models/product_details2_model.dart';

class ReviewSection2 extends StatelessWidget {
  final ProductDetails2Model product;
  final ProductDetails2Cubit cubit;

  const ReviewSection2({super.key, required this.product, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            'Review',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(5, (index) {
              return Icon(Icons.star, color: Colors.orange, size: 16);
            }),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
