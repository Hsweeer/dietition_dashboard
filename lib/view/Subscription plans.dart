import 'package:flutter/material.dart';
import '../utils/app-colors.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  @override
  _SubscriptionPlanScreenState createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'name': 'Free',
      'duration': '1 Week',
      'cost': '\$0',
      'description': 'Enjoy limited access to basic features.',
      'features': ['Basic Support', 'Access to Free Content']
    },
    {
      'name': 'Weekly',
      'duration': '1 Week',
      'cost': '\$5',
      'description': 'Perfect for short-term use.',
      'features': ['Priority Support', 'Access to All Features']
    },
    {
      'name': 'Monthly',
      'duration': '1 Month',
      'cost': '\$15',
      'description': 'Best for regular users.',
      'features': [
        '24/7 Support',
        'Access to All Features',
        'Monthly Discounts'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary
            ),
            child:Center(
              child: Text(
                'Subscription Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ) ,
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: subscriptionPlans.map((plan) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SubscriptionCard(
                          name: plan['name'],
                          duration: plan['duration'],
                          cost: plan['cost'],
                          description: plan['description'],
                          features: plan['features'],
                          isPopular: plan['name'] == 'Monthly', // Highlight Monthly Plan
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String name;
  final String duration;
  final String cost;
  final String description;
  final List<String> features;
  final bool isPopular;

  const SubscriptionCard({
    Key? key,
    required this.name,
    required this.duration,
    required this.cost,
    required this.description,
    required this.features,
    this.isPopular = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 300,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isPopular
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.8),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isPopular)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Center(
                child: Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      cost,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feature) {
                  return Row(
                    children: [
                      Icon(Icons.check, color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle subscription action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  'Subscribe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
