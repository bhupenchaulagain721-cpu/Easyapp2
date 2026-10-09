import React, { useState } from 'react';
import { Layers, Database, ShieldCheck, ArrowRight, CheckCircle2, Cpu, Box, Lock } from 'lucide-react';

export const ArchitectureExplorer: React.FC = () => {
  const [selectedLayer, setSelectedLayer] = useState<'presentation' | 'domain' | 'data' | 'core'>('presentation');

  const layers = {
    presentation: {
      name: 'Presentation Layer (UI & Routing)',
      badge: 'lib/features/auth/presentation/ & lib/features/dashboard/',
      color: 'border-emerald-500 bg-emerald-50/50',
      textColor: 'text-emerald-800',
      description:
        'Contains Flutter Widgets, Riverpod StateNotifiers, GoRouter role-based guards, and the reactive AuthGate. Completely independent of database implementations.',
      components: [
        {
          name: 'AuthGate (Dynamic Router)',
          file: 'lib/features/auth/presentation/screens/auth_gate.dart',
          detail: 'Listens to authNotifierProvider. If unauthenticated, displays Login; if authenticated, inspects user.role and switches between Customer, Business, or Admin portals.',
        },
        {
          name: 'Riverpod AuthNotifier',
          file: 'lib/features/auth/presentation/providers/auth_provider.dart',
          detail: 'StateNotifier managing AuthStateModel. Handles signIn(), signUp(), and signOut() using AuthRepository interface without coupling to Supabase SDK directly.',
        },
        {
          name: 'GoRouter Role Guard',
          file: 'lib/main.dart',
          detail: 'Declarative redirects ensuring Customers cannot enter /admin-dashboard or /business-dashboard, while staff and owners are scoped strictly.',
        },
        {
          name: 'Role-Specific Dashboards',
          file: 'lib/features/dashboard/presentation/screens/*.dart',
          detail: 'Independent customer, merchant, and admin screens with Nepali currency (NPR/रु.), local phone formatting (+977), and light/dark theme support.',
        },
      ],
    },
    domain: {
      name: 'Domain Layer (Enterprise Business Rules)',
      badge: 'lib/features/auth/domain/',
      color: 'border-blue-500 bg-blue-50/50',
      textColor: 'text-blue-800',
      description:
        'The absolute core of Clean Architecture. Contains pure immutable Dart entities and repository contracts. Zero external third-party SDK dependencies (no Supabase, no Flutter UI).',
      components: [
        {
          name: 'UserEntity',
          file: 'lib/features/auth/domain/entities/user_entity.dart',
          detail: 'Immutable user domain model containing id (UUID), email, fullName, role (AppRole), phoneNumber, province, and businessName with equality overrides.',
        },
        {
          name: 'AuthRepository (Abstract Interface)',
          file: 'lib/features/auth/data/repositories/auth_repository_impl.dart',
          detail: 'Specifies the contract for authentication, session streams, and profile fetching. Allows 100% mockability in unit tests.',
        },
      ],
    },
    data: {
      name: 'Data Layer (Supabase Implementation & Models)',
      badge: 'lib/features/auth/data/',
      color: 'border-amber-500 bg-amber-50/50',
      textColor: 'text-amber-800',
      description:
        'Implements the domain repository contracts. Talks directly to Supabase Auth API, handles PKCE session storage, and maps PostgreSQL public.profiles rows to models.',
      components: [
        {
          name: 'UserModel (DTO)',
          file: 'lib/features/auth/data/models/user_model.dart',
          detail: 'Extends UserEntity. Implements fromJson and toJson for serialization to Supabase profiles PostgreSQL table.',
        },
        {
          name: 'AuthRepositoryImpl',
          file: 'lib/features/auth/data/repositories/auth_repository_impl.dart',
          detail: 'Calls SupabaseClient.auth and .from("profiles"). Maps raw Supabase AuthExceptions to friendly bilingual Nepali/English error messages.',
        },
      ],
    },
    core: {
      name: 'Core Layer (Constants & Theme)',
      badge: 'lib/core/',
      color: 'border-purple-500 bg-purple-50/50',
      textColor: 'text-purple-800',
      description:
        'Cross-cutting utilities, role definitions, and design system tokens shared across all features.',
      components: [
        {
          name: 'AppRole Enum & Route Mapping',
          file: 'lib/core/constants/app_roles.dart',
          detail: "Defines superAdmin, businessOwner, staff, customer with English/Nepali display names and role-to-route lookup.",
        },
        {
          name: 'AppColors & AppTheme',
          file: 'lib/core/constants/app_colors.dart & app_theme.dart',
          detail: 'Primary #0F3D3E, Accent #C79A3E, surface palettes, and Material 3 ThemeData with Google Fonts Plus Jakarta Sans.',
        },
      ],
    },
  };

  return (
    <div className="max-w-5xl mx-auto py-6 space-y-8">
      {/* Top Header */}
      <div>
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#0F3D3E]/10 text-[#0F3D3E] text-xs font-bold mb-2">
          <Layers className="w-3.5 h-3.5 text-[#C79A3E]" /> Clean Architecture &amp; SOLID Principles
        </div>
        <h2 className="text-2xl font-black text-slate-900 tracking-tight">
          System Architecture: Clean Separation &amp; RBAC Pipeline
        </h2>
        <p className="text-sm text-slate-600 mt-1">
          Designed for maximum scalability: UI components never speak to the database directly, ensuring zero lock-in, easy testing, and maintainability across high concurrency in Nepal and global deployments.
        </p>
      </div>

      {/* Layer Navigation Tabs */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {(Object.keys(layers) as Array<keyof typeof layers>).map((key) => {
          const l = layers[key];
          const isSelected = selectedLayer === key;
          return (
            <button
              key={key}
              onClick={() => setSelectedLayer(key)}
              className={`p-4 rounded-2xl text-left border-2 transition-all flex flex-col justify-between ${
                isSelected
                  ? 'border-[#0F3D3E] bg-[#0F3D3E]/5 shadow-md shadow-[#0F3D3E]/10'
                  : 'border-slate-200 bg-white hover:border-slate-300'
              }`}
            >
              <div>
                <span className="text-[10px] font-mono uppercase tracking-wider text-slate-400 block mb-1">
                  Layer
                </span>
                <span className="text-sm font-bold text-slate-800 capitalize">{key}</span>
              </div>
              <span className="text-[11px] text-slate-500 mt-2 truncate">{l.badge}</span>
            </button>
          );
        })}
      </div>

      {/* Selected Layer Deep Dive */}
      <div className="bg-white rounded-3xl p-6 md:p-8 border border-slate-200 shadow-sm">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 border-b border-slate-100">
          <div>
            <span className="text-xs font-mono font-bold text-[#C79A3E] uppercase tracking-wider">
              Layer Deep Dive
            </span>
            <h3 className="text-xl font-black text-slate-900">{layers[selectedLayer].name}</h3>
            <p className="text-xs text-slate-500 mt-1">{layers[selectedLayer].description}</p>
          </div>
          <div className="px-3 py-1.5 rounded-xl bg-slate-100 font-mono text-xs text-slate-700 shrink-0">
            {layers[selectedLayer].badge}
          </div>
        </div>

        {/* Components in this Layer */}
        <div className="mt-6 space-y-4">
          {layers[selectedLayer].components.map((comp, idx) => (
            <div
              key={idx}
              className="p-4 rounded-2xl border border-slate-100 bg-slate-50/60 hover:bg-slate-50 transition-colors"
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-1.5">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-[#C79A3E]" />
                  <span className="font-bold text-sm text-slate-900">{comp.name}</span>
                </div>
                <span className="font-mono text-[11px] text-[#0F3D3E] bg-white px-2.5 py-0.5 rounded-md border border-slate-200">
                  {comp.file}
                </span>
              </div>
              <p className="text-xs text-slate-600 pl-4 leading-relaxed">{comp.detail}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Architecture Flow Pipeline Diagram */}
      <div className="bg-[#0F3D3E] rounded-3xl p-6 md:p-8 text-white shadow-xl">
        <div className="flex items-center gap-2 text-xs font-bold text-[#E5B95C] uppercase tracking-wider mb-2">
          <Cpu className="w-4 h-4" /> End-to-End Data &amp; Security Pipeline
        </div>
        <h3 className="text-xl font-black">How an Action Flows Through the Architecture</h3>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
          <div className="bg-white/10 rounded-2xl p-4 border border-white/10">
            <span className="text-[10px] font-mono text-[#E5B95C] font-bold">1. USER INTERFACE</span>
            <div className="font-bold text-sm mt-1">Flutter Widget &amp; Form</div>
            <p className="text-[11px] text-white/70 mt-2 leading-relaxed">
              User enters email &amp; credentials on <code className="text-white">LoginScreen</code> or selects role on <code className="text-white">RegisterScreen</code>.
            </p>
          </div>

          <div className="bg-white/10 rounded-2xl p-4 border border-white/10">
            <span className="text-[10px] font-mono text-[#E5B95C] font-bold">2. STATE MANAGER</span>
            <div className="font-bold text-sm mt-1">Riverpod AuthNotifier</div>
            <p className="text-[11px] text-white/70 mt-2 leading-relaxed">
              Executes validation and sets <code className="text-white">isLoading = true</code>. Calls <code className="text-white">AuthRepository</code> contract.
            </p>
          </div>

          <div className="bg-white/10 rounded-2xl p-4 border border-white/10">
            <span className="text-[10px] font-mono text-[#E5B95C] font-bold">3. DATA LAYER</span>
            <div className="font-bold text-sm mt-1">Supabase Client &amp; DTO</div>
            <p className="text-[11px] text-white/70 mt-2 leading-relaxed">
              Sends encrypted PKCE request. Fetches profile from <code className="text-white">public.profiles</code> table. Maps to <code className="text-white">UserModel</code>.
            </p>
          </div>

          <div className="bg-white/10 rounded-2xl p-4 border border-white/10">
            <span className="text-[10px] font-mono text-[#E5B95C] font-bold">4. POSTGRESQL RLS</span>
            <div className="font-bold text-sm mt-1">Row Level Security</div>
            <p className="text-[11px] text-white/70 mt-2 leading-relaxed">
              Database evaluates <code className="text-white">auth.uid() = id</code> and role constraints. Prevents unauthorized elevation.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
