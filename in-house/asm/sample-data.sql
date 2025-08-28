-- Insert Asset Categories
INSERT INTO asset_category_master (sid, name, domain, description) VALUES
(gen_random_uuid(), 'Laptop', 'IT', 'Portable computing devices'),
(gen_random_uuid(), 'Mobile', 'IT', 'Smartphones and tablets'),
(gen_random_uuid(), 'Monitor', 'IT', 'Display units'),
(gen_random_uuid(), 'Software', 'ICT', 'Software licenses');

-- Insert License Categories
INSERT INTO license_category_master (sid, name, domain, description) VALUES
(gen_random_uuid(), 'Antivirus', 'Security', 'Anti-malware tools'),
(gen_random_uuid(), 'Office Suite', 'Productivity', 'Word, Excel, etc.');

-- Insert Asset Types
INSERT INTO asset_type (sid, name, category_sid) VALUES
(gen_random_uuid(), 'Dell Latitude 7420', (SELECT sid FROM asset_category_master WHERE name = 'Laptop')),
(gen_random_uuid(), 'iPhone 15', (SELECT sid FROM asset_category_master WHERE name = 'Mobile'));

-- Insert License Types
INSERT INTO license_type (sid, name, category_sid) VALUES
(gen_random_uuid(), 'Perpetual', (SELECT sid FROM license_category_master WHERE name = 'Office Suite')),
(gen_random_uuid(), 'Subscription', (SELECT sid FROM license_category_master WHERE name = 'Antivirus'));

-- Insert Vendor
INSERT INTO vendor (sid, vendor_id, vendor_name, email, phone_number) VALUES
(gen_random_uuid(), 'VND-001', 'Dell Technologies', 'support@dell.com', '+1-800-123-4567'),
(gen_random_uuid(), 'VND-002', 'Apple Inc.', 'support@apple.com', '+1-800-234-5678');

-- Junction: Vendor - Asset Category
INSERT INTO vendor_asset_category (sid, vendor_sid, asset_category_sid) VALUES
(gen_random_uuid(), (SELECT sid FROM vendor WHERE vendor_id = 'VND-001'), (SELECT sid FROM asset_category_master WHERE name = 'Laptop'));

-- Insert Employee
INSERT INTO employee (sid, employee_id, first_name, last_name, email, is_active) VALUES
(gen_random_uuid(), 'EMP-1001', 'John', 'Doe', 'john.doe@company.com', TRUE),
(gen_random_uuid(), 'EMP-1002', 'Jane', 'Smith', 'jane.smith@company.com', TRUE);

-- Insert Application User
INSERT INTO application_user (sid, email, first_name, last_name, admin) VALUES
(gen_random_uuid(), 'admin@company.com', 'Admin', 'User', TRUE);

-- Insert Asset
INSERT INTO asset (sid, asset_code, asset_status, category_sid, description, serial_number, service_tag, purchase_date, asset_type_sid) VALUES
(gen_random_uuid(), 'AST-001', 'Active', (SELECT sid FROM asset_category_master WHERE name = 'Laptop'), 'Dell Laptop', 'SN123456789', 'ST987654321', '2023-01-15', (SELECT sid FROM asset_type WHERE name = 'Dell Latitude 7420'));

-- Asset Financial
INSERT INTO asset_financial (sid, asset_sid, purchase_cost, invoice_number, purchase_vendor_sid) VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), 1200.00, 'INV-2023-001', (SELECT sid FROM vendor WHERE vendor_id = 'VND-001'));

-- Asset Insurance
INSERT INTO asset_insurance (sid, asset_sid, is_insured, insurance_start_date, insurance_end_date) VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), TRUE, '2023-01-15', '2024-01-15');

-- Laptop
INSERT INTO laptop (sid, asset_sid, laptop_make, laptop_model, processor, ram_capacity, hdd_capacity, os) VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), 'Dell', 'Latitude 7420', 'Intel i7', '16GB', '512GB SSD', 'Windows 11 Pro');

-- Asset Assignment
INSERT INTO asset_assignment (sid, asset_sid, employee_sid, assigned_by, assigned_date) VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), (SELECT sid FROM employee WHERE employee_id = 'EMP-1001'), (SELECT sid FROM application_user WHERE email = 'admin@company.com'), '2023-01-16');

-- Replacement Detail
INSERT INTO replacement_detail (sid, asset_sid, change_date, changed_parts, replacement_cost) VALUES
(gen_random_uuid(), (SELECT sid FROM asset WHERE asset_code = 'AST-001'), '2023-06-20', 'Battery, Keyboard', 150.00);

-- Asset Warranty
INSERT INTO asset_warranty (sid, warranty_id, asset_sid, warranty_partner_sid, warranty_status, warranty_expiry_date) VALUES
(gen_random_uuid(), 'WRT-001', (SELECT sid FROM asset WHERE asset_code = 'AST-001'), (SELECT sid FROM vendor WHERE vendor_id = 'VND-001'), 'Active', '2025-01-15');

-- Warranty AMC
INSERT INTO warranty_amc (sid, asset_warranty_sid, renewal_partner_sid, price) VALUES
(gen_random_uuid(), (SELECT sid FROM asset_warranty WHERE warranty_id = 'WRT-001'), (SELECT sid FROM vendor WHERE vendor_id = 'VND-001'), 200.00);

-- License
INSERT INTO license (sid, license_id, license_name, license_type_sid, vendor_sid, date_of_purchase, license_end_date, quantity, status, invoice_number) VALUES
(gen_random_uuid(), 'LIC-001', 'Microsoft 365', (SELECT sid FROM license_type WHERE name = 'Subscription'), (SELECT sid FROM vendor WHERE vendor_id = 'VND-002'), '2023-01-01', '2024-01-01', 10, 'Active', 'INV-LIC-001');

-- Report
INSERT INTO report (sid, report_name, category, generated_date) VALUES
(gen_random_uuid(), 'Asset Summary Q1', 'Asset', '2023-03-31');