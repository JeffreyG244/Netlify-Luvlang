-- Luvlang Executive Seed Profiles - Clean Version
-- This script creates realistic executive profiles for all major cities

-- Clean up any existing seed data first
DELETE FROM dating_preferences WHERE user_id LIKE 'seed-%';
DELETE FROM professional_info WHERE user_id LIKE 'seed-%';
DELETE FROM profiles WHERE id LIKE 'seed-%';

-- Insert realistic executive profiles
INSERT INTO profiles (
  id, first_name, last_name, age, location, job_title, company, bio, 
  interests, education, membership_type, 
  profile_complete, is_active, created_at, updated_at
) VALUES

-- Technology Professionals
('seed-tech-001', 'Alexandra', 'Chen', 32, 'San Francisco, CA', 'VP of Product', 'Meta', 'Product leader passionate about building experiences that connect people. Stanford MBA, love hiking in Marin and trying new restaurants in the Mission.', ARRAY['Technology', 'Hiking', 'Wine Tasting', 'Travel', 'Photography'], 'Stanford MBA, UC Berkeley BS Computer Science', 'premium', true, true, NOW(), NOW()),

('seed-tech-002', 'Marcus', 'Rodriguez', 35, 'Palo Alto, CA', 'Venture Partner', 'Andreessen Horowitz', 'Early-stage investor focused on AI and fintech. Former founder who exited to Google. Love sailing on the Bay and exploring Napa Valley.', ARRAY['Investing', 'Sailing', 'Wine', 'AI/ML', 'Entrepreneurship'], 'Harvard MBA, MIT Computer Science', 'executive', true, true, NOW(), NOW()),

('seed-tech-003', 'Ryan', 'Chang', 32, 'Seattle, WA', 'Senior Engineering Manager', 'Amazon', 'Leading cloud infrastructure teams serving millions of customers globally. University of Washington grad passionate about hiking, coffee culture, and sustainable technology.', ARRAY['Cloud Technology', 'Hiking', 'Coffee', 'Sustainability', 'Mountain Climbing'], 'University of Washington Computer Science, Stanford AI Certificate', 'premium', true, true, NOW(), NOW()),

('seed-tech-004', 'Emma', 'Foster', 30, 'Austin, TX', 'Tech Founder', 'RetailTech Innovations', 'Building the future of retail technology. UT Austin grad who loves live music on 6th Street, food trucks, and weekend trips to Hill Country.', ARRAY['Entrepreneurship', 'Live Music', 'Food & Dining', 'Outdoor Activities', 'Technology'], 'UT Austin MBA, Computer Science', 'premium', true, true, NOW(), NOW()),

-- Finance Professionals  
('seed-fin-001', 'Isabella', 'Morgan', 29, 'Manhattan, NY', 'Investment Director', 'Goldman Sachs', 'Leading M&A transactions for Fortune 500 companies. Wharton grad who loves Broadway shows, art galleries, and weekend trips to the Hamptons.', ARRAY['Finance', 'Theater', 'Art', 'Tennis', 'Real Estate'], 'Wharton MBA, Columbia Economics', 'premium', true, true, NOW(), NOW()),

('seed-fin-002', 'James', 'Wellington', 38, 'Upper East Side, NY', 'Managing Partner', 'KKR & Co', 'Private equity professional specializing in healthcare and technology buyouts. Yale alumnus passionate about philanthropy and collecting contemporary art.', ARRAY['Private Equity', 'Art Collecting', 'Philanthropy', 'Golf', 'Fine Dining'], 'Yale MBA, Princeton Economics', 'executive', true, true, NOW(), NOW()),

('seed-fin-003', 'Tyler', 'Brooks', 35, 'Denver, CO', 'Energy Investment Director', 'Blackstone Energy', 'Investing in renewable energy infrastructure across the Western United States. Colorado School of Mines grad who lives for skiing, mountain biking, and craft beer.', ARRAY['Renewable Energy', 'Skiing', 'Mountain Biking', 'Craft Beer', 'Outdoor Adventures'], 'Colorado School of Mines Engineering, Wharton Energy Finance', 'premium', true, true, NOW(), NOW()),

-- Entertainment & Media
('seed-ent-001', 'Sofia', 'Martinez', 31, 'Beverly Hills, CA', 'Entertainment Attorney', 'CAA', 'Entertainment lawyer representing A-list talent and major studios. USC Law grad who loves beach volleyball, yoga in Malibu, and discovering new artists.', ARRAY['Entertainment Law', 'Beach Sports', 'Yoga', 'Music', 'Film'], 'USC Law JD, UCLA Communications', 'premium', true, true, NOW(), NOW()),

('seed-ent-002', 'David', 'Kim', 34, 'Santa Monica, CA', 'Creative Director', 'Netflix', 'Leading original content development for streaming platforms. CalArts alumni with a passion for storytelling, surfing, and exploring LAs food scene.', ARRAY['Content Creation', 'Surfing', 'Food & Wine', 'Travel', 'Photography'], 'CalArts MFA, UCLA Film School', 'premium', true, true, NOW(), NOW()),

