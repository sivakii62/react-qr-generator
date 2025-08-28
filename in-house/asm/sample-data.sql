-- =====================================
-- 1. Financial Category (Master)
-- =====================================
INSERT INTO financial_category_master (sid, name) VALUES
(gen_random_uuid(), 'Computer Hardware'),
(gen_random_uuid(), 'Computer Software'),
(gen_random_uuid(), 'License'),
(gen_random_uuid(), 'Admin-Items');

-- =====================================
-- 2. Asset Category Master (IT / NON-IT only)
-- =====================================
INSERT INTO asset_category_master (sid, name, description) VALUES
(gen_random_uuid(), 'IT', 'Information Technology assets'),
(gen_random_uuid(), 'NON-IT', 'Non-IT office or facility assets');

-- =====================================
-- 3. License Category Master (IT / NON-IT only)
-- =====================================
INSERT INTO license_category_master (sid, name, description) VALUES
(gen_random_uuid(), 'IT', 'Software/licenses for IT use'),
(gen_random_uuid(), 'NON-IT', 'Licenses for non-IT systems (e.g., HVAC, security)');

-- =====================================
-- 4. Asset Types (under IT category)
-- =====================================
WITH it_cat AS (SELECT sid FROM asset_category_master WHERE name = 'IT')
INSERT INTO asset_type (sid, name, category_sid) VALUES
(gen_random_uuid(), 'Laptop', (SELECT sid FROM it_cat)),
(gen_random_uuid(), 'Mobile', (SELECT sid FROM it_cat)),
(gen_random_uuid(), 'Monitor', (SELECT sid FROM it_cat)),
(gen_random_uuid(), 'Accessory', (SELECT sid FROM it_cat));

-- =====================================
-- 5. License Types (under IT license category)
-- =====================================
WITH it_lic_cat AS (SELECT sid FROM license_category_master WHERE name = 'IT')
INSERT INTO license_type (sid, name, category_sid) VALUES
(gen_random_uuid(), 'Microsoft 365 E3', (SELECT sid FROM it_lic_cat)),
(gen_random_uuid(), 'Adobe Creative Cloud', (SELECT sid FROM it_lic_cat)),
(gen_random_uuid(), 'Windows Server License', (SELECT sid FROM it_lic_cat)),
(gen_random_uuid(), 'Figma Team License', (SELECT sid FROM it_lic_cat));

-- =====================================
-- 6. Vendors
-- =====================================
INSERT INTO vendor (sid, vendor_id, vendor_name, contact_person, email, phone_number, location) VALUES
(gen_random_uuid(), 'VND-001', 'Dell Technologies', 'Sarah Johnson', 'sarah.dell@del.com', '+1-800-123-4567', 'Round Rock, TX, USA'),
(gen_random_uuid(), 'VND-002', 'Apple Inc.', 'Mark Liu', 'mark@apple.com', '+1-800-234-5678', 'Cupertino, CA, USA'),
(gen_random_uuid(), 'VND-003', 'Microsoft Corporation', 'Linda Chen', 'linda@microsoft.com', '+1-800-345-6789', 'Redmond, WA, USA'),
(gen_random_uuid(), 'VND-004', 'HP Inc.', 'Robert Kim', 'robert@hp.com', '+1-800-456-7890', 'Palo Alto, CA, USA'),
(gen_random_uuid(), 'VND-005', 'Logitech', 'Emma White', 'emma@logitech.com', '+41-21-123-4567', 'Lausanne, Switzerland');

-- =====================================
-- 7. Junction: Vendor - Asset Type
-- =====================================
-- Dell supplies Dell laptops
INSERT INTO vendor_asset_type (sid, vendor_sid, asset_type_sid)
SELECT gen_random_uuid(), v.sid, at.sid
FROM vendor v, asset_type at
WHERE v.vendor_name = 'Dell Technologies' AND at.name = 'Laptop';

-- Apple supplies MacBook
INSERT INTO vendor_asset_type (sid, vendor_sid, asset_type_sid)
SELECT gen_random_uuid(), v.sid, at.sid
FROM vendor v, asset_type at
WHERE v.vendor_name = 'Apple Inc.' AND at.name = 'Laptop';

