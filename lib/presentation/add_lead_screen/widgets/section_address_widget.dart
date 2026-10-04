import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Address Data Model ───────────────────────────────────────────────────────

class _AddressData {
  final TextEditingController street;
  final TextEditingController landmark;
  final TextEditingController city;
  final TextEditingController district;
  final TextEditingController pincode;
  String state;
  String country;
  String addressTag;
  String ownershipStatus;
  String verificationStatus;
  String region;
  String addressSince;
  double? lat;
  double? lng;
  String otherRegion;
  String otherOwnershipStatus;
  String otherAddressTag;

  _AddressData()
    : street = TextEditingController(),
      landmark = TextEditingController(),
      city = TextEditingController(),
      district = TextEditingController(),
      pincode = TextEditingController(),
      state = '',
      country = 'India',
      addressTag = 'Home',
      ownershipStatus = '',
      verificationStatus = 'Unverified',
      region = '',
      addressSince = '',
      otherRegion = '',
      otherOwnershipStatus = '',
      otherAddressTag = '';

  void dispose() {
    street.dispose();
    landmark.dispose();
    city.dispose();
    district.dispose();
    pincode.dispose();
  }

  void copyFrom(_AddressData other) {
    street.text = other.street.text;
    landmark.text = other.landmark.text;
    city.text = other.city.text;
    district.text = other.district.text;
    pincode.text = other.pincode.text;
    state = other.state;
    country = other.country;
    addressTag = other.addressTag;
    ownershipStatus = other.ownershipStatus;
    verificationStatus = other.verificationStatus;
    region = other.region;
    addressSince = other.addressSince;
  }
}

// ─── Section Address Widget ───────────────────────────────────────────────────

class SectionAddressWidget extends StatefulWidget {
  final Map<String, dynamic>? prefillData;
  const SectionAddressWidget({super.key, this.prefillData});

  @override
  State<SectionAddressWidget> createState() => _SectionAddressWidgetState();
}

class _SectionAddressWidgetState extends State<SectionAddressWidget> {
  String _addressType = 'Permanent';

  // Each address type has its own independent data
  final _permanentAddress = _AddressData();
  final _currentAddress = _AddressData();

  static const _addressTypes = ['Permanent', 'Current', 'Both'];
  static const _addressTags = [
    'Home',
    'Office',
    'Billing',
    'Shipping',
    'Site Visit',
    'Warehouse',
    'Branch',
    'Others',
  ];
  static const _ownershipStatuses = [
    'Owned',
    'Rented',
    'Family-Owned',
    'Company-Provided',
    'Others',
  ];
  static const _verificationStatuses = ['Unverified', 'Verified', 'Rejected'];
  static const _regions = [
    'North',
    'South',
    'East',
    'West',
    'Central',
    'North-East',
    'Others',
  ];
  static const _addressProofTypes = [
    'Aadhaar Card',
    'Passport',
    'Utility Bill',
    'Rent Agreement',
    'Bank Statement',
    'Voter ID',
    'Others',
  ];

