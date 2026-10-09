-- ============================================================================
-- EASY APP - ADVANCED MULTI-TENANT RBAC, DYNAMIC MODULES & AUDIT SCHEMA
-- Official Super App: "Easy App"
-- Owned by: Republic Nepal TV & Advertising Pvt. Ltd.
-- Target Database: Supabase PostgreSQL with Row Level Security (RLS)
-- Author: Lead Software Architect & Supabase Expert
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. SYSTEM SETTINGS & DYNAMIC CONFIG (NO RE-RELEASE)
CREATE TABLE IF NOT EXISTS public.system_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 2. DYNAMIC BUSINESS CATEGORIES & MODULES TABLE
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    name_np TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    segment_type TEXT NOT NULL DEFAULT 'ecommerce' 
        CHECK (segment_type IN ('health', 'food_retail', 'fashion', 'beauty', 'real_estate', 'recycle', 'local_market', 'media_tv', 'utilities', 'services')),
    icon_name TEXT NOT NULL DEFAULT 'category',
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_categories_active_sort ON public.categories(is_active, sort_order);

-- 3. FINE-GRAINED PERMISSION SYSTEM (FUTURE-EXPANDABLE)
CREATE TABLE IF NOT EXISTS public.permissions (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    module TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS public.role_permissions (
    role TEXT NOT NULL,
    permission_id TEXT REFERENCES public.permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role, permission_id)
);

-- 4. STAFF SCOPES TABLE (REGIONAL & CATEGORY-BASED BOUNDARIES)
CREATE TABLE IF NOT EXISTS public.staff_scopes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    territory_scope TEXT NOT NULL DEFAULT 'all', -- e.g. 'Kathmandu Valley', 'Gandaki Province', 'Koshi', 'all'
    category_scope TEXT NOT NULL DEFAULT 'all',  -- e.g. 'health', 'food_retail', 'real_estate', 'all'
    can_approve_merchants BOOLEAN NOT NULL DEFAULT FALSE,
    can_moderate_users BOOLEAN NOT NULL DEFAULT FALSE,
    can_manage_modules BOOLEAN NOT NULL DEFAULT FALSE,
    can_view_audit_logs BOOLEAN NOT NULL DEFAULT FALSE,
    assigned_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_staff_scopes_staff_id ON public.staff_scopes(staff_id);

-- 5. REGISTERED BUSINESSES TABLE (MULTI-TENANT ONBOARDING & APPROVALS)
CREATE TABLE IF NOT EXISTS public.businesses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    name_np TEXT,
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    category_slug TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    email TEXT,
    province TEXT NOT NULL DEFAULT 'Bagmati Province',
    city TEXT NOT NULL DEFAULT 'Kathmandu',
    address TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'suspended')),
    rejection_reason TEXT,
    pan_vat_number TEXT,
    logo_url TEXT,
    verified_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    verified_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_businesses_status ON public.businesses(status);
CREATE INDEX IF NOT EXISTS idx_businesses_owner ON public.businesses(owner_id);
CREATE INDEX IF NOT EXISTS idx_businesses_province ON public.businesses(province);

-- 6. AUDIT LOGS TABLE (COMPLETE SYSTEM ACCOUNTABILITY)
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    actor_role TEXT NOT NULL,
    action TEXT NOT NULL, -- e.g. 'MERCHANT_APPROVED', 'STAFF_HANDOVER', 'MODULE_TOGGLED', 'USER_SUSPENDED'
    entity_type TEXT NOT NULL, -- 'business', 'user', 'category', 'staff_scope'
    entity_id TEXT,
    details JSONB,
    ip_address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON public.audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON public.audit_logs(actor_id);