-- HP supplies monitors
INSERT INTO vendor_asset_type (sid, vendor_sid, asset_type_sid)
SELECT gen_random_uuid(), v.sid, at.sid
FROM vendor v, asset_type at
WHERE v.vendor_name = 'HP Inc.' AND at.name IN ('Monitor');

-- Logitech supplies accessories
INSERT INTO vendor_asset_type (sid, vendor_sid, asset_type_sid)
SELECT gen_random_uuid(), v.sid, at.sid
FROM vendor v, asset_type at
WHERE v.vendor_name = 'Logitech' AND at.name = 'Accessory';

-- =====================================
-- 8. Junction: Vendor - License Type
-- =====================================
INSERT INTO vendor_license_type (sid, vendor_sid, license_type_sid)
SELECT gen_random_uuid(), v.sid, lt.sid
FROM vendor v, license_type lt
WHERE v.vendor_name = 'Microsoft Corporation' AND lt.name = 'Microsoft 365 E3';

INSERT INTO vendor_license_type (sid, vendor_sid, license_type_sid)
SELECT gen_random_uuid(), v.sid, lt.sid
FROM vendor v, license_type lt
WHERE v.vendor_name = 'Adobe' AND lt.name = 'Adobe Creative Cloud';

-- Fallback: Microsoft also sells Windows Server
INSERT INTO vendor_license_type (sid, vendor_sid, license_type_sid)
SELECT gen_random_uuid(), v.sid, lt.sid
FROM vendor v, license_type lt
WHERE v.vendor_name = 'Microsoft Corporation' AND lt.name = 'Windows Server License';

-- =====================================
-- 9. Employees
-- =====================================
INSERT INTO employee (sid, employee_id, first_name, last_name, email, is_active) VALUES
(gen_random_uuid(), 'EMP-1001', 'Alice', 'Johnson', 'alice.johnson@company.com', TRUE),
(gen_random_uuid(), 'EMP-1002', 'Bob', 'Smith', 'bob.smith@company.com', TRUE),
(gen_random_uuid(), 'EMP-1003', 'Carol', 'Taylor', 'carol.taylor@company.com', TRUE),
(gen_random_uuid(), 'EMP-1004', 'David', 'Wong', 'david.wong@company.com', TRUE),
(gen_random_uuid(), 'EMP-1005', 'Eva', 'Martinez', 'eva.martinez@company.com', FALSE); -- Inactive

-- =====================================
-- 10. Application Users
-- =====================================
INSERT INTO application_user (sid, email, first_name, last_name, admin, ict, finance) VALUES
(gen_random_uuid(), 'admin@company.com', 'Admin', 'User', TRUE, TRUE, TRUE),
(gen_random_uuid(), 'ict@company.com', 'Sam', 'Chen', FALSE, TRUE, FALSE),
(gen_random_uuid(), 'finance@company.com', 'Linda', 'Moore', FALSE, FALSE, TRUE);

-- =====================================
-- 11. Core Assets (IT examples)
-- =====================================
-- Laptop 1: Dell
WITH dell_type AS (SELECT sid FROM asset_type WHERE name = 'Laptop'),
     dell_vendor AS (SELECT sid FROM vendor WHERE vendor_name = 'Dell Technologies'),
     fin_hw AS (SELECT sid FROM financial_category_master WHERE name = 'Computer Hardware')
INSERT INTO asset (sid, asset_code, asset_status, description, serial_number, service_tag, purchase_date, asset_type_sid)
VALUES
(gen_random_uuid(), 'AST-001', 'Active', 'Dell Laptop for Dev Team', 'SN1001', 'ST1001', '2023-01-10', (SELECT sid FROM dell_type));

-- MacBook
WITH mb_type AS (SELECT sid FROM asset_type WHERE name = 'Laptop')
INSERT INTO asset (sid, asset_code, asset_status, description, serial_number, service_tag, purchase_date, asset_type_sid)
VALUES
(gen_random_uuid(), 'AST-002', 'Active', 'MacBook for Design Team', 'SN1002', 'ST1002', '2023-02-15', (SELECT sid FROM mb_type));

-- Monitor 1
WITH hp_mon_type AS (SELECT sid FROM asset_type WHERE name = 'Monitor')
INSERT INTO asset (sid, asset_code, asset_status, description, serial_number, service_tag, purchase_date, asset_type_sid)
VALUES
(gen_random_uuid(), 'AST-003', 'In Stock', 'HP Monitor - Spare', 'SN1003', 'ST1003', '2023-03-01', (SELECT sid FROM hp_mon_type));

