import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_skeleton_widget.dart';
import './widgets/lead_card_widget.dart';
import './widgets/lead_filter_bar_widget.dart';
import './widgets/pipeline_kpi_widget.dart';

// Global leads list — starts with rich default leads showing all possible fields
final List<Map<String, dynamic>> globalLeadMaps = [
// ── FULLY FILLED TEST LEAD — shows every Add Lead field in overview ──
{ 'id': 'test-full-001',
'name': 'Arjun Kapoor',
'phone': '+91 99887 76655',
'email': 'arjun.kapoor@fulltest.in',
'company': 'FullTest Enterprises',
'industry': 'Manufacturing',
'status': 'Proposed',
'priority': 'High',
'score': 88,
'dealValue': 850000.0,
'ownerInitials': 'PS',
'ownerName': 'Priya Sharma',
'lastContact': 'Today',
'tags': ['Life Insurance', 'Health Cover', 'Motor Insurance', 'Mutual Funds', 'Home Loan'],
// ── Step 1: Contact Info ── 'salutation': 'Mr.',
'firstName': 'Arjun',
'middleName': 'Raj',
'lastName': 'Kapoor',
'nickname': 'AK',
'primaryMobile': '+91 99887 76655',
'alternatePhone': '+91 99887 00000',
'whatsapp': '+91 99887 76655',
'primaryEmail': 'arjun.kapoor@fulltest.in',
'secondaryEmail': 'arjun.personal@gmail.com',
'gender': 'Male',
'maritalStatus': 'Married',
'dob': '10/07/1988',
'anniversaryDate': '15/02/2015',
'spouseName': 'Neha Kapoor',
'numberOfDependents': '3',
'annualIncome': '₹22,00,000',
'customerType': 'Individual',
'preferredLanguage': 'Hindi',
'bestTimeToCall': 'Evening',
'timezone': 'IST (UTC+5:30)',
'communicationOptIn': 'SMS, WhatsApp, Email',
'occupation': 'Factory Owner',
'degree': 'B.E. Mechanical',
'companyWorking': 'FullTest Enterprises Pvt Ltd',
'workingSalary': '₹22,00,000 per annum',
'yearsOfService': '10 years',
'pan': 'BCDFE5678G',
'aadhaar': '9876 5432 1098',
'gstin': '27BCDFE5678G1Z3',
// ── Step 2: Business Details ── 'companyName': 'FullTest Enterprises',
'companyIndustry': 'Manufacturing',
'designation': 'Managing Director',
'department': 'Operations',
'companySize': '51-100',
'annualRevenue': '₹3 Crore',
'numberOfEmployees': '75',
'companyPhone': '+91 22 4567 8901',
'companyEmail': 'info@fulltest.in',
'website': 'www.fulltest.in',
'businessType': 'Private Limited',
'gstNumber': '27BCDFE5678G1Z3',
'yearEstablished': '2014',
'companyPan': 'AABFT5678C',
'cinNumber': 'U27200MH2014PTC234567',
'decisionMakerRole': 'MD',
'decisionLevel': 'C-Suite',
'companyAddress': '15, MIDC Industrial Area, Pune',
'businessModel': 'B2B & B2C',
'fundingStage': 'Bootstrapped',
'keyCompetitors': 'Godrej, Bosch, Siemens',
'technologiesUsed': 'SAP, AutoCAD, Tally',
// ── Step 3: Lead Details ── 'source': 'Referral',
'campaign': 'Q4 SME Drive',
'utmSource': 'referral',
'utmMedium': 'partner',
'referralName': 'Suresh Joshi',
'tier': 'Silver',
'isVip': false,
'currency': '₹ INR',
'expectedCloseDate': '${DateTime.now().add(const Duration(days: 45)).day}/${DateTime.now().add(const Duration(days: 45)).month}/${DateTime.now().add(const Duration(days: 45)).year}',
'scheduledAction': 'Appointment',
'scheduledActionDate': '${DateTime.now().add(const Duration(days: 5)).day}/${DateTime.now().add(const Duration(days: 5)).month}/${DateTime.now().add(const Duration(days: 5)).year}',
'scheduledActionTime': '11:00',
'actionNotes': 'Present comprehensive insurance + investment portfolio proposal.',
'leadScore': 88.0,
'leadGrade': 'B+',
'conversionProbability': 72.0,
'forecastCategory': 'Pipeline',
'bantBudget': '₹8,50,000 approved',
'bantAuthority': 'MD sign-off',
'bantNeed': 'Life + Health + Motor + Investment portfolio',
'bantTimeline': 'Q1 2027',
'quotationId': 'QT-2026-0088',
'proposalSentDate': '${DateTime.now().subtract(const Duration(days: 3)).day}/${DateTime.now().subtract(const Duration(days: 3)).month}/${DateTime.now().subtract(const Duration(days: 3)).year}',
'discountPercent': '3%',
'contractLength': '12 months',
'renewalFrequency': 'Annual',
'nextBestAction': 'Follow up on proposal',
'leadStatusSubState': 'Proposed → Awaiting Decision',
// ── Step 4: Address ── 'addressType': 'Permanent',
'address': '15, MIDC Industrial Area',
'landmark': 'Near Pune Station',
'city': 'Pune',
'district': 'Pune',
'pincode': '411019',
'state': 'Maharashtra',
'country': 'India',
'addressTag': 'Office',
'region': 'West',
'ownershipStatus': 'Owned',
'addressSince': '2014',
// ── Step 5: Social ── 'linkedin': 'linkedin.com/in/arjunkapoor',
'twitter': '@arjunkapoor_mfg',
'facebook': 'facebook.com/arjunkapoor',
'instagram': '@arjunkapoor',
'youtube': '',
'github': '',
'telegram': '@arjunkapoor_tg',
'preferredMeetingTool': 'Zoom',
'calendlyLink': 'calendly.com/arjunkapoor',
'interests': ['Life Insurance', 'Health Cover', 'Motor Insurance', 'Mutual Funds', 'Home Loan', 'SIP', 'Tax Planning'],
'interest_Life Insurance': {'priority': 'High', 'readiness': 'Ready to Buy', 'coverAmount': '₹75 Lakh', 'premiumFrequency': 'Annual', 'estimatedPremium': '₹18,000/yr', 'kyc': 'Verified', 'closingProbability': '78%', 'paymentMode': 'NEFT', 'interestStatus': 'Quoted'},
'interest_Health Cover': {'priority': 'High', 'readiness': 'Comparing Options', 'coverAmount': '₹20 Lakh Family Floater', 'premiumFrequency': 'Annual', 'estimatedPremium': '₹14,000/yr', 'kyc': 'Submitted', 'closingProbability': '65%', 'interestStatus': 'Negotiation'},
'interest_Motor Insurance': {'priority': 'Medium', 'readiness': 'Renewal Due', 'vehicle': 'Toyota Fortuner 2023', 'premiumFrequency': 'Annual', 'estimatedPremium': '₹22,000/yr', 'kyc': 'Verified', 'interestStatus': 'Exploring'},
'interest_Mutual Funds': {'priority': 'High', 'readiness': 'Ready to Invest', 'investmentAmount': '₹30,000/month SIP', 'riskProfile': 'Moderate', 'interestStatus': 'Quoted'},
'interest_Home Loan': {'priority': 'Medium', 'readiness': 'Exploring', 'loanAmount': '₹60 Lakh', 'tenure': '20 years', 'interestStatus': 'Exploring'},
'interest_SIP': {'priority': 'High', 'readiness': 'Active', 'investmentAmount': '₹15,000/month', 'riskProfile': 'Moderate', 'interestStatus': 'Won'},
'interest_Tax Planning': {'priority': 'Medium', 'readiness': 'Planning', 'targetSaving': '₹1,50,000 under 80C', 'interestStatus': 'Exploring'},
// ── Interest-specific Notes ── 'interest_notes_Life Insurance': 'Customer wants ₹75L term cover. Prefers LIC or HDFC. Annual premium budget around ₹18K. Nominee: Neha Kapoor (spouse).',
'interest_notes_Health Cover': 'Family floater for 4 members. Comparing Star Health vs Niva Bupa. Needs cashless at Pune hospitals.',
'interest_notes_Mutual Funds': 'Ready to start ₹30K/month SIP. Prefers large-cap + balanced funds. Risk: Moderate.',
'relations': [ {'name': 'Neha Kapoor', 'relation': 'Spouse', 'phone': '+91 99887 11111', 'age': '33', 'occupation': 'Teacher', 'email': 'neha.kapoor@gmail.com', 'gender': 'Female', 'isCoApplicant': true, 'isBeneficiary': true, 'influenceLevel': '4', 'annualIncome': '₹6,00,000'},
{'name': 'Rohan Kapoor', 'relation': 'Son', 'phone': '', 'age': '7', 'occupation': 'Student', 'isBeneficiary': true},
{'name': 'Ramesh Kapoor', 'relation': 'Father', 'phone': '+91 99887 22222', 'age': '62', 'occupation': 'Retired', 'influenceLevel': '3'},
],
'createdAt': DateTime.now().subtract(const Duration(days: 2, hours: 1, minutes: 15)),
},
{ 'id': 'default-1',
'name': 'Rahul Mehta',
'phone': '+91 98765 43210',
'email': 'rahul.mehta@techcorp.in',
'company': 'TechCorp Solutions',
'industry': 'Technology',
'status': 'Qualified',
'priority': 'High',
'score': 92,
'dealValue': 1250000.0,
'ownerInitials': 'PS',
'ownerName': 'Priya Sharma',
'lastContact': 'Today',
'tags': ['Life Insurance', 'Health Cover', 'Motor Insurance', 'Home Insurance', 'Travel Insurance', 'Mutual Funds', 'Equity', 'Fixed Deposits', 'Real Estate', 'Education Plan'],
// ── Step 1: Contact Info ── 'salutation': 'Mr.',
'firstName': 'Rahul',
'middleName': 'Kumar',
'lastName': 'Mehta',
'nickname': 'RK',
'primaryMobile': '+91 98765 43210',
'alternatePhone': '+91 98765 00000',
'whatsapp': '+91 98765 43210',
'primaryEmail': 'rahul.mehta@techcorp.in',
'secondaryEmail': 'rahul.personal@gmail.com',
'gender': 'Male',
'maritalStatus': 'Married',
'dob': '15/03/1985',
'anniversaryDate': '20/11/2010',
'spouseName': 'Priya Mehta',
'numberOfDependents': '2',
'annualIncome': '₹18,00,000',
'customerType': 'Individual',
'preferredLanguage': 'English',
'bestTimeToCall': 'Morning',
'timezone': 'IST (UTC+5:30)',
'communicationOptIn': 'SMS, Email, WhatsApp',
'occupation': 'Software Engineer',
'degree': 'B.Tech Computer Science',
'companyWorking': 'TechCorp Solutions Pvt Ltd',
'workingSalary': '₹18,00,000 per annum',
'yearsOfService': '12 years',
'pan': 'ABCDE1234F',
'aadhaar': '1234 5678 9012',
'gstin': '29ABCDE1234F1Z5',
// ── Step 2: Business Details ── 'companyName': 'TechCorp Solutions',
'companyIndustry': 'Technology',
'designation': 'CTO',
'department': 'Technology',
'companySize': '101-500',
'annualRevenue': '₹5 Crore',
'numberOfEmployees': '150',
'companyPhone': '+91 80 4567 8901',
'companyEmail': 'info@techcorp.in',
'website': 'www.techcorp.in',
'businessType': 'Private Limited',
'gstNumber': '29ABCDE1234F1Z5',
'yearEstablished': '2012',
'companyPan': 'AABCT1234C',
'cinNumber': 'U72200KA2012PTC123456',
'decisionMakerRole': 'CTO',
'decisionLevel': 'C-Suite',
'companyAddress': '42, MG Road, Indiranagar, Bangalore',
'businessModel': 'B2B',
'fundingStage': 'Series B',
'keyCompetitors': 'Infosys, Wipro, HCL',
'technologiesUsed': 'AWS, React, Flutter, Python',
// ── Step 3: Lead Details ── 'pipelineStage': 'Qualified',
'campaign': 'Q3 Enterprise Drive',
'utmSource': 'linkedin',
'utmMedium': 'paid',
'referralName': 'Amit Gupta',
'tier': 'Gold',
'isVip': true,
'currency': '₹ INR',
'expectedCloseDate': '${DateTime.now().add(const Duration(days: 30)).day}/${DateTime.now().add(const Duration(days: 30)).month}/${DateTime.now().add(const Duration(days: 30)).year}',
'scheduledAction': 'Appointment',
'scheduledActionDate': '${DateTime.now().add(const Duration(days: 3)).day}/${DateTime.now().add(const Duration(days: 3)).month}/${DateTime.now().add(const Duration(days: 3)).year}',
'scheduledActionTime': '10:30',
'actionNotes': 'Discuss enterprise plan pricing and Q4 rollout timeline.',
'leadScore': 92.0,
'leadGrade': 'A',
'conversionProbability': 85.0,
'forecastCategory': 'Commit',
'bantBudget': '₹12,50,000 approved',
'bantAuthority': 'CTO + CFO sign-off',
'bantNeed': 'Comprehensive insurance + investment portfolio',
'bantTimeline': 'Q4 2026',
'quotationId': 'QT-2026-0042',
'proposalSentDate': '${DateTime.now().subtract(const Duration(days: 5)).day}/${DateTime.now().subtract(const Duration(days: 5)).month}/${DateTime.now().subtract(const Duration(days: 5)).year}',
'discountPercent': '5%',
'contractLength': '24 months',
'renewalFrequency': 'Annual',
'nextBestAction': 'Send pricing proposal',
'leadStatusSubState': 'Contacted → Meeting Scheduled',
// ── Step 4: Address ── 'addressType': 'Permanent',
'address': '42, MG Road, Indiranagar',
'landmark': 'Near Metro Station',
'city': 'Bangalore',
'district': 'Bangalore Urban',
'pincode': '560001',
'state': 'Karnataka',
'country': 'India',
'addressTag': 'Home',
'region': 'South',
'ownershipStatus': 'Owned',
'addressSince': '2015',
// ── Step 5: Social ── 'linkedin': 'linkedin.com/in/rahulmehta',
'twitter': '@rahulmehta_tech',
'facebook': 'facebook.com/rahulmehta',
'instagram': '@rahulmehta',
'youtube': 'youtube.com/@rahulmehta',
'github': 'github.com/rahulmehta',
'telegram': '@rahulmehta_tg',
'preferredMeetingTool': 'Google Meet',
'calendlyLink': 'calendly.com/rahulmehta',
// ── Step 6: Notes (stored separately, not in overview) ── // notes intentionally NOT stored here — stored in _notes list in detail screen // ── Step 7: Interests ── 'interests': [ 'Life Insurance', 'Health Cover', 'Motor Insurance', 'Home Insurance', 'Travel Insurance', 'Real Estate', 'Education Plan', 'Software/IT', 'Healthcare', 'Automotive', 'Financial Services', 'Retail', 'Hospitality', 'Consulting', 'Agriculture', 'Mutual Funds', 'Equity', 'Fixed Deposits', 'TPD Insurance', 'Income Protection', 'Trauma/Critical Illness', 'Superannuation', 'Personal Loan', 'Home Loan', 'SIP', 'Tax Planning', ],
'interest_Life Insurance': {'priority': 'High', 'readiness': 'Ready to Buy', 'coverAmount': '₹1 Crore', 'premiumFrequency': 'Annual', 'estimatedPremium': '₹25,000/yr', 'kyc': 'Verified', 'closingProbability': '85%', 'paymentMode': 'UPI', 'interestStatus': 'Quoted'},
'interest_Health Cover': {'priority': 'High', 'readiness': 'Comparing Options', 'coverAmount': '₹25 Lakh Family Floater', 'premiumFrequency': 'Annual', 'estimatedPremium': '₹18,000/yr', 'kyc': 'Submitted', 'closingProbability': '70%', 'interestStatus': 'Negotiation'},
'interest_Motor Insurance': {'priority': 'Medium', 'readiness': 'Renewal Due', 'vehicle': 'Honda City 2022', 'premiumFrequency': 'Annual', 'estimatedPremium': '₹12,000/yr', 'kyc': 'Verified', 'interestStatus': 'Exploring'},
'interest_Home Insurance': {'priority': 'Medium', 'readiness': 'Exploring', 'propertyValue': '₹85 Lakh', 'estimatedPremium': '₹8,500/yr', 'interestStatus': 'Exploring'},
'interest_Travel Insurance': {'priority': 'Low', 'readiness': 'Seasonal', 'destination': 'International', 'estimatedPremium': '₹3,500/trip', 'interestStatus': 'Exploring'},
'interest_Mutual Funds': {'priority': 'High', 'readiness': 'Ready to Invest', 'investmentAmount': '₹50,000/month SIP', 'riskProfile': 'Moderate-Aggressive', 'interestStatus': 'Quoted'},
'interest_Equity': {'priority': 'High', 'readiness': 'Active Investor', 'investmentAmount': '₹2,00,000 lump sum', 'riskProfile': 'Aggressive', 'interestStatus': 'Won'},
'interest_Fixed Deposits': {'priority': 'Medium', 'readiness': 'Comparing Rates', 'investmentAmount': '₹5,00,000', 'tenure': '3 years', 'interestStatus': 'Exploring'},
'interest_Real Estate': {'priority': 'Medium', 'readiness': 'Exploring', 'propertyType': 'Residential Apartment', 'budget': '₹80 Lakh', 'interestStatus': 'Exploring'},
'interest_Education Plan': {'priority': 'High', 'readiness': 'Planning', 'childAge': '5 years', 'targetAmount': '₹30 Lakh in 13 years', 'interestStatus': 'Quoted'},
'interest_TPD Insurance': {'priority': 'Medium', 'readiness': 'Exploring', 'coverAmount': '₹50 Lakh', 'estimatedPremium': '₹15,000/yr', 'interestStatus': 'Exploring'},
'interest_Income Protection': {'priority': 'High', 'readiness': 'Ready to Buy', 'coverAmount': '75% of income', 'estimatedPremium': '₹20,000/yr', 'interestStatus': 'Quoted'},
'interest_SIP': {'priority': 'High', 'readiness': 'Active', 'investmentAmount': '₹25,000/month', 'riskProfile': 'Moderate', 'interestStatus': 'Won'},
// ── Interest-specific Notes ── 'interest_notes_Life Insurance': 'Wants comprehensive term plan. Nominee is spouse Priya. Prefers HDFC Life. Budget ₹20K/yr.',
'interest_notes_Health Cover': 'Family floater for 4. Needs maternity cover. Comparing Niva Bupa vs Star Health.',
// ── Step 8: Relations ──
'relations': [ {'name': 'Priya Mehta', 'relation': 'Spouse', 'phone': '+91 98765 11111', 'age': '35', 'occupation': 'Doctor', 'email': 'priya.mehta@gmail.com', 'gender': 'Female', 'isCoApplicant': true, 'isBeneficiary': true, 'influenceLevel': '4', 'annualIncome': '₹12,00,000'},
{'name': 'Arjun Mehta', 'relation': 'Son', 'phone': '', 'age': '5', 'occupation': 'Student', 'isBeneficiary': true},
{'name': 'Suresh Mehta', 'relation': 'Father', 'phone': '+91 98765 22222', 'age': '65', 'occupation': 'Retired', 'influenceLevel': '2'},
],
'createdAt': DateTime.now().subtract(const Duration(days: 5, hours: 3, minutes: 22)),
},
{ 'id': 'default-2',
'name': 'Sneha Kapoor',
'phone': '+91 87654 32109',
'email': 'sneha.k@financeplus.com',
'company': 'FinancePlus Ltd',
'industry': 'Finance',
'status': 'Engaged',
'priority': 'Medium',
'score': 65,
'dealValue': 280000.0,
'ownerInitials': 'RS',
'ownerName': 'Rahul Singh',
'lastContact': '1 week ago',
'tags': ['Term Insurance', 'Health Cover', 'Group Policy'],
'designation': 'Finance Manager',
'source': 'Referral',
'city': 'Mumbai',
'state': 'Maharashtra',
'country': 'India',
'occupation': 'Finance Manager',
'degree': 'MBA Finance',
'companyWorking': 'FinancePlus Ltd',
'workingSalary': '₹12,00,000 per annum',
'yearsOfService': '7 years',
'interests': ['Term Insurance', 'Health Cover', 'Group Policy'],
'createdAt': DateTime.now().subtract(const Duration(days: 12, hours: 7, minutes: 45)),
'scheduledAction': 'Follow-up',
'scheduledActionDate': '${DateTime.now().add(const Duration(days: 1)).day}/${DateTime.now().add(const Duration(days: 1)).month}/${DateTime.now().add(const Duration(days: 1)).year}',
'scheduledActionTime': '14:00',
},
{ 'id': 'default-3',
'name': 'Vikram Singh',
'phone': '+91 76543 21098',
'email': 'vikram@healthbridge.org',
'company': 'HealthBridge',
'industry': 'Healthcare',
'status': 'Proposed',
'priority': 'High',
'score': 74,
'dealValue': 620000.0,
'ownerInitials': 'PS',
'ownerName': 'Priya Sharma',
'lastContact': '3 days ago',
'tags': ['Premium Upgrade', 'Family Floater', 'Critical Illness Cover'],
'designation': 'Operations Head',
'source': 'Trade Show',
'city': 'Hyderabad',
'state': 'Telangana',
'country': 'India',
'occupation': 'Operations Head',
'degree': 'MBBS, MBA',
'companyWorking': 'HealthBridge Pvt Ltd',
'workingSalary': '₹22,00,000 per annum',
'yearsOfService': '9 years',
'linkedin': 'linkedin.com/in/vikramsingh',
'interests': ['Premium Upgrade', 'Family Floater', 'Critical Illness Cover'],
'createdAt': DateTime.now().subtract(const Duration(days: 8, hours: 1, minutes: 10)),
'scheduledAction': 'Video Call',
'scheduledActionDate': '${DateTime.now().add(const Duration(days: 5)).day}/${DateTime.now().add(const Duration(days: 5)).month}/${DateTime.now().add(const Duration(days: 5)).year}',
'scheduledActionTime': '11:00',
},
{ 'id': 'default-4',
'name': 'Anita Desai',
'phone': '+91 65432 10987',
'email': 'anita.desai@retailhub.in',
'company': 'RetailHub India',
'industry': 'Retail',
'status': 'Result',
'priority': 'Low',
'score': 91,
'dealValue': 175000.0,
'ownerInitials': 'AP',
'ownerName': 'Ananya Patel',
'lastContact': 'Yesterday',
'tags': ['Add-on Cover', 'Family Floater'],
'designation': 'Proprietor',
'source': 'Walk-in',
'city': 'Delhi',
'state': 'Delhi',
'country': 'India',
'occupation': 'Business Owner',
'degree': 'B.Com',
'companyWorking': 'RetailHub India',
'workingSalary': '₹8,00,000 per annum',
'yearsOfService': '15 years',
'interests': ['Add-on Cover', 'Family Floater'],
'createdAt': DateTime.now().subtract(const Duration(days: 20, hours: 9, minutes: 30)),
'isExistingCustomer': true,
'scheduledAction': 'Call Back',
},
{ 'id': 'default-5',
'name': 'Karan Joshi',
'phone': '+91 54321 09876',
'email': 'karan.j@edutech.co',
'company': 'EduTech Co',
'industry': 'Education',
'status': 'New',
'priority': 'Medium',
'score': 55,
'dealValue': 95000.0,
'ownerInitials': 'KM',
'ownerName': 'Kavya Menon',
'lastContact': '5 days ago',
'tags': ['Startup Plan', 'Basic Cover'],
'designation': 'Founder',
'source': 'Cold Call',
'city': 'Pune',
'state': 'Maharashtra',
'country': 'India',
'occupation': 'Entrepreneur',
'degree': 'B.E. Electronics',
'companyWorking': 'EduTech Co',
'workingSalary': '₹6,00,000 per annum',
'yearsOfService': '3 years',
'interests': ['Startup Plan', 'Basic Cover'],
'createdAt': DateTime.now().subtract(const Duration(days: 6, hours: 4, minutes: 55)),
'scheduledAction': 'Video Call',
'scheduledActionDate': '${DateTime.now().add(const Duration(days: 4)).day}/${DateTime.now().add(const Duration(days: 4)).month}/${DateTime.now().add(const Duration(days: 4)).year}',
'scheduledActionTime': '16:30',
},
{ 'id': 'default-6',
'name': 'Mohammed Al-Rashid',
'phone': '+971 50 123 4567',
'email': 'mohammed@alrashid.ae',
'company': 'Al-Rashid Trading LLC',
'industry': 'Trading',
'status': 'Qualified',
'priority': 'High',
'score': 88,
'dealValue': 1200000.0,
'ownerInitials': 'PS',
'ownerName': 'Priya Sharma',
'lastContact': 'Today',
'tags': ['Corporate Plan', 'International Coverage', 'Key Man Insurance'],
'designation': 'Managing Director',
'source': 'Partner',
'city': 'Dubai',
'state': 'Dubai',
'country': 'UAE',
'occupation': 'Managing Director',
'degree': 'MBA International Business',
'companyWorking': 'Al-Rashid Trading LLC',
'workingSalary': 'AED 45,000/month',
'yearsOfService': '20 years',
'whatsapp': '+971 50 123 4567',
'linkedin': 'linkedin.com/in/mohammedalrashid',
'interests': ['Corporate Plan', 'International Coverage', 'Key Man Insurance'],
'createdAt': DateTime.now().subtract(const Duration(days: 15, hours: 2, minutes: 15)),
'isExistingCustomer': true,
'scheduledAction': 'Appointment',
'scheduledActionDate': '${DateTime.now().add(const Duration(days: 2)).day}/${DateTime.now().add(const Duration(days: 2)).month}/${DateTime.now().add(const Duration(days: 2)).year}',
'scheduledActionTime': '09:00',
'expectedCloseDate': '${DateTime.now().add(const Duration(days: 15)).day}/${DateTime.now().add(const Duration(days: 15)).month}/${DateTime.now().add(const Duration(days: 15)).year}',
},
];

