-- Luvlang Seed Profiles Script
-- Insert realistic executive profiles to populate the platform

-- First, ensure we have the profiles table structure
-- (This should already exist from previous setup)

-- Insert realistic seed profiles for major cities
INSERT INTO profiles (
  id, first_name, last_name, age, location, job_title, company, bio, 
  interests, education, membership_type, 
  profile_complete, is_active, created_at, updated_at
) VALUES

-- San Francisco Bay Area Professionals
(
  'seed-sf-001',
  'Alexandra',
  'Chen',
  32,
  'San Francisco, CA',
  'VP of Product',
  'Meta',
  'Product leader passionate about building experiences that connect people. Stanford MBA, love hiking in Marin and trying new restaurants in the Mission.',
  ARRAY['Technology', 'Hiking', 'Wine Tasting', 'Travel', 'Photography'],
  'Stanford MBA, UC Berkeley BS Computer Science',
  'premium',
  true,
  true,
  '2025-01-01T00:00:00Z',
  '2025-01-01T00:00:00Z'
),
(
  'seed-sf-002',
  'Marcus',
  'Rodriguez',
  35,
  'Palo Alto, CA',
  'Venture Partner',
  'Andreessen Horowitz',
  'Early-stage investor focused on AI and fintech. Former founder who exited to Google. Love sailing on the Bay and exploring Napa Valley.',
  ARRAY['Investing', 'Sailing', 'Wine', 'AI/ML', 'Entrepreneurship'],
  'Harvard MBA, MIT Computer Science',
  'executive',
  true,
  true,
  '2025-01-02T00:00:00Z',
  '2025-01-02T00:00:00Z'
),

-- New York City Professionals
(
  'seed-ny-001',
  'Isabella',
  'Morgan',
  29,
  'Manhattan, NY',
  'Investment Director',
  'Goldman Sachs',
  'Leading M&A transactions for Fortune 500 companies. Wharton grad who loves Broadway shows, art galleries, and weekend trips to the Hamptons.',
  ARRAY['Finance', 'Theater', 'Art', 'Tennis', 'Real Estate'],
  'Wharton MBA, Columbia Economics',
  '???????????',
  'premium',
  true,
  true,
  '2025-01-03T00:00:00Z',
  '2025-01-03T00:00:00Z'
),
(
  'seed-ny-002',
  'James',
  'Wellington',
  38,
  'Upper East Side, NY',
  'Managing Partner',
  'KKR & Co',
  'Private equity professional specializing in healthcare and technology buyouts. Yale alumnus passionate about philanthropy and collecting contemporary art.',
  ARRAY['Private Equity', 'Art Collecting', 'Philanthropy', 'Golf', 'Fine Dining'],
  'Yale MBA, Princeton Economics',
  '???????????',
  'executive',
  true,
  true,
  '2025-01-04T00:00:00Z',
  '2025-01-04T00:00:00Z'
),

-- Los Angeles Professionals
(
  'seed-la-001',
  'Sofia',
  'Martinez',
  31,
  'Beverly Hills, CA',
  'Entertainment Attorney',
  'CAA',
  'Entertainment lawyer representing A-list talent and major studios. USC Law grad who loves beach volleyball, yoga in Malibu, and discovering new artists.',
  ARRAY['Entertainment Law', 'Beach Sports', 'Yoga', 'Music', 'Film'],
  'USC Law JD, UCLA Communications',
  '??????',
  'premium',
  true,
  true,
  '2025-01-05T00:00:00Z',
  '2025-01-05T00:00:00Z'
),
(
  'seed-la-002',
  'David',
  'Kim',
  34,
  'Santa Monica, CA',
  'Creative Director',
  'Netflix',
  'Leading original content development for streaming platforms. CalArts alumni with a passion for storytelling, surfing, and exploring LA''s food scene.',
  ARRAY['Content Creation', 'Surfing', 'Food & Wine', 'Travel', 'Photography'],
  'CalArts MFA, UCLA Film School',
  '????',
  'premium',
  true,
  true,
  '2025-01-06T00:00:00Z',
  '2025-01-06T00:00:00Z'
),