-- Monitor 2
WITH dell_mon_type AS (SELECT sid FROM asset_type WHERE name = 'Monitor')
INSERT INTO asset (sid, asset_code, asset_status, description, serial_number, service_tag, purchase_date, asset_type_sid)
VALUES
(gen_random_uuid(), 'AST-004', 'Assigned', 'High-res monitor for Alice', 'SN1004', 'ST1004', '2023-03-05', (SELECT sid FROM dell_mon_type));

-- Mouse (Accessory)
WITH mouse_type AS (SELECT sid FROM asset_type WHERE name = 'Accessory')
INSERT INTO asset (sid, asset_code, asset_status, description, serial_number, purchase_date, asset_type_sid)
VALUES
(gen_random_uuid(), 'AST-005', 'Assigned', 'Wireless mouse for Bob', 'SN1005', '2023-04-01', (SELECT sid FROM mouse_type));

-- =====================================
-- 12. Asset Financial
-- =================================----
WITH hw_cat AS (SELECT sid FROM financial_category_master WHERE name = 'Computer Hardware'),
     sw_cat AS (SELECT sid FROM financial_category_master WHERE name = 'Computer Software'),
     dell_vendor AS (SELECT sid FROM vendor WHERE vendor_name = 'Dell Technologies'),
     apple_vendor AS (SELECT sid FROM vendor WHERE vendor_name = 'Apple Inc.'),
     hp_vendor AS (SELECT sid FROM vendor WHERE vendor_name = 'HP Inc.'),
     logi_vendor AS (SELECT sid FROM vendor WHERE vendor_name = 'Logitech')
INSERT INTO asset_financial (sid, asset_sid, purchase_cost, residual_value, depreciation_rate, invoice_number, purchase_vendor_sid, financial_category)
VALUES
-- Dell Laptop
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), 1200.00, 300.00, 22.5, 'INV-DLL-2023-001', (SELECT sid FROM dell_vendor), (SELECT sid FROM hw_cat)),
-- MacBook
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-002'), 2399.00, 600.00, 20.0, 'INV-APL-2023-002', (SELECT sid FROM apple_vendor), (SELECT sid FROM hw_cat)),
-- HP Monitor
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-003'), 199.99, 50.00, 25.0, 'INV-HP-2023-003', (SELECT sid FROM hp_vendor), (SELECT sid FROM hw_cat)),
-- Dell Monitor
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-004'), 550.00, 150.00, 20.0, 'INV-DELLMON-2023-004', (SELECT sid FROM dell_vendor), (SELECT sid FROM hw_cat)),
-- Mouse
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-005'), 99.99, 25.00, 30.0, 'INV-LOGI-2023-005', (SELECT sid FROM logi_vendor), (SELECT sid FROM hw_cat));

-- =====================================
-- 13. Asset Insurance
-- =====================================
INSERT INTO asset_insurance (sid, asset_sid, is_insured, insurance_start_date, insurance_end_date, notification_required)
VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), TRUE, '2023-01-10', '2024-01-10', TRUE),
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-002'), TRUE, '2023-02-15', '2024-02-15', TRUE),
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-003'), FALSE, NULL, NULL, FALSE);

-- =====================================
-- 14. Subtype Tables
-- =====================================

-- Laptop
INSERT INTO laptop (sid, asset_sid, laptop_make, laptop_model, processor, ram_capacity, hdd_capacity, os, host_name, charger_code)
VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), 'Dell', 'Latitude 7420', 'Intel i7-1165G7', '16GB', '512GB SSD', 'Windows 11 Pro', 'DL-CH-001', 'CH-001'),
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-002'), 'Apple', 'MacBook Pro 14"', 'Apple M2', '16GB', '1TB SSD', 'macOS Ventura', 'MBP-CH-002', 'STOP123XYZ');

-- Monitor
INSERT INTO monitor (sid, asset_sid, monitor_make, model, screen_size, current_work_station_place)
VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-003'), 'HP', '24es', '23.8"', 'Storage Room'),
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-004'), 'Dell', 'U2723QE', '27"', 'Workstation 05');

