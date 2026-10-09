import React, { useState } from 'react';
import { Database, ShieldCheck, ShieldAlert, Key, Check, Copy, Table, FileCode, Play, Terminal } from 'lucide-react';
import { FLUTTER_FILES } from '../data/flutterFiles';

export const SupabaseRLSExplorer: React.FC = () => {
  const [selectedRole, setSelectedRole] = useState<'customer' | 'businessOwner' | 'staff' | 'superAdmin' | 'anon'>('customer');
  const [selectedAction, setSelectedAction] = useState<string>('read_own');
  const [copiedSql, setCopiedSql] = useState(false);

  const schemaFile = FLUTTER_FILES.find((f) => f.path === 'schema.sql');

  const rlsScenarios: Record<
    string,
    {
      title: string;
      query: string;
      policyName: string;
      results: Record<
        'customer' | 'businessOwner' | 'staff' | 'superAdmin' | 'anon',
        { allowed: boolean; reason: string }
      >;
    }
  > = {
    read_own: {
      title: 'SELECT own profile',
      query: 'SELECT * FROM public.profiles WHERE id = auth.uid();',
      policyName: 'Profiles are viewable by owner, elevated roles, or public directory',
      results: {
        customer: { allowed: true, reason: 'Allowed: auth.uid() matches target row ID.' },
        businessOwner: { allowed: true, reason: 'Allowed: auth.uid() matches target row ID.' },
        staff: { allowed: true, reason: 'Allowed: auth.uid() matches target row ID.' },
        superAdmin: { allowed: true, reason: 'Allowed: is_super_admin() is TRUE and row owner matches.' },
        anon: { allowed: false, reason: 'Blocked: auth.uid() is NULL for unauthenticated requests.' },
      },
    },
    read_merchant: {
      title: 'SELECT merchant/staff public profile',
      query: "SELECT id, full_name, business_name, province FROM public.profiles WHERE role IN ('businessOwner', 'staff');",
      policyName: 'Profiles are viewable by owner, elevated roles, or public directory',
      results: {
        customer: { allowed: true, reason: 'Allowed: Customers can discover merchant stores and counter staff for orders.' },
        businessOwner: { allowed: true, reason: 'Allowed: Public directory view enabled for vendor network.' },
        staff: { allowed: true, reason: 'Allowed: Public directory view enabled.' },
        superAdmin: { allowed: true, reason: 'Allowed: Super Admin has global read visibility.' },
        anon: { allowed: false, reason: 'Blocked: Anonymous users cannot query protected profiles.' },
      },
    },
    update_own_name: {
      title: 'UPDATE personal details (full_name, phone)',
      query: "UPDATE public.profiles SET full_name = 'Sita Sharma', updated_at = NOW() WHERE id = auth.uid();",
      policyName: 'Users can update their own profile without role escalation',
      results: {
        customer: { allowed: true, reason: 'Allowed: Row owner matches auth.uid() and role did not change.' },
        businessOwner: { allowed: true, reason: 'Allowed: Business owner updating their verified details.' },
        staff: { allowed: true, reason: 'Allowed: Staff updating personal contact info.' },
        superAdmin: { allowed: true, reason: 'Allowed: Super Admin has full update authorization.' },
        anon: { allowed: false, reason: 'Blocked: Anonymous sessions cannot perform updates.' },
      },
    },
    elevate_role: {
      title: 'ATTEMPT ROLE ESCALATION (SET role = "superAdmin")',
      query: "UPDATE public.profiles SET role = 'superAdmin' WHERE id = auth.uid();",
      policyName: 'Users can update their own profile without role escalation (WITH CHECK constraint)',
      results: {
        customer: { allowed: false, reason: 'CRITICAL SECURITY BLOCK: WITH CHECK rejects role changes where role != existing role.' },
        businessOwner: { allowed: false, reason: 'CRITICAL SECURITY BLOCK: Merchant cannot elevate self to superAdmin.' },
        staff: { allowed: false, reason: 'CRITICAL SECURITY BLOCK: Staff cannot elevate permissions.' },
        superAdmin: { allowed: true, reason: 'Allowed: Super Admin possesses administrative role modification grant.' },
        anon: { allowed: false, reason: 'Blocked: No authentication credentials provided.' },
      },
    },
    delete_profile: {
      title: 'DELETE profile record',
      query: 'DELETE FROM public.profiles WHERE id = target_id;',
      policyName: 'Users or superAdmins can delete profile',
      results: {
        customer: { allowed: true, reason: 'Allowed ONLY for own account (Right to be Forgotten under privacy laws).' },
        businessOwner: { allowed: true, reason: 'Allowed for own vendor account.' },
        staff: { allowed: true, reason: 'Allowed for own user record.' },
        superAdmin: { allowed: true, reason: 'Allowed: Super Admin can prune or ban any user profile.' },
        anon: { allowed: false, reason: 'Blocked: Unauthorized operation.' },
      },
    },
  };

  const currentScenario = rlsScenarios[selectedAction];
  const outcome = currentScenario.results[selectedRole];

  const copySql = () => {
    if (schemaFile) {
      navigator.clipboard.writeText(schemaFile.code);
      setCopiedSql(true);
      setTimeout(() => setCopiedSql(false), 2000);
    }
  };

  return (
    <div className="max-w-5xl mx-auto py-6 space-y-8">
      {/* Header */}
      <div>
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#0F3D3E]/10 text-[#0F3D3E] text-xs font-bold mb-2">
          <Database className="w-3.5 h-3.5 text-[#C79A3E]" /> Supabase PostgreSQL &amp; Security Layer
        </div>
        <h2 className="text-2xl font-black text-slate-900 tracking-tight">
          Row Level Security (RLS) &amp; Schema Architecture
        </h2>
        <p className="text-sm text-slate-600 mt-1">
          In Supabase, client apps connect straight to PostgreSQL. Row Level Security guarantees data safety at the database engine level, rejecting illegal reads or role escalations even if client code is tampered with.
        </p>
      </div>

      {/* Interactive RLS Live Simulator */}
      <div className="bg-white rounded-3xl p-6 md:p-8 border border-slate-200 shadow-sm">
        <div className="flex items-center justify-between pb-5 border-b border-slate-100">
          <div>
            <span className="text-xs font-mono font-bold text-[#C79A3E] uppercase tracking-wider">
              Interactive Test Bench
            </span>
            <h3 className="text-lg font-black text-slate-900">PostgreSQL RLS Policy Evaluator</h3>
          </div>
          <span className="text-xs bg-slate-100 px-3 py-1 rounded-full font-mono text-slate-600">
            pg_tables: rowsecurity = true
          </span>
        </div>

        {/* Controls: Role and Action */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5 mt-6">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-2">
              1. Simulated Session Role (auth.jwt() -&gt; role)
            </label>
            <div className="grid grid-cols-3 gap-2">
              {(['customer', 'businessOwner', 'staff', 'superAdmin', 'anon'] as const).map((r) => (
                <button
                  key={r}
                  onClick={() => setSelectedRole(r)}
                  className={`py-2 px-3 rounded-xl text-xs font-bold border text-left truncate transition-all ${
                    selectedRole === r
                      ? 'border-[#0F3D3E] bg-[#0F3D3E] text-white shadow-xs'
                      : 'border-slate-200 bg-white text-slate-700 hover:border-slate-300'
                  }`}
                >
                  {r === 'businessOwner'
                    ? 'Merchant'
                    : r === 'superAdmin'
                    ? 'SuperAdmin'
                    : r === 'anon'
                    ? 'Anonymous'
                    : r.toUpperCase()}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-2">
              2. Target Database Query Operation
            </label>
            <select
              value={selectedAction}
              onChange={(e) => setSelectedAction(e.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-800 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0F3D3E]"
            >
              {Object.keys(rlsScenarios).map((key) => (
                <option key={key} value={key}>
                  {rlsScenarios[key].title}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Evaluation Result Box */}
        <div className="mt-6 p-5 rounded-2xl border bg-slate-50 border-slate-200">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-slate-200">
            <div className="flex items-center gap-2">
              <Terminal className="w-4 h-4 text-[#0F3D3E]" />
              <code className="text-xs font-mono font-bold text-slate-800">{currentScenario.query}</code>
            </div>
            <div
              className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-black uppercase shrink-0 ${
                outcome.allowed ? 'bg-emerald-100 text-emerald-800' : 'bg-rose-100 text-rose-800'
              }`}
            >
              {outcome.allowed ? <ShieldCheck className="w-4 h-4" /> : <ShieldAlert className="w-4 h-4" />}
              {outcome.allowed ? 'POLICY ALLOWED (200 OK)' : 'BLOCKED BY RLS (403 FORBIDDEN)'}
            </div>
          </div>

          <div className="mt-3 text-xs text-slate-700 space-y-1.5">
            <div>
              <span className="font-bold text-slate-900">Evaluated Policy:</span>{' '}
              <span className="font-mono text-slate-600">"{currentScenario.policyName}"</span>
            </div>
            <div>
              <span className="font-bold text-slate-900">Security Engine Explanation:</span> {outcome.reason}
            </div>
          </div>
        </div>
      </div>

      {/* Schema Structure & SQL Viewer */}
      <div className="bg-slate-900 rounded-3xl p-6 md:p-8 text-white shadow-xl">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-slate-800">
          <div>
            <div className="flex items-center gap-2 text-xs font-bold text-[#E5B95C] uppercase tracking-wider mb-1">
              <Table className="w-4 h-4" /> schema.sql Production Script
            </div>
            <h3 className="text-xl font-black">PostgreSQL public.profiles &amp; Triggers</h3>
          </div>
          <button
            onClick={copySql}
            className="flex items-center gap-2 px-4 py-2 bg-[#C79A3E] hover:bg-[#d8a846] text-slate-950 rounded-xl text-xs font-bold transition-all"
          >
            {copiedSql ? <Check className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
            {copiedSql ? 'Copied schema.sql!' : 'Copy SQL Script'}
          </button>
        </div>

        {/* Database Columns Preview */}
        <div className="mt-6 mb-6 overflow-x-auto">
          <table className="w-full text-left text-xs border-collapse">
            <thead>
              <tr className="border-b border-slate-800 text-slate-400 font-mono">
                <th className="py-2 px-3">Column Name</th>
                <th className="py-2 px-3">Data Type</th>
                <th className="py-2 px-3">Constraints</th>
                <th className="py-2 px-3">Nepal Domain Purpose</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800/60 font-mono text-[11px]">
              <tr>
                <td className="py-2 px-3 font-bold text-[#E5B95C]">id</td>
                <td className="py-2 px-3 text-emerald-400">UUID</td>
                <td className="py-2 px-3 text-slate-400">PRIMARY KEY -&gt; auth.users</td>
                <td className="py-2 px-3 text-slate-300 font-sans">Synced with Supabase Auth user</td>
              </tr>
              <tr>
                <td className="py-2 px-3 font-bold text-white">email</td>
                <td className="py-2 px-3 text-emerald-400">TEXT</td>
                <td className="py-2 px-3 text-slate-400">NOT NULL</td>
                <td className="py-2 px-3 text-slate-300 font-sans">Primary sign-in handle</td>
              </tr>
              <tr>
                <td className="py-2 px-3 font-bold text-white">full_name</td>
                <td className="py-2 px-3 text-emerald-400">TEXT</td>
                <td className="py-2 px-3 text-slate-400">NOT NULL</td>
                <td className="py-2 px-3 text-slate-300 font-sans">User legal name in English / Devanagari</td>
              </tr>
              <tr>
                <td className="py-2 px-3 font-bold text-white">phone_number</td>
                <td className="py-2 px-3 text-emerald-400">TEXT</td>
                <td className="py-2 px-3 text-slate-400">INDEXED</td>
                <td className="py-2 px-3 text-slate-300 font-sans">Nepal E.164 (+977-98XXXXXXXX)</td>
              </tr>
              <tr>
                <td className="py-2 px-3 font-bold text-[#C79A3E]">role</td>
                <td className="py-2 px-3 text-emerald-400">TEXT</td>
                <td className="py-2 px-3 text-amber-400">CHECK (role IN ('superAdmin', 'businessOwner', 'staff', 'customer'))</td>
                <td className="py-2 px-3 text-slate-300 font-sans">RBAC Role Authority</td>
              </tr>
              <tr>
                <td className="py-2 px-3 font-bold text-white">business_name</td>
                <td className="py-2 px-3 text-emerald-400">TEXT</td>
                <td className="py-2 px-3 text-slate-400">NULLABLE</td>
                <td className="py-2 px-3 text-slate-300 font-sans">Store / Outlet trade name for merchants</td>
              </tr>
              <tr>
                <td className="py-2 px-3 font-bold text-white">province</td>
                <td className="py-2 px-3 text-emerald-400">TEXT</td>
                <td className="py-2 px-3 text-slate-400">INDEXED</td>
                <td className="py-2 px-3 text-slate-300 font-sans">Nepal 7 Federal Provinces</td>
              </tr>
            </tbody>
          </table>
        </div>

        {/* SQL Script block */}
        <div className="relative rounded-2xl bg-black/60 p-4 border border-slate-800 max-h-96 overflow-y-auto">
          <pre className="text-xs font-mono text-slate-300 leading-relaxed">
            <code>{schemaFile?.code}</code>
          </pre>
        </div>
      </div>
    </div>
  );
};