-- Consulting & Strategy
('seed-con-001', 'Victoria', 'Thompson', 33, 'Chicago, IL', 'Strategy Consultant', 'McKinsey & Company', 'Strategy consultant helping Fortune 100 companies transform their operations. Northwestern Kellogg MBA who loves deep-dish pizza, Blues music, and architecture tours.', ARRAY['Strategy', 'Architecture', 'Jazz Music', 'Running', 'Business Innovation'], 'Northwestern Kellogg MBA, University of Chicago Economics', 'premium', true, true, NOW(), NOW()),

-- Healthcare & Biotech
('seed-health-001', 'Michael', 'OConnor', 36, 'Boston, MA', 'Biotech CEO', 'Moderna', 'Leading breakthrough vaccine research and development. Harvard Medical School background with a passion for innovation, sailing on Cape Cod, and Red Sox games.', ARRAY['Biotechnology', 'Medical Research', 'Sailing', 'Baseball', 'Innovation'], 'Harvard Medical School MD/PhD, MIT Biology', 'executive', true, true, NOW(), NOW()),

('seed-health-002', 'Grace', 'Williams', 29, 'Nashville, TN', 'Healthcare Executive', 'HCA Healthcare', 'Leading digital transformation in healthcare delivery systems. Vanderbilt MBA who loves country music, Southern cuisine, and healthcare innovation.', ARRAY['Healthcare Innovation', 'Country Music', 'Southern Culture', 'Digital Health', 'Philanthropy'], 'Vanderbilt MBA, Nursing Administration', 'premium', true, true, NOW(), NOW()),

-- Real Estate & Development
('seed-re-001', 'Camila', 'Santos', 28, 'Miami, FL', 'Real Estate Developer', 'Related Group', 'Developing luxury waterfront properties across South Florida. University of Miami business grad who loves beach life, Latin dance, and international travel.', ARRAY['Real Estate', 'Dance', 'Beach Activities', 'Travel', 'Architecture'], 'University of Miami Business, Real Estate Finance', 'premium', true, true, NOW(), NOW()),

-- Additional Major Cities Coverage
('seed-extra-001', 'Jonathan', 'Pierce', 34, 'Atlanta, GA', 'Investment Manager', 'Blackstone', 'Managing institutional investment portfolios across the Southeast. Georgia Tech and Emory MBA background with interests in golf, southern hospitality, and growth equity.', ARRAY['Investment Management', 'Golf', 'Southern Culture', 'Growth Equity', 'Networking'], 'Emory MBA, Georgia Tech Engineering', 'premium', true, true, NOW(), NOW()),

('seed-extra-002', 'Stephanie', 'Clarke', 31, 'Washington, DC', 'Policy Director', 'McKinsey Government Practice', 'Advising federal agencies on digital transformation initiatives. Georgetown Law and policy expertise with passion for public service, international relations, and DC cultural scene.', ARRAY['Public Policy', 'International Relations', 'Museums', 'Government Innovation', 'Cultural Events'], 'Georgetown Law JD, Princeton Public Policy', 'premium', true, true, NOW(), NOW()),

('seed-extra-003', 'Anthony', 'Torres', 37, 'Phoenix, AZ', 'Technology Executive', 'Intel', 'Leading semiconductor innovation for next-generation computing. Arizona State and Stanford background with love for desert hiking, tech innovation, and startup mentoring.', ARRAY['Semiconductor Technology', 'Desert Hiking', 'Innovation', 'Mentoring', 'Outdoor Adventures'], 'Stanford MS Engineering, Arizona State', 'premium', true, true, NOW(), NOW()),

('seed-extra-004', 'Rachel', 'Bennett', 30, 'Portland, OR', 'Sustainability Director', 'Nike', 'Driving corporate sustainability initiatives across global operations. University of Oregon and sustainability focus with interests in environmental policy, outdoor sports, and local food scene.', ARRAY['Sustainability', 'Environmental Policy', 'Outdoor Sports', 'Local Food', 'Corporate Innovation'], 'University of Oregon MBA, Environmental Studies', 'premium', true, true, NOW(), NOW());