-- Accessory
INSERT INTO accessory (sid, asset_sid, model, specification, remarks)
VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-005'), 'MX Master 3', 'Wireless, Ergonomic, Bluetooth', 'Assigned to Bob');

-- Mobile (Optional, if used later)
-- Not inserted here unless needed

-- =====================================
-- 15. Licenses
-- =====================================
WITH m365_type AS (SELECT sid FROM license_type WHERE name = 'Microsoft 365 E3'),
     m365_vendor AS (SELECT sid FROM vendor WHERE vendor_name = 'Microsoft Corporation'),
     lic_cat AS (SELECT sid FROM financial_category_master WHERE name = 'License')
INSERT INTO license (sid, license_id, license_name, license_type_sid, vendor_sid, date_of_purchase, license_end_date, renewal_interval, renewal_term_type, quantity, status, notification_required, invoice_number, financial_category, licensed_to_email)
VALUES
(gen_random_uuid(), 'LIC-1001', 'Microsoft 365 Enterprise E3', (SELECT sid FROM m365_type), (SELECT sid FROM m365_vendor), '2023-01-01', '2024-01-01', 12, 'Monthly', 10, 'Active', TRUE, 'INV-LIC-M365-001', (SELECT sid FROM lic_cat), 'alice.johnson@company.com'),
(gen_random_uuid(), 'LIC-1002', 'Adobe Creative Cloud', NULL, NULL, '2023-02-01', '2024-02-01', 12, 'Yearly', 5, 'Active', TRUE, 'INV-LIC-ADB-002', (SELECT sid FROM lic_cat), 'carol.taylor@company.com');

-- =====================================
-- 16. Asset Assignments
-- =====================================
INSERT INTO asset_assignment (sid, asset_sid, employee_sid, assigned_by, approved_by, assigned_date, remarks)
VALUES
-- AST-001 → Alice
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1001'), (SELECT sid FROM application_user WHERE email = 'admin@company.com'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1001'), '2023-01-12', 'Development use'),
-- AST-004 → Bob
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-004'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1002'), (SELECT sid FROM application_user WHERE email = 'ict@company.com'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1002'), '2023-03-06', 'High-res display for design'),
-- AST-005 → Bob
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-005'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1002'), (SELECT sid FROM application_user WHERE email = 'ict@company.com'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1002'), '2023-04-02', 'Ergonomic upgrade');

-- =====================================
-- 17. Replacement Details
-- =====================================
INSERT INTO replacement_detail (sid, replacement_id, pid, change_date, changed_parts, replacement_cost, remarks)
VALUES
(gen_random_uuid(), 'REP-001', (SELECT sid FROM asset WHERE asset_code = 'AST-001'), '2023-08-10', 'Battery Replacement', 120.00, 'Warranty-covered'),
(gen_random_uuid(), 'REP-002', (SELECT sid FROM asset WHERE asset_code = 'AST-002'), '2023-09-05', 'Screen Repair', 450.00, 'Out of warranty');

-- =====================================
-- 18. Warranty AMC
-- =====================================
INSERT INTO warranty_amc (sid, warranty_code, pid, warranty_partner_sid, renewal_partner_sid, warranty_status, warranty_expiry_date, price)
VALUES
(gen_random_uuid(), 'WRT-AMC-001', (SELECT sid FROM asset WHERE asset_code = 'AST-001'), (SELECT sid FROM vendor WHERE vendor_name = 'Dell Technologies'), (SELECT sid FROM vendor WHERE vendor_name = 'Dell Technologies'), 'Active', '2025-01-10', 180.00),
(gen_random_uuid(), 'WRT-AMC-002', (SELECT sid FROM asset WHERE asset_code = 'AST-002'), (SELECT sid FROM vendor WHERE vendor_name = 'Apple Inc.'), (SELECT sid FROM vendor WHERE vendor_name = 'Apple Inc.'), 'Active', '2025-02-15', 250.00);

-- =====================================
-- 19. Reports
-- =====================================
INSERT INTO report (sid, report_name, category, generated_date) VALUES
(gen_random_uuid(), 'Q1 Asset Summary', 'Asset', '2023-03-31'),
(gen_random_uuid(), 'License Compliance Report', 'License', '2023-06-30'),
(gen_random_uuid(), 'Depreciation Forecast 2023', 'Finance', '2023-12-01');