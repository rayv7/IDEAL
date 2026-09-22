import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutSheet extends StatefulWidget {
  final Map<String, dynamic> cartItems;
  final double subtotal;
  final double deliveryFee;

  const CheckoutSheet({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
  });

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _fulfillmentType = 'Delivery'; // 'Delivery' or 'Pickup'
  String? _selectedHostel;
  String? _selectedSlot;

  final List<String> _hostels = [
    'Bethel Hostel',
    'Ebenezer Hostel',
    'Grace Hostel',
    'Off-Campus Residence',
  ];

  final List<String> _timeSlots = [
    'Immediate (Within 30 mins)',
    '12:00 PM - 2:00 PM',
    '4:00 PM - 6:00 PM',
  ];

  double get _finalTotal {
    return _fulfillmentType == 'Delivery'
        ? widget.subtotal + widget.deliveryFee
        : widget.subtotal;
  }

  Future<void> _sendToWhatsApp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fulfillmentType == 'Delivery' && _selectedHostel == null) {
      Get.snackbar('Error', 'Please select a hostel for delivery',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (_selectedSlot == null) {
      Get.snackbar('Error', 'Please select a time slot',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Build item breakdown text
    StringBuffer itemsBuffer = StringBuffer();
    widget.cartItems.forEach((key, value) {
      final product = value['product'] as Map<String, String>;
      final qty = value['quantity'];
      itemsBuffer.writeln('• ${product['name']} x$qty - ${product['price']}');
    });

    // Format WhatsApp message
    final String message = '''
🛒 *NEW ORDER - IDEAL MINIMART*
--------------------------------
*Customer Details:*
• *Name:* ${_nameController.text.trim()}
• *Phone:* ${_phoneController.text.trim()}
• *Type:* $_fulfillmentType
${_fulfillmentType == 'Delivery' ? '• *Hostel:* $_selectedHostel\n' : ''}• *Slot:* $_selectedSlot

*Order Items:*
${itemsBuffer.toString()}
--------------------------------
• *Subtotal:* Ksh ${widget.subtotal.toStringAsFixed(0)}
• *Delivery Fee:* Ksh ${_fulfillmentType == 'Delivery' ? widget.deliveryFee.toStringAsFixed(0) : '0'}
• *TOTAL AMOUNT:* Ksh ${_finalTotal.toStringAsFixed(0)}
''';

    // Specify merchant WhatsApp number (including country code)
    const String whatsappNumber = '254780529965'; 
    final Uri url = Uri.parse(
        'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55, // Opens at ~half screen
      minChildSize: 0.4,
      maxChildSize: 0.95, // Allows pulling up to cover nearly whole screen
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Checkout Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val!.trim().isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 12),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val!.trim().isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 16),

                    // Delivery vs Pickup Selection
                    const Text('Order Type',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Delivery'),
                            value: 'Delivery',
                            groupValue: _fulfillmentType,
                            onChanged: (val) =>
                                setState(() => _fulfillmentType = val!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Pickup'),
                            value: 'Pickup',
                            groupValue: _fulfillmentType,
                            onChanged: (val) =>
                                setState(() => _fulfillmentType = val!),
                          ),
                        ),
                      ],
                    ),

                    // Hostel Dropdown (Only shown if Delivery selected)
                    if (_fulfillmentType == 'Delivery') ...[
                      DropdownButtonFormField<String>(
                        value: _selectedHostel,
                        decoration: const InputDecoration(
                          labelText: 'Select Hostel',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        items: _hostels.map((hostel) {
                          return DropdownMenuItem(
                            value: hostel,
                            child: Text(hostel),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedHostel = val),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Time Slot Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedSlot,
                      decoration: const InputDecoration(
                        labelText: 'Delivery/Pickup Time Slot',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(),
                      ),
                      items: _timeSlots.map((slot) {
                        return DropdownMenuItem(
                          value: slot,
                          child: Text(slot),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSlot = val),
                    ),
                    const SizedBox(height: 20),

                    // Total Calculation Readout
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total to Pay:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'Ksh ${_finalTotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _sendToWhatsApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          'Place Order via WhatsApp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}