import React, { useState } from 'react';
import {
  LayoutDashboard,
  Users,
  Building2,
  CheckCircle2,
  GitBranch,
  Grid,
  Package,
  Wrench,
  ShoppingBag,
  Calendar,
  CreditCard,
  Tv,
  Star,
  FileText,
  Bell,
  HelpCircle,
  ShieldAlert,
  History,
  BarChart3,
  Flag,
  Settings,
  Search,
  Filter,
  Check,
  X,
  AlertTriangle,
  UserCheck,
  UserX,
  ArrowRightLeft,
  Sparkles,
  Lock,
  Globe,
  MapPin,
  Phone,
  Tag,
  Clock,
  Send,
  Eye,
  Plus,
  RefreshCw,
  ExternalLink,
  Sliders,
  DollarSign,
  TrendingUp,
  Percent,
  CheckSquare,
  AlertCircle,
  FileSpreadsheet,
  Download,
} from 'lucide-react';

export interface BusinessItem {
  id: string;
  name: string;
  ownerName: string;
  phone: string;
  category: string;
  categorySlug: string;
  province: string;
  city: string;
  status: 'pending' | 'approved' | 'rejected' | 'suspended';
  rejectionReason?: string;
  appliedDate: string;
  panNumber: string;
  address?: string;
  description?: string;
}

export interface StaffItem {
  id: string;
  name: string;
  email: string;
  role: string;
  status: 'active' | 'suspended';
  territoryScope: string;
  categoryScope: string;
  canApproveMerchants: boolean;
  canModerateUsers: boolean;
  canManageModules: boolean;
  canViewAuditLogs: boolean;
  assignedTasksCount: number;
}

export interface AuditLogItem {
  id: string;
  timestamp: string;
  actor: string;
  role: string;
  action: string;
  target: string;
  details: string;
}

export interface CategoryItem {
  id: string;
  name: string;
  nameNp: string;
  segment: string;
  active: boolean;
  description?: string;
}

interface WebAdminPanelProps {
  businesses: BusinessItem[];
  onApproveBusiness: (id: string) => void;
  onRejectBusiness: (id: string, reason: string) => void;
  onSuspendBusiness?: (id: string) => void;
  dynamicAppTitle: string;
  onUpdateAppTitle: (title: string) => void;
  categories: CategoryItem[];
  onToggleCategory: (id: string) => void;
  onAddCategory?: (name: string, nameNp: string, segment: string) => void;
  onSwitchToMobile?: () => void;
}