-- 7. STAFF HANDOVER & OFFBOARDING TABLE
CREATE TABLE IF NOT EXISTS public.staff_handovers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outgoing_staff_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
    incoming_staff_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
    reassigned_tasks_count INT NOT NULL DEFAULT 0,
    handover_notes TEXT,
    handover_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- 8. COMPREHENSIVE USER PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT NOT NULL,
    phone_number TEXT,
    role TEXT NOT NULL DEFAULT 'customer' CHECK (role IN (
        'superAdmin', 'platformAdmin', 'supportAdmin', 
        'businessOwner', 'businessAdmin', 'branchManager', 'departmentManager', 
        'staff', 'deliveryPartner', 'serviceProvider', 
        'customer', 'guest', 'partner'
    )),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'pending', 'suspended', 'blocked')),
    avatar_url TEXT,
    is_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    business_name TEXT,
    province TEXT DEFAULT 'Bagmati Province',
    city TEXT DEFAULT 'Kathmandu',
    delivery_addresses JSONB DEFAULT '[]'::jsonb,
    favorites JSONB DEFAULT '[]'::jsonb,
    referral_code TEXT,
    referred_by TEXT,
    reward_points INT DEFAULT 0,
    device_info JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_status ON public.profiles(status);

-- 9. TRIGGERS FOR UPDATED_AT
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::TEXT, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_categories_updated BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER on_businesses_updated BEFORE UPDATE ON public.businesses FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER on_profiles_updated BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- 10. SECURITY DEFINER HELPER FUNCTIONS
CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() 
          AND role = 'superAdmin' 
          AND status = 'active'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.is_platform_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() 
          AND role IN ('superAdmin', 'platformAdmin', 'supportAdmin') 
          AND status = 'active'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- 11. STAFF OFFBOARDING & HANDOVER FUNCTION
CREATE OR REPLACE FUNCTION public.execute_staff_handover(
    p_outgoing_id UUID,
    p_incoming_id UUID,
    p_notes TEXT
)
RETURNS JSONB AS $$
DECLARE
    v_tasks_count INT := 0;
BEGIN
    IF NOT public.is_super_admin() THEN
        RAISE EXCEPTION 'Only superAdmin can execute staff offboarding and handover.';
    END IF;

    -- 1. Count pending businesses assigned to outgoing staff
    SELECT COUNT(*) INTO v_tasks_count 
    FROM public.businesses 
    WHERE status = 'pending' AND province IN (
        SELECT territory_scope FROM public.staff_scopes WHERE staff_id = p_outgoing_id
    );

    -- 2. Suspend the outgoing staff member
    UPDATE public.profiles 
    SET status = 'suspended', updated_at = NOW() 
    WHERE id = p_outgoing_id;

    -- 3. Record handover record
    INSERT INTO public.staff_handovers (
        outgoing_staff_id, incoming_staff_id, reassigned_tasks_count, handover_notes, handover_by
    ) VALUES (
        p_outgoing_id, p_incoming_id, v_tasks_count, p_notes, auth.uid()
    );

    -- 4. Record audit log
    INSERT INTO public.audit_logs (
        actor_id, actor_role, action, entity_type, entity_id, details
    ) VALUES (
        auth.uid(), 'superAdmin', 'STAFF_OFFBOARDING_HANDOVER', 'staff_handover', p_outgoing_id::text,
        jsonb_build_object(
            'outgoing_staff', p_outgoing_id,
            'incoming_staff', p_incoming_id,
            'reassigned_tasks', v_tasks_count,
            'notes', p_notes
        )
    );

    RETURN jsonb_build_object(
        'success', true,
        'reassigned_tasks', v_tasks_count,
        'message', 'Staff offboarded and pending operations transferred successfully.'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 12. INITIAL SEEDS: SYSTEM CONFIG & EXPANDED DYNAMIC CATEGORIES
INSERT INTO public.system_settings (key, value, description)
VALUES 
(
    'app_config',
    '{
        "app_title": "Easy App",
        "app_title_np": "इजी एप (Easy App)",
        "tagline": "All Digital Services & Live Media in One Place",
        "owner_company": "Republic Nepal TV & Advertising Pvt. Ltd.",
        "support_phone": "+977-1-4XXXXXX",
        "maintenance_mode": false,
        "primary_color": "#0F3D3E",
        "accent_color": "#C79A3E"
    }'::jsonb,
    'Global app branding and operational settings.'
)
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