-- Chicago Professionals
(
  'seed-chi-001',
  'Victoria',
  'Thompson',
  33,
  'Chicago, IL',
  'Strategy Consultant',
  'McKinsey & Company',
  'Strategy consultant helping Fortune 100 companies transform their operations. Northwestern Kellogg MBA who loves deep-dish pizza, Blues music, and architecture tours.',
  ARRAY['Strategy', 'Architecture', 'Jazz Music', 'Running', 'Business Innovation'],
  'Northwestern Kellogg MBA, University of Chicago Economics',
  '???????????',
  'premium',
  true,
  true,
  '2025-01-07T00:00:00Z',
  '2025-01-07T00:00:00Z'
),

-- Boston Professionals
(
  'seed-bos-001',
  'Michael',
  'O''Connor',
  36,
  'Boston, MA',
  'Biotech CEO',
  'Moderna',
  'Leading breakthrough vaccine research and development. Harvard Medical School background with a passion for innovation, sailing on Cape Cod, and Red Sox games.',
  ARRAY['Biotechnology', 'Medical Research', 'Sailing', 'Baseball', 'Innovation'],
  'Harvard Medical School MD/PhD, MIT Biology',
  '????',
  'executive',
  true,
  true,
  '2025-01-08T00:00:00Z',
  '2025-01-08T00:00:00Z'
),

-- Austin Professionals
(
  'seed-aus-001',
  'Emma',
  'Foster',
  30,
  'Austin, TX',
  'Tech Founder',
  'RetailTech Innovations',
  'Building the future of retail technology. UT Austin grad who loves live music on 6th Street, food trucks, and weekend trips to Hill Country.',
  ARRAY['Entrepreneurship', 'Live Music', 'Food & Dining', 'Outdoor Activities', 'Technology'],
  'UT Austin MBA, Computer Science',
  '????',
  'premium',
  true,
  true,
  '2025-01-09T00:00:00Z',
  '2025-01-09T00:00:00Z'
),

-- Seattle Professionals
(
  'seed-sea-001',
  'Ryan',
  'Chang',
  32,
  'Seattle, WA',
  'Senior Engineering Manager',
  'Amazon',
  'Leading cloud infrastructure teams serving millions of customers globally. University of Washington grad passionate about hiking, coffee culture, and sustainable technology.',
  ARRAY['Cloud Technology', 'Hiking', 'Coffee', 'Sustainability', 'Mountain Climbing'],
  'University of Washington Computer Science, Stanford AI Certificate',
  '??????',
  'premium',
  true,
  true,
  '2025-01-10T00:00:00Z',
  '2025-01-10T00:00:00Z'
),

-- Miami Professionals
(
  'seed-mia-001',
  'Camila',
  'Santos',
  28,
  'Miami, FL',
  'Real Estate Developer',
  'Related Group',
  'Developing luxury waterfront properties across South Florida. University of Miami business grad who loves beach life, Latin dance, and international travel.',
  ARRAY['Real Estate', 'Dance', 'Beach Activities', 'Travel', 'Architecture'],
  'University of Miami Business, Real Estate Finance',
  '????',
  'premium',
  true,
  true,
  '2025-01-11T00:00:00Z',
  '2025-01-11T00:00:00Z'
),

-- Denver Professionals
(
  'seed-den-001',
  'Tyler',
  'Brooks',
  35,
  'Denver, CO',
  'Energy Investment Director',
  'Blackstone Energy',
  'Investing in renewable energy infrastructure across the Western United States. Colorado School of Mines grad who lives for skiing, mountain biking, and craft beer.',
  ARRAY['Renewable Energy', 'Skiing', 'Mountain Biking', 'Craft Beer', 'Outdoor Adventures'],
  'Colorado School of Mines Engineering, Wharton Energy Finance',
  '???',
  'premium',
  true,
  true,
  '2025-01-12T00:00:00Z',
  '2025-01-12T00:00:00Z'
),

-- Nashville Professionals
(
  'seed-nash-001',
  'Grace',
  'Williams',
  29,
  'Nashville, TN',
  'Healthcare Executive',
  'HCA Healthcare',
  'Leading digital transformation in healthcare delivery systems. Vanderbilt MBA who loves country music, Southern cuisine, and healthcare innovation.',
  ARRAY['Healthcare Innovation', 'Country Music', 'Southern Culture', 'Digital Health', 'Philanthropy'],
  'Vanderbilt MBA, Nursing Administration',
  '????',
  'premium',
  true,
  true,
  '2025-01-13T00:00:00Z',
  '2025-01-13T00:00:00Z'
);

