import React, { useState } from 'react';
import { FLUTTER_FILES, FlutterFile } from '../data/flutterFiles';
import { FileCode, Copy, Check, Download, Search, Folder, FolderGit2, Sparkles } from 'lucide-react';
import JSZip from 'jszip';

export const CodeViewer: React.FC = () => {
  const [selectedFile, setSelectedFile] = useState<FlutterFile>(FLUTTER_FILES[0]);
  const [searchQuery, setSearchQuery] = useState('');
  const [copied, setCopied] = useState(false);
  const [isZipping, setIsZipping] = useState(false);
  const [activeCategory, setActiveCategory] = useState<string>('All');

  const categories = ['All', 'Configuration', 'Core & Theme', 'Domain Layer', 'Data Layer', 'Presentation', 'Database / Supabase', 'Android Native'];

  const filteredFiles = FLUTTER_FILES.filter((file) => {
    const matchesSearch =
      file.path.toLowerCase().includes(searchQuery.toLowerCase()) ||
      file.description.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = activeCategory === 'All' || file.category === activeCategory;
    return matchesSearch && matchesCategory;
  });

  const handleCopy = () => {
    navigator.clipboard.writeText(selectedFile.code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownloadZip = async () => {
    setIsZipping(true);
    try {
      const zip = new JSZip();

      // Add all 16 files into their exact directory structures
      FLUTTER_FILES.forEach((f) => {
        zip.file(f.path, f.code);
      });

      // Add a quick README for the developer
      zip.file(
        'README.md',
        `# Nepal Super App - Phase 1 Foundation & Auth

Built with Flutter 3.19+, Riverpod, GoRouter, and Supabase PostgreSQL with RLS.

## Quick Start:
1. Run schema.sql in your Supabase SQL Editor.
2. In Flutter project:
   \`\`\`bash
   flutter pub get
   flutter run --dart-define=SUPABASE_URL=YOUR_URL --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
   \`\`\`
`
      );

      const blob = await zip.generateAsync({ type: 'blob' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'nepal_super_app_phase1.zip';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (e) {
      console.error('Failed to generate zip', e);
    } finally {
      setIsZipping(false);
    }
  };

  return (
    <div className="max-w-6xl mx-auto py-6 space-y-6">
      {/* Header with Export Action */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#0F3D3E]/10 text-[#0F3D3E] text-xs font-bold mb-2">
            <FolderGit2 className="w-3.5 h-3.5 text-[#C79A3E]" /> Production Flutter Codebase (16 Files)
          </div>
          <h2 className="text-2xl font-black text-slate-900 tracking-tight">
            Code Explorer &amp; One-Click Export
          </h2>
          <p className="text-xs text-slate-600">
            Browse the complete, un-truncated Clean Architecture source files or download the full project zip to run directly with <code className="text-slate-800 font-mono font-bold">flutter run</code>.
          </p>
        </div>

        <button
          onClick={handleDownloadZip}
          disabled={isZipping}
          className="flex items-center gap-2 px-5 py-3 rounded-2xl bg-[#0F3D3E] hover:bg-[#165B5E] text-white font-bold text-xs shadow-lg shadow-[#0F3D3E]/20 transition-all shrink-0"
        >
          {isZipping ? (
            <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
          ) : (
            <Download className="w-4 h-4 text-[#C79A3E]" />
          )}
          Download Project ZIP (16 Files)
        </button>
      </div>

      {/* Category Pills & Search */}
      <div className="flex flex-col md:flex-row items-center justify-between gap-3">
        <div className="flex items-center gap-1.5 overflow-x-auto w-full md:w-auto pb-2 md:pb-0">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setActiveCategory(cat)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition-all ${
                activeCategory === cat
                  ? 'bg-[#0F3D3E] text-white'
                  : 'bg-white border border-slate-200 text-slate-600 hover:border-slate-300'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        <div className="relative w-full md:w-64">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-2.5" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search files or paths..."
            className="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-200 bg-white text-xs focus:outline-none focus:ring-2 focus:ring-[#0F3D3E]"
          />
        </div>
      </div>

      {/* Main Split Layout: File Tree and Code Preview */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        {/* Left Sidebar: File List */}
        <div className="lg:col-span-4 bg-white rounded-3xl border border-slate-200 overflow-hidden shadow-sm">
          <div className="p-4 border-b border-slate-100 flex items-center justify-between">
            <span className="text-xs font-bold text-slate-700">Project Files ({filteredFiles.length})</span>
            <span className="text-[10px] font-mono text-slate-400">Dart / YAML / SQL</span>
          </div>

          <div className="divide-y divide-slate-100 max-h-[640px] overflow-y-auto">
            {filteredFiles.map((file) => {
              const isSelected = selectedFile.path === file.path;
              return (
                <button
                  key={file.path}
                  onClick={() => setSelectedFile(file)}
                  className={`w-full p-3.5 text-left transition-colors flex flex-col gap-1 ${
                    isSelected ? 'bg-[#0F3D3E]/5 border-l-4 border-[#0F3D3E]' : 'hover:bg-slate-50'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <FileCode
                      className={`w-4 h-4 shrink-0 ${
                        isSelected ? 'text-[#0F3D3E]' : 'text-slate-400'
                      }`}
                    />
                    <span
                      className={`font-mono text-xs truncate ${
                        isSelected ? 'font-bold text-[#0F3D3E]' : 'text-slate-700'
                      }`}
                    >
                      {file.path}
                    </span>
                  </div>
                  <span className="text-[11px] text-slate-400 line-clamp-1 pl-6">
                    {file.description}
                  </span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Right Pane: Code View */}
        <div className="lg:col-span-8 bg-slate-900 rounded-3xl overflow-hidden border border-slate-800 shadow-xl flex flex-col">
          {/* File Tab Header */}
          <div className="px-5 py-3.5 bg-slate-950/80 border-b border-slate-800 flex items-center justify-between text-xs">
            <div className="flex items-center gap-2.5">
              <div className="w-2.5 h-2.5 rounded-full bg-emerald-500" />
              <span className="font-mono text-white font-bold">{selectedFile.path}</span>
              <span className="text-[10px] text-slate-400 px-2 py-0.5 rounded bg-slate-800 font-sans">
                {selectedFile.category}
              </span>
            </div>

            <button
              onClick={handleCopy}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold transition-colors"
            >
              {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
              {copied ? 'Copied!' : 'Copy Code'}
            </button>
          </div>

          {/* Description banner */}
          <div className="px-5 py-2.5 bg-slate-900/90 border-b border-slate-800 text-[11px] text-slate-400">
            {selectedFile.description}
          </div>

          {/* Code Body with Line Numbers */}
          <div className="p-5 overflow-x-auto max-h-[580px] overflow-y-auto">
            <pre className="font-mono text-xs leading-relaxed text-slate-200">
              <code>
                {selectedFile.code.split('\n').map((line, i) => (
                  <div key={i} className="table-row">
                    <span className="table-cell pr-4 text-slate-600 select-none text-right font-mono text-[11px]">
                      {i + 1}
                    </span>
                    <span className="table-cell">{line}</span>
                  </div>
                ))}
              </code>
            </pre>
          </div>
        </div>
      </div>
    </div>
  );
};