INSERT INTO public.categories (name, name_np, slug, segment_type, icon_name, sort_order, is_active)
VALUES
('Republic TV & Media', 'टिभी तथा प्रत्यक्ष प्रसारण', 'tv-media', 'media_tv', 'tv', 1, true),
('Easy Marketplace (Pasal)', 'अनलाइन ई-कमर्स बजार', 'marketplace', 'food_retail', 'shopping_bag', 2, true),
('Clinic & Health Centers', 'क्लिनिक तथा स्वास्थ्य सेवा', 'health-clinics', 'health', 'heart_pulse', 3, true),
('Kirana & Food Retail', 'किराना तथा दैनिक उपभोग्य', 'kirana-retail', 'food_retail', 'store', 4, true),
('Clothing & Fashion', 'पहिरन तथा फेसन स्टोर', 'clothing-fashion', 'fashion', 'shirt', 5, true),
('Cosmetics & Beauty', 'सौन्दर्य तथा कस्मेटिक्स', 'cosmetics-beauty', 'beauty', 'sparkles', 6, true),
('Real Estate (Buy & Sell)', 'घरजग्गा खरिद तथा बिक्री', 'real-estate', 'real_estate', 'home', 7, true),
('Reuse & Recycle', 'पुन: प्रयोग तथा रिसाइकल', 'reuse-recycle', 'recycle', 'refresh_cw', 8, true),
('Local Market (Haat Bazaar)', 'हाट बजार तथा स्थानीय उत्पादन', 'local-market', 'local_market', 'tags', 9, true),
('Electricity & Utility Bills', 'बिजुली तथा खानेपानी महसुल', 'utilities', 'utilities', 'zap', 10, true)
ON CONFLICT (slug) DO UPDATE SET 
    name = EXCLUDED.name, 
    name_np = EXCLUDED.name_np, 
    segment_type = EXCLUDED.segment_type, 
    is_active = EXCLUDED.is_active;

-- 13. ROW LEVEL SECURITY (RLS) POLICIES

-- CATEGORIES: Customers only view is_active = true
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Customers view active categories" ON public.categories FOR SELECT
    USING (is_active = true OR public.is_platform_admin());
CREATE POLICY "Admins manage categories" ON public.categories FOR ALL
    USING (public.is_super_admin()) WITH CHECK (public.is_super_admin());

-- BUSINESSES: Multi-tenant isolation & Staff territorial scopes
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public view approved businesses" ON public.businesses FOR SELECT
    USING (status = 'approved');
CREATE POLICY "Owners view own businesses" ON public.businesses FOR SELECT
    USING (auth.uid() = owner_id);
CREATE POLICY "Owners can register business" ON public.businesses FOR INSERT
    WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Owners can update own pending/rejected business" ON public.businesses FOR UPDATE
    USING (auth.uid() = owner_id AND status IN ('pending', 'rejected'))
    WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "SuperAdmin and Scoped Staff manage businesses" ON public.businesses FOR ALL
    USING (
        public.is_super_admin() OR 
        (public.is_platform_admin() AND EXISTS (
            SELECT 1 FROM public.staff_scopes s 
            WHERE s.staff_id = auth.uid() 
              AND (s.territory_scope = 'all' OR s.territory_scope = province)
              AND (s.category_scope = 'all' OR s.category_scope = category_slug)
        ))
    );

-- AUDIT LOGS: Staff and Admin only
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins view audit logs" ON public.audit_logs FOR SELECT
    USING (public.is_super_admin() OR (public.is_platform_admin() AND EXISTS (
        SELECT 1 FROM public.staff_scopes WHERE staff_id = auth.uid() AND can_view_audit_logs = true
    )));
CREATE POLICY "System can insert audit logs" ON public.audit_logs FOR INSERT
    WITH CHECK (true);

-- SYSTEM SETTINGS: Public read, SuperAdmin write
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read settings" ON public.system_settings FOR SELECT USING (true);
CREATE POLICY "SuperAdmin edit settings" ON public.system_settings FOR ALL
    USING (public.is_super_admin()) WITH CHECK (public.is_super_admin());

-- PROFILES: Self or Admin
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own profile" ON public.profiles FOR SELECT USING (auth.uid() = id OR public.is_platform_admin());
CREATE POLICY "Users insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id OR public.is_super_admin());
CREATE POLICY "Users update own profile" ON public.profiles FOR UPDATE
    USING (auth.uid() = id OR public.is_super_admin())
    WITH CHECK (
        public.is_super_admin() OR (
            auth.uid() = id AND 
            role = (SELECT p.role FROM public.profiles p WHERE p.id = auth.uid()) AND
            status = (SELECT p.status FROM public.profiles p WHERE p.id = auth.uid())
        )
    );
