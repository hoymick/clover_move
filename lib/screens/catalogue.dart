import 'package:flutter/widgets.dart';

import 'discovery/discovery_screen.dart';
import 'discovery/empty_state_screen.dart';
import 'discovery/filters_screen.dart';
import 'discovery/map_screen.dart';
import 'discovery/meet_point_screen.dart';
import 'discovery/official_event_screen.dart';
import 'discovery/search_results_screen.dart';
import 'discovery/user_route_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'admin/admin_review_screen.dart';
import 'business/business_signup_screen.dart';
import 'business/meet_point_signup_screen.dart';
import 'business/partner_dashboard_screen.dart';
import 'business/partner_venue_screen.dart';
import 'business/plans_business_screen.dart';
import 'business/sponsor_brand_screen.dart';
import 'community/community_screen.dart';
import 'community/account_settings_screen.dart';
import 'community/invite_screen.dart';
import 'community/notifications_screen.dart';
import 'community/plans_screen.dart';
import 'community/user_dashboard_screen.dart';
import 'hosting/changes_needed_screen.dart';
import 'hosting/create_route_screen.dart';
import 'hosting/host_dashboard_screen.dart';
import 'hosting/manage_route_screen.dart';
import 'hosting/route_categories_screen.dart';
import 'onboarding/colour_screen.dart';
import 'onboarding/language_screen.dart';
import 'onboarding/kit_access_screen.dart';
import 'onboarding/terms_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'jerseys/bag_screen.dart';
import 'jerseys/store_checkout_screen.dart';
import 'jerseys/claim_new_screen.dart';
import 'jerseys/claim_screen.dart';
import 'jerseys/gift_jersey_screen.dart';
import 'jerseys/gift_kit_screen.dart';
import 'jerseys/jersey_kit_screen.dart';
import 'jerseys/orders_screen.dart';
import 'jerseys/share_qr_screen.dart';
import 'jerseys/share_select_screen.dart';
import 'jerseys/smart_jerseys_screen.dart';
import 'jerseys/store_catalogue_screen.dart';
import 'problems/event_cancelled_screen.dart';
import 'problems/loading_screen.dart';
import 'problems/offline_screen.dart';
import 'problems/payment_declined_screen.dart';
import 'problems/request_declined_screen.dart';
import 'registry.dart';
import 'taking_part/check_in_screen.dart';
import 'taking_part/fully_booked_screen.dart';
import 'taking_part/payment_screen.dart';
import 'taking_part/payment_history_screen.dart';
import 'taking_part/registration_screen.dart';
import 'taking_part/reviews_screen.dart';
import 'taking_part/ticket_screen.dart';