// Backward-compat aliases used by sessions_screen, follow_ups_screen, templates_screen
List<Map<String, dynamic>> get globalLeads => globalLeadMaps;
List<Map<String, dynamic>> get dummyLeads => globalLeadMaps;

// Notifier: call this after inserting/updating a lead to refresh the list
VoidCallback? onLeadsChanged;

// TODO: Replace with [Riverpod/Bloc] for production
class LeadsListScreen extends StatefulWidget {
  const LeadsListScreen({super.key});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

enum _SortOption {
  nameAZ,
  nameZA,
  dealValueHigh,
  dealValueLow,
  dateNewest,
  dateOldest,
  priorityHigh,
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isSearchActive = false;
  _SortOption _sortOption = _SortOption.dateNewest;
  bool? _existingCustomerFilter;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<LeadModel> _leads = [];
  // Multiselect for assigned employees
  List<String> _selectedEmployees = [];
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    onLeadsChanged = _reloadFromGlobal;
    _loadLeads();
  }

  @override
  void dispose() {
    if (onLeadsChanged == _reloadFromGlobal) {
      onLeadsChanged = null;
    }
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadFromGlobal();
  }

  void _reloadFromGlobal() {
    if (mounted) {
      setState(() {
        _leads = globalLeadMaps.map(LeadModel.fromMap).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLeads() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _reloadFromGlobal();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    _reloadFromGlobal();
  }

  void removeLead(String id) {
    setState(() {
      _leads.removeWhere((l) => l.id == id);
      globalLeadMaps.removeWhere((m) => m['id'] == id);
    });
  }

  void _generateFiveRandomLeads() {
    final names = ['Arjun Sharma', 'Deepa Nair', 'Suresh Pillai', 'Meena Gupta', 'Rajesh Kumar', 'Lakshmi Devi', 'Pradeep Rao', 'Sunita Verma', 'Arun Iyer', 'Pooja Menon'];
    final companies = ['Infosys Ltd', 'Wipro Technologies', 'HCL Systems', 'Tata Consultancy', 'Reliance Industries', 'HDFC Bank', 'ICICI Securities', 'Bajaj Finance', 'Mahindra Group', 'Adani Enterprises'];
    final cities = ['Bangalore', 'Mumbai', 'Delhi', 'Chennai', 'Hyderabad', 'Pune', 'Kolkata', 'Ahmedabad', 'Jaipur', 'Kochi'];
    final states = ['Karnataka', 'Maharashtra', 'Delhi', 'Tamil Nadu', 'Telangana', 'Maharashtra', 'West Bengal', 'Gujarat', 'Rajasthan', 'Kerala'];
    final statuses = ['New', 'Contacted', 'Engaged', 'Qualified', 'Proposed', 'Follow Up', 'Sessions', 'Negotiations'];
    final priorities = ['High', 'Medium', 'Low'];
    final sources = ['LinkedIn', 'Referral', 'Cold Call', 'Trade Show', 'Website', 'Partner'];
    final actions = ['Appointment', 'Follow-up', 'Video Call', 'Call Back'];
    final owners = [
      {'name': 'Priya Sharma', 'initials': 'PS'},
      {'name': 'Rahul Singh', 'initials': 'RS'},
      {'name': 'Ananya Patel', 'initials': 'AP'},
      {'name': 'Kavya Menon', 'initials': 'KM'},
    ];
    final allInterestSets = [
      ['Life Insurance', 'Health Cover', 'Motor Insurance'],
      ['Mutual Funds', 'Equity', 'Fixed Deposits', 'SIP'],
      ['Home Insurance', 'Home Loan', 'Real Estate'],
      ['Term Insurance', 'TPD Insurance', 'Income Protection', 'Trauma/Critical Illness'],
      ['Corporate Plan', 'Key Man Insurance', 'Group Policy'],
    ];
    final occupations = ['Software Engineer', 'Doctor', 'Teacher', 'Business Owner', 'Chartered Accountant'];
    final degrees = ['B.Tech', 'MBBS', 'B.Ed', 'B.Com', 'CA'];
    final salaries = ['₹6,00,000', '₹8,00,000', '₹12,00,000', '₹15,00,000', '₹18,00,000'];
    final yearsOfService = ['2 years', '5 years', '8 years', '10 years', '15 years'];

    final now = DateTime.now();
    for (int i = 0; i < 5; i++) {
      final idx = (now.millisecondsSinceEpoch + i * 1000) % names.length;
      final compIdx = (idx + i) % companies.length;
      final cityIdx = (idx + i * 2) % cities.length;
      final statusIdx = i % statuses.length;
      final priorityIdx = i % priorities.length;
      final sourceIdx = (idx + i) % sources.length;
      final actionIdx = i % actions.length;
      final ownerIdx = i % owners.length;
      final interestIdx = i % allInterestSets.length;
      final occIdx = (idx + i) % occupations.length;
      final salIdx = i % salaries.length;
      final yosIdx = (i + 1) % yearsOfService.length;
      final interests = allInterestSets[interestIdx];
      final owner = owners[ownerIdx];
      final newId = '${now.millisecondsSinceEpoch}-$i';
      final actionDate = now.add(Duration(days: 1 + i * 2));

      globalLeadMaps.insert(0, {
        'id': newId,
        'name': names[idx],
        'phone': '+91 9${(8765 + idx * 111) % 10000} ${(43210 + i * 1234) % 100000}',
        'email': '${names[idx].toLowerCase().replaceAll(' ', '.')}@${companies[compIdx].toLowerCase().replaceAll(' ', '')}.com',
        'company': companies[compIdx],
        'industry': 'Technology',
        'status': statuses[statusIdx],
        'priority': priorities[priorityIdx],
        'score': 50 + (idx * 7 + i * 11) % 45,
        'dealValue': (100000.0 + idx * 50000 + i * 75000),
        'ownerInitials': owner['initials'],
        'ownerName': owner['name'],
        'lastContact': 'Just now',
        'tags': interests,
        'firstName': names[idx].split(' ').first,
        'lastName': names[idx].split(' ').last,
        'salutation': 'Mr.',
        'primaryMobile': '+91 9${(8765 + idx * 111) % 10000} ${(43210 + i * 1234) % 100000}',
        'primaryEmail': '${names[idx].toLowerCase().replaceAll(' ', '.')}@${companies[compIdx].toLowerCase().replaceAll(' ', '')}.com',
        'gender': i % 2 == 0 ? 'Male' : 'Female',
        'maritalStatus': i % 2 == 0 ? 'Married' : 'Single',
        'occupation': occupations[occIdx],
        'degree': degrees[occIdx],
        'companyWorking': companies[compIdx],
        'workingSalary': '${salaries[salIdx]} per annum',
        'yearsOfService': yearsOfService[yosIdx],
        'designation': occupations[occIdx],
        'city': cities[cityIdx],
        'state': states[cityIdx],
        'country': 'India',
        'source': sources[sourceIdx],
        'tier': i % 2 == 0 ? 'Gold' : 'Silver',
        'scheduledAction': actions[actionIdx],
        'scheduledActionDate': '${actionDate.day}/${actionDate.month}/${actionDate.year}',
        'scheduledActionTime': '${10 + i}:00',
        'actionNotes': 'Auto-generated lead for testing.',
        'interests': interests,
        'createdAt': now,
      });
    }
    onLeadsChanged?.call();
    if (mounted) {
      _reloadFromGlobal();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Text('5 random leads generated!'),
          ]),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  bool get _hasActiveFilters =>
      _existingCustomerFilter != null ||
      _selectedEmployees.isNotEmpty ||
      _dateFrom != null ||
      _dateTo != null;

  void _clearAllFilters() {
    setState(() {
      _existingCustomerFilter = null;
      _selectedEmployees = [];
      _dateFrom = null;
      _dateTo = null;
    });
  }

  List<LeadModel> get _filteredLeads {
    List<LeadModel> result = _leads.where((lead) {
      bool matchesFilter;
      if (_selectedFilter == 'All') {
        matchesFilter = true;
      } else if (_selectedFilter == 'Won') {
        // Match leads with status 'Won' or resultOutcome 'Won'
        final map = globalLeadMaps.firstWhere((m) => m['id'] == lead.id, orElse: () => {});
        matchesFilter = lead.status == 'Won' ||
            (map['resultOutcome'] as String? ?? '') == 'Won';
      } else if (_selectedFilter == 'Lost') {
        final map = globalLeadMaps.firstWhere((m) => m['id'] == lead.id, orElse: () => {});
        matchesFilter = lead.status == 'Lost' ||
            (map['resultOutcome'] as String? ?? '') == 'Lost';
      } else {
        matchesFilter = lead.status == _selectedFilter;
      }
      final matchesSearch =
          _searchQuery.isEmpty ||
          lead.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lead.phone.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lead.company.toLowerCase().contains(_searchQuery.toLowerCase());
      final isExistingCustomer =
          lead.status == 'Won' || lead.status == 'Result';
      final matchesExistingFilter =
          _existingCustomerFilter == null ||
          (_existingCustomerFilter == true && isExistingCustomer) ||
          (_existingCustomerFilter == false && !isExistingCustomer);
      // Multiselect employee filter
      final matchesEmployee =
          _selectedEmployees.isEmpty ||
          _selectedEmployees.contains(lead.ownerName);
      bool matchesDate = true;
      final map = globalLeadMaps.firstWhere(
        (m) => m['id'] == lead.id,
        orElse: () => {},
      );
      final createdAt = map['createdAt'] as DateTime?;
      if (createdAt != null) {
        if (_dateFrom != null && createdAt.isBefore(_dateFrom!)) {
          matchesDate = false;
        }
        if (_dateTo != null &&
            createdAt.isAfter(_dateTo!.add(const Duration(days: 1)))) {
          matchesDate = false;
        }
      }
      return matchesFilter &&
          matchesSearch &&
          matchesExistingFilter &&
          matchesEmployee &&
          matchesDate;
    }).toList();

    switch (_sortOption) {
      case _SortOption.nameAZ:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SortOption.nameZA:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case _SortOption.dealValueHigh:
        result.sort((a, b) => b.dealValue.compareTo(a.dealValue));
        break;
      case _SortOption.dealValueLow:
        result.sort((a, b) => a.dealValue.compareTo(b.dealValue));
        break;
      case _SortOption.priorityHigh:
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        result.sort(
          (a, b) => (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1),
        );
        break;
      case _SortOption.dateNewest:
      case _SortOption.dateOldest:
        if (_sortOption == _SortOption.dateOldest) {
          result = result.reversed.toList();
        }
        break;
    }
    return result;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Sort By',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...[
                  (_SortOption.dateNewest, Icons.calendar_today_rounded, 'Newest First'),
                  (_SortOption.dateOldest, Icons.calendar_today_outlined, 'Oldest First'),
                  (_SortOption.nameAZ, Icons.sort_by_alpha_rounded, 'Name A → Z'),
                  (_SortOption.nameZA, Icons.sort_by_alpha_rounded, 'Name Z → A'),
                  (_SortOption.dealValueHigh, Icons.trending_up_rounded, 'Deal Value: High → Low'),
                  (_SortOption.dealValueLow, Icons.trending_down_rounded, 'Deal Value: Low → High'),
                  (_SortOption.priorityHigh, Icons.priority_high_rounded, 'Priority: High First'),
                ].map((item) {
                  final (opt, icon, label) = item;
                  final isSelected = _sortOption == opt;
                  return ListTile(
                    dense: true,
                    leading: Icon(icon, size: 20, color: isSelected ? AppTheme.primary : AppTheme.textSecondary),
                    title: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? AppTheme.primary : AppTheme.textPrimary)),
                    trailing: isSelected ? const Icon(Icons.check_rounded, color: AppTheme.primary, size: 18) : null,
                    onTap: () {
                      setState(() => _sortOption = opt);
                      setSheet(() {});
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          builder: (_, ctrl) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: ListView(
              controller: ctrl,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: AppTheme.surface200, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Row(
                  children: [
                    Text('Filters', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (_hasActiveFilters)
                      TextButton(
                        onPressed: () { _clearAllFilters(); Navigator.pop(ctx); },
                        child: Text('Clear All', style: GoogleFonts.plusJakartaSans(color: AppTheme.error, fontSize: 13)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Existing customer filter
                Text('Existing Customer', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _FilterChip(label: 'All', isSelected: _existingCustomerFilter == null, onTap: () { setState(() => _existingCustomerFilter = null); setSheet(() {}); }),
                    _FilterChip(label: 'Yes (Won/Result)', isSelected: _existingCustomerFilter == true, onTap: () { setState(() => _existingCustomerFilter = true); setSheet(() {}); }),
                    _FilterChip(label: 'No', isSelected: _existingCustomerFilter == false, onTap: () { setState(() => _existingCustomerFilter = false); setSheet(() {}); }),
                  ],
                ),
                const Divider(height: 24),
                // Assigned To — multiselect with pinned selected at top
                Text('Assigned To', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                _AssignedToFilter(
                  selectedEmployees: _selectedEmployees,
                  onChanged: (employees) {
                    setState(() => _selectedEmployees = employees);
                    setSheet(() {});
                  },
                ),
                const Divider(height: 24),
                // Date range filter
                Text('Date Range', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final d = await showDatePicker(context: ctx, initialDate: _dateFrom ?? DateTime.now().subtract(const Duration(days: 30)), firstDate: DateTime(2020), lastDate: DateTime.now());
                          if (d != null) { setState(() => _dateFrom = d); setSheet(() {}); }
                        },
                        icon: const Icon(Icons.calendar_today_rounded, size: 14),
                        label: Text(_dateFrom != null ? '${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}' : 'From', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final d = await showDatePicker(context: ctx, initialDate: _dateTo ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)));
                          if (d != null) { setState(() => _dateTo = d); setSheet(() {}); }
                        },
                        icon: const Icon(Icons.calendar_today_rounded, size: 14),
                        label: Text(_dateTo != null ? '${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}' : 'To', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                      ),
                    ),
                    if (_dateFrom != null || _dateTo != null) ...[
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.clear_rounded, size: 18, color: AppTheme.error), onPressed: () { setState(() { _dateFrom = null; _dateTo = null; }); setSheet(() {}); }),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_hasActiveFilters)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () { _clearAllFilters(); Navigator.pop(ctx); },
                          style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error, side: BorderSide(color: AppTheme.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: Text('Clear All', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    if (_hasActiveFilters) const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: FilledButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: Text('Apply', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      floatingActionButton: GestureDetector(
        onLongPress: _generateFiveRandomLeads,
        onDoubleTap: _generateFiveRandomLeads,
        child: FloatingActionButton(
          onPressed: () => context.go(AppRoutes.addLeadScreen),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          tooltip: 'Add Lead (Long press for 5 random)',
          child: const Icon(Icons.person_add_rounded, size: 24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
          slivers: [
            // App Bar — same design as call logs header with Filter + Sort buttons
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: AppTheme.backgroundLight,
              elevation: 0,
              scrolledUnderElevation: 1,
              shadowColor: AppTheme.surface200,
              leading: IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_rounded, size: 20, color: AppTheme.textPrimary),
                ),
                onPressed: () => appScaffoldKey.currentState?.openDrawer(),
                tooltip: 'Menu',
              ),
              title: _isSearchActive
                  ? Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primary.withAlpha(120)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search leads, phone...',
                          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          isDense: true,
                          prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppTheme.textMuted),
                        ),
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textPrimary),
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),
                    )
                  : Text(
                      'Leads',
                      style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.3),
                    ),
              actions: [
                // Search button
                IconButton(
                  icon: Icon(_isSearchActive ? Icons.close_rounded : Icons.search_rounded, color: AppTheme.textPrimary),
                  onPressed: () {
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) { _searchController.clear(); _searchQuery = ''; }
                    });
                  },
                ),
                // Filter button
                IconButton(
                  icon: Stack(
                    children: [
                      Icon(Icons.filter_list_rounded, color: _hasActiveFilters ? AppTheme.primary : AppTheme.textPrimary),
                      if (_hasActiveFilters)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle)),
                        ),
                    ],
                  ),
                  onPressed: () => _showFilterSheet(),
                ),
                // Sort button
                IconButton(
                  icon: Icon(Icons.sort_rounded, color: _sortOption != _SortOption.dateNewest ? AppTheme.primary : AppTheme.textPrimary),
                  onPressed: () => _showSortSheet(),
                ),
              ],
            ),

            // Pipeline KPI Cards
            SliverToBoxAdapter(
              child: _isLoading ? _buildKpiSkeleton() : PipelineKpiWidget(leads: _leads),
            ),

            // Filter Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterBarDelegate(
                child: LeadFilterBarWidget(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (f) => setState(() => _selectedFilter = f),
                ),
              ),
            ),

            // Active filter chips
            if (_hasActiveFilters)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      ..._selectedEmployees.map((e) => _ActiveFilterChip(label: 'Assigned: $e', onRemove: () => setState(() => _selectedEmployees.remove(e)))),
                      if (_dateFrom != null) _ActiveFilterChip(label: 'From: ${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}', onRemove: () => setState(() => _dateFrom = null)),
                      if (_dateTo != null) _ActiveFilterChip(label: 'To: ${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}', onRemove: () => setState(() => _dateTo = null)),
                      if (_existingCustomerFilter != null) _ActiveFilterChip(label: 'Existing: ${_existingCustomerFilter! ? 'Yes' : 'No'}', onRemove: () => setState(() => _existingCustomerFilter = null)),
                      GestureDetector(
                        onTap: _clearAllFilters,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.error.withAlpha(20), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.error.withAlpha(60))),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.clear_all_rounded, size: 14, color: AppTheme.error),
                            const SizedBox(width: 4),
                            Text('Clear All', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.error, fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Results count
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  _isLoading ? 'Loading...' : '${_filteredLeads.length} lead${_filteredLeads.length != 1 ? 's' : ''}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                ),
              ),
            ),

            // List content
            if (_isLoading)
              SliverList(delegate: SliverChildBuilderDelegate((_, i) => const LeadCardSkeletonWidget(), childCount: 5))
            else if (_filteredLeads.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  icon: Icons.people_outline_rounded,
                  title: 'No leads found',
                  subtitle: _searchQuery.isNotEmpty ? 'Try a different search term or clear filters' : 'Start building your pipeline by adding your first lead',
                ),
              )
            else
              isTablet
                  ? SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, navBarHeight + 16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.6, crossAxisSpacing: 12, mainAxisSpacing: 12),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => LeadCardWidget(lead: _filteredLeads[index], index: index, onRemove: () => removeLead(_filteredLeads[index].id)),
                          childCount: _filteredLeads.length,
                        ),
                      ),
                    )
                  : _buildGroupedLeadList(_filteredLeads),
          ],
        ),
      ),
      ),
  );
  }

  // ─── Grouped list with date section headers (descending) ─────────────────
  Widget _buildGroupedLeadList(List<LeadModel> leads) {
    // Group leads by date (descending)
    final Map<String, List<LeadModel>> grouped = {};
    for (final lead in leads) {
      final map = globalLeadMaps.firstWhere((m) => m['id'] == lead.id, orElse: () => {});
      final createdAt = map['createdAt'] as DateTime?;
      final key = createdAt != null ? _dateGroupKey(createdAt) : 'Unknown';
      grouped.putIfAbsent(key, () => []).add(lead);
    }
    // Sort keys descending by date
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final da = _keyToDate(a);
        final db = _keyToDate(b);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });

    // Build sliver list items
    final items = <Widget>[];
    for (final key in sortedKeys) {
      items.add(_DateSectionHeader(label: key));
      final groupLeads = grouped[key]!;
      for (int i = 0; i < groupLeads.length; i++) {
        items.add(LeadCardWidget(
          lead: groupLeads[i],
          index: i,
          onRemove: () => removeLead(groupLeads[i].id),
        ));
      }
    }
    items.add(SizedBox(height: MediaQuery.paddingOf(context).bottom + 16));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => items[index],
        childCount: items.length,
      ),
    );
  }

  String _dateGroupKey(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(date).inDays;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    if (diff == 0) return 'Today · $dateStr';
    if (diff == 1) return 'Yesterday · $dateStr';
    if (diff < 0) return 'Upcoming · $dateStr';
    return dateStr;
  }

  DateTime? _keyToDate(String key) {
    try {
      final parts = key.split('·').last.trim().split(' ');
      if (parts.length < 3) return null;
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final day = int.tryParse(parts[0]) ?? 1;
      final month = months.indexOf(parts[1]) + 1;
      final year = int.tryParse(parts[2]) ?? 2026;
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  Widget _buildKpiSkeleton() {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const LoadingSkeletonWidget(width: 120, height: 86, borderRadius: 16),
      ),
    );
  }
}

