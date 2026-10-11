import React, { useState } from 'react';
import {
  Smartphone,
  LogOut,
  Moon,
  Sun,
  Globe,
  ShoppingBag,
  Store,
  UserCheck,
  Shield,
  Eye,
  EyeOff,
  CheckCircle2,
  AlertCircle,
  QrCode,
  Send,
  PlusCircle,
  Receipt,
  Utensils,
  Bike,
  Zap,
  Plane,
  HeartPulse,
  Tv,
  Sparkles,
  ArrowRight,
  RefreshCw,
  Sliders,
  ToggleLeft,
  ToggleRight,
  Ban,
  Check,
  Trash2,
  Building2,
  Plus,
  Edit3,
  MapPin,
  Phone,
  Mail,
  User,
  Heart,
  Clock,
  Star,
  Bell,
  Gift,
  Lock,
  Laptop,
  CheckSquare,
  AlertTriangle,
  ChevronRight,
  ExternalLink,
  Search,
  X,
  CreditCard,
  FileText,
  HelpCircle,
  Home,
  Tag,
  Share2,
  Music,
  Radio,
  Volume2,
  Play,
  Pause,
  SkipForward,
  SkipBack,
} from 'lucide-react';
import { BusinessItem, CategoryItem } from './WebAdminPanel';

export type AppRoleType = 'customer' | 'businessOwner' | 'staff' | 'superAdmin';

interface MobileSimulatorProps {
  currentRole: AppRoleType;
  onRoleChange: (role: AppRoleType) => void;
  dynamicAppTitle: string;
  businesses: BusinessItem[];
  onRegisterBusiness: (biz: {
    name: string;
    ownerName: string;
    phone: string;
    category: string;
    categorySlug: string;
    province: string;
    city: string;
    panNumber: string;
    address?: string;
  }) => void;
  onUpdateBusiness: (biz: BusinessItem) => void;
  categories: CategoryItem[];
  onToggleCategory?: (id: string) => void;
  onUpdateAppTitle?: (title: string) => void;
  onOpenAdminPanel?: () => void;
  onOpenApkStation?: () => void;
}

