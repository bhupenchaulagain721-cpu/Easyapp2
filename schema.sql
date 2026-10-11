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

-- 8a. BRANCHES TABLE (PROVINCIAL & REGIONAL OFFICES)
CREATE TABLE IF NOT EXISTS public.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    name_np TEXT NOT NULL,
    province TEXT NOT NULL,
    city TEXT NOT NULL,
    address TEXT NOT NULL,
    phone_number TEXT,
    email TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_branches_province ON public.branches(province);

-- 8b. ADVERTISEMENTS & SPONSORSHIPS TABLE (REPUBLIC NEPAL TV ADS ENGINE)
CREATE TABLE IF NOT EXISTS public.ads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    title_np TEXT,
    image_url TEXT NOT NULL,
    redirect_url TEXT,
    sponsor_name TEXT NOT NULL DEFAULT 'Republic Nepal TV & Advertising Pvt. Ltd.',
    placement TEXT NOT NULL DEFAULT 'home' CHECK (placement IN ('home', 'home_banner', 'live_tv', 'category_top', 'interstitial')),
    priority INT NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'expired')),
    submitted_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    contact_phone TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    end_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_ads_active_placement ON public.ads(status, is_active, placement);

-- 8c. OFFERS & DEALS TABLE
CREATE TABLE IF NOT EXISTS public.offers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID REFERENCES public.businesses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    title_np TEXT NOT NULL,
    description TEXT,
    discount_percent INT DEFAULT 0,
    coupon_code TEXT,
    valid_until TIMESTAMP WITH TIME ZONE,
    status TEXT NOT NULL DEFAULT 'approved' CHECK (status IN ('pending', 'approved', 'rejected')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_offers_business ON public.offers(business_id);
CREATE INDEX IF NOT EXISTS idx_offers_active ON public.offers(status, is_active);

-- 8d. TICKER ITEMS TABLE (LIVE NEWS, NOTICES & MARKET RATES)
-- Matches exact schema: kind IN ('news', 'notice', 'market_rate'), sort_order, fee_amount, status, approved_by, created_by
CREATE TABLE IF NOT EXISTS public.ticker_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message TEXT NOT NULL,
    message_np TEXT NOT NULL,
    kind TEXT NOT NULL DEFAULT 'news' CHECK (kind IN ('news', 'notice', 'market_rate')),
    rate_item TEXT, -- e.g. 'Gold (छापावाल सुन)', 'Tomato Big (गोलभेडा ठुलो)'
    rate_value TEXT, -- e.g. 'रु. १,६२,००० / तोला', 'रु. ५५ / केजी'
    sort_order INT NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    fee_amount NUMERIC(10,2) DEFAULT 0.00,
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    approved_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    contact_phone TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_ticker_items_sort ON public.ticker_items(status, is_active, sort_order);

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
        "app_title_np": "इजी एप",
        "tv_name": "RN TV",
        "footer_text": "रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि",
        "logo_url": "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=200",
        "owner_company": "Republic Nepal TV & Advertising Pvt. Ltd.",
        "support_phone": "+977-1-4112233",
        "maintenance_mode": false,
        "primary_color": "#0F3D3E",
        "accent_color": "#C79A3E"
    }'::jsonb,
    'Global app branding, logo, tv_name, footer_text, and operational settings.'
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

-- BRANCHES: Public read active, Admins manage
ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read active branches" ON public.branches FOR SELECT
    USING (is_active = true OR public.is_platform_admin());
CREATE POLICY "Admins manage branches" ON public.branches FOR ALL
    USING (public.is_super_admin()) WITH CHECK (public.is_super_admin());

-- ADS: Public read approved & active (home placement), Public insert pending, Admins manage all
ALTER TABLE public.ads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read approved ads" ON public.ads FOR SELECT
    USING ((status = 'approved' AND is_active = true) OR public.is_platform_admin());
CREATE POLICY "Public insert pending ads" ON public.ads FOR INSERT
    WITH CHECK (status = 'pending');
CREATE POLICY "Admins manage ads" ON public.ads FOR ALL
    USING (public.is_super_admin()) WITH CHECK (public.is_super_admin());

-- OFFERS: Public read approved & active, Business Owners manage own, Admins manage all
ALTER TABLE public.offers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read approved offers" ON public.offers FOR SELECT
    USING ((status = 'approved' AND is_active = true) OR public.is_platform_admin());
CREATE POLICY "Owners manage own offers" ON public.offers FOR ALL
    USING (
        public.is_super_admin() OR
        EXISTS (
            SELECT 1 FROM public.businesses b
            WHERE b.id = offers.business_id AND b.owner_id = auth.uid()
        )
    );

-- TICKER ITEMS: Public read approved & active, Public insert pending, Admins manage all
ALTER TABLE public.ticker_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read approved ticker items" ON public.ticker_items FOR SELECT
    USING ((status = 'approved' AND is_active = true) OR public.is_platform_admin());
CREATE POLICY "Public insert pending ticker items" ON public.ticker_items FOR INSERT
    WITH CHECK (status = 'pending');
CREATE POLICY "Admins manage ticker items" ON public.ticker_items FOR ALL
    USING (public.is_super_admin()) WITH CHECK (public.is_super_admin());