/// The design pack, in pack order. Sections and captions mirror the source
/// document so a screen can be checked against it by name.
const screenSections = <ScreenSection>[
  ScreenSection(
    title: 'Getting in',
    screens: [
      ScreenEntry(
        code: '01',
        title: 'Welcome',
        blurb: 'New background · logo in full colour · language',
        path: 'welcome',
        builder: _welcome,
      ),
      ScreenEntry(
        code: '01b',
        title: 'Language',
        blurb: 'English · Português BR & PT · Español · Français',
        path: 'language',
        builder: _language,
      ),
      ScreenEntry(
        code: '01c',
        title: 'Smart Jersey Access',
        blurb: 'Kit code · direct access',
        path: 'kit-access',
        builder: _kitAccess,
      ),
      ScreenEntry(
        code: '02',
        title: 'Choose Colour',
        blurb: 'Leaf buttons · Green, White, Orange',
        path: 'colour',
        builder: _colour,
      ),
      ScreenEntry(
        code: '03',
        title: 'Terms of Use',
        blurb: 'Accept · no login required',
        path: 'terms',
        builder: _terms,
      ),
    ],
  ),
  ScreenSection(
    title: 'Finding something to do',
    screens: [
      ScreenEntry(
        code: '04',
        title: 'Smart Discovery',
        blurb: 'Leaves as the category switch',
        path: 'discovery',
        builder: _discovery,
      ),
      ScreenEntry(
        code: '05',
        title: 'Interactive Map',
        blurb: 'Leaf markers as location pins',
        path: 'map',
        builder: _map,
      ),
      ScreenEntry(
        code: '06',
        title: 'Search Filters',
        blurb: 'Every county in Ireland',
        path: 'filters',
        builder: _filters,
      ),
      ScreenEntry(
        code: '36',
        title: 'Search Results',
        blurb: 'List view of the map',
        path: 'search-results',
        builder: _searchResults,
      ),
      ScreenEntry(
        code: '07',
        title: 'Official Event',
        blurb: 'Leaf badge · join',
        path: 'official-event',
        builder: _officialEvent,
      ),
      ScreenEntry(
        code: '08',
        title: 'User Route',
        blurb: 'Morning Route · Stillorgan',
        path: 'user-route',
        builder: _userRoute,
      ),
      ScreenEntry(
        code: '30',
        title: 'Meet Point',
        blurb: 'Public point, safety & access',
        path: 'meet-point',
        builder: _meetPoint,
      ),
      ScreenEntry(
        code: '38',
        title: 'Empty State',
        blurb: 'No routes in this area',
        path: 'empty-state',
        builder: _emptyState,
      ),
    ],
  ),
  ScreenSection(
    title: 'Taking part',
    screens: [
      ScreenEntry(
        code: '12',
        title: 'Registration',
        blurb: 'Participant details',
        path: 'registration',
        builder: _registration,
      ),
      ScreenEntry(
        code: '13',
        title: 'Payment',
        blurb: 'Official and host payment options',
        path: 'payment',
        builder: _payment,
      ),
      ScreenEntry(
        code: '13b',
        title: 'Payment History',
        blurb: 'Payment method and status by event',
        path: 'payment-history',
        builder: _paymentHistory,
      ),
      ScreenEntry(
        code: '14',
        title: 'Digital Ticket',
        blurb: 'QR, perforation, directions',
        path: 'ticket',
        builder: _ticket,
      ),
      ScreenEntry(
        code: '31',
        title: 'Event Check-in',
        blurb: 'Arrived at the Meet Point',
        path: 'check-in',
        builder: _checkIn,
      ),
      ScreenEntry(
        code: '16',
        title: 'Reviews',
        blurb: 'Rate host, venue & safety',
        path: 'reviews',
        builder: _reviews,
      ),
      ScreenEntry(
        code: '46',
        title: 'Fully Booked',
        blurb: 'Waiting list',
        path: 'fully-booked',
        builder: _fullyBooked,
      ),
    ],
  ),
  ScreenSection(
    title: 'Hosting',
    screens: [
      ScreenEntry(
        code: '09',
        title: 'Create Route',
        blurb: 'Host flow · step 2 of 4',
        path: 'create-route',
        builder: _createRoute,
      ),
      ScreenEntry(
        code: '35',
        title: 'Route Categories',
        blurb: 'Who the route welcomes',
        path: 'route-categories',
        builder: _routeCategories,
      ),
      ScreenEntry(
        code: '21',
        title: 'Host Dashboard',
        blurb: 'Requests, sessions, create',
        path: 'host-dashboard',
        builder: _hostDashboard,
      ),
      ScreenEntry(
        code: '22',
        title: 'Manage Route',
        blurb: 'Participants & check-in',
        path: 'manage-route',
        builder: _manageRoute,
      ),
      ScreenEntry(
        code: '45',
        title: 'Changes Needed',
        blurb: "Host's rejected route",
        path: 'changes-needed',
        builder: _changesNeeded,
      ),
    ],
  ),
  ScreenSection(
    title: 'Smart Jerseys',
    screens: [
      ScreenEntry(
        code: '10',
        title: 'Smart Jersey Kit',
        blurb: 'Kit contents · sleeve · single jersey',
        path: 'jersey-kit',
        builder: _jerseyKit,
      ),
      ScreenEntry(
        code: '28',
        title: 'Store Catalogue',
        blurb: 'Product grid & categories',
        path: 'store-catalogue',
        builder: _storeCatalogue,
      ),
      ScreenEntry(
        code: '29',
        title: 'Bag & Checkout',
        blurb: 'Line items, promo, totals',
        path: 'bag',
        builder: _bag,
      ),
      ScreenEntry(
        code: '29b',
        title: 'Store Checkout',
        blurb: 'Delivery or Partner Meet Point collection',
        path: 'store-checkout',
        builder: _storeCheckout,
      ),
      ScreenEntry(
        code: '34',
        title: 'Orders',
        blurb: 'History & tracking',
        path: 'orders',
        builder: _orders,
      ),
      ScreenEntry(
        code: '11',
        title: 'Smart Jerseys',
        blurb: 'One token · kits · optional sharing',
        path: 'smart-jerseys',
        builder: _smartJerseys,
      ),
      ScreenEntry(
        code: '11b',
        title: 'Share — Select',
        blurb: 'Colour must be chosen first',
        path: 'share-select',
        builder: _shareSelect,
      ),
      ScreenEntry(
        code: '11c',
        title: 'Share — QR',
        blurb: 'One-time code for one jersey',
        path: 'share-qr',
        builder: _shareQr,
      ),
      ScreenEntry(
        code: '11d',
        title: 'Claim',
        blurb: 'Recipient already has an account',
        path: 'claim',
        builder: _claim,
      ),
      ScreenEntry(
        code: '11e',
        title: 'Claim — New',
        blurb: 'Recipient joins to claim',
        path: 'claim-new',
        builder: _claimNew,
      ),
      ScreenEntry(
        code: '11f',
        title: 'Gift a Jersey',
        blurb: 'One jersey, transferred for good',
        path: 'gift-jersey',
        builder: _giftJersey,
      ),
      ScreenEntry(
        code: '11g',
        title: 'Gift a Kit',
        blurb: 'All three jerseys transfer',
        path: 'gift-kit',
        builder: _giftKit,
      ),
    ],
  ),
  ScreenSection(
    title: 'Community & account',
    screens: [
      ScreenEntry(
        code: '15',
        title: 'Community',
        blurb: 'Members in your colour',
        path: 'community',
        builder: _community,
      ),
      ScreenEntry(
        code: '32',
        title: 'Invite Friends',
        blurb: 'QR, link, WhatsApp, SMS',
        path: 'invite',
        builder: _invite,
      ),
      ScreenEntry(
        code: '37',
        title: 'Notifications',
        blurb: 'Today & this week',
        path: 'notifications',
        builder: _notifications,
      ),
      ScreenEntry(
        code: '17',
        title: 'User Dashboard',
        blurb: 'Logo in official colours on the token',
        path: 'user-dashboard',
        builder: _userDashboard,
      ),
      ScreenEntry(
        code: '17b',
        title: 'Account Settings',
        blurb: 'Profile, account and deletion controls',
        path: 'account-settings',
        builder: _accountSettings,
      ),
      ScreenEntry(
        code: '18',
        title: 'Plans & Pricing',
        blurb: 'Member, Host & Partner',
        path: 'plans',
        builder: _plans,
      ),
    ],
  ),
  ScreenSection(
    title: 'Business & partners',
    screens: [
      ScreenEntry(
        code: '19',
        title: 'Partner Venue',
        blurb: 'Business+ profile',
        path: 'partner-venue',
        builder: _partnerVenue,
      ),
      ScreenEntry(
        code: '23',
        title: 'Partner Dashboard',
        blurb: 'Views, enquiries, promotions',
        path: 'partner-dashboard',
        builder: _partnerDashboard,
      ),
      ScreenEntry(
        code: '24',
        title: 'Business Sign-up',
        blurb: 'Free Official Partner listing',
        path: 'business-signup',
        builder: _businessSignup,
      ),
      ScreenEntry(
        code: '25',
        title: 'Meet Point Sign-up',
        blurb: 'Free Meet Point registration',
        path: 'meet-point-signup',
        builder: _meetPointSignup,
      ),
      ScreenEntry(
        code: '26',
        title: 'Sponsor Brand',
        blurb: 'Official sponsor profile',
        path: 'sponsor-brand',
        builder: _sponsorBrand,
      ),
      ScreenEntry(
        code: '27',
        title: 'Plans — Business',
        blurb: 'Partner, Business+, Sponsor',
        path: 'plans-business',
        builder: _plansBusiness,
      ),
    ],
  ),
  ScreenSection(
    title: 'Admin',
    screens: [
      ScreenEntry(
        code: '20',
        title: 'Admin Dashboard',
        blurb: 'Route & business approvals',
        path: 'admin-dashboard',
        builder: _adminDashboard,
      ),
      ScreenEntry(
        code: '44',
        title: 'Admin Review',
        blurb: 'Route checks before approval',
        path: 'admin-review',
        builder: _adminReview,
      ),
    ],
  ),
  ScreenSection(
    title: 'When things go wrong',
    screens: [
      ScreenEntry(
        code: '41',
        title: 'Request Declined',
        blurb: "Host couldn't give a place",
        path: 'request-declined',
        builder: _requestDeclined,
      ),
      ScreenEntry(
        code: '42',
        title: 'Event Cancelled',
        blurb: 'Refund & reschedule',
        path: 'event-cancelled',
        builder: _eventCancelled,
      ),
      ScreenEntry(
        code: '43',
        title: 'Payment Declined',
        blurb: 'Recovery, place held',
        path: 'payment-declined',
        builder: _paymentDeclined,
      ),
      ScreenEntry(
        code: '39',
        title: 'Offline / Error',
        blurb: 'What still works offline',
        path: 'offline',
        builder: _offline,
      ),
      ScreenEntry(
        code: '40',
        title: 'Loading',
        blurb: 'Skeleton of the feed',
        path: 'loading',
        builder: _loading,
      ),
    ],
  ),
];
// Top-level builders so the catalogue itself can stay a `const` list.
Widget _welcome(BuildContext _) => const WelcomeScreen();
Widget _language(BuildContext _) => const LanguageScreen();
Widget _kitAccess(BuildContext _) => const KitAccessScreen();
Widget _colour(BuildContext _) => const ColourScreen();
Widget _terms(BuildContext _) => const TermsScreen();
Widget _discovery(BuildContext _) => const DiscoveryScreen();
Widget _map(BuildContext _) => const MapScreen();
Widget _filters(BuildContext _) => const FiltersScreen();
Widget _searchResults(BuildContext _) => const SearchResultsScreen();
Widget _officialEvent(BuildContext _) => const OfficialEventScreen();
Widget _userRoute(BuildContext _) => const UserRouteScreen();
Widget _meetPoint(BuildContext _) => const MeetPointScreen();
Widget _emptyState(BuildContext _) => const EmptyStateScreen();
Widget _registration(BuildContext _) => const RegistrationScreen();
Widget _payment(BuildContext _) => const PaymentScreen();
Widget _paymentHistory(BuildContext _) => const PaymentHistoryScreen();
Widget _ticket(BuildContext _) => const TicketScreen();
Widget _checkIn(BuildContext _) => const CheckInScreen();
Widget _reviews(BuildContext _) => const ReviewsScreen();
Widget _fullyBooked(BuildContext _) => const FullyBookedScreen();
Widget _createRoute(BuildContext _) => const CreateRouteScreen();
Widget _routeCategories(BuildContext _) => const RouteCategoriesScreen();
Widget _hostDashboard(BuildContext _) => const HostDashboardScreen();
Widget _manageRoute(BuildContext _) => const ManageRouteScreen();
Widget _changesNeeded(BuildContext _) => const ChangesNeededScreen();
Widget _storeCatalogue(BuildContext _) => const StoreCatalogueScreen();
Widget _userDashboard(BuildContext _) => const UserDashboardScreen();
Widget _accountSettings(BuildContext _) => const AccountSettingsScreen();
Widget _adminDashboard(BuildContext _) => const AdminDashboardScreen();
Widget _adminReview(BuildContext _) => const AdminReviewScreen();
Widget _requestDeclined(BuildContext _) => const RequestDeclinedScreen();
Widget _eventCancelled(BuildContext _) => const EventCancelledScreen();
Widget _paymentDeclined(BuildContext _) => const PaymentDeclinedScreen();
Widget _offline(BuildContext _) => const OfflineScreen();
Widget _loading(BuildContext _) => const LoadingScreen();
Widget _community(BuildContext _) => const CommunityScreen();
Widget _invite(BuildContext _) => const InviteScreen();
Widget _notifications(BuildContext _) => const NotificationsScreen();
Widget _plans(BuildContext _) => const PlansScreen();
Widget _partnerVenue(BuildContext _) => const PartnerVenueScreen();
Widget _partnerDashboard(BuildContext _) => const PartnerDashboardScreen();
Widget _businessSignup(BuildContext _) => const BusinessSignupScreen();
Widget _meetPointSignup(BuildContext _) => const MeetPointSignupScreen();
Widget _sponsorBrand(BuildContext _) => const SponsorBrandScreen();
Widget _plansBusiness(BuildContext _) => const PlansBusinessScreen();
Widget _jerseyKit(BuildContext _) => const JerseyKitScreen();
Widget _bag(BuildContext _) => const BagScreen();
Widget _storeCheckout(BuildContext _) => const StoreCheckoutScreen();
Widget _orders(BuildContext _) => const OrdersScreen();
Widget _smartJerseys(BuildContext _) => const SmartJerseysScreen();
Widget _shareSelect(BuildContext _) => const ShareSelectScreen();
Widget _shareQr(BuildContext _) => const ShareQrScreen();
Widget _claim(BuildContext _) => const ClaimScreen();
Widget _claimNew(BuildContext _) => const ClaimNewScreen();
Widget _giftJersey(BuildContext _) => const GiftJerseyScreen();
Widget _giftKit(BuildContext _) => const GiftKitScreen();
