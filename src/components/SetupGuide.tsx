import React from 'react';
import { Terminal, Database, ShieldCheck, CheckCircle2, ArrowRight, ExternalLink, Sparkles } from 'lucide-react';

export const SetupGuide: React.FC = () => {
  return (
    <div className="max-w-4xl mx-auto py-6 space-y-8">
      <div>
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#0F3D3E]/10 text-[#0F3D3E] text-xs font-bold mb-2">
          <Terminal className="w-3.5 h-3.5 text-[#C79A3E]" /> Production Deployment &amp; Setup
        </div>
        <h2 className="text-2xl font-black text-slate-900 tracking-tight">
          Phase 1 Setup &amp; Execution Guide
        </h2>
        <p className="text-sm text-slate-600 mt-1">
          Follow these sequential steps to boot the Nepal Super App with a live Supabase PostgreSQL backend and run it on iOS, Android, or Web.
        </p>
      </div>

      <div className="space-y-6">
        {/* Step 1 */}
        <div className="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm">
          <div className="flex items-center gap-3 mb-4">
            <span className="w-8 h-8 rounded-full bg-[#0F3D3E] text-white flex items-center justify-center font-black text-sm">
              1
            </span>
            <h3 className="text-lg font-bold text-slate-900">Configure Supabase Project &amp; Run schema.sql</h3>
          </div>

          <p className="text-xs text-slate-600 leading-relaxed mb-4">
            Go to your Supabase Dashboard (<span className="font-mono text-[#0F3D3E]">app.supabase.com</span>), open the <strong>SQL Editor</strong>, and execute the entire contents of <code className="text-slate-800 font-mono font-bold">schema.sql</code>.
          </p>

          <div className="bg-slate-900 text-slate-200 rounded-2xl p-4 text-xs font-mono space-y-2">
            <div className="text-emerald-400">-- What schema.sql sets up:</div>
            <div>✓ Creates public.profiles with user role enum check</div>
            <div>✓ Sets up auto-trigger handle_new_user() on auth.users</div>
            <div>✓ Enables Row Level Security (RLS) on public.profiles</div>
            <div>✓ Adds security barrier preventing role escalation to superAdmin</div>
          </div>
        </div>

        {/* Step 2 */}
        <div className="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm">
          <div className="flex items-center gap-3 mb-4">
            <span className="w-8 h-8 rounded-full bg-[#0F3D3E] text-white flex items-center justify-center font-black text-sm">
              2
            </span>
            <h3 className="text-lg font-bold text-slate-900">Install Flutter Dependencies</h3>
          </div>

          <p className="text-xs text-slate-600 leading-relaxed mb-4">
            Ensure you have Flutter 3.19+ installed. Run the pubspec command in your terminal:
          </p>

          <div className="bg-slate-900 text-slate-200 rounded-2xl p-4 text-xs font-mono">
            <span className="text-slate-500">$ </span>flutter pub get
          </div>
        </div>

        {/* Step 3 */}
        <div className="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm">
          <div className="flex items-center gap-3 mb-4">
            <span className="w-8 h-8 rounded-full bg-[#0F3D3E] text-white flex items-center justify-center font-black text-sm">
              3
            </span>
            <h3 className="text-lg font-bold text-slate-900">Run App with Dart Defines</h3>
          </div>

          <p className="text-xs text-slate-600 leading-relaxed mb-4">
            Pass your Supabase Project URL and Anon Public Key securely at compile/run time via Dart defines:
          </p>

          <div className="bg-slate-900 text-slate-200 rounded-2xl p-4 text-xs font-mono overflow-x-auto">
            <span className="text-slate-500">$ </span>
            flutter run \<br />
            &nbsp;&nbsp;--dart-define=SUPABASE_URL=https://your-project.supabase.co \<br />
            &nbsp;&nbsp;--dart-define=SUPABASE_ANON_KEY=your-anon-jwt-token
          </div>
        </div>

        {/* Step 4 */}
        <div className="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm">
          <div className="flex items-center gap-3 mb-4">
            <span className="w-8 h-8 rounded-full bg-[#0F3D3E] text-white flex items-center justify-center font-black text-sm">
              4
            </span>
            <h3 className="text-lg font-bold text-slate-900">Test Multi-Role Routing Matrix</h3>
          </div>

          <p className="text-xs text-slate-600 leading-relaxed mb-3">
            Register or sign in with different user roles to verify GoRouter redirects and access:
          </p>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
            <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
              <span className="font-bold text-[#0F3D3E]">customer (ग्राहक):</span>
              <p className="text-slate-500 mt-1">Routes to /customer-dashboard with Nepal Super Wallet &amp; Marketplace.</p>
            </div>
            <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
              <span className="font-bold text-[#0F3D3E]">businessOwner (व्यापारी):</span>
              <p className="text-slate-500 mt-1">Routes to /business-dashboard with full store POS &amp; management.</p>
            </div>
            <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
              <span className="font-bold text-[#0F3D3E]">staff (कर्मचारी):</span>
              <p className="text-slate-500 mt-1">Routes to /business-dashboard with scoped POS operator permissions.</p>
            </div>
            <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
              <span className="font-bold text-[#0F3D3E]">superAdmin (मुख्य प्रशासक):</span>
              <p className="text-slate-500 mt-1">Routes to /admin-dashboard with full KYC merchant approvals &amp; metrics.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