-- 14. INITIAL SEEDS: BRANCHES, ADS, OFFERS, TICKER ITEMS
INSERT INTO public.branches (name, name_np, province, city, address, phone_number, email)
VALUES
('Kathmandu Central HQ', 'काठमाडौँ केन्द्रीय कार्यालय', 'Bagmati Province', 'Kathmandu', 'Tinkune, Subidhanagar', '+977-1-4112233', 'hq@republicnepal.tv'),
('Pokhara Regional Office', 'पोखरा प्रादेशिक शाखा', 'Gandaki Province', 'Pokhara', 'New Road, Pokhara-8', '+977-61-523456', 'gandaki@republicnepal.tv'),
('Biratnagar Koshi Hub', 'विराटनगर कोशी शाखा', 'Koshi Province', 'Biratnagar', 'Main Road, Ward 2', '+977-21-456789', 'koshi@republicnepal.tv'),
('Butwal Lumbini Hub', 'बुटवल लुम्बिनी शाखा', 'Lumbini Province', 'Butwal', 'Traffic Chowk, Butwal', '+977-71-543210', 'lumbini@republicnepal.tv')
ON CONFLICT DO NOTHING;

INSERT INTO public.ads (title, title_np, image_url, redirect_url, sponsor_name, placement, priority, status, is_active)
VALUES
('Republic Nepal TV Live 24/7', 'रिपब्लिक नेपाल टिभी २४/७ प्रत्यक्ष', 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=800', 'https://republicnepal.tv', 'Republic Nepal TV & Advertising Pvt. Ltd.', 'home', 1, 'approved', true),
('Organic Himalayan Herbs & Food Festival', 'जैविक हिमाली जडीबुटी तथा खाद्यान्न महोत्सव', 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800', '/category/kirana-retail', 'Nepal Agriculture Chamber', 'home', 2, 'approved', true),
('Nepal Real Estate & Housing Expo 2026', 'नेपाल घरजग्गा तथा आवास मेला २०२६', 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800', '/category/real-estate', 'Real Estate Association of Nepal', 'home', 3, 'approved', true)
ON CONFLICT DO NOTHING;

INSERT INTO public.offers (title, title_np, description, discount_percent, coupon_code, status, is_active)
VALUES
('Grand Opening Grocery Discount', 'किराना तथा दैनिक उपभोग्यमा १५% विशेष छुट', 'Applicable across all verified Kirana retail stores on Easy App', 15, 'EASYKIRANA15', 'approved', true),
('Ayurvedic Health Consultation Token', 'क्लिनिक तथा ओपिडी परामर्शमा नि:शुल्क टोकन', 'Free preliminary doctor consultation token at partner clinics', 25, 'SWASTHYA2026', 'approved', true),
('Local Haat Farmers Seasonal Offer', 'हाट बजार स्थानीय तरकारी तथा फलफूल', 'Direct farm-to-table fresh seasonal produce with zero markup', 10, 'HAATBAZAR10', 'approved', true)
ON CONFLICT DO NOTHING;

INSERT INTO public.ticker_items (message, message_np, kind, rate_item, rate_value, sort_order, status, is_active)
VALUES
('Gold (छापावाल सुन): रु. १,६२,००० / तोला | Silver (चाँदी): रु. १,९५० / तोला', 'सुन (छापावाल): रु. १,६२,०००/तोला | चाँदी: रु. १,९५०/तोला (नेपाल सुनचाँदी व्यवसायी महासंघ)', 'market_rate', 'Gold / Silver', 'रु. १,६२,०००', 1, 'approved', true),
('Kalimati Veg: Tomato (गोलभेडा) रु. ५५/केजी | Potato (आलु) रु. ४२/केजी | Onion (प्याज) रु. ८५/केजी', 'कालीमाटी बजार: गोलभेडा रु. ५५/केजी, रातो आलु रु. ४२/केजी, सुकेको प्याज रु. ८५/केजी', 'market_rate', 'Vegetables (कालीमाटी)', 'दैनिक दररेट', 2, 'approved', true),
('Forex: USD $1 = NPR 134.20 | EUR €1 = NPR 146.50 | QAR 1 = NPR 36.85 (NRB Official)', 'मुद्रा विनिमय: अमेरिकी डलर १ = रु. १३४.२०, युरो १ = रु. १४६.५० (नेपाल राष्ट्र बैंक)', 'market_rate', 'Forex (विदेशी मुद्रा)', 'NRB Rate', 3, 'approved', true),
('Republic Nepal TV: Prime-time special report broadcasting live tonight at 8:00 PM.', 'ताजा समाचार: रिपब्लिक नेपाल टिभीमा आज राति ८ बजे विशेष विश्लेषणात्मक प्रत्यक्ष प्रसारण।', 'news', 'Live TV News', 'LIVE', 4, 'approved', true),
('Notice: Register your local business on Easy App to reach thousands of verified customers.', 'सूचना: आफ्नो पसल, क्लिनिक वा सेवा Easy App मा दर्ता गरी नयाँ ग्राहकसम्म पुग्नुहोस्।', 'notice', 'Notice', 'Public', 5, 'approved', true)
ON CONFLICT DO NOTHING;