// ─── Date Section Header ──────────────────────────────────────────────────────

class _DateSectionHeader extends StatelessWidget {
  final String label;
  const _DateSectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: AppTheme.surface200, height: 1)),
        ],
      ),
    );
  }
}

// ─── Assigned To Filter Widget (multiselect with pinned selected at top) ──────

class _EmployeeEntry {
  final String name;
  final String initials;
  final String role;
  final String id;
  final Color avatarColor;

  const _EmployeeEntry({
    required this.name,
    required this.initials,
    required this.role,
    required this.id,
    required this.avatarColor,
  });
}

const _kEmployees = [
  _EmployeeEntry(name: 'Priya Sharma', initials: 'PS', role: 'Admin', id: 'ADM-1042', avatarColor: Color(0xFF7C3AED)),
  _EmployeeEntry(name: 'Rahul Singh', initials: 'RS', role: 'Senior Rep', id: 'EMP-2391', avatarColor: Color(0xFF059669)),
  _EmployeeEntry(name: 'Ananya Patel', initials: 'AP', role: 'Manager', id: 'EMP-1874', avatarColor: Color(0xFF059669)),
  _EmployeeEntry(name: 'Kavya Menon', initials: 'KM', role: 'Sales Rep', id: 'EMP-3012', avatarColor: Color(0xFF059669)),
  _EmployeeEntry(name: 'Arjun Das', initials: 'AD', role: 'Sales Rep', id: 'EMP-2756', avatarColor: Color(0xFF059669)),
  _EmployeeEntry(name: 'Vikram Nair', initials: 'VN', role: 'Contractor', id: 'CONT-8391', avatarColor: Color(0xFFD97706)),
  _EmployeeEntry(name: 'Meera Iyer', initials: 'MI', role: 'Contractor', id: 'CONT-5204', avatarColor: Color(0xFFD97706)),
];