export const WebAdminPanel: React.FC<WebAdminPanelProps> = ({
  businesses,
  onApproveBusiness,
  onRejectBusiness,
  onSuspendBusiness,
  dynamicAppTitle,
  onUpdateAppTitle,
  categories,
  onToggleCategory,
  onAddCategory,
  onSwitchToMobile,
}) => {
  const [activeSection, setActiveSection] = useState<string>('approve_businesses');
  const [approvalTab, setApprovalTab] = useState<'pending' | 'approved'>('pending');
  const [rejectModalId, setRejectModalId] = useState<string | null>(null);
  const [rejectReason, setRejectReason] = useState('Missing official PAN registration document or invalid ward permit');
  const [appTitleInput, setAppTitleInput] = useState(dynamicAppTitle);

  // Search and filter states
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCityFilter, setSelectedCityFilter] = useState('all');

  // New Category Modal
  const [showAddCatModal, setShowAddCatModal] = useState(false);
  const [newCatName, setNewCatName] = useState('');
  const [newCatNameNp, setNewCatNameNp] = useState('');
  const [newCatSegment, setNewCatSegment] = useState('RETAIL');

  // Staff members state
  const [staffList, setStaffList] = useState<StaffItem[]>([
    {
      id: 'st_1',
      name: 'Sunita Dahal (सुनिता दाहाल)',
      email: 'sunita.staff@republicnepal.tv',
      role: 'staff',
      status: 'active',
      territoryScope: 'Kathmandu Valley',
      categoryScope: 'Health & Clinics',
      canApproveMerchants: true,
      canModerateUsers: false,
      canManageModules: false,
      canViewAuditLogs: true,
      assignedTasksCount: 8,
    },
    {
      id: 'st_2',
      name: 'Bikram Thapa (बिक्रम थापा)',
      email: 'bikram.staff@republicnepal.tv',
      role: 'branchManager',
      status: 'active',
      territoryScope: 'Gandaki Province (Pokhara)',
      categoryScope: 'Food & Kirana Retail',
      canApproveMerchants: true,
      canModerateUsers: true,
      canManageModules: false,
      canViewAuditLogs: true,
      assignedTasksCount: 14,
    },
    {
      id: 'st_3',
      name: 'Pooja Karki (पूजा कार्की)',
      email: 'pooja.support@republicnepal.tv',
      role: 'supportAdmin',
      status: 'active',
      territoryScope: 'All Provinces',
      categoryScope: 'All Categories',
      canApproveMerchants: false,
      canModerateUsers: true,
      canManageModules: false,
      canViewAuditLogs: true,
      assignedTasksCount: 5,
    },
  ]);

  // Handover modal state
  const [handoverOutgoingId, setHandoverOutgoingId] = useState<string | null>(null);
  const [handoverIncomingId, setHandoverIncomingId] = useState<string>('st_2');
  const [handoverNotes, setHandoverNotes] = useState('Staff relocation to Pokhara branch; transferring all pending merchant verifications.');

  // Audit Logs state
  const [auditLogs, setAuditLogs] = useState<AuditLogItem[]>([
    {
      id: 'log_01',
      timestamp: 'Today, 10:15 AM',
      actor: 'Super Admin (Bishal Thapa)',
      role: 'superAdmin',
      action: 'MERCHANT_APPROVED',
      target: 'Annapurna Kirana & Organic Mart',
      details: 'Verified PAN 601928374 in Gandaki Province',
    },
    {
      id: 'log_02',
      timestamp: 'Today, 09:40 AM',
      actor: 'Sunita Dahal',
      role: 'staff',
      action: 'CATEGORY_TOGGLED',
      target: 'Clinic (Health)',
      details: 'Enabled dynamic doctor appointment & OPD booking segment',
    },
    {
      id: 'log_03',
      timestamp: 'Today, 08:30 AM',
      actor: 'Super Admin (Bishal Thapa)',
      role: 'superAdmin',
      action: 'CONFIG_UPDATED',
      target: 'public.system_settings',
      details: 'Dynamic App Title updated to Easy App without re-release',
    },
    {
      id: 'log_04',
      timestamp: 'Yesterday, 05:12 PM',
      actor: 'Bikram Thapa',
      role: 'branchManager',
      action: 'MERCHANT_REJECTED',
      target: 'Everest Tech & Refurbished Mobile',
      details: 'PAN document scan was illegible; requested updated PDF',
    },
  ]);

  // Handle Offboarding Handover
  const executeHandover = () => {
    if (!handoverOutgoingId) return;

    const outgoing = staffList.find((s) => s.id === handoverOutgoingId);
    const incoming = staffList.find((s) => s.id === handoverIncomingId);
    if (!outgoing || !incoming) return;

    setStaffList((prev) =>
      prev.map((s) => {
        if (s.id === outgoing.id) {
          return { ...s, status: 'suspended', assignedTasksCount: 0 };
        }
        if (s.id === incoming.id) {
          return { ...s, assignedTasksCount: s.assignedTasksCount + outgoing.assignedTasksCount };
        }
        return s;
      })
    );

    const newLog: AuditLogItem = {
      id: `log_${Date.now()}`,
      timestamp: 'Just now',
      actor: 'Super Admin',
      role: 'superAdmin',
      action: 'STAFF_HANDOVER_OFFBOARD',
      target: `${outgoing.name} -> ${incoming.name}`,
      details: `Reassigned ${outgoing.assignedTasksCount} tasks. Reason: ${handoverNotes}`,
    };

    setAuditLogs([newLog, ...auditLogs]);
    setHandoverOutgoingId(null);
  };

  const pendingBusinesses = businesses.filter((b) => b.status === 'pending');
  const approvedBusinesses = businesses.filter((b) => b.status === 'approved');

  const menuSections = [
    { id: 'dashboard', label: 'Executive Dashboard', icon: LayoutDashboard },
    { id: 'approve_businesses', label: 'Approve Businesses', icon: CheckCircle2, count: pendingBusinesses.length },
    { id: 'businesses', label: 'All Businesses', icon: Building2, count: businesses.length },
    { id: 'users', label: 'Users & Roles (RBAC)', icon: Users },
    { id: 'staff_control', label: 'Staff & Handover', icon: ArrowRightLeft },
    { id: 'branches', label: 'Branches (Provinces)', icon: GitBranch },
    { id: 'categories', label: 'Categories & Modules', icon: Grid, count: categories.filter((c) => c.active).length },
    { id: 'products', label: 'Products Catalog', icon: Package },
    { id: 'services', label: 'Services & Clinics', icon: Wrench },
    { id: 'orders', label: 'Orders (Kirana/Retail)', icon: ShoppingBag },
    { id: 'bookings', label: 'Bookings & Appointments', icon: Calendar },
    { id: 'subscriptions', label: 'Merchant Subscriptions', icon: CreditCard },
    { id: 'payments', label: 'Payments & Settlements', icon: DollarSign },
    { id: 'advertisements', label: 'Republic TV Ads Engine', icon: Tv },
    { id: 'reviews', label: 'Reviews & Ratings', icon: Star },
    { id: 'content', label: 'Content & Live Media', icon: FileText },
    { id: 'notifications', label: 'Push Notifications', icon: Bell },
    { id: 'support', label: 'Support & Disputes', icon: HelpCircle },
    { id: 'security', label: 'Security & Supabase RLS', icon: ShieldAlert },
    { id: 'audit_logs', label: 'Audit Logs', icon: History },
    { id: 'reports', label: 'Reports & Analytics', icon: BarChart3 },
    { id: 'feature_flags', label: 'Dynamic Feature Flags', icon: Flag },
    { id: 'system_settings', label: 'System Settings', icon: Settings },
  ];

  return (
    <div className="bg-white rounded-3xl border border-slate-200 overflow-hidden shadow-xl flex flex-col min-h-[820px]">
      {/* Enterprise Header Bar */}
      <div className="bg-[#0F3D3E] text-white px-6 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-[#0A2B2C]">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center border border-[#C79A3E]/40 shadow-inner">
            <Tv className="w-5 h-5 text-[#C79A3E]" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-black text-sm tracking-wide">
                REPUBLIC NEPAL TV &amp; ADVERTISING PVT. LTD.
              </span>
              <span className="bg-[#C79A3E] text-slate-950 text-[10px] font-extrabold px-2 py-0.5 rounded-full uppercase tracking-wider">
                Super Admin Engine
              </span>
            </div>
            <div className="text-[11px] text-white/70">
              Multi-Tenant Architecture · Fine-Grained Permissions · Dynamic DB Config (No App Re-Release Required)
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3 text-xs">
          <div className="bg-white/10 px-3.5 py-1.5 rounded-xl border border-white/15 flex items-center gap-2 font-mono text-[11px]">
            <span className="text-[#E5B95C]">DB App Title:</span>
            <span className="font-bold text-white">{dynamicAppTitle}</span>
          </div>
          {onSwitchToMobile && (
            <button
              onClick={onSwitchToMobile}
              className="px-3 py-1.5 bg-[#C79A3E] hover:bg-[#d8a846] text-slate-950 font-bold rounded-xl text-xs transition-all flex items-center gap-1.5 shadow-sm"
            >
              <span>View in Mobile App</span>
              <ExternalLink className="w-3.5 h-3.5" />
            </button>
          )}
        </div>
      </div>

      {/* Main Split Layout: Sidebar & Content Area */}
      <div className="flex-1 grid grid-cols-1 md:grid-cols-12 min-h-[720px]">
        {/* Left Navigation Sidebar (23 Sections) */}
        <aside className="md:col-span-3 lg:col-span-3 bg-slate-50 border-r border-slate-200 p-3 overflow-y-auto max-h-[800px]">
          <div className="text-[10px] font-bold uppercase tracking-wider text-slate-400 px-3 py-1 mb-1">
            Core Modules &amp; Governance
          </div>
          <nav className="space-y-0.5">
            {menuSections.map((item) => {
              const IconComp = item.icon;
              const isSelected = activeSection === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => setActiveSection(item.id)}
                  className={`w-full flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold transition-all ${
                    isSelected
                      ? 'bg-[#0F3D3E] text-white shadow-sm font-bold'
                      : 'text-slate-600 hover:bg-slate-200/60 hover:text-slate-900'
                  }`}
                >
                  <div className="flex items-center gap-2.5 truncate">
                    <IconComp className={`w-4 h-4 shrink-0 ${isSelected ? 'text-[#C79A3E]' : 'text-slate-500'}`} />
                    <span className="truncate">{item.label}</span>
                  </div>
                  {item.count !== undefined && item.count > 0 && (
                    <span
                      className={`text-[10px] font-black px-1.5 py-0.2 rounded-full ${
                        item.id === 'approve_businesses'
                          ? 'bg-amber-500 text-white'
                          : isSelected
                          ? 'bg-white/20 text-white'
                          : 'bg-slate-200 text-slate-700'
                      }`}
                    >
                      {item.count}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        </aside>

        {/* Right Detail Pane */}
        <main className="md:col-span-9 lg:col-span-9 p-6 overflow-y-auto max-h-[800px] bg-slate-50/50">
          {/* SECTION: EXECUTIVE DASHBOARD */}
          {activeSection === 'dashboard' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-200">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <LayoutDashboard className="w-5 h-5 text-[#0F3D3E]" /> Super Admin Executive Dashboard
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Real-time multi-tenant monitoring across Nepal's 7 provinces and global diaspora transactions.
                  </p>
                </div>
                <div className="flex items-center gap-2">
                  <span className="text-[11px] font-bold px-2.5 py-1 bg-emerald-100 text-emerald-800 rounded-full flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full bg-emerald-600 animate-pulse" />
                    Supabase Live Sync Active
                  </span>
                </div>
              </div>

              {/* KPI Cards */}
              <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
                <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs">
                  <div className="text-[11px] text-slate-500 font-medium">Daily Platform GMV</div>
                  <div className="text-xl font-black text-[#0F3D3E] mt-1">रु. ४८,५०,०००</div>
                  <div className="text-[10px] text-emerald-600 font-bold mt-1 flex items-center gap-1">
                    <TrendingUp className="w-3 h-3" /> +14.2% vs last week
                  </div>
                </div>

                <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs">
                  <div className="text-[11px] text-slate-500 font-medium">Total Registered Businesses</div>
                  <div className="text-xl font-black text-slate-900 mt-1">{businesses.length} Merchants</div>
                  <div className="text-[10px] text-amber-600 font-bold mt-1">
                    {pendingBusinesses.length} awaiting approval
                  </div>
                </div>

                <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs">
                  <div className="text-[11px] text-slate-500 font-medium">Active Users (Nepal)</div>
                  <div className="text-xl font-black text-slate-900 mt-1">१,४२,८०० Users</div>
                  <div className="text-[10px] text-slate-500 font-medium mt-1">
                    Across 7 Provinces
                  </div>
                </div>

                <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs">
                  <div className="text-[11px] text-slate-500 font-medium">Republic TV Live Viewers</div>
                  <div className="text-xl font-black text-red-600 mt-1">३२,४५० Live</div>
                  <div className="text-[10px] text-red-600 font-bold mt-1 flex items-center gap-1">
                    <Tv className="w-3 h-3" /> Broadcast Active
                  </div>
                </div>
              </div>

              {/* Quick Action Banner */}
              <div className="bg-gradient-to-r from-[#0F3D3E] to-[#165B5E] text-white p-5 rounded-2xl flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                  <div className="font-black text-base">Pending Merchant Approvals Queue</div>
                  <p className="text-xs text-white/80 mt-1">
                    {pendingBusinesses.length} merchant applications are waiting for Super Admin or Scoped Staff verification.
                  </p>
                </div>
                <button
                  onClick={() => setActiveSection('approve_businesses')}
                  className="px-4 py-2 bg-[#C79A3E] text-slate-950 rounded-xl text-xs font-bold hover:bg-[#d8a846] transition-all shrink-0 flex items-center gap-1.5"
                >
                  <CheckCircle2 className="w-4 h-4" /> Go to Approvals Screen
                </button>
              </div>

              {/* Provincial Breakdown */}
              <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
                <h4 className="font-bold text-sm text-slate-900 mb-3">Merchant Distribution Across Nepal</h4>
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
                  <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                    <div className="text-slate-500 text-[10px]">Bagmati (Kathmandu/Lalitpur)</div>
                    <div className="text-base font-black text-[#0F3D3E] mt-0.5">६२% (१,८४०)</div>
                  </div>
                  <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                    <div className="text-slate-500 text-[10px]">Gandaki (Pokhara)</div>
                    <div className="text-base font-black text-[#0F3D3E] mt-0.5">१८% (५४०)</div>
                  </div>
                  <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                    <div className="text-slate-500 text-[10px]">Koshi (Biratnagar/Dharan)</div>
                    <div className="text-base font-black text-[#0F3D3E] mt-0.5">११% (३३०)</div>
                  </div>
                  <div className="p-3 rounded-xl bg-slate-50 border border-slate-100">
                    <div className="text-slate-500 text-[10px]">Lumbini &amp; Others</div>
                    <div className="text-base font-black text-[#0F3D3E] mt-0.5">९% (२७०)</div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* SECTION: APPROVE BUSINESSES WORKFLOW (Image 1) */}
          {activeSection === 'approve_businesses' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-200">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <CheckCircle2 className="w-5 h-5 text-[#0F3D3E]" /> Approve Businesses
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Review merchant applications submitted via "Register my business". Verify PAN documents and approve or reject.
                  </p>
                </div>

                {/* Tabs: Pending vs Approved */}
                <div className="flex items-center gap-1 bg-slate-200/70 p-1 rounded-xl self-start">
                  <button
                    onClick={() => setApprovalTab('pending')}
                    className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                      approvalTab === 'pending'
                        ? 'bg-[#0F3D3E] text-white shadow-xs'
                        : 'text-slate-600 hover:text-slate-900'
                    }`}
                  >
                    Pending ({pendingBusinesses.length})
                  </button>
                  <button
                    onClick={() => setApprovalTab('approved')}
                    className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
                      approvalTab === 'approved'
                        ? 'bg-[#0F3D3E] text-white shadow-xs'
                        : 'text-slate-600 hover:text-slate-900'
                    }`}
                  >
                    Approved ({approvedBusinesses.length})
                  </button>
                </div>
              </div>

              {/* Pending Tab Content */}
              {approvalTab === 'pending' && (
                <div className="space-y-4">
                  {pendingBusinesses.length === 0 ? (
                    <div className="p-12 text-center text-slate-400 bg-white rounded-2xl border border-slate-200">
                      <CheckCircle2 className="w-10 h-10 text-emerald-500 mx-auto mb-2 opacity-50" />
                      <div className="font-bold text-slate-700 text-sm">All pending applications processed!</div>
                      <p className="text-xs text-slate-400 mt-1">
                        New registrations submitted in the mobile app simulator will appear here immediately.
                      </p>
                    </div>
                  ) : (
                    pendingBusinesses.map((b) => (
                      <div
                        key={b.id}
                        className="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs hover:border-slate-300 transition-all flex flex-col md:flex-row md:items-center justify-between gap-4"
                      >
                        <div className="space-y-1.5">
                          <div className="flex items-center gap-2">
                            <span className="font-black text-base text-slate-900">{b.name}</span>
                            <span className="text-[10px] font-extrabold px-2 py-0.5 rounded-full bg-amber-100 text-amber-800">
                              WAITING FOR ADMIN APPROVAL
                            </span>
                          </div>
                          <div className="text-xs text-slate-600 flex flex-wrap items-center gap-x-4 gap-y-1">
                            <span>Owner: <strong>{b.ownerName}</strong></span>
                            <span>Phone: <strong className="font-mono text-[#0F3D3E]">{b.phone}</strong></span>
                            <span>Category: <strong className="text-[#C79A3E]">{b.category}</strong></span>
                            <span>Location: <strong>{b.city}, {b.province}</strong></span>
                            <span>PAN/VAT: <strong className="font-mono">{b.panNumber}</strong></span>
                          </div>
                          <div className="text-[11px] text-slate-400">
                            Applied: {b.appliedDate} · Verification Scope: Kathmandu HQ &amp; Regional Branch
                          </div>
                        </div>

                        <div className="flex items-center gap-2 shrink-0">
                          <button
                            onClick={() => onApproveBusiness(b.id)}
                            className="flex items-center gap-1.5 px-4 py-2 bg-[#0F3D3E] hover:bg-[#165B5E] text-white rounded-xl text-xs font-bold transition-all shadow-sm"
                          >
                            <Check className="w-3.5 h-3.5" /> Approve
                          </button>
                          <button
                            onClick={() => setRejectModalId(b.id)}
                            className="flex items-center gap-1.5 px-3.5 py-2 bg-red-50 hover:bg-red-100 text-red-700 border border-red-200 rounded-xl text-xs font-bold transition-all"
                          >
                            <X className="w-3.5 h-3.5" /> Reject
                          </button>
                        </div>
                      </div>
                    ))
                  )}
                </div>
              )}

              {/* Approved Tab Content */}
              {approvalTab === 'approved' && (
                <div className="space-y-3">
                  {approvedBusinesses.map((b) => (
                    <div
                      key={b.id}
                      className="bg-white rounded-2xl border border-slate-200 p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3"
                    >
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-sm text-slate-900">{b.name}</span>
                          <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                            ACTIVE MERCHANT ✓
                          </span>
                        </div>
                        <div className="text-xs text-slate-500 mt-1">
                          {b.category} · Phone: {b.phone} · Location: {b.city}, {b.province} · PAN: {b.panNumber}
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-emerald-700 font-bold bg-emerald-50 px-2.5 py-1 rounded-lg border border-emerald-200">
                          Live on Easy App
                        </span>
                        {onSuspendBusiness && (
                          <button
                            onClick={() => onSuspendBusiness(b.id)}
                            className="px-2.5 py-1 text-xs text-amber-800 bg-amber-50 hover:bg-amber-100 rounded-lg border border-amber-200 font-medium"
                          >
                            Suspend
                          </button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              )}

              {/* Rejection Modal */}
              {rejectModalId && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
                  <div className="bg-white rounded-3xl p-6 max-w-md w-full shadow-2xl border border-slate-200">
                    <h4 className="font-bold text-base text-slate-900">Reject Business Application</h4>
                    <p className="text-xs text-slate-500 mt-1">
                      Provide a clear explanation so the merchant can correct their information and resubmit.
                    </p>

                    <div className="mt-4">
                      <label className="block text-xs font-bold text-slate-700 mb-1">Rejection Reason</label>
                      <textarea
                        value={rejectReason}
                        onChange={(e) => setRejectReason(e.target.value)}
                        className="w-full p-3 rounded-xl border border-slate-200 text-xs focus:ring-2 focus:ring-[#0F3D3E]"
                        rows={3}
                      />
                    </div>

                    <div className="flex justify-end gap-2 mt-5">
                      <button
                        onClick={() => setRejectModalId(null)}
                        className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:bg-slate-100"
                      >
                        Cancel
                      </button>
                      <button
                        onClick={() => {
                          onRejectBusiness(rejectModalId, rejectReason);
                          setRejectModalId(null);
                        }}
                        className="px-4 py-2 bg-red-600 text-white rounded-xl text-xs font-bold hover:bg-red-700"
                      >
                        Confirm Rejection
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* SECTION: ALL BUSINESSES */}
          {activeSection === 'businesses' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-200">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <Building2 className="w-5 h-5 text-[#0F3D3E]" /> All Registered Businesses
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Complete merchant registry with statuses: Approved, Pending, Rejected, and Suspended.
                  </p>
                </div>
              </div>

              {/* Filters */}
              <div className="flex flex-wrap items-center gap-2">
                <input
                  type="text"
                  placeholder="Search by business name or phone..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="px-3 py-1.5 bg-white border border-slate-200 rounded-xl text-xs flex-1 min-w-[200px]"
                />
              </div>

              {/* Business Table */}
              <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden shadow-xs">
                <table className="w-full text-left text-xs">
                  <thead className="bg-slate-50 border-b border-slate-200 text-slate-500">
                    <tr>
                      <th className="p-3 font-bold">Business Name</th>
                      <th className="p-3 font-bold">Category</th>
                      <th className="p-3 font-bold">Owner / Contact</th>
                      <th className="p-3 font-bold">Location</th>
                      <th className="p-3 font-bold">Status</th>
                      <th className="p-3 font-bold text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {businesses
                      .filter(
                        (b) =>
                          b.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          b.phone.includes(searchQuery)
                      )
                      .map((b) => (
                        <tr key={b.id} className="hover:bg-slate-50/50">
                          <td className="p-3 font-bold text-slate-900">
                            {b.name}
                            <div className="text-[10px] text-slate-400 font-mono">PAN: {b.panNumber}</div>
                          </td>
                          <td className="p-3 text-slate-600">{b.category}</td>
                          <td className="p-3">
                            <div className="font-medium text-slate-800">{b.ownerName}</div>
                            <div className="text-[10px] text-slate-500 font-mono">{b.phone}</div>
                          </td>
                          <td className="p-3 text-slate-600">{b.city}, {b.province}</td>
                          <td className="p-3">
                            <span
                              className={`px-2 py-0.5 rounded-full text-[10px] font-black uppercase ${
                                b.status === 'approved'
                                  ? 'bg-emerald-100 text-emerald-800'
                                  : b.status === 'pending'
                                  ? 'bg-amber-100 text-amber-800'
                                  : b.status === 'rejected'
                                  ? 'bg-red-100 text-red-800'
                                  : 'bg-orange-100 text-orange-800'
                              }`}
                            >
                              {b.status}
                            </span>
                          </td>
                          <td className="p-3 text-right">
                            {b.status === 'pending' && (
                              <button
                                onClick={() => onApproveBusiness(b.id)}
                                className="px-2.5 py-1 bg-[#0F3D3E] text-white rounded-lg text-[10px] font-bold"
                              >
                                Approve
                              </button>
                            )}
                            {b.status === 'approved' && onSuspendBusiness && (
                              <button
                                onClick={() => onSuspendBusiness(b.id)}
                                className="px-2.5 py-1 bg-amber-50 text-amber-800 border border-amber-200 rounded-lg text-[10px] font-bold"
                              >
                                Suspend
                              </button>
                            )}
                          </td>
                        </tr>
                      ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* SECTION: USERS & ROLES */}
          {activeSection === 'users' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-200">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <Users className="w-5 h-5 text-[#0F3D3E]" /> Users &amp; Role-Based Access Control (RBAC)
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Managing profiles across four roles: superAdmin, businessOwner, staff, and customer.
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-white p-4 rounded-2xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-sm text-slate-900">Aarav Sharma</span>
                    <span className="text-[10px] font-bold bg-blue-100 text-blue-800 px-2 py-0.5 rounded-full">
                      CUSTOMER
                    </span>
                  </div>
                  <div className="text-xs text-slate-500 space-y-0.5">
                    <div>Email: aarav.sharma@nepal.np</div>
                    <div>Phone: +977 9841234567</div>
                    <div>Province: Bagmati (Kathmandu)</div>
                    <div>Status: <strong className="text-emerald-600">Active (KYC Verified)</strong></div>
                  </div>
                </div>

                <div className="bg-white p-4 rounded-2xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-sm text-slate-900">Pasang Sherpa</span>
                    <span className="text-[10px] font-bold bg-emerald-100 text-emerald-800 px-2 py-0.5 rounded-full">
                      BUSINESS OWNER
                    </span>
                  </div>
                  <div className="text-xs text-slate-500 space-y-0.5">
                    <div>Business: Himalayan Organic Mart</div>
                    <div>Phone: +977 9856012345</div>
                    <div>Province: Gandaki (Pokhara)</div>
                    <div>Status: <strong className="text-emerald-600">Active Merchant</strong></div>
                  </div>
                </div>

                <div className="bg-white p-4 rounded-2xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-sm text-slate-900">Sunita Dahal</span>
                    <span className="text-[10px] font-bold bg-purple-100 text-purple-800 px-2 py-0.5 rounded-full">
                      STAFF
                    </span>
                  </div>
                  <div className="text-xs text-slate-500 space-y-0.5">
                    <div>Email: sunita.staff@republicnepal.tv</div>
                    <div>Assigned Scope: Health &amp; Clinic Verification</div>
                    <div>Territory: Kathmandu Valley</div>
                    <div>Status: <strong className="text-emerald-600">Active Staff</strong></div>
                  </div>
                </div>

                <div className="bg-white p-4 rounded-2xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-sm text-slate-900">Bishal Thapa</span>
                    <span className="text-[10px] font-bold bg-amber-100 text-amber-800 px-2 py-0.5 rounded-full">
                      SUPER ADMIN
                    </span>
                  </div>
                  <div className="text-xs text-slate-500 space-y-0.5">
                    <div>Organization: Republic Nepal TV &amp; Advertising Pvt. Ltd.</div>
                    <div>Role: Lead Architect &amp; Super Admin</div>
                    <div>Access: Full Unrestricted Multi-Tenant Control</div>
                    <div>Status: <strong className="text-emerald-600">Root Active</strong></div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* SECTION: STAFF CONTROL & HANDOVER */}
          {activeSection === 'staff_control' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-200">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <ArrowRightLeft className="w-5 h-5 text-[#0F3D3E]" /> Staff Scopes &amp; Offboarding Handover
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Fine-grained territorial &amp; category permissions. Reassign pending audits &amp; tasks upon staff exit.
                  </p>
                </div>
              </div>

              {/* Staff Cards List */}
              <div className="space-y-4">
                {staffList.map((st) => (
                  <div
                    key={st.id}
                    className={`rounded-2xl border p-5 transition-all ${
                      st.status === 'suspended'
                        ? 'bg-slate-50 border-slate-200 opacity-60'
                        : 'bg-white border-slate-200'
                    }`}
                  >
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-3">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-base text-slate-900">{st.name}</span>
                          <span className="text-[10px] font-mono uppercase bg-slate-100 text-slate-700 px-2 py-0.5 rounded">
                            {st.role}
                          </span>
                          <span
                            className={`text-[10px] font-black px-2 py-0.5 rounded-full ${
                              st.status === 'active'
                                ? 'bg-emerald-100 text-emerald-800'
                                : 'bg-red-100 text-red-800'
                            }`}
                          >
                            {st.status.toUpperCase()}
                          </span>
                        </div>
                        <div className="text-xs text-slate-500 mt-1">
                          {st.email} · Territorial: <strong>{st.territoryScope}</strong> · Category Scope: <strong>{st.categoryScope}</strong>
                        </div>
                      </div>

                      <div className="flex items-center gap-2">
                        <div className="text-right mr-3 hidden sm:block">
                          <div className="text-[11px] text-slate-400">Assigned Tasks</div>
                          <div className="text-sm font-black text-[#0F3D3E]">{st.assignedTasksCount}</div>
                        </div>

                        {st.status === 'active' && (
                          <button
                            onClick={() => setHandoverOutgoingId(st.id)}
                            className="px-3.5 py-2 bg-amber-50 hover:bg-amber-100 text-amber-900 border border-amber-200 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5"
                          >
                            <ArrowRightLeft className="w-3.5 h-3.5" /> Offboard &amp; Handover
                          </button>
                        )}
                      </div>
                    </div>

                    {/* Fine-grained permissions pills */}
                    <div className="flex flex-wrap gap-1.5 mt-3 pt-3 border-t border-slate-100 text-[10px]">
                      <span className={`px-2 py-0.5 rounded ${st.canApproveMerchants ? 'bg-emerald-50 text-emerald-700 font-bold' : 'bg-slate-100 text-slate-400'}`}>
                        {st.canApproveMerchants ? '✓ Approve Merchants' : '✕ Approve Merchants'}
                      </span>
                      <span className={`px-2 py-0.5 rounded ${st.canModerateUsers ? 'bg-emerald-50 text-emerald-700 font-bold' : 'bg-slate-100 text-slate-400'}`}>
                        {st.canModerateUsers ? '✓ Moderate Users' : '✕ Moderate Users'}
                      </span>
                      <span className={`px-2 py-0.5 rounded ${st.canManageModules ? 'bg-emerald-50 text-emerald-700 font-bold' : 'bg-slate-100 text-slate-400'}`}>
                        {st.canManageModules ? '✓ Manage Modules' : '✕ Manage Modules'}
                      </span>
                      <span className={`px-2 py-0.5 rounded ${st.canViewAuditLogs ? 'bg-emerald-50 text-emerald-700 font-bold' : 'bg-slate-100 text-slate-400'}`}>
                        {st.canViewAuditLogs ? '✓ View Audit Logs' : '✕ View Audit Logs'}
                      </span>
                    </div>
                  </div>
                ))}
              </div>

              {/* Handover Dialog */}
              {handoverOutgoingId && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
                  <div className="bg-white rounded-3xl p-6 max-w-lg w-full shadow-2xl border border-slate-200">
                    <h4 className="font-bold text-base text-slate-900 flex items-center gap-2">
                      <ArrowRightLeft className="w-5 h-5 text-amber-600" />
                      Staff Handover &amp; Task Reassignment
                    </h4>
                    <p className="text-xs text-slate-500 mt-1">
                      This will automatically suspend the outgoing staff account and reassign all their pending tasks to the new staff member with full audit logging.
                    </p>

                    <div className="mt-4 space-y-3">
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1">Outgoing Staff Member</label>
                        <input
                          type="text"
                          disabled
                          value={staffList.find((s) => s.id === handoverOutgoingId)?.name}
                          className="w-full px-3 py-2 rounded-xl bg-slate-100 border border-slate-200 text-xs font-bold"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1">Reassign Pending Tasks To</label>
                        <select
                          value={handoverIncomingId}
                          onChange={(e) => setHandoverIncomingId(e.target.value)}
                          className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-semibold bg-white"
                        >
                          {staffList
                            .filter((s) => s.id !== handoverOutgoingId && s.status === 'active')
                            .map((s) => (
                              <option key={s.id} value={s.id}>
                                {s.name} ({s.role}) - Current Tasks: {s.assignedTasksCount}
                              </option>
                            ))}
                        </select>
                      </div>

                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1">Handover Notes</label>
                        <textarea
                          value={handoverNotes}
                          onChange={(e) => setHandoverNotes(e.target.value)}
                          rows={2}
                          className="w-full p-2.5 rounded-xl border border-slate-200 text-xs"
                        />
                      </div>
                    </div>

                    <div className="flex justify-end gap-2 mt-6">
                      <button
                        onClick={() => setHandoverOutgoingId(null)}
                        className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:bg-slate-100"
                      >
                        Cancel
                      </button>
                      <button
                        onClick={executeHandover}
                        className="px-5 py-2 bg-[#0F3D3E] text-white rounded-xl text-xs font-bold hover:bg-[#165B5E]"
                      >
                        Execute Handover
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* SECTION: DYNAMIC CATEGORIES & MODULES (NO RE-RELEASE) */}
          {activeSection === 'categories' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-200">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <Grid className="w-5 h-5 text-[#0F3D3E]" /> Dynamic Business Categories &amp; Modules
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Toggle business segments on/off instantly. The Flutter client reactive provider updates immediately without requiring an app store re-release (No Re-Release).
                  </p>
                </div>

                <button
                  onClick={() => setShowAddCatModal(true)}
                  className="px-3.5 py-2 bg-[#0F3D3E] text-white rounded-xl text-xs font-bold hover:bg-[#165B5E] flex items-center gap-1.5 self-start"
                >
                  <Plus className="w-3.5 h-3.5" /> Add New Category
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                {categories.map((cat) => (
                  <div
                    key={cat.id}
                    className="p-4 rounded-2xl border border-slate-200 bg-white flex items-center justify-between shadow-xs"
                  >
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-bold text-sm text-slate-900">{cat.name}</span>
                        <span className="text-[9px] font-mono uppercase bg-slate-100 text-slate-700 px-2 py-0.5 rounded">
                          {cat.segment}
                        </span>
                      </div>
                      <div className="text-xs text-slate-500 mt-0.5">{cat.nameNp}</div>
                    </div>

                    <button
                      onClick={() => onToggleCategory(cat.id)}
                      className={`px-3 py-1.5 rounded-xl text-xs font-black transition-all ${
                        cat.active
                          ? 'bg-emerald-100 text-emerald-800 hover:bg-emerald-200'
                          : 'bg-slate-100 text-slate-500 hover:bg-slate-200'
                      }`}
                    >
                      {cat.active ? 'ACTIVE ✓' : 'DISABLED'}
                    </button>
                  </div>
                ))}
              </div>

              {/* Add Category Modal */}
              {showAddCatModal && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
                  <div className="bg-white rounded-3xl p-6 max-w-md w-full shadow-2xl border border-slate-200">
                    <h4 className="font-bold text-base text-slate-900">Add New Dynamic Module</h4>
                    <p className="text-xs text-slate-500 mt-1">
                      Instantly registers a new category into Supabase DB. Reflected on all user mobile apps immediately.
                    </p>

                    <div className="mt-4 space-y-3">
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1">Module Name (English)</label>
                        <input
                          type="text"
                          placeholder="e.g. Diagnostic Labs & Blood Bank"
                          value={newCatName}
                          onChange={(e) => setNewCatName(e.target.value)}
                          className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1">Nepali Title</label>
                        <input
                          type="text"
                          placeholder="उदा: ल्याब तथा रगत परीक्षण"
                          value={newCatNameNp}
                          onChange={(e) => setNewCatNameNp(e.target.value)}
                          className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1">Segment Slug</label>
                        <input
                          type="text"
                          placeholder="HEALTH_LAB"
                          value={newCatSegment}
                          onChange={(e) => setNewCatSegment(e.target.value.toUpperCase())}
                          className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-mono"
                        />
                      </div>
                    </div>

                    <div className="flex justify-end gap-2 mt-5">
                      <button
                        onClick={() => setShowAddCatModal(false)}
                        className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:bg-slate-100"
                      >
                        Cancel
                      </button>
                      <button
                        onClick={() => {
                          if (onAddCategory && newCatName) {
                            onAddCategory(newCatName, newCatNameNp || newCatName, newCatSegment);
                            setNewCatName('');
                            setNewCatNameNp('');
                            setShowAddCatModal(false);
                          }
                        }}
                        className="px-4 py-2 bg-[#0F3D3E] text-white rounded-xl text-xs font-bold hover:bg-[#165B5E]"
                      >
                        Publish Module
                      </button>
                    </div>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* SECTION: BRANCHES */}
          {activeSection === 'branches' && (
            <div className="space-y-6">
              <div className="pb-4 border-b border-slate-200">
                <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                  <GitBranch className="w-5 h-5 text-[#0F3D3E]" /> Multi-Tenant Provincial Branches
                </h3>
                <p className="text-xs text-slate-500 mt-0.5">
                  Decentralized operation hubs across Nepal managing merchant onboarding and offline verification.
                </p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-slate-900 text-sm">Kathmandu Valley Central HQ</span>
                    <span className="px-2 py-0.5 bg-emerald-100 text-emerald-800 rounded-full text-[10px] font-bold">HQ PRIMARY</span>
                  </div>
                  <div className="text-xs text-slate-500">Republic Nepal TV Tower, Baneshwor, Kathmandu</div>
                  <div className="text-[11px] text-slate-600 pt-2 border-t border-slate-100 flex justify-between">
                    <span>Manager: <strong>Bishal Thapa</strong></span>
                    <span>Merchants: <strong>1,840</strong></span>
                  </div>
                </div>

                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-slate-900 text-sm">Gandaki Province Branch</span>
                    <span className="px-2 py-0.5 bg-blue-100 text-blue-800 rounded-full text-[10px] font-bold">BRANCH</span>
                  </div>
                  <div className="text-xs text-slate-500">Lakeside Road, Pokhara</div>
                  <div className="text-[11px] text-slate-600 pt-2 border-t border-slate-100 flex justify-between">
                    <span>Manager: <strong>Bikram Thapa</strong></span>
                    <span>Merchants: <strong>540</strong></span>
                  </div>
                </div>

                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-slate-900 text-sm">Koshi Province Branch</span>
                    <span className="px-2 py-0.5 bg-blue-100 text-blue-800 rounded-full text-[10px] font-bold">BRANCH</span>
                  </div>
                  <div className="text-xs text-slate-500">Main Road, Biratnagar</div>
                  <div className="text-[11px] text-slate-600 pt-2 border-t border-slate-100 flex justify-between">
                    <span>Manager: <strong>Sunil Giri</strong></span>
                    <span>Merchants: <strong>330</strong></span>
                  </div>
                </div>

                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-slate-900 text-sm">Chitwan Narayani Hub</span>
                    <span className="px-2 py-0.5 bg-blue-100 text-blue-800 rounded-full text-[10px] font-bold">BRANCH</span>
                  </div>
                  <div className="text-xs text-slate-500">Lions Chowk, Bharatpur</div>
                  <div className="text-[11px] text-slate-600 pt-2 border-t border-slate-100 flex justify-between">
                    <span>Manager: <strong>Pooja Karki</strong></span>
                    <span>Merchants: <strong>210</strong></span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* SECTION: PRODUCTS & SERVICES */}
          {(activeSection === 'products' || activeSection === 'services') && (
            <div className="space-y-6">
              <div className="pb-4 border-b border-slate-200">
                <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                  {activeSection === 'products' ? <Package className="w-5 h-5 text-[#0F3D3E]" /> : <Wrench className="w-5 h-5 text-[#0F3D3E]" />}
                  {activeSection === 'products' ? 'Products Catalog Moderation' : 'Services & Clinic Listings'}
                </h3>
                <p className="text-xs text-slate-500 mt-0.5">
                  Multi-tenant inventory catalog submitted by registered merchants across Nepal.
                </p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="font-bold text-sm text-slate-900">Organic Jumla Apple (१ केजी)</div>
                  <div className="text-xs text-slate-500">Merchant: Himalayan Organic Mart</div>
                  <div className="flex justify-between items-center pt-2 border-t border-slate-100">
                    <span className="font-mono font-bold text-[#0F3D3E]">रु. २५०.००</span>
                    <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded">In Stock (४० केजी)</span>
                  </div>
                </div>

                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="font-bold text-sm text-slate-900">Dr. Consultation Token (OPD)</div>
                  <div className="text-xs text-slate-500">Merchant: Siddhartha Health Clinic</div>
                  <div className="flex justify-between items-center pt-2 border-t border-slate-100">
                    <span className="font-mono font-bold text-[#0F3D3E]">रु. ५००.००</span>
                    <span className="text-[10px] font-bold text-blue-700 bg-blue-50 px-2 py-0.5 rounded">Appointment Slot</span>
                  </div>
                </div>

                <div className="p-4 bg-white rounded-2xl border border-slate-200 shadow-xs space-y-2">
                  <div className="font-bold text-sm text-slate-900">Traditional Dhaka Topi</div>
                  <div className="text-xs text-slate-500">Merchant: Palpali Dhaka Store</div>
                  <div className="flex justify-between items-center pt-2 border-t border-slate-100">
                    <span className="font-mono font-bold text-[#0F3D3E]">रु. ७५०.००</span>
                    <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded">Active (१५ वटा)</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* SECTION: ORDERS & BOOKINGS */}
          {(activeSection === 'orders' || activeSection === 'bookings') && (
            <div className="space-y-6">
              <div className="pb-4 border-b border-slate-200">
                <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                  {activeSection === 'orders' ? <ShoppingBag className="w-5 h-5 text-[#0F3D3E]" /> : <Calendar className="w-5 h-5 text-[#0F3D3E]" />}
                  {activeSection === 'orders' ? 'Orders Tracker' : 'Appointments & Bookings'}
                </h3>
                <p className="text-xs text-slate-500 mt-0.5">
                  Real-time transaction flow from Easy App mobile customer checkouts.
                </p>
              </div>

              <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
                <table className="w-full text-left text-xs">
                  <thead className="bg-slate-50 text-slate-500 border-b border-slate-200">
                    <tr>
                      <th className="p-3">Ref ID</th>
                      <th className="p-3">Customer</th>
                      <th className="p-3">Service / Item</th>
                      <th className="p-3">Amount</th>
                      <th className="p-3">Payment</th>
                      <th className="p-3">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    <tr>
                      <td className="p-3 font-mono font-bold">#ORD-9021</td>
                      <td className="p-3">Aarav Sharma</td>
                      <td className="p-3">Kirana Groceries (4 items)</td>
                      <td className="p-3 font-mono font-bold text-[#0F3D3E]">रु. २,४५०</td>
                      <td className="p-3 text-slate-500">Fonepay QR</td>
                      <td className="p-3"><span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">Delivered</span></td>
                    </tr>
                    <tr>
                      <td className="p-3 font-mono font-bold">#BKG-4412</td>
                      <td className="p-3">Sunita Shrestha</td>
                      <td className="p-3">Clinic OPD Token (Dr. Karki)</td>
                      <td className="p-3 font-mono font-bold text-[#0F3D3E]">रु. ५००</td>
                      <td className="p-3 text-slate-500">Easy Wallet</td>
                      <td className="p-3"><span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-blue-800">Confirmed (Tomorrow 10 AM)</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* SECTION: ADVERTISEMENTS (REPUBLIC NEPAL TV ENGINE) */}
          {activeSection === 'advertisements' && (
            <div className="space-y-6">
              <div className="pb-4 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div>
                  <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                    <Tv className="w-5 h-5 text-red-600" /> Republic TV &amp; Advertising Engine
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Broadcast campaigns on Republic Nepal TV channel and in-app dynamic banner slots.
                  </p>
                </div>
                <span className="px-3 py-1 bg-red-100 text-red-800 font-bold rounded-xl text-xs flex items-center gap-1.5 self-start">
                  <Tv className="w-3.5 h-3.5" /> 24/7 TV Satellite Link Active
                </span>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-white p-5 rounded-2xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-sm text-slate-900">Himalayan Organic Mart Campaign</span>
                    <span className="px-2 py-0.5 rounded bg-emerald-100 text-emerald-800 text-[10px] font-bold">LIVE ON AIR</span>
                  </div>
                  <div className="text-xs text-slate-500">
                    Slot: Prime Time News (08:00 PM) · Duration: 30s Spot + Mobile Carousel
                  </div>
                  <div className="flex justify-between text-xs text-slate-600 pt-2 border-t border-slate-100">
                    <span>Impressions: <strong>84,200</strong></span>
                    <span>Clicks: <strong>4,120</strong></span>
                    <span>Rate: <strong>रु. १२,००० / दिन</strong></span>
                  </div>
                </div>

                <div className="bg-white p-5 rounded-2xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-sm text-slate-900">Siddhartha Health Camp Awareness</span>
                    <span className="px-2 py-0.5 rounded bg-blue-100 text-blue-800 text-[10px] font-bold">SCHEDULED</span>
                  </div>
                  <div className="text-xs text-slate-500">
                    Slot: Morning Health Hour (07:30 AM) · Banner Pin on App Home
                  </div>
                  <div className="flex justify-between text-xs text-slate-600 pt-2 border-t border-slate-100">
                    <span>Target: <strong>Kathmandu Valley</strong></span>
                    <span>Status: <strong>Ready for Broadcast</strong></span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* SECTION: AUDIT LOGS */}
          {activeSection === 'audit_logs' && (
            <div className="space-y-6">
              <div className="pb-4 border-b border-slate-200">
                <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                  <History className="w-5 h-5 text-[#0F3D3E]" /> Full System Audit Logs
                </h3>
                <p className="text-xs text-slate-500 mt-0.5">
                  Tamper-evident logs of all staff activities, merchant approvals, role alterations, and module toggles.
                </p>
              </div>

              <div className="space-y-3">
                {auditLogs.map((log) => (
                  <div
                    key={log.id}
                    className="p-3.5 rounded-2xl border border-slate-200 bg-white flex flex-col sm:flex-row sm:items-center justify-between gap-2 text-xs"
                  >
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-mono font-bold text-[#0F3D3E]">{log.action}</span>
                        <span className="text-slate-400 font-mono text-[11px]">[{log.target}]</span>
                      </div>
                      <div className="text-slate-600 mt-1">{log.details}</div>
                    </div>
                    <div className="text-right shrink-0">
                      <div className="font-bold text-slate-800">{log.actor}</div>
                      <div className="text-[10px] text-slate-400">{log.timestamp}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* SECTION: SYSTEM SETTINGS (DYNAMIC TITLE & BRANDING) */}
          {activeSection === 'system_settings' && (
            <div className="space-y-6">
              <div className="pb-4 border-b border-slate-200">
                <h3 className="text-xl font-black text-slate-900 flex items-center gap-2">
                  <Settings className="w-5 h-5 text-[#0F3D3E]" /> System Settings &amp; Dynamic Branding
                </h3>
                <p className="text-xs text-slate-500 mt-0.5">
                  Manage app title, company branding, and global settings stored in Supabase public.system_settings without requiring app re-release.
                </p>
              </div>

              <div className="bg-white p-6 rounded-2xl border border-slate-200 space-y-4 max-w-xl shadow-xs">
                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-1">
                    Dynamic App Title (No App Re-Release Needed)
                  </label>
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={appTitleInput}
                      onChange={(e) => setAppTitleInput(e.target.value)}
                      className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-bold"
                    />
                    <button
                      onClick={() => onUpdateAppTitle(appTitleInput)}
                      className="px-4 py-2 bg-[#0F3D3E] text-white rounded-xl text-xs font-bold hover:bg-[#165B5E] shrink-0"
                    >
                      Save Title
                    </button>
                  </div>
                  <span className="text-[11px] text-slate-400 mt-1 block">
                    Reflected live in the mobile app header and auth screens immediately.
                  </span>
                </div>

                <div className="pt-4 border-t border-slate-100 text-xs space-y-2">
                  <div className="font-bold text-slate-700">Official Owner Entity:</div>
                  <div className="text-[#0F3D3E] font-black text-sm">
                    Republic Nepal TV &amp; Advertising Pvt. Ltd.
                  </div>
                  <div className="text-slate-500 text-xs">
                    रिपब्लिक नेपाल टिभी एण्ड एडभरटाइजिङ प्रा. लि.
                  </div>
                  <div className="text-[11px] text-slate-400">
                    Kathmandu HQ · Registration No. 289410/079/080 · VAT: 610283749
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* FALLBACK FOR OTHER RICH SECTIONS */}
          {activeSection !== 'dashboard' &&
            activeSection !== 'approve_businesses' &&
            activeSection !== 'businesses' &&
            activeSection !== 'users' &&
            activeSection !== 'staff_control' &&
            activeSection !== 'categories' &&
            activeSection !== 'branches' &&
            activeSection !== 'products' &&
            activeSection !== 'services' &&
            activeSection !== 'orders' &&
            activeSection !== 'bookings' &&
            activeSection !== 'advertisements' &&
            activeSection !== 'audit_logs' &&
            activeSection !== 'system_settings' && (
              <div className="space-y-4">
                <div className="pb-4 border-b border-slate-200">
                  <h3 className="text-xl font-black text-slate-900 capitalize flex items-center gap-2">
                    <Sliders className="w-5 h-5 text-[#0F3D3E]" /> {activeSection.replace('_', ' ')} Control
                  </h3>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Enterprise management module governed by Row Level Security and scoped staff access.
                  </p>
                </div>

                <div className="bg-white p-6 rounded-2xl border border-slate-200 text-xs space-y-3">
                  <div className="font-bold text-slate-800 text-sm">Module Configuration: {activeSection.toUpperCase()}</div>
                  <p className="text-slate-600">
                    This section connects directly to Supabase PostgreSQL multi-tenant tables. All actions are logged into <code className="font-mono text-[#0F3D3E]">public.audit_logs</code>.
                  </p>
                  <div className="p-3 bg-slate-50 rounded-xl border border-slate-100 text-slate-500 font-mono text-[11px]">
                    Status: ACTIVE · RLS: Enforced · Multi-Tenant Isolation: Enabled
                  </div>
                </div>
              </div>
            )}
        </main>
      </div>
    </div>
  );
};