  static const _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Others',
  ];
  static const _countries = [
    'India',
    'USA',
    'UK',
    'UAE',
    'Singapore',
    'Australia',
    'Canada',
    'Germany',
    'France',
    'Japan',
    'China',
    'South Korea',
    'Brazil',
    'Saudi Arabia',
    'Qatar',
    'Kuwait',
    'Bahrain',
    'Oman',
    'Pakistan',
    'Bangladesh',
    'Sri Lanka',
    'Nepal',
    'Malaysia',
    'Others',
  ];

  static const Map<String, String> _pincodeStateMap = {
    '400': 'Maharashtra',
    '110': 'Delhi',
    '560': 'Karnataka',
    '600': 'Tamil Nadu',
    '500': 'Telangana',
    '380': 'Gujarat',
    '302': 'Rajasthan',
    '700': 'West Bengal',
    '411': 'Maharashtra',
    '226': 'Uttar Pradesh',
    '160': 'Punjab',
    '641': 'Tamil Nadu',
    '682': 'Kerala',
  };

  @override
  void dispose() {
    _permanentAddress.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  void _onPincodeChanged(String value, _AddressData data) {
    if (value.length >= 3) {
      final prefix = value.substring(0, 3);
      final state = _pincodeStateMap[prefix];
      if (state != null) {
        setState(() => data.state = state);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address type segmented control
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            children: _addressTypes.map((type) {
              final isSelected = _addressType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _addressType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.surfaceLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withAlpha(15),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Show address form(s) based on type
        if (_addressType == 'Permanent' || _addressType == 'Both') ...[
          if (_addressType == 'Both') ...[
            _AddressTypeHeader(
              label: 'Permanent Address',
              icon: Icons.home_outlined,
            ),
            const SizedBox(height: 12),
          ],
          _buildAddressForm(_permanentAddress),
        ],
        if (_addressType == 'Both') ...[
          const SizedBox(height: 20),
          _AddressTypeHeader(
            label: 'Current Address',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 8),
          // Copy from permanent option
          GestureDetector(
            onTap: () {
              setState(() => _currentAddress.copyFrom(_permanentAddress));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(60),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.copy_outlined,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Copy from Permanent Address',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAddressForm(_currentAddress),
        ],
        if (_addressType == 'Current') _buildAddressForm(_currentAddress),
        // Single "Open in Maps" button — only here, removed from _buildAddressForm
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.map_outlined, size: 16),
          label: const Text('Open in Maps'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: BorderSide(color: AppTheme.primary.withAlpha(128)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressForm(_AddressData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional notice
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Text(
            'Address is optional — fill only if available',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        // Address Tag
        Text(
          'Address Tag',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _addressTags.map((tag) {
              final isSelected = data.addressTag == tag;
              return GestureDetector(
                onTap: () => setState(() {
                  data.addressTag = tag;
                  if (tag != 'Others') data.otherAddressTag = '';
                }),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryContainer
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Visibility(
          visible: data.addressTag == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Address Tag *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  data.addressTag == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => data.otherAddressTag = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Verification Status
        Row(
          children: [
            Text(
              'Verification: ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            ...['Unverified', 'Verified', 'Rejected'].map((s) {
              final isSelected = data.verificationStatus == s;
              final color = s == 'Verified'
                  ? AppTheme.success
                  : s == 'Rejected'
                  ? AppTheme.error
                  : AppTheme.warning;
              return GestureDetector(
                onTap: () => setState(() => data.verificationStatus = s),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withAlpha(30)
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? color : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Street Address
        TextFormField(
          controller: data.street,
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Icon(Icons.home_outlined, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Landmark
        TextFormField(
          controller: data.landmark,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Landmark',
            prefixIcon: Icon(Icons.place_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // City
        TextFormField(
          controller: data.city,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'City',
            prefixIcon: Icon(Icons.location_city_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // District
        TextFormField(
          controller: data.district,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'District',
            prefixIcon: Icon(Icons.map_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // Pincode
        TextFormField(
          controller: data.pincode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'Pincode',
            prefixIcon: Icon(Icons.pin_drop_outlined, size: 18),
            counterText: '',
          ),
          onChanged: (v) => _onPincodeChanged(v, data),
        ),
        const SizedBox(height: 12),
        // State dropdown
        StatefulBuilder(
          builder: (ctx, setInner) {
            String otherState = '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'State',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: data.state.isEmpty ? null : data.state,
                      isExpanded: true,
                      isDense: true,
                      hint: Text(
                        'Select State',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      items: _states
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => data.state = v);
                          setInner(() {});
                        }
                      },
                      icon: const Icon(Icons.expand_more_rounded, size: 16),
                    ),
                  ),
                ),
                Visibility(
                  visible: data.state == 'Others',
                  maintainState: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Specify State *',
                        hintText: 'Please specify...',
                      ),
                      validator: (v) =>
                          data.state == 'Others' &&
                              (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                      onChanged: (v) => setInner(() => otherState = v),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        // Country dropdown
        StatefulBuilder(
          builder: (ctx, setInner) {
            String otherCountry = '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: data.country.isEmpty ? null : data.country,
                      isExpanded: true,
                      isDense: true,
                      items: _countries
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => data.country = v);
                          setInner(() {});
                        }
                      },
                      icon: const Icon(Icons.expand_more_rounded, size: 16),
                    ),
                  ),
                ),
                Visibility(
                  visible: data.country == 'Others',
                  maintainState: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Specify Country *',
                        hintText: 'Please specify...',
                      ),
                      validator: (v) =>
                          data.country == 'Others' &&
                              (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                      onChanged: (v) => setInner(() => otherCountry = v),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),

        // Region / Zone
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Region / Zone',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: data.region.isEmpty ? null : data.region,
              hint: Text(
                'Select Region',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _regions
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(
                        r,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                data.region = v ?? '';
                if (v != 'Others') data.otherRegion = '';
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        Visibility(
          visible: data.region == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Region *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  data.region == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => data.otherRegion = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Ownership Status
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Ownership Status',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: data.ownershipStatus.isEmpty ? null : data.ownershipStatus,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _ownershipStatuses
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(
                        o,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                data.ownershipStatus = v ?? '';
                if (v != 'Others') data.otherOwnershipStatus = '';
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        Visibility(
          visible: data.ownershipStatus == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Ownership Status *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  data.ownershipStatus == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => data.otherOwnershipStatus = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Address Since
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Address Since (Year)',
            prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
          ),
          onChanged: (v) => data.addressSince = v,
        ),
        const SizedBox(height: 12),

        // Geo-coordinates
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Geo-coordinates',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  if (data.lat != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Captured',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (data.lat != null)
                Text(
                  'Lat: ${data.lat!.toStringAsFixed(6)}, Lng: ${data.lng!.toStringAsFixed(6)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                )
              else
                Text(
                  'Tap to capture current location',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() {
                        data.lat = 12.9716;
                        data.lng = 77.5946;
                      }),
                      icon: const Icon(Icons.gps_fixed_rounded, size: 16),
                      label: Text(
                        'Capture Location',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.primary.withAlpha(120),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.map_outlined, size: 16),
                      label: Text(
                        'Open in Maps',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.surface200),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressTypeHeader extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AddressTypeHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}