class _AssignedToFilter extends StatefulWidget {
  final List<String> selectedEmployees;
  final ValueChanged<List<String>> onChanged;

  const _AssignedToFilter({
    required this.selectedEmployees,
    required this.onChanged,
  });

  @override
  State<_AssignedToFilter> createState() => _AssignedToFilterState();
}

class _AssignedToFilterState extends State<_AssignedToFilter> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_EmployeeEntry> get _displayList {
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      return _kEmployees.where((e) =>
        e.name.toLowerCase().contains(q) ||
        e.role.toLowerCase().contains(q) ||
        e.id.toLowerCase().contains(q),
      ).toList();
    }
    // When not searching: pinned selected at top, then unselected (max 3 unselected shown)
    final selected = _kEmployees.where((e) => widget.selectedEmployees.contains(e.name)).toList();
    final unselected = _kEmployees.where((e) => !widget.selectedEmployees.contains(e.name)).take(3).toList();
    return [...selected, ...unselected];
  }

  Color _idColor(String id) {
    if (id.startsWith('ADM')) return const Color(0xFF7C3AED);
    if (id.startsWith('EMP')) return const Color(0xFF059669);
    return const Color(0xFFD97706);
  }

  Color _idBgColor(String id) {
    if (id.startsWith('ADM')) return const Color(0xFFEDE9FE);
    if (id.startsWith('EMP')) return const Color(0xFFD1FAE5);
    return const Color(0xFFFEF3C7);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Search to see all employees...',
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textMuted),
              prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppTheme.textMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(height: 8),
        // All option
        _buildRow('ALL', 'All Employees', 'Show all leads', '', AppTheme.textSecondary, widget.selectedEmployees.isEmpty, () {
          widget.onChanged([]);
        }),
        ..._displayList.map((emp) => _buildRow(
          emp.initials, emp.name, emp.role, emp.id, emp.avatarColor,
          widget.selectedEmployees.contains(emp.name),
          () {
            final updated = List<String>.from(widget.selectedEmployees);
            if (updated.contains(emp.name)) {
              updated.remove(emp.name);
            } else {
              updated.add(emp.name);
            }
            widget.onChanged(updated);
          },
        )),
        if (_query.isEmpty && widget.selectedEmployees.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text('Search to see all employees', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textMuted)),
          ),
      ],
    );
  }

  Widget _buildRow(String initials, String name, String role, String id, Color avatarColor, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: isSelected ? BoxDecoration(color: AppTheme.primaryContainer.withAlpha(80), borderRadius: BorderRadius.circular(10)) : null,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor.withAlpha(40),
              child: Text(initials.length > 2 ? initials.substring(0, 2) : initials, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: avatarColor)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(child: Text(role, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis, maxLines: 1)),
                      if (id.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: _idBgColor(id), borderRadius: BorderRadius.circular(6)),
                          child: Text(id, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: _idColor(id)), overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_rounded, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Active Filter Chip ───────────────────────────────────────────────────────

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary), overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
          const SizedBox(width: 4),
          GestureDetector(onTap: onRemove, child: const Icon(Icons.close_rounded, size: 12, color: AppTheme.primary)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surface100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.surface200),
        ),
        child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? AppTheme.primary : AppTheme.textSecondary)),
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _FilterBarDelegate({required this.child});

  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppTheme.backgroundLight, child: child);
  }

  @override
  bool shouldRebuild(_FilterBarDelegate oldDelegate) => child != oldDelegate.child;
}