-- Create dating preferences for all seed profiles
INSERT INTO dating_preferences (
  user_id, age_min, age_max, location_preference, 
  privacy_level, show_age, show_location, show_professional_info,
  allow_messages_from, created_at, updated_at
) VALUES
('seed-tech-001', 28, 40, 'Bay Area', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-tech-002', 30, 42, 'Bay Area', 'private', true, true, true, 'verified_only', NOW(), NOW()),
('seed-tech-003', 28, 38, 'Seattle', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-tech-004', 25, 38, 'Austin', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-fin-001', 25, 35, 'New York Metro', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-fin-002', 32, 45, 'New York Metro', 'private', true, true, false, 'verified_only', NOW(), NOW()),
('seed-fin-003', 30, 42, 'Denver', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-ent-001', 27, 38, 'Los Angeles', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-ent-002', 28, 40, 'Los Angeles', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-con-001', 28, 40, 'Chicago', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-health-001', 30, 42, 'Boston', 'private', true, true, true, 'verified_only', NOW(), NOW()),
('seed-health-002', 25, 36, 'Nashville', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-re-001', 24, 35, 'Miami', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-extra-001', 28, 40, 'Atlanta', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-extra-002', 27, 38, 'Washington DC', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-extra-003', 30, 45, 'Phoenix', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-extra-004', 26, 36, 'Portland', 'private', true, true, true, 'matches_only', NOW(), NOW());

-- Create professional info for comprehensive N8N matching
INSERT INTO professional_info (
  user_id, company_name, job_title, industry, salary_range, net_worth_range,
  education_level, university, linkedin_verified, company_verified,
  created_at, updated_at
) VALUES
('seed-tech-001', 'Meta', 'VP of Product', 'Technology', '$200K-$300K', '$1M-$5M', 'Masters', 'Stanford University', true, true, NOW(), NOW()),
('seed-tech-002', 'Andreessen Horowitz', 'Venture Partner', 'Venture Capital', '$500K+', '$10M+', 'Masters', 'Harvard Business School', true, true, NOW(), NOW()),
('seed-tech-003', 'Amazon', 'Senior Engineering Manager', 'Cloud Computing', '$250K-$400K', '$1M-$3M', 'Bachelors', 'University of Washington', true, true, NOW(), NOW()),
('seed-tech-004', 'RetailTech Innovations', 'Tech Founder', 'E-commerce Technology', '$150K-$250K', '$2M-$5M', 'Masters', 'UT Austin', true, true, NOW(), NOW()),
('seed-fin-001', 'Goldman Sachs', 'Investment Director', 'Investment Banking', '$300K-$500K', '$2M-$10M', 'Masters', 'Wharton School', true, true, NOW(), NOW()),
('seed-fin-002', 'KKR & Co', 'Managing Partner', 'Private Equity', '$1M+', '$25M+', 'Masters', 'Yale School of Management', true, true, NOW(), NOW()),
('seed-fin-003', 'Blackstone Energy', 'Energy Investment Director', 'Energy & Infrastructure', '$300K-$500K', '$3M-$10M', 'Masters', 'Colorado School of Mines', true, true, NOW(), NOW()),
('seed-ent-001', 'CAA', 'Entertainment Attorney', 'Entertainment Law', '$250K-$400K', '$1M-$5M', 'JD', 'USC Law School', true, true, NOW(), NOW()),
('seed-ent-002', 'Netflix', 'Creative Director', 'Media & Entertainment', '$200K-$350K', '$1M-$3M', 'Masters', 'CalArts', true, true, NOW(), NOW()),
('seed-con-001', 'McKinsey & Company', 'Strategy Consultant', 'Management Consulting', '$200K-$300K', '$500K-$2M', 'Masters', 'Northwestern Kellogg', true, true, NOW(), NOW()),
('seed-health-001', 'Moderna', 'Biotech CEO', 'Biotechnology', '$500K+', '$10M+', 'MD/PhD', 'Harvard Medical School', true, true, NOW(), NOW()),
('seed-health-002', 'HCA Healthcare', 'Healthcare Executive', 'Healthcare Administration', '$180K-$280K', '$500K-$2M', 'Masters', 'Vanderbilt University', true, true, NOW(), NOW()),
('seed-re-001', 'Related Group', 'Real Estate Developer', 'Real Estate Development', '$200K-$350K', '$2M-$5M', 'Bachelors', 'University of Miami', true, true, NOW(), NOW()),
('seed-extra-001', 'Blackstone', 'Investment Manager', 'Investment Management', '$250K-$400K', '$2M-$8M', 'Masters', 'Emory Business School', true, true, NOW(), NOW()),
('seed-extra-002', 'McKinsey Government Practice', 'Policy Director', 'Government Consulting', '$200K-$300K', '$800K-$3M', 'JD', 'Georgetown Law', true, true, NOW(), NOW()),
('seed-extra-003', 'Intel', 'Technology Executive', 'Semiconductor Technology', '$300K-$450K', '$3M-$12M', 'Masters', 'Stanford Engineering', true, true, NOW(), NOW()),
('seed-extra-004', 'Nike', 'Sustainability Director', 'Corporate Sustainability', '$150K-$250K', '$500K-$2M', 'Masters', 'University of Oregon', true, true, NOW(), NOW());

-- Success confirmation
SELECT 
    COUNT(*) as profiles_inserted,
    'Seed profiles inserted successfully! Users will now see realistic matches.' as status 
FROM profiles 
WHERE id LIKE 'seed-%';