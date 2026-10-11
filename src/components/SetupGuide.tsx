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

        {/* Step 5: Codemagic CI/CD Build */}
        <div className="bg-white rounded-3xl p-6 border-2 border-[#C79A3E]/30 shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <span className="w-8 h-8 rounded-full bg-[#C79A3E] text-slate-950 flex items-center justify-center font-black text-sm">
                5
              </span>
              <h3 className="text-lg font-bold text-slate-900">
                Codemagic (कोडम्याजिक CI/CD) मार्फत Android APK (.apk) बनाउने तरिका
              </h3>
            </div>
            <span className="px-2.5 py-1 bg-[#0F3D3E] text-white text-[10px] font-bold rounded-full">
              Automated Cloud Build
            </span>
          </div>

          <p className="text-xs text-slate-600 leading-relaxed">
            यस <strong>Easy App</strong> लाई <strong>Codemagic (codemagic.io)</strong> मा जोडेर कुनै पनि कम्प्युटर वा मोबाइलबाट सिधै इन्स्टल गर्न मिल्ने <strong>Release APK</strong> बनाउन सकिन्छ:
          </p>

          <div className="space-y-3 text-xs">
            <div className="p-3.5 bg-slate-50 rounded-2xl border border-slate-200 space-y-1.5">
              <div className="font-bold text-slate-800">१. कोडलाई GitHub मा Push गर्नुहोस्:</div>
              <p className="text-slate-600">
                आफ्नो कम्प्युटरको टर्मिनलमा गई यो Flutter प्रोजेक्टलाई GitHub, GitLab वा Bitbucket मा राख्नुहोस्:
              </p>
              <div className="bg-slate-900 text-slate-200 p-2.5 rounded-xl font-mono text-[11px]">
                git init<br />
                git add .<br />
                git commit -m "Initial commit for Easy App with Codemagic"<br />
                git push -u origin main
              </div>
            </div>

            <div className="p-3.5 bg-slate-50 rounded-2xl border border-slate-200 space-y-1.5">
              <div className="font-bold text-slate-800">२. Codemagic (codemagic.io) मा खाता खोल्नुहोस्:</div>
              <p className="text-slate-600">
                <strong>codemagic.io</strong> मा गई आफ्नो GitHub खाताबाट <strong>Sign up with GitHub</strong> गर्नुहोस् र <strong>Easy App</strong> रिपोजिटरी चयन गर्नुहोस्।
              </p>
            </div>

            <div className="p-3.5 bg-slate-50 rounded-2xl border border-slate-200 space-y-1.5">
              <div className="font-bold text-slate-800">३. Environment Variables (गोप्य साँचोहरू) सेट गर्नुहोस्:</div>
              <p className="text-slate-600">
                Codemagic को <strong>Environment variables</strong> ट्याबमा गई यी दुईवटा मानहरू थप्नुहोस्:
              </p>
              <ul className="list-disc pl-5 space-y-1 text-slate-600 font-mono text-[11px]">
                <li><strong className="text-[#0F3D3E]">SUPABASE_URL</strong> = https://your-project.supabase.co</li>
                <li><strong className="text-[#0F3D3E]">SUPABASE_ANON_KEY</strong> = your-anon-key</li>
              </ul>
            </div>

            <div className="p-3.5 bg-slate-50 rounded-2xl border border-slate-200 space-y-1.5">
              <div className="font-bold text-slate-800">४. codemagic.yaml प्रयोग गरी Build सुरु गर्नुहोस्:</div>
              <p className="text-slate-600">
                प्रोजेक्टको रूटमा हामीले तयार पारिदिएको <code className="font-mono font-bold text-[#0F3D3E]">codemagic.yaml</code> फाइल स्वतः लोड हुन्छ। त्यसपछि Codemagic मा <strong>"Start new build"</strong> बटन थिच्नुहोस्।
              </p>
            </div>

            <div className="p-3.5 bg-emerald-50 rounded-2xl border border-emerald-200 space-y-1">
              <div className="font-bold text-emerald-900">५. APK फाइल डाउनलोड र इन्स्टल:</div>
              <p className="text-emerald-800 text-[11px]">
                करिब ४ देखि ६ मिनेट भित्र बिल्ड पूरा भएपछि Codemagic को <strong>Artifacts</strong> सेक्सनमा वा तपाईंको इमेलमा <strong>app-release.apk</strong> फाइल आउँछ। सो फाइल सिधै एन्ड्रोइड मोबाइलमा इन्स्टल गर्न सकिन्छ!
              </p>
            </div>
          </div>
        </div>

        {/* Step 6: Local Terminal APK Build */}
        <div className="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm space-y-4">
          <div className="flex items-center gap-3">
            <span className="w-8 h-8 rounded-full bg-[#0F3D3E] text-white flex items-center justify-center font-black text-sm">
              6
            </span>
            <h3 className="text-lg font-bold text-slate-900">
              आफ्नै कम्प्युटर (Terminal) बाट सिधै APK निकाल्ने कमाण्ड
            </h3>
          </div>

          <p className="text-xs text-slate-600 leading-relaxed">
            यदि इन्टरनेट क्लाउड CI/CD बिना आफ्नै कम्प्युटरमा APK बनाउन चाहनुहुन्छ भने तलको कमाण्ड चलाउनुहोस्:
          </p>

          <div className="bg-slate-900 text-slate-200 rounded-2xl p-4 text-xs font-mono overflow-x-auto space-y-2">
            <div className="text-slate-400"># 1. Debug APK (द्रुत परीक्षणको लागि):</div>
            <div>flutter build apk --debug</div>
            <div className="text-slate-400 pt-2"># 2. Production Release APK (प्रयोगकर्ताहरूलाई वितरणको लागि):</div>
            <div>
              flutter build apk --release \<br />
              &nbsp;&nbsp;--dart-define=SUPABASE_URL=https://your-project.supabase.co \<br />
              &nbsp;&nbsp;--dart-define=SUPABASE_ANON_KEY=your-anon-jwt-token \<br />
              &nbsp;&nbsp;--dart-define=APP_NAME="Easy App"
            </div>
          </div>

          <div className="p-3 bg-slate-50 rounded-xl border border-slate-100 text-[11px] text-slate-600">
            बिल्ड भइसकेपछि तपाईंको कम्प्युटरमा निम्न स्थानमा APK फाइल तयार हुन्छ:<br />
            <code className="font-bold text-[#0F3D3E] font-mono">build/app/outputs/flutter-apk/app-release.apk</code>
          </div>
        </div>
      </div>
    </div>
  );
};