// ─── Model ────────────────────────────────────────────────────
class LeadModel {
  final String id;
  final String name;
  final String company;
  final String status;
  final String priority;
  final int score;
  final double dealValue;
  final String ownerInitials;
  final String ownerName;
  final String lastContact;
  final String phone;
  final String email;
  final String industry;
  final List<String> tags;
  final String? firstName;
  final String? lastName;
  final String? whatsapp;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? source;
  final String? campaign;
  final String? notes;
  final List<String>? interests;
  final DateTime? createdAt;
  final String? scheduledAction;

  const LeadModel({
    required this.id,
    required this.name,
    required this.company,
    required this.status,
    required this.priority,
    required this.score,
    required this.dealValue,
    required this.ownerInitials,
    required this.ownerName,
    required this.lastContact,
    required this.phone,
    required this.email,
    required this.industry,
    required this.tags,
    this.firstName,
    this.lastName,
    this.whatsapp,
    this.address,
    this.city,
    this.state,
    this.country,
    this.source,
    this.campaign,
    this.notes,
    this.interests,
    this.createdAt,
    this.scheduledAction,
  });

  factory LeadModel.fromMap(Map<String, dynamic> map) => LeadModel(
    id: map['id'] as String? ?? '',
    name: map['name'] as String? ?? '',
    company: map['company'] as String? ?? '',
    status: map['status'] as String? ?? 'New',
    priority: map['priority'] as String? ?? 'Medium',
    score: (map['score'] as num?)?.toInt() ?? 0,
    dealValue: (map['dealValue'] as num?)?.toDouble() ?? 0.0,
    ownerInitials: map['ownerInitials'] as String? ?? 'PS',
    ownerName: map['ownerName'] as String? ?? 'Priya Sharma',
    lastContact: map['lastContact'] as String? ?? 'Just now',
    phone: map['phone'] as String? ?? '',
    email: map['email'] as String? ?? '',
    industry: map['industry'] as String? ?? '',
    tags: List<String>.from(map['tags'] as List? ?? []),
    firstName: map['firstName'] as String?,
    lastName: map['lastName'] as String?,
    whatsapp: map['whatsapp'] as String?,
    address: map['address'] as String?,
    city: map['city'] as String?,
    state: map['state'] as String?,
    country: map['country'] as String?,
    source: map['source'] as String?,
    campaign: map['campaign'] as String?,
    notes: map['notes'] as String?,
    interests: map['interests'] != null ? List<String>.from(map['interests'] as List) : null,
    createdAt: map['createdAt'] as DateTime?,
    scheduledAction: map['scheduledAction'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'company': company,
    'status': status,
    'priority': priority,
    'score': score,
    'dealValue': dealValue,
    'ownerInitials': ownerInitials,
    'ownerName': ownerName,
    'lastContact': lastContact,
    'phone': phone,
    'email': email,
    'industry': industry,
    'tags': tags,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (whatsapp != null) 'whatsapp': whatsapp,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (state != null) 'state': state,
    if (country != null) 'country': country,
    if (source != null) 'source': source,
    if (campaign != null) 'campaign': campaign,
    if (notes != null) 'notes': notes,
    if (interests != null) 'interests': interests,
    if (createdAt != null) 'createdAt': createdAt,
    if (scheduledAction != null) 'scheduledAction': scheduledAction,
  };

  LeadModel copyWith({
    String? id, String? name, String? company, String? status, String? priority,
    int? score, double? dealValue, String? ownerInitials, String? ownerName,
    String? lastContact, String? phone, String? email, String? industry, List<String>? tags,
  }) => LeadModel(
    id: id ?? this.id, name: name ?? this.name, company: company ?? this.company,
    status: status ?? this.status, priority: priority ?? this.priority,
    score: score ?? this.score, dealValue: dealValue ?? this.dealValue,
    ownerInitials: ownerInitials ?? this.ownerInitials, ownerName: ownerName ?? this.ownerName,
    lastContact: lastContact ?? this.lastContact, phone: phone ?? this.phone,
    email: email ?? this.email, industry: industry ?? this.industry, tags: tags ?? this.tags,
  );
}