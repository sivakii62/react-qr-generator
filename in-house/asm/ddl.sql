-- =============================
-- Asset Category (e.g., IT, Non-IT)
-- =============================
CREATE TABLE asset_category_master (
    sid UUID PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    domain VARCHAR(50) NOT NULL,
    description TEXT
);

-- =============================
-- License Category
-- =============================
CREATE TABLE license_category_master (
    sid UUID PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    domain VARCHAR(50) NOT NULL,
    description TEXT
);

-- =============================
-- Asset Type (e.g., Laptop, Monitor)
-- =============================
CREATE TABLE asset_type (
    sid UUID PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    category_sid UUID REFERENCES asset_category_master(sid)
);

-- =============================
-- License Type (e.g., Laptop, Monitor)
-- =============================
CREATE TABLE license_type (
    sid UUID PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    category_sid UUID REFERENCES license_category_master(sid)
);

-- =============================
-- Vendor (suppliers, warranty partners)
-- =============================
CREATE TABLE vendor (
    sid UUID PRIMARY KEY,
    vendor_id VARCHAR(255) UNIQUE NOT NULL,
    vendor_name VARCHAR(50),
    contact_person VARCHAR(100),
    email VARCHAR(120),
    phone_number VARCHAR(50),
    location TEXT,
    remarks TEXT,
    asset_category_sid UUID REFERENCES asset_category_master(sid),
    license_category_sid UUID REFERENCES license_category_master(sid)
);

-- =============================
-- Employee (users who own or use assets)
-- =============================
CREATE TABLE employee (
    sid UUID PRIMARY KEY,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(120),
    is_active BOOLEAN
);

-- =============================
-- Application User (system login accounts)
-- =============================
CREATE TABLE application_user (
    sid UUID PRIMARY KEY,
    email VARCHAR(120) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    user_roles TEXT,
    admin BOOLEAN DEFAULT FALSE,
    app_admin BOOLEAN DEFAULT FALSE,
    finance BOOLEAN DEFAULT FALSE,
    ict BOOLEAN DEFAULT FALSE
);

-- =============================
-- Core Asset Table (main entity)
-- =============================
CREATE TABLE asset (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL,
    asset_status VARCHAR(100),
    category_sid UUID REFERENCES asset_category_master(sid),
    description TEXT,
    serial_number VARCHAR(50) UNIQUE,
    service_tag VARCHAR(50),
    purchase_date DATE,
    scrapped_date DATE,
    asset_type_name VARCHAR(255) REFERENCES asset_type(name)
);

-- =============================
-- Asset Financial Details (purchase info)
-- =============================
CREATE TABLE asset_financial (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL REFERENCES asset(asset_code),
    purchase_cost DOUBLE PRECISION,
    residual_value DOUBLE PRECISION,
    depreciation_rate DOUBLE PRECISION,
    invoice_number VARCHAR(50),
    purchase_vendor_id VARCHAR(255) REFERENCES vendor(vendor_id),
    financial_category_sid UUID REFERENCES asset_category_master(sid)
);

-- =============================
-- Asset Insurance Details
-- =============================
CREATE TABLE asset_insurance (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL REFERENCES asset(asset_code),
    is_insured BOOLEAN,
    insurance_start_date DATE,
    insurance_end_date DATE,
    notification_required BOOLEAN
);

-- =============================
-- Subtype: Laptop
-- =============================
CREATE TABLE laptop (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL REFERENCES asset(asset_code),
    laptop_make VARCHAR(50),
    laptop_model VARCHAR(50),
    processor VARCHAR(50),
    ram_capacity VARCHAR(50),
    hdd_capacity VARCHAR(50),
    os VARCHAR(50),
    host_name VARCHAR(50),
    charger_code VARCHAR(50),
    stoptrack VARCHAR(50)
);

-- =============================
-- Subtype: Mobile
-- =============================
CREATE TABLE mobile (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL REFERENCES asset(asset_code),
    brand VARCHAR(50),
    model VARCHAR(50),
    os VARCHAR(50),
    imei_number VARCHAR(50),
    sim_card_number VARCHAR(50),
    storage_capacity VARCHAR(50)
);

-- =============================
-- Subtype: Monitor
-- =============================
CREATE TABLE monitor (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL REFERENCES asset(asset_code),
    monitor_make VARCHAR(50),
    model VARCHAR(50),
    screen_size VARCHAR(50),
    current_work_station_place VARCHAR(50)
);

-- =============================
-- Subtype: Accessory
-- =============================
CREATE TABLE accessory (
    sid UUID PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL REFERENCES asset(asset_code),
    model VARCHAR(50),
    specification TEXT,
    remarks TEXT
);

-- =============================
-- License (software license)
-- =============================
CREATE TABLE license (
    sid UUID PRIMARY KEY,
    license_id VARCHAR(100) UNIQUE NOT NULL,
    license_name VARCHAR(100),
    license_type VARCHAR(50) REFERENCES license_type(name),
    vendor_id VARCHAR(255) REFERENCES vendor(vendor_id),
    vendor_name VARCHAR(50),
    vendor_email VARCHAR(120),
    date_of_purchase DATE,
    date_of_activation DATE,
    license_end_date DATE,
    renewal_interval BIGINT,
    renewal_term_type VARCHAR(255),
    quantity BIGINT,
    status VARCHAR(255),
    notification_required BOOLEAN,
    invoice_number VARCHAR(50),
    licensed_to_email VARCHAR(120)
);

-- =============================
-- Asset Assignments (history of who was assigned an asset)
-- =============================
CREATE TABLE asset_assignment (
    sid UUID PRIMARY KEY,
    asset_sid UUID NOT NULL REFERENCES asset(sid),
    employee_sid UUID NOT NULL REFERENCES employee(sid),
    assigned_by UUID REFERENCES application_user(sid),
    approved_by UUID REFERENCES employee(sid),
    assigned_date DATE NOT NULL,
    return_date DATE,
    reason_of_return TEXT,
    remarks TEXT
);

-- =============================
-- Replacement Details (maintenance log)
-- =============================
CREATE TABLE replacement_detail (
    sid UUID PRIMARY KEY,
    replacement_id BIGSERIAL UNIQUE NOT NULL,
    asset_code VARCHAR(50) NOT NULL REFERENCES asset(asset_code),
    change_date DATE,
    changed_parts TEXT,
    replacement_cost DOUBLE PRECISION,
    remarks TEXT
);

-- =============================
-- Asset Warranty Details
-- =============================
CREATE TABLE asset_warranty (
    sid UUID PRIMARY KEY,
    warranty_id VARCHAR(100) UNIQUE NOT NULL,
    asset_sid UUID NOT NULL REFERENCES asset(sid) UNIQUE,
    warranty_partner_sid UUID REFERENCES vendor(sid),
    warranty_status VARCHAR(50),
    warranty_expiry_date DATE
);

-- =============================
-- Warranty AMC Renewals
-- =============================
CREATE TABLE warranty_amc (
    sid UUID PRIMARY KEY,
    asset_warranty_sid UUID NOT NULL REFERENCES asset_warranty(sid),
    renewal_partner_sid UUID NOT NULL REFERENCES vendor(sid),
    price DOUBLE PRECISION
);

-- =============================
-- Reports
-- =============================
CREATE TABLE report (
    sid UUID PRIMARY KEY,
    report_name VARCHAR(100),
    category VARCHAR(50),
    generated_date DATE
);