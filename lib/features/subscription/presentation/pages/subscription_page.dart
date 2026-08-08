import 'package:flutter/material.dart';
import '../../../../core/utils/premium_manager.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    // If the user is already premium, show a completely different "Active" UI
    if (PremiumManager.isPremium) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF9C4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.deepPurple, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF9C4),
                Color(0xFFE1BEE7), // Soft purple for premium feel
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)
                  ]
                ),
                child: const Text(
                  '👑',
                  style: TextStyle(fontSize: 80),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'You are Premium!',
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${PremiumManager.activePlanName} Plan Active',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Thank you for subscribing. All premium features, cursive writing, custom words, and the full curriculum are now unlocked for your child!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Start Learning',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              if (PremiumManager.activePlanName == 'Monthly') ...[
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Logic to upgrade to Yearly will go here
                    // e.g., RevenueCat purchasePackage(yearlyPackage)
                  },
                  child: const Text(
                    'Upgrade to Yearly & Save 50%',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.deepPurple, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9C4), // Soft Yellow
              Color(0xFFFFCDD2), // Soft Pink
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Header Icon / Animation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '👑',
                  style: TextStyle(fontSize: 60),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Unlock Premium',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Give your child the best learning experience!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              
              // Features List
              _buildFeatureItem('🚫 No Advertisements'),
              _buildFeatureItem('🔓 Unlock All Words & Numbers'),
              _buildFeatureItem('🚀 Unlimited Daily Practice'),
              _buildFeatureItem('👨‍👩‍👧 Add Custom Words'),
              
              const SizedBox(height: 30),

              // Pricing Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPricingCard(
                        id: 'monthly',
                        title: '1 Month',
                        price: '\$4.99',
                        description: 'Cancel anytime',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildPricingCard(
                        id: 'yearly',
                        title: '1 Year',
                        price: '\$29.99',
                        description: 'Best Value! 50% OFF',
                        isHighlighted: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement actual purchase logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment Gateway will be connected here!'),
                        backgroundColor: Colors.deepPurple,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Legal Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to privacy policy or open url
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.black54, decoration: TextDecoration.underline),
                    ),
                  ),
                  const Text('|', style: TextStyle(color: Colors.black54)),
                  TextButton(
                    onPressed: () {
                      // Restore purchases logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Restoring purchases...')),
                      );
                    },
                    child: const Text(
                      'Restore Purchases',
                      style: TextStyle(color: Colors.black54, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required String id,
    required String title,
    required String price,
    required String description,
    bool isHighlighted = false,
  }) {
    bool isSelected = selectedPlan == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withAlpha(25) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withAlpha(50),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            if (isHighlighted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'SAVE 50%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isHighlighted ? Colors.orange : Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