-- Create additional dating preferences for seed profiles
INSERT INTO dating_preferences (
  user_id, age_min, age_max, location_preference, 
  privacy_level, show_age, show_location, show_professional_info,
  allow_messages_from, created_at, updated_at
) VALUES
('seed-sf-001', 28, 40, 'Bay Area', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-sf-002', 30, 42, 'Bay Area', 'private', true, true, true, 'verified_only', NOW(), NOW()),
('seed-ny-001', 25, 35, 'New York Metro', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-ny-002', 32, 45, 'New York Metro', 'private', true, true, false, 'verified_only', NOW(), NOW()),
('seed-la-001', 27, 38, 'Los Angeles', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-la-002', 28, 40, 'Los Angeles', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-chi-001', 28, 40, 'Chicago', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-bos-001', 30, 42, 'Boston', 'private', true, true, true, 'verified_only', NOW(), NOW()),
('seed-aus-001', 25, 38, 'Austin', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-sea-001', 28, 38, 'Seattle', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-mia-001', 24, 35, 'Miami', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-den-001', 30, 42, 'Denver', 'private', true, true, true, 'matches_only', NOW(), NOW()),
('seed-nash-001', 25, 36, 'Nashville', 'private', true, true, true, 'matches_only', NOW(), NOW());

-- Create professional info for seed profiles
INSERT INTO professional_info (
  user_id, company_name, job_title, industry, salary_range, net_worth_range,
  education_level, university, linkedin_verified, company_verified,
  created_at, updated_at
) VALUES
('seed-sf-001', 'Meta', 'VP of Product', 'Technology', '$200K-$300K', '$1M-$5M', 'Masters', 'Stanford University', true, true, NOW(), NOW()),
('seed-sf-002', 'Andreessen Horowitz', 'Venture Partner', 'Venture Capital', '$500K+', '$10M+', 'Masters', 'Harvard Business School', true, true, NOW(), NOW()),
('seed-ny-001', 'Goldman Sachs', 'Investment Director', 'Investment Banking', '$300K-$500K', '$2M-$10M', 'Masters', 'Wharton School', true, true, NOW(), NOW()),
('seed-ny-002', 'KKR & Co', 'Managing Partner', 'Private Equity', '$1M+', '$25M+', 'Masters', 'Yale School of Management', true, true, NOW(), NOW()),
('seed-la-001', 'CAA', 'Entertainment Attorney', 'Entertainment Law', '$250K-$400K', '$1M-$5M', 'JD', 'USC Law School', true, true, NOW(), NOW()),
('seed-la-002', 'Netflix', 'Creative Director', 'Media & Entertainment', '$200K-$350K', '$1M-$3M', 'Masters', 'CalArts', true, true, NOW(), NOW()),
('seed-chi-001', 'McKinsey & Company', 'Strategy Consultant', 'Management Consulting', '$200K-$300K', '$500K-$2M', 'Masters', 'Northwestern Kellogg', true, true, NOW(), NOW()),
('seed-bos-001', 'Moderna', 'Biotech CEO', 'Biotechnology', '$500K+', '$10M+', 'MD/PhD', 'Harvard Medical School', true, true, NOW(), NOW()),
('seed-aus-001', 'RetailTech Innovations', 'Tech Founder', 'E-commerce Technology', '$150K-$250K', '$2M-$5M', 'Masters', 'UT Austin', true, true, NOW(), NOW()),
('seed-sea-001', 'Amazon', 'Senior Engineering Manager', 'Cloud Computing', '$250K-$400K', '$1M-$3M', 'Bachelors', 'University of Washington', true, true, NOW(), NOW()),
('seed-mia-001', 'Related Group', 'Real Estate Developer', 'Real Estate Development', '$200K-$350K', '$2M-$5M', 'Bachelors', 'University of Miami', true, true, NOW(), NOW()),
('seed-den-001', 'Blackstone Energy', 'Energy Investment Director', 'Energy & Infrastructure', '$300K-$500K', '$3M-$10M', 'Masters', 'Colorado School of Mines', true, true, NOW(), NOW()),
('seed-nash-001', 'HCA Healthcare', 'Healthcare Executive', 'Healthcare Administration', '$180K-$280K', '$500K-$2M', 'Masters', 'Vanderbilt University', true, true, NOW(), NOW());

-- Success message
SELECT 'Seed profiles inserted successfully! Luvlang now has realistic executive profiles across major cities.' as status;