export const MobileSimulator: React.FC<MobileSimulatorProps> = ({
  currentRole,
  onRoleChange,
  dynamicAppTitle,
  businesses,
  onRegisterBusiness,
  onUpdateBusiness,
  categories,
  onToggleCategory,
  onUpdateAppTitle,
  onOpenAdminPanel,
  onOpenApkStation,
}) => {
  // Screens & Tabs
  const [screen, setScreen] = useState<'splash' | 'login' | 'register' | 'dashboard'>('dashboard');
  const [activeBottomTab, setActiveBottomTab] = useState<'home' | 'businesses' | 'music' | 'tv' | 'profile'>('home');
  const [isDark, setIsDark] = useState(false);
  const [lang, setLang] = useState<'np' | 'en'>('np');

  // Music & Radio Player state (कोड म्युजिक)
  const [isPlayingMusic, setIsPlayingMusic] = useState(false);
  const [currentTrackIndex, setCurrentTrackIndex] = useState(0);
  const nepaliPlaylist = [
    { id: '1', title: 'Republic Nepal Live Audio Broadcast', artist: 'Republic Nepal TV & Radio', category: 'Live FM 98.4 MHz', duration: 'LIVE' },
    { id: '2', title: 'Resham Firiri (रेशम फिरिरी)', artist: 'Himalayan Folk Flute & Sarangi', category: 'Folk Classic', duration: '04:12' },
    { id: '3', title: 'Maya Pirati (माया पिरती)', artist: 'Aarav Sharma & Priya KC', category: 'Modern Adhunik Hit', duration: '03:48' },
    { id: '4', title: 'Sirphul Siraima (शिरफूल शिरैमा)', artist: 'Gandaki Lok Dohori Pariwar', category: 'Lok Dohori', duration: '05:02' },
  ];

  // Business Detail & Registration Modals
  const [selectedBusiness, setSelectedBusiness] = useState<BusinessItem | null>(null);
  const [isEditingBusiness, setIsEditingBusiness] = useState(false);
  const [editBizName, setEditBizName] = useState('');
  const [editBizPhone, setEditBizPhone] = useState('');
  const [editBizCity, setEditBizCity] = useState('');

  // Register Business Flow
  const [showRegisterFlow, setShowRegisterFlow] = useState(false);
  const [registerStep, setRegisterStep] = useState<'category' | 'details'>('category');
  const [newBizCategory, setNewBizCategory] = useState({ name: 'Clinic (Health)', slug: 'health' });
  const [regBizName, setRegBizName] = useState('');
  const [regBizOwner, setRegBizOwner] = useState('Aarav Sharma');
  const [regBizPhone, setRegBizPhone] = useState('9841234567');
  const [regBizCity, setRegBizCity] = useState('Kathmandu');
  const [regBizProvince, setRegBizProvince] = useState('Bagmati Province');
  const [regBizPan, setRegBizPan] = useState('');
  const [registrationSuccessBanner, setRegistrationSuccessBanner] = useState(false);

  // Quick Action Modals
  const [activeActionModal, setActiveActionModal] = useState<'scan' | 'send' | 'topup' | 'electricity' | null>(null);
  const [selectedCategoryDetail, setSelectedCategoryDetail] = useState<string | null>(null);

  // Version 1: Connected Supabase tables state (ticker_items: kind news, notice, market_rate, ordered by sort_order)
  const [tickerItems, setTickerItems] = useState([
    {
      id: 't1',
      kind: 'market_rate',
      category: 'market_rate',
      rateItem: 'Gold / Silver',
      rateValue: 'रु. १,६२,०००',
      message: 'Gold: रु. १,६२,००० / तोला | Silver: रु. १,९५० / तोला (नेपाल सुनचाँदी)',
      messageNp: 'सुन: रु. १,६२,०००/तोला | चाँदी: रु. १,९५०/तोला (नेपाल सुनचाँदी)',
      sort_order: 1,
      status: 'approved',
    },
    {
      id: 't2',
      kind: 'market_rate',
      category: 'market_rate',
      rateItem: 'Vegetables',
      rateValue: 'कालीमाटी',
      message: 'Kalimati: Tomato रु. ५५/केजी | Potato रु. ४२/केजी | Onion रु. ८५/केजी',
      messageNp: 'कालीमाटी: गोलभेडा रु. ५५/केजी, रातो आलु रु. ४२/केजी, प्याज रु. ८५/केजी',
      sort_order: 2,
      status: 'approved',
    },
    {
      id: 't3',
      kind: 'market_rate',
      category: 'market_rate',
      rateItem: 'Forex',
      rateValue: 'NRB Rate',
      message: 'Forex: USD $1 = NPR 134.20 | EUR €1 = NPR 146.50 (NRB)',
      messageNp: 'मुद्रा: अमेरिकी डलर १ = रु. १३४.२०, युरो १ = रु. १४६.५० (नेपाल राष्ट्र बैंक)',
      sort_order: 3,
      status: 'approved',
    },
    {
      id: 't4',
      kind: 'news',
      category: 'news',
      rateItem: 'Live TV News',
      rateValue: 'LIVE',
      message: 'RN TV: Special prime-time coverage streaming live tonight.',
      messageNp: 'RN TV: आज राति ८ बजे विशेष विश्लेषणात्मक प्रत्यक्ष प्रसारण।',
      sort_order: 4,
      status: 'approved',
    },
  ]);
  const [activeTickerIndex, setActiveTickerIndex] = useState(0);

  const [adsList, setAdsList] = useState([
    {
      id: 'ad1',
      title: 'Republic Nepal TV Live 24/7 Satellite',
      titleNp: 'रिपब्लिक नेपाल टिभी २४/७ प्रत्यक्ष डिजिटल प्रसारण',
      imageUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=800',
      sponsorName: 'Republic Nepal TV & Advertising Pvt. Ltd.',
      placement: 'home',
      status: 'approved',
    },
    {
      id: 'ad2',
      title: 'Organic Himalayan Herbs & Food Festival',
      titleNp: 'जैविक हिमाली जडीबुटी तथा खाद्यान्न महोत्सव',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
      sponsorName: 'Nepal Agriculture Chamber',
      placement: 'home',
      status: 'approved',
    },
    {
      id: 'ad3',
      title: 'Nepal Real Estate & Housing Expo 2026',
      titleNp: 'नेपाल घरजग्गा तथा आवास मेला २०२६',
      imageUrl: 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800',
      sponsorName: 'Real Estate Association of Nepal',
      placement: 'home',
      status: 'approved',
    },
  ]);
  const [activeAdIndex, setActiveAdIndex] = useState(0);

  const [offersList, setOffersList] = useState([
    {
      id: 'o1',
      title: 'Grand Opening Grocery Discount',
      titleNp: 'किराना तथा दैनिक उपभोग्यमा १५% विशेष छुट',
      discountPercent: 15,
      couponCode: 'EASYKIRANA15',
      status: 'approved',
    },
    {
      id: 'o2',
      title: 'Ayurvedic Health Consultation Token',
      titleNp: 'क्लिनिक तथा ओपिडी परामर्शमा नि:शुल्क टोकन',
      discountPercent: 25,
      couponCode: 'SWASTHYA2026',
      status: 'approved',
    },
    {
      id: 'o3',
      title: 'Local Haat Farmers Seasonal Offer',
      titleNp: 'हाट बजार स्थानीय तरकारी तथा फलफूल',
      discountPercent: 10,
      couponCode: 'HAATBAZAR10',
      status: 'approved',
    },
  ]);

  // Forms for Post News & Post Ad (status: pending only)
  const [isPostingNews, setIsPostingNews] = useState(false);
  const [isPostingAd, setIsPostingAd] = useState(false);
  const [newsHeadline, setNewsHeadline] = useState('');
  const [newsHeadlineNp, setNewsHeadlineNp] = useState('');
  const [newsCategory, setNewsCategory] = useState<'news' | 'market_rate' | 'notice'>('news');
  const [newsPhone, setNewsPhone] = useState('');

  const [adTitle, setAdTitle] = useState('');
  const [adTitleNp, setAdTitleNp] = useState('');
  const [adImageUrl, setAdImageUrl] = useState('https://images.unsplash.com/photo-1542838132-92c53300491e?w=800');
  const [adSponsor, setAdSponsor] = useState('');
  const [adPhone, setAdPhone] = useState('');

  const [submissionNotice, setSubmissionNotice] = useState<string | null>(null);

  // Login form state
  const [loginEmail, setLoginEmail] = useState('aarav.sharma@nepal.np');
  const [loginPassword, setLoginPassword] = useState('Nepal@2026');
  const [showPassword, setShowPassword] = useState(false);
  const [authError, setAuthError] = useState<string | null>(null);
  const [isAuthenticating, setIsAuthenticating] = useState(false);

  // Register user form state
  const [regName, setRegName] = useState('');
  const [regEmail, setRegEmail] = useState('');
  const [regPhone, setRegPhone] = useState('');
  const [regRole, setRegRole] = useState<AppRoleType>('customer');

  // Customer Profile State
  const [customerAddresses, setCustomerAddresses] = useState([
    { id: 'addr_1', label: 'Home (घर)', address: 'New Baneshwor, Ward No. 10, Kathmandu', isDefault: true },
    { id: 'addr_2', label: 'Work (कार्यालय)', address: 'Durbar Marg, Kathmandu', isDefault: false },
  ]);
  const [savedFavorites, setSavedFavorites] = useState([
    { id: 'fav_1', name: 'Siddhartha Health Clinic', category: 'Health', location: 'Kathmandu' },
    { id: 'fav_2', name: 'Annapurna Organic Kirana', category: 'Food & Groceries', location: 'Pokhara' },
  ]);
  const [twoFactorEnabled, setTwoFactorEnabled] = useState(true);

  // User details based on active role
  const mockUsers = {
    customer: {
      id: 'usr_nep_001_cust',
      fullName: lang === 'np' ? 'आरव शर्मा (Aarav Sharma)' : 'Aarav Sharma',
      email: 'aarav.sharma@nepal.np',
      phone: '+977 9841234567',
      province: lang === 'np' ? 'बागमती प्रदेश (काठमाडौँ)' : 'Bagmati (Kathmandu)',
      balance: 'रु. २४,५००.००',
      walletSub: 'NPR 24,500.00 Available',
      roleTitle: lang === 'np' ? 'ग्राहक' : 'Customer',
    },
    businessOwner: {
      id: 'usr_nep_002_owner',
      fullName: lang === 'np' ? 'पासाङ शेर्पा (Pasang Sherpa)' : 'Pasang Sherpa',
      email: 'himalayan.crafts@nepal.np',
      phone: '+977 9856012345',
      province: lang === 'np' ? 'गण्डकी प्रदेश (पोखरा)' : 'Gandaki (Pokhara)',
      businessName: 'Himalayan Organic Mart',
      revenue: 'रु. ८६,४२०.००',
      roleTitle: lang === 'np' ? 'व्यापारी' : 'Merchant Owner',
    },
    staff: {
      id: 'usr_nep_003_staff',
      fullName: lang === 'np' ? 'सुनिता दाहाल (Sunita Dahal)' : 'Sunita Dahal',
      email: 'sunita.staff@republicnepal.tv',
      phone: '+977 9801987654',
      province: lang === 'np' ? 'बागमती प्रदेश (ललितपुर)' : 'Bagmati (Lalitpur)',
      businessName: 'Health & Clinic Verification Desk',
      revenue: 'रु. ८६,४२०.००',
      roleTitle: lang === 'np' ? 'स्टोर कर्मचारी' : 'Staff',
    },
    superAdmin: {
      id: 'usr_nep_000_admin',
      fullName: lang === 'np' ? 'विशाल थापा (Bishal Thapa)' : 'Bishal Thapa',
      email: 'admin@republicnepal.tv',
      phone: '+977 9800000001',
      province: lang === 'np' ? 'Republic Nepal TV HQ (काठमाडौँ)' : 'Republic Nepal TV HQ',
      gmv: 'रु. ४८.५ लाख / दिन',
      roleTitle: lang === 'np' ? 'मुख्य प्रशासक' : 'Super Admin',
    },
  };

  const activeUser = mockUsers[currentRole];

  // Category selection options for "Register my business" (Image 4)
  const businessCategoryOptions = [
    {
      id: 'cat_health',
      name: 'Health (स्वास्थ्य तथा क्लिनिक)',
      slug: 'health',
      icon: HeartPulse,
      description: 'Clinics, pharmacies, diagnostic labs & doctor chambers',
      badge: 'High Priority',
    },
    {
      id: 'cat_food',
      name: 'Food & Stay (खाना, किराना तथा होटल)',
      slug: 'food_stay',
      icon: Utensils,
      description: 'Kirana stores, restaurants, cafes, bakeries & lodges',
      badge: 'Popular',
    },
    {
      id: 'cat_retail',
      name: 'Shops & Retail (पसल, कपडा तथा कस्मेटिक्स)',
      slug: 'retail',
      icon: ShoppingBag,
      description: 'Clothing, cosmetics, electronics, footwear & jewelry',
      badge: 'Trending',
    },
    {
      id: 'cat_buy_sell',
      name: 'Buy & Sell (घरजग्गा, गाडी तथा खरिदबिक्री)',
      slug: 'buy_sell',
      icon: Tag,
      description: 'Real estate, vehicles, gadgets, furniture & machinery',
      badge: 'New',
    },
    {
      id: 'cat_reuse',
      name: 'Reuse & Recycle (पुनःप्रयोग तथा कवाडी)',
      slug: 'reuse_recycle',
      icon: RefreshCw,
      description: 'Second-hand goods, refurbished devices, e-waste & scrap',
      badge: 'Eco-Friendly',
    },
    {
      id: 'cat_edu',
      name: 'Education & Training (शिक्षा तथा तालिम)',
      slug: 'education',
      icon: FileText,
      description: 'Institutes, tutoring, language classes & vocational hubs',
      badge: 'Verified',
    },
    {
      id: 'cat_local',
      name: 'Local Market & Haat (हाटबजार तथा स्थानीय सेवा)',
      slug: 'local_market',
      icon: Store,
      description: 'Neighborhood market, seasonal crafts, farm produce & repairs',
      badge: 'Local',
    },
  ];

  const handleLoginSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsAuthenticating(true);
    setAuthError(null);

    setTimeout(() => {
      setIsAuthenticating(false);
      setScreen('dashboard');
    }, 600);
  };

  const handleRegisterSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onRoleChange(regRole);
    setScreen('dashboard');
  };

  const handleCreateBusinessSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!regBizName || !regBizPhone) return;

    onRegisterBusiness({
      name: regBizName,
      ownerName: regBizOwner,
      phone: regBizPhone,
      category: newBizCategory.name,
      categorySlug: newBizCategory.slug,
      province: regBizProvince,
      city: regBizCity,
      panNumber: regBizPan || '60199' + Math.floor(1000 + Math.random() * 9000),
      address: `${regBizCity}, ${regBizProvince}`,
    });

    setRegistrationSuccessBanner(true);
    setShowRegisterFlow(false);
    setRegisterStep('category');
    setRegBizName('');
    setRegBizPan('');

    setTimeout(() => {
      setRegistrationSuccessBanner(false);
    }, 4000);
  };

  const handleSaveEditBusiness = () => {
    if (!selectedBusiness) return;
    const updated: BusinessItem = {
      ...selectedBusiness,
      name: editBizName || selectedBusiness.name,
      phone: editBizPhone || selectedBusiness.phone,
      city: editBizCity || selectedBusiness.city,
    };
    onUpdateBusiness(updated);
    setSelectedBusiness(updated);
    setIsEditingBusiness(false);
  };

  return (
    <div className="flex flex-col items-center justify-center p-2 sm:p-6 w-full max-w-5xl mx-auto space-y-4">
      {/* Top Role Switcher & Controls */}
      <div className="w-full bg-white rounded-2xl p-3 border border-slate-200 shadow-sm flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Active Role:</span>
          <div className="flex bg-slate-100 p-1 rounded-xl gap-1">
            <button
              onClick={() => onRoleChange('customer')}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition-all ${
                currentRole === 'customer'
                  ? 'bg-[#0F3D3E] text-white shadow-xs'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              Customer (ग्राहक)
            </button>
            <button
              onClick={() => onRoleChange('businessOwner')}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition-all ${
                currentRole === 'businessOwner'
                  ? 'bg-[#0F3D3E] text-white shadow-xs'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              Merchant (व्यापारी)
            </button>
            <button
              onClick={() => onRoleChange('staff')}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition-all ${
                currentRole === 'staff'
                  ? 'bg-[#0F3D3E] text-white shadow-xs'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              Staff (कर्मचारी)
            </button>
            <button
              onClick={() => onRoleChange('superAdmin')}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition-all ${
                currentRole === 'superAdmin'
                  ? 'bg-[#0F3D3E] text-white shadow-xs'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              Super Admin (प्रशासक)
            </button>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {onOpenApkStation && (
            <button
              onClick={onOpenApkStation}
              className="flex items-center gap-1.5 px-3 py-1 bg-[#C79A3E] hover:bg-[#d8a846] text-slate-950 rounded-xl text-xs font-black transition-all shadow-xs"
              title="Build & Download APK via Codemagic"
            >
              <span>⚡ Build APK</span>
            </button>
          )}
          <button
            onClick={() => setLang(lang === 'np' ? 'en' : 'np')}
            className="flex items-center gap-1.5 px-3 py-1 bg-slate-100 hover:bg-slate-200 rounded-xl text-xs font-bold text-slate-700 transition-all"
          >
            <Globe className="w-3.5 h-3.5 text-[#C79A3E]" />
            <span>{lang === 'np' ? 'नेपाली (NP)' : 'English (EN)'}</span>
          </button>
          <button
            onClick={() => setIsDark(!isDark)}
            className="p-1.5 bg-slate-100 hover:bg-slate-200 rounded-xl text-slate-700 transition-all"
            title="Toggle theme"
          >
            {isDark ? <Sun className="w-4 h-4 text-amber-500" /> : <Moon className="w-4 h-4 text-slate-700" />}
          </button>
        </div>
      </div>

      {/* Success Banner when new business registered */}
      {registrationSuccessBanner && (
        <div className="w-full max-w-sm bg-amber-50 border border-amber-300 text-amber-900 px-4 py-3 rounded-2xl text-xs font-medium flex items-center justify-between shadow-md animate-fadeIn">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 text-amber-600 shrink-0" />
            <span>
              <strong>व्यापार सफलतापूर्वक दर्ता भयो!</strong> (Waiting for Super Admin approval in Web Admin Panel)
            </span>
          </div>
        </div>
      )}

      {/* Submission Banner for Pending News / Ads */}
      {submissionNotice && (
        <div className="w-full max-w-sm bg-emerald-50 border border-emerald-300 text-emerald-950 px-4 py-3 rounded-2xl text-xs font-semibold flex items-center justify-between shadow-md animate-fadeIn">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
            <span>{submissionNotice}</span>
          </div>
        </div>
      )}

      {/* SMARTPHONE DEVICE CONTAINER */}
      <div
        className={`relative w-full max-w-[390px] h-[780px] rounded-[48px] shadow-2xl border-[10px] ${
          isDark ? 'border-slate-800 bg-[#0F172A]' : 'border-slate-900 bg-slate-50'
        } overflow-hidden flex flex-col transition-colors duration-300`}
      >
        {/* Device Notch & Dynamic Status Bar */}
        <div className="h-7 w-full bg-black flex items-center justify-between px-6 shrink-0 z-30">
          <span className="text-[11px] font-bold text-white font-mono">10:45 AM</span>
          <div className="w-24 h-4 bg-black rounded-b-2xl mx-auto flex items-center justify-center">
            <div className="w-3 h-3 rounded-full bg-[#111827] border border-slate-700/60 mr-2" />
            <div className="w-2 h-2 rounded-full bg-blue-900/60" />
          </div>
          <div className="flex items-center gap-1.5 text-white text-[10px] font-mono">
            <span>NTC 5G</span>
            <div className="w-4 h-2 rounded-xs border border-white/80 p-0.5 flex items-center">
              <div className="h-full w-full bg-emerald-400 rounded-2xs" />
            </div>
          </div>
        </div>

        {/* ========================================================================= */}
        {/* INNER SCREEN CONTAINER */}
        {/* ========================================================================= */}
        <div className={`flex-1 flex flex-col overflow-hidden relative ${isDark ? 'text-slate-100' : 'text-slate-900'}`}>
          {/* SCREEN 1: SPLASH */}
          {screen === 'splash' && (
            <div className="flex-1 flex flex-col justify-between items-center p-8 bg-[#0F3D3E] text-white text-center">
              <div className="pt-16 space-y-4">
                <div className="w-20 h-20 mx-auto rounded-3xl bg-white/10 flex items-center justify-center border-2 border-[#C79A3E] shadow-xl">
                  <Tv className="w-10 h-10 text-[#C79A3E]" />
                </div>
                <h2 className="text-3xl font-black tracking-tight">{dynamicAppTitle}</h2>
                <p className="text-xs text-white/80 max-w-xs leading-relaxed">
                  नेपालको पहिलो अल-इन-वन सुपर एप · भुक्तानी, बजार, स्वास्थ्य, किराना तथा टिभी
                </p>
              </div>

              <div className="w-full space-y-3 pb-4">
                <button
                  onClick={() => setScreen('login')}
                  className="w-full py-3 bg-[#C79A3E] text-slate-950 font-black rounded-2xl text-xs uppercase tracking-wider shadow-lg hover:bg-[#d8a846] transition-all"
                >
                  {lang === 'np' ? 'सुरु गर्नुहोस् (Get Started)' : 'Get Started'}
                </button>

                <div className="text-center pt-2">
                  <div className="text-[10px] font-bold text-white">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                  <div className="text-[8px] text-white/60">Easy App · All rights reserved</div>
                </div>
              </div>
            </div>
          )}

          {/* SCREEN 2: LOGIN */}
          {screen === 'login' && (
            <div className="flex-1 flex flex-col justify-between p-6 overflow-y-auto">
              <div className="pt-4 space-y-4">
                <div className="flex items-center justify-between">
                  <div className="w-10 h-10 rounded-2xl bg-[#0F3D3E] flex items-center justify-center text-[#C79A3E]">
                    <Tv className="w-5 h-5" />
                  </div>
                  <span className="text-[11px] font-extrabold text-[#0F3D3E] uppercase">{dynamicAppTitle}</span>
                </div>

                <div>
                  <h3 className="text-xl font-black text-slate-900">
                    {lang === 'np' ? 'नमस्ते! स्वागत छ' : 'Welcome Back'}
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    {lang === 'np' ? 'आफ्नो खातामा लगइन गर्नुहोस्' : 'Sign in to access your dashboard'}
                  </p>
                </div>

                <form onSubmit={handleLoginSubmit} className="space-y-3 pt-2">
                  <div>
                    <label className="block text-[11px] font-bold text-slate-700 mb-1">
                      {lang === 'np' ? 'इमेल वा मोबाइल नम्बर' : 'Email or Mobile'}
                    </label>
                    <input
                      type="text"
                      value={loginEmail}
                      onChange={(e) => setLoginEmail(e.target.value)}
                      className="w-full px-3 py-2 bg-white rounded-xl border border-slate-200 text-xs"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-[11px] font-bold text-slate-700 mb-1">
                      {lang === 'np' ? 'गोप्य पासवर्ड' : 'Password'}
                    </label>
                    <div className="relative">
                      <input
                        type={showPassword ? 'text' : 'password'}
                        value={loginPassword}
                        onChange={(e) => setLoginPassword(e.target.value)}
                        className="w-full px-3 py-2 bg-white rounded-xl border border-slate-200 text-xs pr-9"
                        required
                      />
                      <button
                        type="button"
                        onClick={() => setShowPassword(!showPassword)}
                        className="absolute right-2.5 top-2.5 text-slate-400"
                      >
                        {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  <button
                    type="submit"
                    className="w-full py-2.5 bg-[#0F3D3E] text-white font-bold rounded-xl text-xs hover:bg-[#165B5E] transition-all"
                  >
                    {isAuthenticating ? 'प्रमाणीकरण हुँदैछ...' : `${dynamicAppTitle} मा लगइन`}
                  </button>
                </form>

                <div className="text-center pt-2">
                  <button
                    onClick={() => setScreen('register')}
                    className="text-xs font-bold text-[#C79A3E] hover:underline"
                  >
                    {lang === 'np' ? 'नयाँ खाता दर्ता गर्नुहोस्' : 'Create New Account'}
                  </button>
                </div>
              </div>

              {/* Permanent Footer Branding */}
              <div className="text-center pt-4 border-t border-slate-200/80">
                <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
              </div>
            </div>
          )}

          {/* SCREEN 3: REGISTER */}
          {screen === 'register' && (
            <div className="flex-1 flex flex-col justify-between p-5 overflow-y-auto">
              <div className="space-y-3">
                <div className="flex items-center justify-between pb-2 border-b border-slate-200">
                  <h4 className="text-sm font-bold text-[#0F3D3E]">
                    {dynamicAppTitle} {lang === 'np' ? 'नयाँ खाता दर्ता' : 'Register'}
                  </h4>
                  <button onClick={() => setScreen('login')} className="text-xs text-slate-500 hover:underline">
                    {lang === 'np' ? 'लगइन' : 'Back'}
                  </button>
                </div>

                <form onSubmit={handleRegisterSubmit} className="space-y-2.5">
                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-1">
                      {lang === 'np' ? 'भूमिका (Account Role)' : 'Account Role'}
                    </label>
                    <div className="grid grid-cols-3 gap-1 bg-slate-200/60 p-1 rounded-xl">
                      <button
                        type="button"
                        onClick={() => setRegRole('customer')}
                        className={`py-1 text-[10px] font-bold rounded-lg ${
                          regRole === 'customer' ? 'bg-[#0F3D3E] text-white shadow-xs' : 'text-slate-600'
                        }`}
                      >
                        ग्राहक
                      </button>
                      <button
                        type="button"
                        onClick={() => setRegRole('businessOwner')}
                        className={`py-1 text-[10px] font-bold rounded-lg ${
                          regRole === 'businessOwner' ? 'bg-[#0F3D3E] text-white shadow-xs' : 'text-slate-600'
                        }`}
                      >
                        व्यापारी
                      </button>
                      <button
                        type="button"
                        onClick={() => setRegRole('staff')}
                        className={`py-1 text-[10px] font-bold rounded-lg ${
                          regRole === 'staff' ? 'bg-[#0F3D3E] text-white shadow-xs' : 'text-slate-600'
                        }`}
                      >
                        कर्मचारी
                      </button>
                    </div>
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">पूरा नाम (Full Name)</label>
                    <input
                      type="text"
                      value={regName}
                      onChange={(e) => setRegName(e.target.value)}
                      placeholder="Aarav Sharma"
                      required
                      className="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs bg-white"
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">इमेल (Email)</label>
                    <input
                      type="email"
                      value={regEmail}
                      onChange={(e) => setRegEmail(e.target.value)}
                      placeholder="user@nepal.np"
                      required
                      className="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs bg-white"
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">मोबाइल (+977)</label>
                    <input
                      type="tel"
                      value={regPhone}
                      onChange={(e) => setRegPhone(e.target.value)}
                      placeholder="98XXXXXXXX"
                      className="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs bg-white"
                    />
                  </div>

                  <button
                    type="submit"
                    className="w-full mt-2 py-2 rounded-xl font-bold text-xs bg-[#0F3D3E] text-white hover:bg-[#165B5E]"
                  >
                    खाता खोल्नुहोस् (Register)
                  </button>
                </form>
              </div>

              <div className="text-center pt-2 border-t border-slate-200">
                <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
              </div>
            </div>
          )}

          {/* SCREEN 4: UNIFIED APP DASHBOARDS */}
          {screen === 'dashboard' && (
            <div className="flex-1 flex flex-col h-full overflow-hidden">
              {/* App Top Bar */}
              <div
                className={`px-4 py-2.5 border-b flex items-center justify-between shrink-0 z-10 ${
                  isDark ? 'border-slate-800 bg-[#111E21]' : 'border-slate-200 bg-white'
                }`}
              >
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 rounded-lg bg-[#0F3D3E] flex items-center justify-center shadow-xs">
                    <Tv className="w-4 h-4 text-[#C79A3E]" />
                  </div>
                  <div>
                    <div className="text-xs font-black leading-tight text-[#0F3D3E]">{dynamicAppTitle}</div>
                    <div className="text-[10px] text-slate-500 font-medium">
                      {activeUser.fullName.split(' ')[0]} · {activeUser.roleTitle}
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-1.5">
                  <button
                    onClick={() => setScreen('login')}
                    title="Sign Out"
                    className="p-1.5 text-slate-400 hover:text-red-500 rounded-lg hover:bg-slate-100"
                  >
                    <LogOut className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>

              {/* Scrollable Main Body */}
              <div className="flex-1 overflow-y-auto">
                {/* ========================================================================= */}
                {/* TAB 1: UNIFIED APP DASHBOARD (HOME) */}
                {/* ========================================================================= */}
                {activeBottomTab === 'home' && (
                  <div className="p-3.5 space-y-3.5">
                    {/* Live RN TV Bar (Switches to TV Tab) */}
                    <div
                      onClick={() => setActiveBottomTab('tv')}
                      className="rounded-2xl p-3 bg-gradient-to-r from-[#1E293B] to-[#0F172A] text-white shadow-md flex items-center justify-between border border-white/10 cursor-pointer hover:opacity-95 transition-all"
                    >
                      <div className="flex items-center gap-2.5">
                        <div>
                          <div className="flex items-center gap-1.5">
                            <span className="text-xs font-black">RN TV</span>
                            <span className="text-[8px] bg-red-600 text-white font-black px-1.5 py-0.5 rounded flex items-center gap-1">
                              <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" />
                              LIVE
                            </span>
                          </div>
                          <span className="text-[9px] text-white/70">प्रत्यक्ष २४/७ डिजिटल तथा स्याटेलाइट प्रसारण</span>
                        </div>
                      </div>
                      <ChevronRight className="w-4 h-4 text-white/60" />
                    </div>

                    {/* 1. NEWS & MARKET-RATE TICKER BAR (Supabase: ticker_items table) */}
                    {tickerItems.filter((t) => t.status === 'approved').length > 0 && (
                      <div className="rounded-2xl p-2.5 bg-white border border-[#C79A3E]/40 shadow-xs flex items-center justify-between gap-2">
                        <div className="flex items-center gap-2 overflow-hidden flex-1">
                          <span className="text-[8px] bg-[#0F3D3E] text-white px-2 py-0.5 rounded font-black uppercase tracking-wider shrink-0">
                            {tickerItems[activeTickerIndex % tickerItems.length].category === 'market_rate'
                              ? 'RATES'
                              : 'NEWS'}
                          </span>
                          <span className="text-[11px] font-semibold text-slate-800 truncate">
                            {lang === 'np'
                              ? tickerItems[activeTickerIndex % tickerItems.length].messageNp
                              : tickerItems[activeTickerIndex % tickerItems.length].message}
                          </span>
                        </div>
                        <button
                          onClick={() => setIsPostingNews(true)}
                          className="p-1 rounded-lg bg-slate-100 hover:bg-slate-200 text-[#0F3D3E] shrink-0"
                          title="Post News / Notice"
                        >
                          <Plus className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    )}

                    {/* 2. APPROVED HOME BANNER ADS SLIDER (Supabase: ads table) */}
                    {adsList.filter((a) => a.status === 'approved').length > 0 && (
                      <div className="relative rounded-2xl overflow-hidden shadow-md border border-slate-200">
                        <div className="h-36 relative">
                          <img
                            src={adsList[activeAdIndex % adsList.length].imageUrl}
                            alt={adsList[activeAdIndex % adsList.length].title}
                            className="w-full h-full object-cover"
                          />
                          <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/20 to-transparent p-3 flex flex-col justify-end">
                            <span className="text-[8px] uppercase bg-[#C79A3E] text-slate-950 font-black px-1.5 py-0.5 rounded w-fit mb-1">
                              {adsList[activeAdIndex % adsList.length].sponsorName}
                            </span>
                            <span className="text-xs font-bold text-white line-clamp-1">
                              {lang === 'np' && adsList[activeAdIndex % adsList.length].titleNp
                                ? adsList[activeAdIndex % adsList.length].titleNp
                                : adsList[activeAdIndex % adsList.length].title}
                            </span>
                          </div>
                        </div>

                        {/* Slider dots */}
                        <div className="absolute bottom-2 right-2 flex items-center gap-1 z-10">
                          {adsList.map((_, idx) => (
                            <button
                              key={idx}
                              onClick={() => setActiveAdIndex(idx)}
                              className={`h-1.5 rounded-full transition-all ${
                                activeAdIndex === idx ? 'w-4 bg-[#C79A3E]' : 'w-1.5 bg-white/60'
                              }`}
                            />
                          ))}
                        </div>
                      </div>
                    )}

                    {/* 3. POST NEWS & POST AD ACTION BUTTONS (Inserts status 'pending' only) */}
                    <div className="grid grid-cols-2 gap-2">
                      <button
                        onClick={() => setIsPostingNews(true)}
                        className="py-2.5 px-3 rounded-xl border border-[#0F3D3E] bg-white text-[#0F3D3E] text-[11px] font-bold flex items-center justify-center gap-1.5 hover:bg-slate-50 transition-all shadow-xs"
                      >
                        <FileText className="w-3.5 h-3.5" />
                        <span>{lang === 'np' ? 'समाचार / सूचना पठाउनुहोस्' : 'Post News / Notice'}</span>
                      </button>

                      <button
                        onClick={() => setIsPostingAd(true)}
                        className="py-2.5 px-3 rounded-xl bg-[#C79A3E] hover:bg-[#d8a846] text-slate-950 text-[11px] font-black flex items-center justify-center gap-1.5 transition-all shadow-xs"
                      >
                        <Tv className="w-3.5 h-3.5" />
                        <span>{lang === 'np' ? 'विज्ञापन पेश गर्नुहोस्' : 'Post Ad / Banner'}</span>
                      </button>
                    </div>

                    {/* 4. TRENDING APPROVED OFFERS & DEALS (Supabase: offers table) */}
                    {offersList.filter((o) => o.status === 'approved').length > 0 && (
                      <div className="space-y-1.5">
                        <div className="flex items-center justify-between">
                          <span className="text-xs font-black text-slate-800">
                            {lang === 'np' ? 'विशेष छुट तथा अफरहरू (Offers)' : 'Trending Offers & Discounts'}
                          </span>
                          <span className="text-[10px] text-amber-700 font-bold">
                            {offersList.length} Active
                          </span>
                        </div>

                        <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar">
                          {offersList.map((offer) => (
                            <div
                              key={offer.id}
                              className="w-48 shrink-0 p-2.5 bg-white rounded-xl border border-amber-200/90 shadow-xs flex flex-col justify-between"
                            >
                              <div className="flex items-center justify-between mb-1">
                                <span className="text-[9px] bg-red-100 text-red-700 font-black px-1.5 py-0.5 rounded">
                                  {offer.discountPercent}% OFF
                                </span>
                                <span className="text-[9px] font-mono text-slate-400 font-bold">
                                  {offer.couponCode}
                                </span>
                              </div>
                              <span className="text-[11px] font-bold text-slate-800 line-clamp-1">
                                {lang === 'np' ? offer.titleNp : offer.title}
                              </span>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* 'REGISTER MY BUSINESS' HERO BANNER (image_3.png) */}
                    <div className="p-3 bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200/80 rounded-2xl flex items-center justify-between shadow-xs">
                      <div className="space-y-0.5">
                        <div className="text-xs font-black text-amber-950 flex items-center gap-1">
                          <Building2 className="w-3.5 h-3.5 text-[#0F3D3E]" />
                          <span>पसल वा सेवा व्यवसाय छ?</span>
                        </div>
                        <div className="text-[10px] text-amber-800">
                          {dynamicAppTitle} मा दर्ता गर्नुहोस् र अनलाइन व्यापार बढाउनुहोस्
                        </div>
                      </div>
                      <button
                        onClick={() => {
                          setShowRegisterFlow(true);
                          setRegisterStep('category');
                        }}
                        className="px-3 py-1.5 bg-[#0F3D3E] hover:bg-[#165B5E] text-white rounded-xl text-[10px] font-bold flex items-center gap-1 shrink-0 shadow-sm"
                      >
                        <Plus className="w-3 h-3" />
                        <span>दर्ता गर्नुहोस्</span>
                      </button>
                    </div>

                    {/* DYNAMIC BUSINESS MODULES GRID (Requirements: Clinic, Kirana/Retail, Clothing, Cosmetics, Real Estate, Reuse/Recycle, Local Market) */}
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-xs font-black text-slate-800">
                          सक्रिय सेवा मोड्युलहरू (Dynamic Modules)
                        </span>
                        <span className="text-[10px] text-slate-400 font-medium">DB Managed</span>
                      </div>

                      <div className="grid grid-cols-3 gap-2">
                        {categories
                          .filter((c) => c.active)
                          .map((cat) => (
                            <button
                              key={cat.id}
                              onClick={() => setSelectedCategoryDetail(cat.name)}
                              className="p-2.5 rounded-xl bg-white border border-slate-200 flex flex-col items-center text-center gap-1 shadow-xs hover:border-[#0F3D3E] transition-all"
                            >
                              <div className="w-8 h-8 rounded-lg bg-[#0F3D3E]/10 flex items-center justify-center text-[#0F3D3E]">
                                {cat.segment === 'HEALTH' && <HeartPulse className="w-4 h-4 text-red-600" />}
                                {cat.segment === 'FOOD' && <Utensils className="w-4 h-4 text-emerald-600" />}
                                {cat.segment === 'CLOTHING' && <ShoppingBag className="w-4 h-4 text-purple-600" />}
                                {cat.segment === 'COSMETICS' && <Sparkles className="w-4 h-4 text-pink-600" />}
                                {cat.segment === 'REALESTATE' && <Building2 className="w-4 h-4 text-amber-600" />}
                                {cat.segment === 'RECYCLE' && <RefreshCw className="w-4 h-4 text-teal-600" />}
                                {cat.segment === 'LOCAL_MARKET' && <Store className="w-4 h-4 text-orange-600" />}
                                {cat.segment === 'UTILITIES' && <Zap className="w-4 h-4 text-yellow-600" />}
                                {cat.segment === 'MEDIA' && <Tv className="w-4 h-4 text-blue-600" />}
                                {cat.segment !== 'HEALTH' &&
                                  cat.segment !== 'FOOD' &&
                                  cat.segment !== 'CLOTHING' &&
                                  cat.segment !== 'COSMETICS' &&
                                  cat.segment !== 'REALESTATE' &&
                                  cat.segment !== 'RECYCLE' &&
                                  cat.segment !== 'LOCAL_MARKET' &&
                                  cat.segment !== 'UTILITIES' &&
                                  cat.segment !== 'MEDIA' && <Tag className="w-4 h-4 text-[#0F3D3E]" />}
                              </div>
                              <span className="text-[10px] font-bold text-slate-800 leading-tight line-clamp-1">
                                {cat.name}
                              </span>
                              <span className="text-[8px] text-slate-400 font-mono truncate max-w-full">
                                {cat.nameNp || cat.segment}
                              </span>
                            </button>
                          ))}
                      </div>
                    </div>

                    {/* Category Detail Modal / Sheet */}
                    {selectedCategoryDetail && (
                      <div className="p-3 bg-white rounded-2xl border border-slate-200 shadow-sm space-y-2">
                        <div className="flex items-center justify-between border-b border-slate-100 pb-1.5">
                          <span className="text-xs font-bold text-[#0F3D3E]">{selectedCategoryDetail}</span>
                          <button
                            onClick={() => setSelectedCategoryDetail(null)}
                            className="text-slate-400 hover:text-slate-700"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </div>
                        <p className="text-[11px] text-slate-500">
                          Verified listings in Kathmandu Valley &amp; Gandaki. Book services or order directly.
                        </p>
                        <div className="text-[10px] font-bold text-emerald-700 bg-emerald-50 p-2 rounded-lg">
                          ✓ Live merchant data synced from Supabase multi-tenant database.
                        </div>
                      </div>
                    )}

                    {/* Permanent Footer Branding */}
                    <div className="pt-3 pb-1 text-center border-t border-slate-200/80">
                      <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                      <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
                    </div>
                  </div>
                )}

                {/* ========================================================================= */}
                {/* TAB 2: MY BUSINESSES (image_2.png & image_3.png) */}
                {/* ========================================================================= */}
                {activeBottomTab === 'businesses' && (
                  <div className="p-3.5 space-y-3.5">
                    {/* Header */}
                    <div className="flex items-center justify-between">
                      <div>
                        <h4 className="text-sm font-black text-slate-900">
                          {lang === 'np' ? 'मेरा व्यवसायहरू (My Businesses)' : 'My Businesses'}
                        </h4>
                        <p className="text-[10px] text-slate-500">
                          {businesses.length} registered ventures under your account
                        </p>
                      </div>

                      {/* 'Register my business' button (image_3.png) */}
                      <button
                        onClick={() => {
                          setShowRegisterFlow(true);
                          setRegisterStep('category');
                        }}
                        className="flex items-center gap-1 px-3 py-1.5 bg-[#0F3D3E] hover:bg-[#165B5E] text-white rounded-xl text-xs font-bold transition-all shadow-xs"
                      >
                        <Plus className="w-3.5 h-3.5" />
                        <span>Register</span>
                      </button>
                    </div>

                    {/* Business List displaying Registered, Pending, Rejected, Suspended (image_3.png) */}
                    <div className="space-y-2.5">
                      {businesses.map((biz) => {
                        const isPending = biz.status === 'pending';
                        const isRejected = biz.status === 'rejected';
                        const isSuspended = biz.status === 'suspended';
                        const isApproved = biz.status === 'approved';

                        return (
                          <div
                            key={biz.id}
                            className="bg-white rounded-2xl border border-slate-200 p-3.5 shadow-xs space-y-2"
                          >
                            <div className="flex items-start justify-between gap-2">
                              <div>
                                <h5 className="font-bold text-xs text-slate-900">{biz.name}</h5>
                                <div className="text-[10px] text-slate-500">
                                  {biz.category} · Phone: {biz.phone}
                                </div>
                              </div>

                              {/* Status Badge */}
                              <span
                                className={`text-[9px] font-black px-2 py-0.5 rounded-full uppercase shrink-0 ${
                                  isApproved
                                    ? 'bg-emerald-100 text-emerald-800'
                                    : isPending
                                    ? 'bg-amber-100 text-amber-800'
                                    : isRejected
                                    ? 'bg-red-100 text-red-800'
                                    : 'bg-orange-100 text-orange-800'
                                }`}
                              >
                                {isPending ? 'Pending Approval' : biz.status}
                              </span>
                            </div>

                            {/* Additional Status Context */}
                            {isPending && (
                              <div className="text-[10px] text-amber-800 bg-amber-50 p-2 rounded-xl border border-amber-100 flex items-center gap-1.5">
                                <Clock className="w-3.5 h-3.5 text-amber-600 shrink-0" />
                                <span>Waiting for admin approval. Verification in progress.</span>
                              </div>
                            )}

                            {isRejected && (
                              <div className="text-[10px] text-red-800 bg-red-50 p-2 rounded-xl border border-red-100 flex items-start gap-1.5">
                                <AlertTriangle className="w-3.5 h-3.5 text-red-600 shrink-0 mt-0.5" />
                                <div>
                                  <div className="font-bold">Application Rejected:</div>
                                  <div>{biz.rejectionReason || 'Documents did not meet criteria.'}</div>
                                </div>
                              </div>
                            )}

                            {/* Action Buttons: View Details & Edit (image_2.png & image_3.png) */}
                            <div className="flex items-center justify-end gap-2 pt-2 border-t border-slate-100">
                              <button
                                onClick={() => {
                                  setSelectedBusiness(biz);
                                  setIsEditingBusiness(true);
                                  setEditBizName(biz.name);
                                  setEditBizPhone(biz.phone);
                                  setEditBizCity(biz.city);
                                }}
                                className="px-2.5 py-1 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-[10px] font-bold flex items-center gap-1"
                              >
                                <Edit3 className="w-3 h-3" /> Edit
                              </button>
                              <button
                                onClick={() => setSelectedBusiness(biz)}
                                className="px-3 py-1 bg-[#0F3D3E] hover:bg-[#165B5E] text-white rounded-lg text-[10px] font-bold flex items-center gap-1"
                              >
                                <span>View Details</span>
                                <ChevronRight className="w-3 h-3" />
                              </button>
                            </div>
                          </div>
                        );
                      })}
                    </div>

                    {/* Permanent Footer Branding */}
                    <div className="pt-3 text-center border-t border-slate-200/80">
                      <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                      <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
                    </div>
                  </div>
                )}

                {/* ========================================================================= */}
                {/* TAB 3: RN TV LIVE SATELLITE & DIGITAL BROADCAST */}
                {/* ========================================================================= */}
                {activeBottomTab === 'tv' && (
                  <div className="p-3.5 space-y-3.5">
                    <div className="rounded-2xl overflow-hidden bg-black text-white shadow-md">
                      <div className="aspect-video bg-slate-900 relative flex items-center justify-center">
                        <Tv className="w-12 h-12 text-[#C79A3E]/60 animate-pulse" />
                        <span className="absolute top-2 left-2 text-[9px] bg-red-600 text-white px-2 py-0.5 rounded font-black uppercase flex items-center gap-1">
                          <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" />
                          LIVE
                        </span>
                        <span className="absolute bottom-2 left-2 text-[10px] text-white/90 font-medium bg-black/60 px-2 py-0.5 rounded">
                          RN TV 24/7 Digital Satellite Broadcast
                        </span>
                      </div>
                      <div className="p-3 bg-[#0F3D3E] flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <span className="text-xs font-black text-white">RN TV</span>
                          <span className="text-[8px] bg-red-600 text-white font-black px-1.5 py-0.5 rounded">
                            LIVE
                          </span>
                        </div>
                        <span className="text-[10px] bg-[#C79A3E] text-slate-950 font-black px-2 py-0.5 rounded">
                          ON AIR
                        </span>
                      </div>
                    </div>

                    <div className="bg-white p-3.5 rounded-2xl border border-slate-200 space-y-2">
                      <div className="flex items-center gap-2">
                        <h5 className="font-bold text-xs text-slate-900">RN TV Commercial Advertisements Program</h5>
                        <span className="text-[8px] bg-red-600 text-white font-black px-1.5 py-0.2 rounded">LIVE</span>
                      </div>
                      <p className="text-[11px] text-slate-600 leading-relaxed">
                        Registered merchants on Easy App can advertise their products directly on RN TV broadcasts.
                      </p>
                      <button
                        onClick={() => {
                          if (onOpenAdminPanel) onOpenAdminPanel();
                        }}
                        className="w-full py-2 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-xl text-xs font-bold text-center"
                      >
                        Book RN TV Commercial Slot
                      </button>
                    </div>

                    {/* Permanent Footer Branding */}
                    <div className="pt-3 text-center border-t border-slate-200/80">
                      <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                      <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
                    </div>
                  </div>
                )}

                {/* ========================================================================= */}
                {/* TAB: EASY MUSIC & RADIO PLAYER (कोड म्युजिक) */}
                {/* ========================================================================= */}
                {activeBottomTab === 'music' && (
                  <div className="p-3.5 space-y-3.5">
                    {/* Visualizer & Playing Track Card */}
                    <div className="bg-gradient-to-br from-[#0F3D3E] to-[#165B5E] text-white p-5 rounded-3xl shadow-lg shadow-[#0F3D3E]/25 text-center space-y-3">
                      <div className="w-20 h-20 mx-auto rounded-2xl bg-white/10 flex items-center justify-center border-2 border-[#C79A3E]/40 relative shadow-inner">
                        <Music className="w-10 h-10 text-[#C79A3E]" />
                        {isPlayingMusic && (
                          <span className="absolute top-2 right-2 w-2.5 h-2.5 bg-emerald-400 rounded-full animate-ping" />
                        )}
                      </div>

                      <div>
                        <span className="text-[9px] bg-white/20 text-white px-2 py-0.5 rounded-full font-bold uppercase tracking-wider">
                          {nepaliPlaylist[currentTrackIndex].category}
                        </span>
                        <h4 className="text-sm font-black mt-1 leading-tight text-white">
                          {nepaliPlaylist[currentTrackIndex].title}
                        </h4>
                        <div className="text-[11px] text-[#E5B95C] font-medium">
                          {nepaliPlaylist[currentTrackIndex].artist}
                        </div>
                      </div>

                      {/* Controls */}
                      <div className="flex items-center justify-center gap-4 pt-1">
                        <button
                          onClick={() => {
                            setCurrentTrackIndex(
                              (prev) => (prev - 1 + nepaliPlaylist.length) % nepaliPlaylist.length
                            );
                            setIsPlayingMusic(true);
                          }}
                          className="p-2 text-white/80 hover:text-white"
                        >
                          <SkipBack className="w-4 h-4" />
                        </button>

                        <button
                          onClick={() => setIsPlayingMusic(!isPlayingMusic)}
                          className="w-11 h-11 rounded-full bg-[#C79A3E] text-slate-950 flex items-center justify-center shadow-md hover:bg-[#d8a846] transition-all"
                        >
                          {isPlayingMusic ? <Pause className="w-5 h-5 fill-current" /> : <Play className="w-5 h-5 fill-current ml-0.5" />}
                        </button>

                        <button
                          onClick={() => {
                            setCurrentTrackIndex((prev) => (prev + 1) % nepaliPlaylist.length);
                            setIsPlayingMusic(true);
                          }}
                          className="p-2 text-white/80 hover:text-white"
                        >
                          <SkipForward className="w-4 h-4" />
                        </button>
                      </div>
                    </div>

                    {/* Playlist items */}
                    <div className="space-y-2">
                      <div className="text-xs font-black text-slate-900 flex items-center justify-between">
                        <span>चर्चित नेपाली गीत तथा प्रत्यक्ष एफएम</span>
                        <span className="text-[10px] text-slate-400">4 Tracks</span>
                      </div>

                      {nepaliPlaylist.map((trk, idx) => (
                        <div
                          key={trk.id}
                          onClick={() => {
                            setCurrentTrackIndex(idx);
                            setIsPlayingMusic(true);
                          }}
                          className={`p-3 rounded-2xl border transition-all cursor-pointer flex items-center justify-between ${
                            currentTrackIndex === idx
                              ? 'bg-amber-50/80 border-amber-300 shadow-xs'
                              : 'bg-white border-slate-200 hover:border-slate-300'
                          }`}
                        >
                          <div className="flex items-center gap-2.5">
                            <div
                              className={`w-8 h-8 rounded-xl flex items-center justify-center font-bold text-xs ${
                                currentTrackIndex === idx
                                  ? 'bg-[#0F3D3E] text-white'
                                  : 'bg-slate-100 text-slate-600'
                              }`}
                            >
                              {currentTrackIndex === idx && isPlayingMusic ? (
                                <Radio className="w-4 h-4 text-[#C79A3E] animate-pulse" />
                              ) : (
                                <Music className="w-3.5 h-3.5" />
                              )}
                            </div>
                            <div>
                              <div className="font-bold text-xs text-slate-900">{trk.title}</div>
                              <div className="text-[10px] text-slate-500">
                                {trk.artist} · {trk.category}
                              </div>
                            </div>
                          </div>

                          <span className="text-[10px] font-mono font-bold text-slate-400">{trk.duration}</span>
                        </div>
                      ))}
                    </div>

                    {/* Permanent Footer Branding */}
                    <div className="pt-3 text-center border-t border-slate-200/80">
                      <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                      <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
                    </div>
                  </div>
                )}

                {/* ========================================================================= */}
                {/* TAB 4: FULL CUSTOMER PROFILE MANAGEMENT (image_9.png) */}
                {/* ========================================================================= */}
                {activeBottomTab === 'profile' && (
                  <div className="p-3.5 space-y-3.5">
                    {/* User Profile Card */}
                    <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-xs flex items-center gap-3">
                      <div className="w-12 h-12 rounded-2xl bg-[#0F3D3E] text-[#C79A3E] flex items-center justify-center font-black text-lg border-2 border-[#C79A3E]/30 shrink-0">
                        AS
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5">
                          <h4 className="font-black text-xs text-slate-900 truncate">{activeUser.fullName}</h4>
                          <span className="text-[9px] bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.2 rounded shrink-0">
                            KYC ✓
                          </span>
                        </div>
                        <div className="text-[10px] text-slate-500 font-mono truncate">{activeUser.email}</div>
                        <div className="text-[10px] text-slate-500 font-mono">{activeUser.phone}</div>
                      </div>
                    </div>

                    {/* Privacy & Minimal Data Collection Guarantee (image_9.png requirement) */}
                    <div className="p-2.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-900 text-[10px] space-y-0.5">
                      <div className="font-bold flex items-center gap-1">
                        <Shield className="w-3 h-3 text-emerald-700" />
                        <span>डाटा न्यूनतम संकलन सिद्धान्त (Minimal Data Collection)</span>
                      </div>
                      <p className="text-[9px] text-emerald-800">
                        Easy App only collects strictly necessary data to process payments &amp; local merchant delivery.
                      </p>
                    </div>

                    {/* 1. Saved Addresses */}
                    <div className="bg-white rounded-2xl p-3 border border-slate-200 space-y-2">
                      <div className="flex items-center justify-between text-xs font-bold text-slate-900">
                        <span className="flex items-center gap-1.5">
                          <MapPin className="w-3.5 h-3.5 text-[#0F3D3E]" /> Saved Addresses
                        </span>
                        <button className="text-[10px] text-[#0F3D3E] font-bold">+ Add</button>
                      </div>
                      <div className="space-y-1.5">
                        {customerAddresses.map((addr) => (
                          <div key={addr.id} className="p-2 bg-slate-50 rounded-xl text-[10px] border border-slate-100">
                            <div className="font-bold text-slate-800">{addr.label}</div>
                            <div className="text-slate-500">{addr.address}</div>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* 2. Favorites */}
                    <div className="bg-white rounded-2xl p-3 border border-slate-200 space-y-2">
                      <div className="flex items-center justify-between text-xs font-bold text-slate-900">
                        <span className="flex items-center gap-1.5">
                          <Heart className="w-3.5 h-3.5 text-red-500" /> Favorites
                        </span>
                        <span className="text-[10px] text-slate-400">{savedFavorites.length} saved</span>
                      </div>
                      <div className="space-y-1.5">
                        {savedFavorites.map((fav) => (
                          <div key={fav.id} className="p-2 bg-slate-50 rounded-xl text-[10px] border border-slate-100 flex items-center justify-between">
                            <div>
                              <div className="font-bold text-slate-800">{fav.name}</div>
                              <div className="text-slate-500">{fav.category} · {fav.location}</div>
                            </div>
                            <ChevronRight className="w-3.5 h-3.5 text-slate-400" />
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* 3. Orders, Bookings & Appointment History */}
                    <div className="bg-white rounded-2xl p-3 border border-slate-200 space-y-2">
                      <div className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                        <Clock className="w-3.5 h-3.5 text-[#0F3D3E]" /> Orders &amp; Appointment History
                      </div>
                      <div className="p-2 bg-slate-50 rounded-xl text-[10px] border border-slate-100 space-y-1">
                        <div className="flex justify-between font-bold text-slate-800">
                          <span>Doctor Consultation Token #042</span>
                          <span className="text-emerald-700">Completed</span>
                        </div>
                        <div className="text-slate-500">Siddhartha Health Clinic · रु. ५००.००</div>
                      </div>
                    </div>

                    {/* 4. Referrals & Rewards */}
                    <div className="bg-white rounded-2xl p-3 border border-slate-200 space-y-2">
                      <div className="flex items-center justify-between text-xs font-bold text-slate-900">
                        <span className="flex items-center gap-1.5">
                          <Gift className="w-3.5 h-3.5 text-[#C79A3E]" /> Easy Rewards
                        </span>
                        <span className="font-black text-[#0F3D3E]">४५० Coins</span>
                      </div>
                      <div className="text-[10px] text-slate-500">
                        Invite code: <strong className="font-mono text-slate-800">EASY-NEPAL-2026</strong>
                      </div>
                    </div>

                    {/* 5. Privacy & Security / Device Session */}
                    <div className="bg-white rounded-2xl p-3 border border-slate-200 space-y-2">
                      <div className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                        <Lock className="w-3.5 h-3.5 text-[#0F3D3E]" /> Privacy, Security &amp; Session
                      </div>
                      <div className="flex items-center justify-between text-[10px] text-slate-700 py-1">
                        <span>Two-Factor Authentication</span>
                        <button
                          onClick={() => setTwoFactorEnabled(!twoFactorEnabled)}
                          className={`px-2 py-0.5 rounded font-bold ${
                            twoFactorEnabled ? 'bg-emerald-100 text-emerald-800' : 'bg-slate-200 text-slate-600'
                          }`}
                        >
                          {twoFactorEnabled ? 'Enabled' : 'Disabled'}
                        </button>
                      </div>
                      <div className="p-2 bg-slate-50 rounded-xl text-[9px] text-slate-500 space-y-0.5 border border-slate-100">
                        <div className="font-bold text-slate-700 flex items-center gap-1">
                          <Laptop className="w-3 h-3" /> Current Device Session
                        </div>
                        <div>Samsung Galaxy S24 · Kathmandu, Nepal</div>
                        <div className="text-emerald-600">Active Now via Supabase JWT</div>
                      </div>
                    </div>

                    {/* Permanent Footer Branding */}
                    <div className="pt-3 text-center border-t border-slate-200/80">
                      <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                      <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
                    </div>
                  </div>
                )}
              </div>

              {/* Floating Mini Music Bar (if music active or user playing) */}
              {isPlayingMusic && (
                <div
                  onClick={() => setActiveBottomTab('music')}
                  className="mx-3 mb-1 p-2 bg-[#0F3D3E] text-white rounded-2xl flex items-center justify-between shadow-md cursor-pointer animate-fadeIn shrink-0 border border-white/10"
                >
                  <div className="flex items-center gap-2 truncate">
                    <div className="w-7 h-7 rounded-lg bg-white/10 flex items-center justify-center shrink-0">
                      <Radio className="w-3.5 h-3.5 text-[#C79A3E] animate-pulse" />
                    </div>
                    <div className="truncate">
                      <div className="text-[10px] font-black truncate">{nepaliPlaylist[currentTrackIndex].title}</div>
                      <div className="text-[8px] text-white/70 truncate">{nepaliPlaylist[currentTrackIndex].artist}</div>
                    </div>
                  </div>

                  <div className="flex items-center gap-1.5 shrink-0" onClick={(e) => e.stopPropagation()}>
                    <button
                      onClick={() => setIsPlayingMusic(!isPlayingMusic)}
                      className="p-1 rounded-full bg-white/15 text-white hover:bg-white/25"
                    >
                      {isPlayingMusic ? <Pause className="w-3.5 h-3.5 fill-current" /> : <Play className="w-3.5 h-3.5 fill-current" />}
                    </button>
                  </div>
                </div>
              )}

              {/* ========================================================================= */}
              {/* BOTTOM NAVIGATION BAR */}
              {/* ========================================================================= */}
              <div
                className={`px-3 py-2 border-t flex items-center justify-around shrink-0 ${
                  isDark ? 'border-slate-800 bg-[#111E21]' : 'border-slate-200 bg-white'
                }`}
              >
                <button
                  onClick={() => setActiveBottomTab('home')}
                  className={`flex flex-col items-center gap-0.5 ${
                    activeBottomTab === 'home' ? 'text-[#0F3D3E] font-bold' : 'text-slate-400'
                  }`}
                >
                  <Home className="w-4 h-4" />
                  <span className="text-[9px]">Home</span>
                </button>

                <button
                  onClick={() => setActiveBottomTab('businesses')}
                  className={`flex flex-col items-center gap-0.5 relative ${
                    activeBottomTab === 'businesses' ? 'text-[#0F3D3E] font-bold' : 'text-slate-400'
                  }`}
                >
                  <Store className="w-4 h-4" />
                  <span className="text-[9px]">Businesses</span>
                  {businesses.some((b) => b.status === 'pending') && (
                    <span className="w-1.5 h-1.5 bg-amber-500 rounded-full absolute -top-0.5 right-2" />
                  )}
                </button>

                <button
                  onClick={() => setActiveBottomTab('music')}
                  className={`flex flex-col items-center gap-0.5 relative ${
                    activeBottomTab === 'music' ? 'text-[#0F3D3E] font-bold' : 'text-slate-400'
                  }`}
                >
                  <Music className="w-4 h-4" />
                  <span className="text-[9px]">Music</span>
                  {isPlayingMusic && (
                    <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full absolute -top-0.5 right-2 animate-ping" />
                  )}
                </button>

                <button
                  onClick={() => setActiveBottomTab('tv')}
                  className={`flex flex-col items-center gap-0.5 ${
                    activeBottomTab === 'tv' ? 'text-[#0F3D3E] font-bold' : 'text-slate-400'
                  }`}
                >
                  <Tv className="w-4 h-4" />
                  <span className="text-[9px]">TV</span>
                </button>

                <button
                  onClick={() => setActiveBottomTab('profile')}
                  className={`flex flex-col items-center gap-0.5 ${
                    activeBottomTab === 'profile' ? 'text-[#0F3D3E] font-bold' : 'text-slate-400'
                  }`}
                >
                  <User className="w-4 h-4" />
                  <span className="text-[9px]">Profile</span>
                </button>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* MODAL 1: BUSINESS DETAILS PAGE (image_2.png) */}
          {/* ========================================================================= */}
          {selectedBusiness && !isEditingBusiness && (
            <div className="absolute inset-0 bg-white z-40 flex flex-col justify-between overflow-y-auto animate-fadeIn">
              <div className="p-4 space-y-4">
                {/* Top bar with back */}
                <div className="flex items-center justify-between pb-3 border-b border-slate-200">
                  <button
                    onClick={() => setSelectedBusiness(null)}
                    className="text-xs text-slate-500 flex items-center gap-1 hover:text-slate-900 font-medium"
                  >
                    ← Back
                  </button>
                  <span className="text-xs font-black text-[#0F3D3E]">Business Details</span>
                  <button
                    onClick={() => {
                      setIsEditingBusiness(true);
                      setEditBizName(selectedBusiness.name);
                      setEditBizPhone(selectedBusiness.phone);
                      setEditBizCity(selectedBusiness.city);
                    }}
                    className="px-2.5 py-1 bg-[#0F3D3E] text-white rounded-lg text-xs font-bold"
                  >
                    Edit
                  </button>
                </div>

                {/* Business Details Header matching image_2.png */}
                <div>
                  <h3 className="text-lg font-black text-slate-900">{selectedBusiness.name}</h3>
                  <div className="mt-1">
                    <span
                      className={`text-[10px] font-black px-2.5 py-0.5 rounded-full uppercase ${
                        selectedBusiness.status === 'approved'
                          ? 'bg-emerald-100 text-emerald-800'
                          : selectedBusiness.status === 'pending'
                          ? 'bg-amber-100 text-amber-800'
                          : selectedBusiness.status === 'rejected'
                          ? 'bg-red-100 text-red-800'
                          : 'bg-orange-100 text-orange-800'
                      }`}
                    >
                      Status: {selectedBusiness.status.toUpperCase()}
                    </span>
                  </div>
                </div>

                {/* Status Explanation (image_2.png: "Waiting for admin approval") */}
                {selectedBusiness.status === 'pending' && (
                  <div className="p-3 bg-amber-50 rounded-2xl border border-amber-200 text-amber-900 text-xs space-y-1">
                    <div className="font-bold flex items-center gap-1.5">
                      <Clock className="w-4 h-4 text-amber-600" /> Waiting for admin approval
                    </div>
                    <p className="text-[11px] text-amber-800 leading-relaxed">
                      Your business application has been submitted to the Super Admin review queue. You can edit details while verification is ongoing.
                    </p>
                  </div>
                )}

                {selectedBusiness.status === 'approved' && (
                  <div className="p-3 bg-emerald-50 rounded-2xl border border-emerald-200 text-emerald-900 text-xs">
                    <div className="font-bold flex items-center gap-1.5">
                      <CheckCircle2 className="w-4 h-4 text-emerald-600" /> Verified Merchant Account
                    </div>
                    <p className="text-[11px] text-emerald-800 mt-0.5">
                      Your business is live and receiving customer orders on Easy App.
                    </p>
                  </div>
                )}

                {selectedBusiness.status === 'rejected' && (
                  <div className="p-3 bg-red-50 rounded-2xl border border-red-200 text-red-900 text-xs">
                    <div className="font-bold flex items-center gap-1.5">
                      <AlertTriangle className="w-4 h-4 text-red-600" /> Rejection Notice
                    </div>
                    <p className="text-[11px] text-red-800 mt-1">
                      Reason: {selectedBusiness.rejectionReason || 'PAN document invalid.'}
                    </p>
                  </div>
                )}

                {/* Core Attributes */}
                <div className="bg-slate-50 p-4 rounded-2xl border border-slate-200 space-y-2 text-xs">
                  <div className="flex justify-between py-1 border-b border-slate-200">
                    <span className="text-slate-500 font-medium">Category:</span>
                    <span className="font-bold text-slate-800">{selectedBusiness.category}</span>
                  </div>
                  <div className="flex justify-between py-1 border-b border-slate-200">
                    <span className="text-slate-500 font-medium">Phone Number:</span>
                    <span className="font-bold font-mono text-[#0F3D3E]">{selectedBusiness.phone}</span>
                  </div>
                  <div className="flex justify-between py-1 border-b border-slate-200">
                    <span className="text-slate-500 font-medium">Owner Name:</span>
                    <span className="font-bold text-slate-800">{selectedBusiness.ownerName}</span>
                  </div>
                  <div className="flex justify-between py-1 border-b border-slate-200">
                    <span className="text-slate-500 font-medium">Location:</span>
                    <span className="font-bold text-slate-800">{selectedBusiness.city}, {selectedBusiness.province}</span>
                  </div>
                  <div className="flex justify-between py-1">
                    <span className="text-slate-500 font-medium">PAN/VAT:</span>
                    <span className="font-bold font-mono text-slate-800">{selectedBusiness.panNumber}</span>
                  </div>
                </div>
              </div>

              {/* Footer */}
              <div className="p-4 border-t border-slate-200 text-center">
                <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* MODAL 2: EDIT BUSINESS DETAILS */}
          {/* ========================================================================= */}
          {selectedBusiness && isEditingBusiness && (
            <div className="absolute inset-0 bg-white z-50 flex flex-col justify-between overflow-y-auto animate-fadeIn p-4">
              <div className="space-y-4">
                <div className="flex items-center justify-between pb-3 border-b border-slate-200">
                  <h4 className="text-sm font-bold text-slate-900">Edit Business Information</h4>
                  <button
                    onClick={() => setIsEditingBusiness(false)}
                    className="text-xs text-slate-500"
                  >
                    Cancel
                  </button>
                </div>

                <div className="space-y-3">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Business Name</label>
                    <input
                      type="text"
                      value={editBizName}
                      onChange={(e) => setEditBizName(e.target.value)}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl text-xs font-bold"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Phone Number</label>
                    <input
                      type="text"
                      value={editBizPhone}
                      onChange={(e) => setEditBizPhone(e.target.value)}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl text-xs font-mono"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">City / Location</label>
                    <input
                      type="text"
                      value={editBizCity}
                      onChange={(e) => setEditBizCity(e.target.value)}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl text-xs"
                    />
                  </div>
                </div>

                <button
                  onClick={handleSaveEditBusiness}
                  className="w-full py-2.5 bg-[#0F3D3E] hover:bg-[#165B5E] text-white rounded-xl text-xs font-bold"
                >
                  Save Changes
                </button>
              </div>

              <div className="text-center pt-3 border-t border-slate-200">
                <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* MODAL 3: REGISTER MY BUSINESS FLOW (image_3.png & image_4.png) */}
          {/* ========================================================================= */}
          {showRegisterFlow && (
            <div className="absolute inset-0 bg-white z-50 flex flex-col justify-between overflow-y-auto animate-fadeIn p-4">
              <div className="space-y-4">
                <div className="flex items-center justify-between pb-3 border-b border-slate-200">
                  <div className="flex items-center gap-1.5">
                    <Building2 className="w-4 h-4 text-[#0F3D3E]" />
                    <h4 className="text-xs font-black text-slate-900">
                      {registerStep === 'category' ? 'Select Business Category' : 'Enter Business Details'}
                    </h4>
                  </div>
                  <button
                    onClick={() => setShowRegisterFlow(false)}
                    className="text-xs text-slate-400 hover:text-slate-700"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>

                {/* STEP 1: CATEGORY SELECTION MENU (image_4.png) */}
                {registerStep === 'category' && (
                  <div className="space-y-3">
                    <p className="text-[11px] text-slate-500">
                      Choose the sector that best describes your business in Nepal:
                    </p>

                    <div className="space-y-2">
                      {businessCategoryOptions.map((opt) => {
                        const IconComp = opt.icon;
                        return (
                          <button
                            key={opt.id}
                            onClick={() => {
                              setNewBizCategory({ name: opt.name, slug: opt.slug });
                              setRegisterStep('details');
                            }}
                            className="w-full p-3 rounded-2xl border border-slate-200 bg-white hover:border-[#0F3D3E] hover:bg-slate-50 flex items-center justify-between text-left transition-all shadow-2xs group"
                          >
                            <div className="flex items-center gap-3">
                              <div className="w-9 h-9 rounded-xl bg-[#0F3D3E]/10 flex items-center justify-center text-[#0F3D3E] group-hover:bg-[#0F3D3E] group-hover:text-white transition-all shrink-0">
                                <IconComp className="w-4 h-4" />
                              </div>
                              <div>
                                <div className="text-xs font-bold text-slate-900">{opt.name}</div>
                                <div className="text-[10px] text-slate-400 leading-tight">{opt.description}</div>
                              </div>
                            </div>
                            <span className="text-[9px] font-bold text-slate-400 bg-slate-100 px-2 py-0.5 rounded-full shrink-0">
                              {opt.badge}
                            </span>
                          </button>
                        );
                      })}
                    </div>
                  </div>
                )}

                {/* STEP 2: BUSINESS DETAILS FORM */}
                {registerStep === 'details' && (
                  <form onSubmit={handleCreateBusinessSubmit} className="space-y-3">
                    <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-200 text-xs flex items-center justify-between">
                      <span className="text-slate-500">Selected Category:</span>
                      <span className="font-bold text-[#0F3D3E]">{newBizCategory.name}</span>
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-slate-700 mb-0.5">
                        Business Name (पसल वा क्लिनिकको नाम) *
                      </label>
                      <input
                        type="text"
                        placeholder="उदा: पशुपति आयुर्वेदिक क्लिनिक"
                        value={regBizName}
                        onChange={(e) => setRegBizName(e.target.value)}
                        required
                        className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-bold bg-white"
                      />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-slate-700 mb-0.5">
                        Owner Name (सञ्चालकको नाम) *
                      </label>
                      <input
                        type="text"
                        value={regBizOwner}
                        onChange={(e) => setRegBizOwner(e.target.value)}
                        required
                        className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs bg-white"
                      />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-slate-700 mb-0.5">
                        Contact Phone (+977) *
                      </label>
                      <input
                        type="tel"
                        value={regBizPhone}
                        onChange={(e) => setRegBizPhone(e.target.value)}
                        required
                        className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-mono bg-white"
                      />
                    </div>

                    <div className="grid grid-cols-2 gap-2">
                      <div>
                        <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Province</label>
                        <select
                          value={regBizProvince}
                          onChange={(e) => setRegBizProvince(e.target.value)}
                          className="w-full px-2 py-2 rounded-xl border border-slate-200 text-xs bg-white"
                        >
                          <option>Bagmati Province</option>
                          <option>Gandaki Province</option>
                          <option>Koshi Province</option>
                          <option>Lumbini Province</option>
                          <option>Madhesh Province</option>
                        </select>
                      </div>

                      <div>
                        <label className="block text-[10px] font-bold text-slate-700 mb-0.5">City / Town</label>
                        <input
                          type="text"
                          value={regBizCity}
                          onChange={(e) => setRegBizCity(e.target.value)}
                          className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs bg-white"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-slate-700 mb-0.5">
                        PAN / Ward Registration (वार्ड वा प्यान दर्ता)
                      </label>
                      <input
                        type="text"
                        placeholder="उदा: 601928374"
                        value={regBizPan}
                        onChange={(e) => setRegBizPan(e.target.value)}
                        className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-mono bg-white"
                      />
                    </div>

                    <div className="flex gap-2 pt-2">
                      <button
                        type="button"
                        onClick={() => setRegisterStep('category')}
                        className="w-1/3 py-2.5 bg-slate-100 text-slate-700 rounded-xl text-xs font-bold"
                      >
                        Back
                      </button>
                      <button
                        type="submit"
                        className="w-2/3 py-2.5 bg-[#0F3D3E] hover:bg-[#165B5E] text-white rounded-xl text-xs font-bold shadow-sm"
                      >
                        Submit Application
                      </button>
                    </div>
                  </form>
                )}
              </div>

              <div className="text-center pt-3 border-t border-slate-200">
                <div className="text-[10px] font-bold text-[#0F3D3E]">Powered by रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि</div>
                <div className="text-[8px] text-slate-400">Easy App · All rights reserved</div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* MODAL: POST NEWS / NOTICE FORM (Inserts status: 'pending' only) */}
          {/* ========================================================================= */}
          {isPostingNews && (
            <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4 animate-fadeIn">
              <div className="bg-white rounded-3xl p-5 max-w-xs w-full shadow-2xl border border-slate-200 space-y-3">
                <div className="flex items-center justify-between border-b border-slate-100 pb-2">
                  <div className="flex items-center gap-1.5">
                    <FileText className="w-4 h-4 text-[#0F3D3E]" />
                    <h4 className="text-xs font-bold text-slate-900">Post News / Notice</h4>
                  </div>
                  <button onClick={() => setIsPostingNews(false)}>
                    <X className="w-4 h-4 text-slate-400" />
                  </button>
                </div>

                <div className="p-2 rounded-xl bg-amber-50 border border-amber-200 text-[10px] text-amber-900 font-medium">
                  Notice: Submissions enter <strong>Pending</strong> state and are verified by administrators before going live.
                </div>

                <div className="space-y-2 text-xs">
                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Category</label>
                    <select
                      value={newsCategory}
                      onChange={(e) => setNewsCategory(e.target.value as any)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white"
                    >
                      <option value="news">Live TV News (समाचार)</option>
                      <option value="market_rate">Market Rate (दैनिक दररेट)</option>
                      <option value="notice">Public Notice (सूचना)</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Headline (English)</label>
                    <input
                      type="text"
                      placeholder="e.g. Kathmandu organic market notice"
                      value={newsHeadline}
                      onChange={(e) => setNewsHeadline(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Headline (नेपालीमा)</label>
                    <input
                      type="text"
                      placeholder="उदा: काठमाडौँ कृषि हाटबजार सम्बन्धी सूचना"
                      value={newsHeadlineNp}
                      onChange={(e) => setNewsHeadlineNp(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Phone Number</label>
                    <input
                      type="tel"
                      placeholder="+977 98XXXXXXXX"
                      value={newsPhone}
                      onChange={(e) => setNewsPhone(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs font-mono"
                    />
                  </div>

                  <button
                    onClick={() => {
                      if (!newsHeadline) return;
                      const newItem = {
                        id: `t_${Date.now()}`,
                        category: newsCategory,
                        rateItem: newsCategory === 'market_rate' ? 'Market Rate' : 'Bulletin',
                        rateValue: 'NEW',
                        message: newsHeadline,
                        messageNp: newsHeadlineNp || newsHeadline,
                        status: 'pending', // Strictly 'pending' only
                      };
                      setTickerItems([newItem, ...tickerItems]);
                      setIsPostingNews(false);
                      setNewsHeadline('');
                      setNewsHeadlineNp('');
                      setNewsPhone('');
                      setSubmissionNotice('समाचार / सूचना दर्ता भयो (Status: Pending) - सुपर एडमिन स्वीकृतिको पर्खाइमा छ!');
                      setTimeout(() => setSubmissionNotice(null), 5000);
                    }}
                    className="w-full mt-2 py-2 bg-[#0F3D3E] text-white rounded-xl text-xs font-bold shadow-xs hover:bg-[#165B5E]"
                  >
                    Submit for Review (Status: Pending)
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* MODAL: POST AD FORM (Inserts status: 'pending' only) */}
          {/* ========================================================================= */}
          {isPostingAd && (
            <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4 animate-fadeIn">
              <div className="bg-white rounded-3xl p-5 max-w-xs w-full shadow-2xl border border-slate-200 space-y-3">
                <div className="flex items-center justify-between border-b border-slate-100 pb-2">
                  <div className="flex items-center gap-1.5">
                    <Tv className="w-4 h-4 text-[#C79A3E]" />
                    <h4 className="text-xs font-bold text-slate-900">Post Advertisement (विज्ञापन)</h4>
                  </div>
                  <button onClick={() => setIsPostingAd(false)}>
                    <X className="w-4 h-4 text-slate-400" />
                  </button>
                </div>

                <div className="p-2 rounded-xl bg-amber-50 border border-amber-200 text-[10px] text-amber-900 font-medium">
                  Notice: Banner will be displayed on the Home Slider once approved (Status: Pending).
                </div>

                <div className="space-y-2 text-xs">
                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Campaign Title</label>
                    <input
                      type="text"
                      placeholder="e.g. Nepal Agro Trade Festival"
                      value={adTitle}
                      onChange={(e) => setAdTitle(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Title in Nepali</label>
                    <input
                      type="text"
                      placeholder="उदा: नेपाल कृषि मेला २०२६"
                      value={adTitleNp}
                      onChange={(e) => setAdTitleNp(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs"
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Sponsor / Business Name</label>
                    <input
                      type="text"
                      placeholder="e.g. Himalayan Natural Products"
                      value={adSponsor}
                      onChange={(e) => setAdSponsor(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Banner Image URL</label>
                    <input
                      type="url"
                      value={adImageUrl}
                      onChange={(e) => setAdImageUrl(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs font-mono"
                    />
                  </div>

                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Contact Phone</label>
                    <input
                      type="tel"
                      placeholder="+977 98XXXXXXXX"
                      value={adPhone}
                      onChange={(e) => setAdPhone(e.target.value)}
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs font-mono"
                    />
                  </div>

                  <button
                    onClick={() => {
                      if (!adTitle || !adSponsor) return;
                      const newAd = {
                        id: `ad_${Date.now()}`,
                        title: adTitle,
                        titleNp: adTitleNp || adTitle,
                        imageUrl: adImageUrl,
                        sponsorName: adSponsor,
                        placement: 'home',
                        status: 'pending', // Strictly 'pending' only
                      };
                      setAdsList([newAd, ...adsList]);
                      setIsPostingAd(false);
                      setAdTitle('');
                      setAdTitleNp('');
                      setAdSponsor('');
                      setAdPhone('');
                      setSubmissionNotice('विज्ञापन पेश भयो (Status: Pending) - रिपब्लिक नेपाल टिभी डेस्कले प्रमाणीकरण गरेपछि प्रसारण हुनेछ!');
                      setTimeout(() => setSubmissionNotice(null), 5000);
                    }}
                    className="w-full mt-2 py-2 bg-[#C79A3E] text-slate-950 rounded-xl text-xs font-bold shadow-xs hover:bg-[#d8a846]"
                  >
                    Submit Ad for Moderation (Status: Pending)
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* ACTION MODAL: ELECTRICITY UTILITY BILL INQUIRY */}
          {/* ========================================================================= */}
          {activeActionModal && (
            <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4 animate-fadeIn">
              <div className="bg-white rounded-3xl p-5 max-w-xs w-full shadow-2xl border border-slate-200 space-y-3">
                <div className="flex items-center justify-between border-b border-slate-100 pb-2">
                  <h4 className="text-xs font-bold text-slate-900 capitalize">
                    NEA Electricity Bill Inquiry
                  </h4>
                  <button onClick={() => setActiveActionModal(null)}>
                    <X className="w-4 h-4 text-slate-400" />
                  </button>
                </div>

                <div className="space-y-2 text-xs">
                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">NEA Counter</label>
                    <select className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white">
                      <option>Kathmandu Central (Ratnapark)</option>
                      <option>Baneshwor Counter</option>
                      <option>Pokhara Counter</option>
                      <option>Lalitpur (Patan)</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-[10px] font-bold text-slate-700 mb-0.5">Consumer ID</label>
                    <input
                      type="text"
                      placeholder="012.34.567"
                      className="w-full p-2 rounded-xl border border-slate-200 text-xs font-mono"
                    />
                  </div>
                  <button
                    onClick={() => setActiveActionModal(null)}
                    className="w-full mt-2 py-2 bg-[#0F3D3E] text-white rounded-xl text-xs font-bold"
                  >
                    Inquire Due Amount
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
