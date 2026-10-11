import React, { useState } from 'react';
import {
  Smartphone,
  Layers,
  Database,
  Code2,
  BookOpen,
  Tv,
  ShoppingBag,
  Sparkles,
  ShieldCheck,
  CheckCircle2,
  ExternalLink,
  Building2,
  Sliders,
  RefreshCw,
} from 'lucide-react';
import { MobileSimulator, AppRoleType } from './components/MobileSimulator';
import { WebAdminPanel, BusinessItem, CategoryItem } from './components/WebAdminPanel';
import { ArchitectureExplorer } from './components/ArchitectureExplorer';
import { SupabaseRLSExplorer } from './components/SupabaseRLSExplorer';
import { CodeViewer } from './components/CodeViewer';
import { SetupGuide } from './components/SetupGuide';
import { ApkBuildStation } from './components/ApkBuildStation';

export default function App() {
  const [activeTab, setActiveTab] = useState<'simulator' | 'admin' | 'apk' | 'architecture' | 'rls' | 'code' | 'guide'>('simulator');
  const [currentRole, setCurrentRole] = useState<AppRoleType>('customer');

  // Shared Dynamic State (Simulating Supabase public.system_settings table)
  const [dynamicAppTitle, setDynamicAppTitle] = useState('Easy App');

  // Shared Registered Businesses (Simulating Supabase public.businesses table)
  const [businesses, setBusinesses] = useState<BusinessItem[]>([
    {
      id: 'biz_01',
      name: 'Siddhartha Health Clinic & Pharmacy',
      ownerName: 'Dr. Ramesh Karki',
      phone: '9851029384',
      category: 'Clinic (Health)',
      categorySlug: 'health',
      province: 'Bagmati Province',
      city: 'Kathmandu',
      status: 'pending',
      appliedDate: 'Today, 09:15 AM',
      panNumber: '601928374',
      address: 'New Baneshwor, Kathmandu',
      description: 'OPD Doctor consultations, pathology laboratory tests, and 24/7 emergency pharmacy.',
    },
    {
      id: 'biz_02',
      name: 'Annapurna Kirana & Organic Mart',
      ownerName: 'Pasang Sherpa',
      phone: '9841234567',
      category: 'Kirana/Retail (Food)',
      categorySlug: 'food_stay',
      province: 'Gandaki Province',
      city: 'Pokhara',
      status: 'approved',
      appliedDate: 'Yesterday, 02:40 PM',
      panNumber: '602819231',
      address: 'Lakeside-6, Pokhara',
      description: 'Organic grains, Himalayan honey, Jumla apples, and local daily groceries.',
    },
    {
      id: 'biz_03',
      name: 'Everest Tech & Refurbished Mobile',
      ownerName: 'Bikash Tamang',
      phone: '9801239876',
      category: 'Reuse/Recycle',
      categorySlug: 'reuse_recycle',
      province: 'Bagmati Province',
      city: 'Lalitpur',
      status: 'rejected',
      rejectionReason: 'PAN registration document scan was illegible; please upload clear PDF copy from Inland Revenue Department.',
      appliedDate: '2 days ago',
      panNumber: '603847291',
      address: 'Pulchowk, Lalitpur',
      description: 'Certified pre-owned smartphones, laptop refurbishment, and electronics circular recycling.',
    },
    {
      id: 'biz_04',
      name: 'Himalayan Herbal Cosmetics',
      ownerName: 'Radha Shrestha',
      phone: '9812345678',
      category: 'Cosmetics',
      categorySlug: 'retail',
      province: 'Bagmati Province',
      city: 'Bhaktapur',
      status: 'suspended',
      rejectionReason: 'Annual cosmetic manufacturing license renewal pending with Department of Drug Administration.',
      appliedDate: 'Last week',
      panNumber: '604819382',
      address: 'Suryabinayak, Bhaktapur',
      description: 'Organic skincare, herbal oils, and natural Himalayan beauty products.',
    },
  ]);

  // Shared Dynamic Categories / Modules (Simulating Supabase public.categories table)
  const [categories, setCategories] = useState<CategoryItem[]>([
    {
      id: 'cat_clinic',
      name: 'Clinic (Health)',
      nameNp: 'क्लिनिक तथा स्वास्थ्य सेवा',
      segment: 'HEALTH',
      active: true,
      description: 'Doctor appointments, OPD tokens & clinic listings',
    },
    {
      id: 'cat_kirana',
      name: 'Kirana/Retail (Food)',
      nameNp: 'किराना तथा दैनिक खाद्यान्न',
      segment: 'FOOD',
      active: true,
      description: 'Daily food essentials, fresh vegetables & kirana delivery',
    },
    {
      id: 'cat_clothing',
      name: 'Clothing',
      nameNp: 'कपडा तथा फेसन',
      segment: 'CLOTHING',
      active: true,
      description: 'Traditional wear, Dhaka topi & modern garments',
    },
    {
      id: 'cat_cosmetics',
      name: 'Cosmetics',
      nameNp: 'कस्मेटिक्स तथा सौन्दर्य',
      segment: 'COSMETICS',
      active: true,
      description: 'Beauty products, herbal skincare & personal care',
    },
    {
      id: 'cat_realestate',
      name: 'Real Estate (Buy & Sell)',
      nameNp: 'घरजग्गा तथा खरिदबिक्री',
      segment: 'REALESTATE',
      active: true,
      description: 'Properties, house rental, land plots in Nepal',
    },
    {
      id: 'cat_recycle',
      name: 'Reuse/Recycle',
      nameNp: 'पुनःप्रयोग तथा कवाडी',
      segment: 'RECYCLE',
      active: true,
      description: 'Pre-owned goods, electronics e-waste & circular recycling',
    },
    {
      id: 'cat_localmarket',
      name: 'Local Market',
      nameNp: 'स्थानीय हाटबजार',
      segment: 'LOCAL_MARKET',
      active: true,
      description: 'Neighborhood market, seasonal crafts & local artisans',
    },
    {
      id: 'cat_electricity',
      name: 'Electricity & Utilities',
      nameNp: 'बिजुली तथा खानेपानी महसुल',
      segment: 'UTILITIES',
      active: true,
      description: 'NEA electricity bill payment & Khanepani counters',
    },
    {
      id: 'cat_tv',
      name: 'Republic Nepal TV Live',
      nameNp: 'टिभी प्रत्यक्ष प्रसारण तथा विज्ञापन',
      segment: 'MEDIA',
      active: true,
      description: '24/7 Live satellite stream and sponsored video ads',
    },
  ]);

  // Business Approval Actions
  const handleApproveBusiness = (id: string) => {
    setBusinesses((prev) =>
      prev.map((b) => (b.id === id ? { ...b, status: 'approved' as const, rejectionReason: undefined } : b))
    );
  };

  const handleRejectBusiness = (id: string, reason: string) => {
    setBusinesses((prev) =>
      prev.map((b) => (b.id === id ? { ...b, status: 'rejected' as const, rejectionReason: reason } : b))
    );
  };

  const handleSuspendBusiness = (id: string) => {
    setBusinesses((prev) =>
      prev.map((b) => (b.id === id ? { ...b, status: 'suspended' as const } : b))
    );
  };

  const handleRegisterBusiness = (newBizData: {
    name: string;
    ownerName: string;
    phone: string;
    category: string;
    categorySlug: string;
    province: string;
    city: string;
    panNumber: string;
    address?: string;
  }) => {
    const newBiz: BusinessItem = {
      ...newBizData,
      id: `biz_${Date.now()}`,
      status: 'pending',
      appliedDate: 'Just now',
    };
    setBusinesses([newBiz, ...businesses]);
  };

  const handleUpdateBusiness = (updatedBiz: BusinessItem) => {
    setBusinesses((prev) => prev.map((b) => (b.id === updatedBiz.id ? updatedBiz : b)));
  };

  // Dynamic Module Toggling (No App Re-Release Needed)
  const handleToggleCategory = (id: string) => {
    setCategories((prev) =>
      prev.map((c) => (c.id === id ? { ...c, active: !c.active } : c))
    );
  };

  const handleAddCategory = (name: string, nameNp: string, segment: string) => {
    const newCat: CategoryItem = {
      id: `cat_${Date.now()}`,
      name,
      nameNp,
      segment,
      active: true,
    };
    setCategories([...categories, newCat]);
  };

  const pendingCount = businesses.filter((b) => b.status === 'pending').length;

  return (
    <div className="min-h-screen bg-[#F7F9FA] text-[#0F172A] flex flex-col">
      {/* Top Navigation Header */}
      <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-slate-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            {/* Brand Logo & Title */}
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-[#0F3D3E] flex items-center justify-center shadow-md shadow-[#0F3D3E]/20">
                <Tv className="w-5 h-5 text-[#C79A3E]" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <span className="font-black text-sm tracking-tight text-slate-900">
                    {dynamicAppTitle.toUpperCase()}
                  </span>
                  <span className="px-2 py-0.5 rounded-full bg-[#0F3D3E]/10 text-[#0F3D3E] text-[10px] font-extrabold uppercase tracking-wide">
                    Republic Nepal TV
                  </span>
                </div>
                <div className="text-[11px] text-slate-500 font-medium truncate max-w-xs sm:max-w-none">
                  Republic Nepal TV &amp; Advertising Pvt. Ltd. · Flutter &amp; Supabase RLS
                </div>
              </div>
            </div>

            {/* Navigation Tabs */}
            <nav className="hidden lg:flex items-center gap-1 bg-slate-100 p-1 rounded-2xl">
              <button
                onClick={() => setActiveTab('simulator')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'simulator'
                    ? 'bg-white text-[#0F3D3E] shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <Smartphone className="w-3.5 h-3.5 text-[#C79A3E]" /> Mobile App (Unified)
              </button>

              <button
                onClick={() => setActiveTab('admin')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all relative ${
                  activeTab === 'admin'
                    ? 'bg-white text-[#0F3D3E] shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <Sliders className="w-3.5 h-3.5 text-[#C79A3E]" /> Web Admin Panel
                {pendingCount > 0 && (
                  <span className="bg-amber-500 text-white text-[9px] font-black px-1.5 py-0.2 rounded-full">
                    {pendingCount}
                  </span>
                )}
              </button>

              <button
                onClick={() => setActiveTab('apk')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'apk'
                    ? 'bg-[#C79A3E] text-slate-950 shadow-sm font-black'
                    : 'text-slate-700 hover:text-slate-950 font-bold bg-amber-50/70 border border-amber-200/60'
                }`}
              >
                <span>⚡ Build APK (कोडम्याजिक)</span>
              </button>

              <button
                onClick={() => setActiveTab('architecture')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'architecture'
                    ? 'bg-white text-[#0F3D3E] shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <Layers className="w-3.5 h-3.5 text-[#C79A3E]" /> Architecture
              </button>

              <button
                onClick={() => setActiveTab('rls')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'rls'
                    ? 'bg-white text-[#0F3D3E] shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <Database className="w-3.5 h-3.5 text-[#C79A3E]" /> Supabase RLS
              </button>

              <button
                onClick={() => setActiveTab('code')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'code'
                    ? 'bg-white text-[#0F3D3E] shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <Code2 className="w-3.5 h-3.5 text-[#C79A3E]" /> Flutter Code (27 Files)
              </button>

              <button
                onClick={() => setActiveTab('guide')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                  activeTab === 'guide'
                    ? 'bg-white text-[#0F3D3E] shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <BookOpen className="w-3.5 h-3.5 text-[#C79A3E]" /> Setup Guide
              </button>
            </nav>

            {/* Status Pill & Live Sync Indicator */}
            <div className="flex items-center gap-2">
              <span className="hidden sm:inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-800 text-[11px] font-bold border border-emerald-200">
                <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" /> Multi-Tenant Ready
              </span>
            </div>
          </div>

          {/* Mobile / Compact Tab Selector */}
          <div className="lg:hidden flex items-center gap-1 overflow-x-auto py-2 border-t border-slate-100">
            <button
              onClick={() => setActiveTab('simulator')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap ${
                activeTab === 'simulator' ? 'bg-[#0F3D3E] text-white' : 'bg-slate-100 text-slate-700'
              }`}
            >
              📱 Mobile App
            </button>
            <button
              onClick={() => setActiveTab('admin')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap flex items-center gap-1 ${
                activeTab === 'admin' ? 'bg-[#0F3D3E] text-white' : 'bg-slate-100 text-slate-700'
              }`}
            >
              🖥️ Admin Panel {pendingCount > 0 && `(${pendingCount})`}
            </button>
            <button
              onClick={() => setActiveTab('apk')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap ${
                activeTab === 'apk' ? 'bg-[#C79A3E] text-slate-950 font-black' : 'bg-amber-100 text-amber-900 font-bold'
              }`}
            >
              ⚡ Build APK
            </button>
            <button
              onClick={() => setActiveTab('architecture')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap ${
                activeTab === 'architecture' ? 'bg-[#0F3D3E] text-white' : 'bg-slate-100 text-slate-700'
              }`}
            >
              Architecture
            </button>
            <button
              onClick={() => setActiveTab('rls')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap ${
                activeTab === 'rls' ? 'bg-[#0F3D3E] text-white' : 'bg-slate-100 text-slate-700'
              }`}
            >
              Supabase RLS
            </button>
            <button
              onClick={() => setActiveTab('code')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap ${
                activeTab === 'code' ? 'bg-[#0F3D3E] text-white' : 'bg-slate-100 text-slate-700'
              }`}
            >
              Code (27)
            </button>
            <button
              onClick={() => setActiveTab('guide')}
              className={`px-3 py-1 rounded-lg text-xs font-bold whitespace-nowrap ${
                activeTab === 'guide' ? 'bg-[#0F3D3E] text-white' : 'bg-slate-100 text-slate-700'
              }`}
            >
              Guide
            </button>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6">
        {activeTab === 'simulator' && (
          <MobileSimulator
            currentRole={currentRole}
            onRoleChange={setCurrentRole}
            dynamicAppTitle={dynamicAppTitle}
            businesses={businesses}
            onRegisterBusiness={handleRegisterBusiness}
            onUpdateBusiness={handleUpdateBusiness}
            categories={categories}
            onToggleCategory={handleToggleCategory}
            onUpdateAppTitle={setDynamicAppTitle}
            onOpenAdminPanel={() => setActiveTab('admin')}
            onOpenApkStation={() => setActiveTab('apk')}
          />
        )}

        {activeTab === 'admin' && (
          <WebAdminPanel
            businesses={businesses}
            onApproveBusiness={handleApproveBusiness}
            onRejectBusiness={handleRejectBusiness}
            onSuspendBusiness={handleSuspendBusiness}
            dynamicAppTitle={dynamicAppTitle}
            onUpdateAppTitle={setDynamicAppTitle}
            categories={categories}
            onToggleCategory={handleToggleCategory}
            onAddCategory={handleAddCategory}
            onSwitchToMobile={() => setActiveTab('simulator')}
          />
        )}

        {activeTab === 'apk' && <ApkBuildStation dynamicAppTitle={dynamicAppTitle} />}

        {activeTab === 'architecture' && <ArchitectureExplorer />}
        {activeTab === 'rls' && <SupabaseRLSExplorer />}
        {activeTab === 'code' && <CodeViewer />}
        {activeTab === 'guide' && <SetupGuide />}
      </main>

      {/* Permanent Footer Branding */}
      <footer className="bg-white border-t border-slate-200 py-6 text-center text-xs text-slate-500">
        <div className="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-3">
          <div className="flex flex-col sm:flex-row items-center gap-1 sm:gap-2">
            <span className="font-bold text-slate-700">{dynamicAppTitle} Enterprise Platform</span>
            <span className="hidden sm:inline">·</span>
            <span>Clean Architecture · Dynamic Super Admin · No App Re-Release</span>
          </div>
          <div className="text-[11px] text-slate-500">
            Powered by <strong className="text-[#0F3D3E]">Republic Nepal TV &amp; Advertising Pvt. Ltd.</strong>
          </div>
        </div>
      </footer>
    </div>
  );
}
