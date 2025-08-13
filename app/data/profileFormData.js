export const profileFormConfig = {
  sections: [
    {
      id: 'executive-profile',
      title: 'Executive Profile',
      description: 'Your professional essence & achievement level',
      fields: [
        { id: 'firstName', type: 'text', label: 'First Name', required: true },
        { id: 'lastName', type: 'text', label: 'Last Name', required: true },
        { 
          id: 'age', 
          type: 'select', 
          label: 'Age', 
          required: true,
          options: Array.from({length: 45}, (_, i) => ({ value: i + 28, label: `${i + 28}` }))
        },
        {
          id: 'professionalTier',
          type: 'select',
          label: 'Professional Tier',
          required: true,
          options: [
            { value: 'c-suite', label: 'C-Suite Executive (CEO, CTO, CFO, etc.)' },
            { value: 'founder', label: 'Company Founder/Co-Founder' },
            { value: 'partner', label: 'Senior Partner (Law, Consulting, Finance)' },
            { value: 'investor', label: 'Private Equity/Venture Capital' },
            { value: 'portfolio-executive', label: 'Portfolio Executive/Board Member' },
            { value: 'family-office', label: 'Family Office/Private Wealth' },
            { value: 'creative-executive', label: 'Creative Industry Executive' },
            { value: 'tech-leader', label: 'Tech Unicorn Leader' },
            { value: 'professional-elite', label: 'Elite Professional (MD, JD, etc.)' }
          ]
        },
        {
          id: 'industrySpecialization',
          type: 'select',
          label: 'Industry Specialization',
          required: true,
          options: [
            { value: 'technology', label: 'Technology & Innovation' },
            { value: 'finance', label: 'Finance & Investment Banking' },
            { value: 'private-equity', label: 'Private Equity & Venture Capital' },
            { value: 'consulting', label: 'Strategy Consulting' },
            { value: 'legal', label: 'Corporate Law & Legal Services' },
            { value: 'healthcare', label: 'Healthcare & Biotechnology' },
            { value: 'real-estate', label: 'Luxury Real Estate & Development' },
            { value: 'media', label: 'Media & Entertainment' },
            { value: 'fashion-luxury', label: 'Fashion & Luxury Brands' },
            { value: 'aerospace', label: 'Aerospace & Defense' },
            { value: 'energy', label: 'Energy & Sustainability' },
            { value: 'education', label: 'Higher Education & Research' }
          ]
        },
        { id: 'primaryLocation', type: 'text', label: 'Primary Residence', placeholder: 'Manhattan, Palo Alto, etc.', required: true },
        { id: 'secondaryLocation', type: 'text', label: 'Secondary Residence (Optional)', placeholder: 'Hamptons, Aspen, etc.' },
        {
          id: 'wealthLevel',
          type: 'select',
          label: 'Wealth Bracket (Confidential)',
          required: true,
          options: [
            { value: 'high-earning', label: '$500K+ Annual Income' },
            { value: 'very-affluent', label: '$1M+ Annual Income' },
            { value: 'ultra-affluent', label: '$5M+ Annual Income' },
            { value: 'uhnw', label: '$10M+ Net Worth' },
            { value: 'ultra-hnw', label: '$50M+ Net Worth' },
            { value: 'billionaire', label: '$100M+ Net Worth' }
          ]
        },
        {
          id: 'educationLevel',
          type: 'select',
          label: 'Educational Background',
          required: true,
          options: [
            { value: 'ivy-league', label: 'Ivy League (Harvard, Yale, Princeton, etc.)' },
            { value: 'top-tier', label: 'Top Tier University (Stanford, MIT, etc.)' },
            { value: 'elite-international', label: 'Elite International (Oxford, Cambridge, etc.)' },
            { value: 'top-business-school', label: 'Top MBA Program' },
            { value: 'advanced-degree', label: 'Advanced Professional Degree (JD, MD, PhD)' },
            { value: 'self-made', label: 'Self-Made Success' }
          ]
        }
      ]
    },
    {
      id: 'identity-preferences',
      title: 'Relationship Intentions',
      description: 'What you\'re seeking in a meaningful connection',
      fields: [
        {
          id: 'relationshipGoal',
          type: 'select',
          label: 'Primary Relationship Goal',
          required: true,
          options: [
            { value: 'life-partnership', label: 'Life Partnership & Marriage' },
            { value: 'exclusive-relationship', label: 'Exclusive Long-term Relationship' },
            { value: 'sophisticated-companionship', label: 'Sophisticated Companionship' },
            { value: 'intellectual-connection', label: 'Deep Intellectual & Emotional Connection' },
            { value: 'selective-dating', label: 'Selective High-Quality Dating' },
            { value: 'exploring-connection', label: 'Exploring Meaningful Connections' }
          ]
        },
        {
          id: 'interestedIn',
          type: 'select',
          label: 'Interested in Meeting',
          required: true,
          options: [
            { value: 'men', label: 'Men' },
            { value: 'women', label: 'Women' },
            { value: 'all-genders', label: 'All Genders' },
            { value: 'depends-connection', label: 'Depends on the Connection' }
          ]
        },
        {
          id: 'preferredPartnerLevel',
          type: 'multiselect',
          label: 'Preferred Partner Professional Level',
          required: true,
          options: [
            'C-Suite Executive', 'Successful Entrepreneur', 'Senior Partner/Principal',
            'Investment Professional', 'Elite Medical Professional', 'Distinguished Academic',
            'Creative Industry Leader', 'Board Member/Director', 'Family Office Principal',
            'Accomplished Professional', 'Open to Achievement Level'
          ]
        },
        {
          id: 'partnerQualities',
          type: 'multiselect',
          label: 'Most Important Partner Qualities (Select up to 5)',
          limit: 5,
          required: true,
          options: [
            'Exceptional Intelligence', 'Strong Ambition', 'Emotional Sophistication',
            'Cultural Refinement', 'Financial Success', 'Global Perspective',
            'Philanthropic Spirit', 'Athletic/Wellness Focused', 'Family-Oriented',
            'Entrepreneurial Mind', 'Artistic Appreciation', 'Leadership Qualities',
            'Intellectual Curiosity', 'Social Grace', 'Adventure Spirit'
          ]
        },
        {
          id: 'absoluteRequirements',
          type: 'multiselect',
          label: 'Absolute Requirements (Non-negotiable)',
          required: true,
          options: [
            'Financial Stability/Success', 'College Education (Minimum)', 'Advanced Degree Preferred',
            'Professional Achievement', 'Emotional Maturity', 'No Substance Dependencies',
            'Health & Fitness Conscious', 'Ambitious & Goal-Oriented', 'Cultural Sophistication',
            'Family Values', 'Integrity & Honesty', 'Discretion & Privacy Respect'
          ]
        },
        {
          id: 'preferredAgeRange',
          type: 'select',
          label: 'Preferred Age Range',
          required: true,
          options: [
            { value: '28-35', label: '28-35' },
            { value: '30-40', label: '30-40' },
            { value: '35-45', label: '35-45' },
            { value: '40-50', label: '40-50' },
            { value: '45-55', label: '45-55' },
            { value: '50-60', label: '50-60' },
            { value: '55+', label: '55+' },
            { value: 'flexible', label: 'Age is Just a Number' }
          ]
        },
        {
          id: 'geographicPreference',
          type: 'select',
          label: 'Geographic Preference',
          required: true,
          options: [
            { value: 'same-metro', label: 'Same Metropolitan Area' },
            { value: 'major-cities', label: 'Major Global Cities (NYC, SF, LA, London, etc.)' },
            { value: 'coastal-us', label: 'US East/West Coast' },
            { value: 'national', label: 'Anywhere in US' },
            { value: 'international', label: 'International (High Net Worth Hubs)' },
            { value: 'truly-global', label: 'Truly Global - Distance Not a Factor' }
          ]
        }
      ]
    },
    {
      id: 'lifestyle-values',
      title: 'Lifestyle & Values',
      description: 'Your worldview and way of living',
      fields: [
        {
          id: 'lifestyleDescription',
          type: 'multiselect',
          label: 'Your Lifestyle Best Described As',
          required: true,
          options: [
            'Sophisticated & Cultured', 'High-Achieving & Driven', 'Cosmopolitan & Global',
            'Philanthropic & Giving', 'Health & Wellness Focused', 'Arts & Culture Enthusiast',
            'Adventure & Travel Oriented', 'Family & Tradition Centered', 'Innovation & Tech Forward',
            'Luxury & Quality Appreciating', 'Intellectual & Curious', 'Social & Well-Connected'
          ]
        },
        {
          id: 'socialCircle',
          type: 'multiselect',
          label: 'Your Social Circle Includes',
          options: [
            'Business Leaders & Executives', 'Entrepreneurs & Innovators', 'Artists & Creatives',
            'Academic & Intellectual Elites', 'Philanthropists & Board Members', 'International Professionals',
            'Investment & Finance Professionals', 'Cultural & Arts Leaders', 'Sports & Wellness Enthusiasts',
            'Political & Policy Leaders', 'Technology & Innovation Leaders', 'Luxury Industry Professionals'
          ]
        },
        {
          id: 'personalPhilosophy',
          type: 'select',
          label: 'Personal Philosophy',
          required: true,
          options: [
            { value: 'excellence-driven', label: 'Excellence in Everything' },
            { value: 'balance-harmony', label: 'Balance & Harmony' },
            { value: 'impact-legacy', label: 'Making an Impact & Leaving a Legacy' },
            { value: 'authentic-meaningful', label: 'Authentic & Meaningful Living' },
            { value: 'growth-adventure', label: 'Continuous Growth & Adventure' },
            { value: 'service-contribution', label: 'Service & Contribution to Society' },
            { value: 'family-relationships', label: 'Family & Relationships First' },
            { value: 'freedom-independence', label: 'Freedom & Independence' }
          ]
        },
        {
          id: 'culturalBackground',
          type: 'text',
          label: 'Cultural Heritage/Background',
          placeholder: 'e.g., Italian-American, British, International mix'
        },
        {
          id: 'languagesSpoken',
          type: 'multiselect',
          label: 'Languages Spoken Fluently',
          required: true,
          options: [
            'English', 'Spanish', 'French', 'German', 'Italian', 'Portuguese',
            'Mandarin', 'Japanese', 'Korean', 'Arabic', 'Russian', 'Dutch',
            'Swedish', 'Norwegian', 'Hindi', 'Hebrew', 'Greek', 'Other'
          ]
        },
        {
          id: 'residentialStyle',
          type: 'multiselect',
          label: 'Residential Properties',
          options: [
            'Manhattan Penthouse', 'Suburban Estate', 'Beachfront Property', 'Mountain/Ski House',
            'International Residence', 'Historic Property', 'Modern Architectural', 'Country Club Community',
            'Luxury High-Rise', 'Private Estate', 'Investment Properties', 'Family Generational Property'
          ]
        },
        {
          id: 'philanthropicInvolvement',
          type: 'multiselect',
          label: 'Philanthropic Involvement',
          options: [
            'Education & Schools', 'Healthcare & Medical Research', 'Arts & Culture',
            'Environmental & Sustainability', 'Community Development', 'International Relief',
            'Technology & Innovation', 'Youth Development', 'Women\'s Empowerment',
            'Animal Welfare', 'Religious/Spiritual Organizations', 'Political/Policy Causes',
            'Not Currently Active', 'Prefer to Keep Private'
          ]
        },
        {
          id: 'familyValues',
          type: 'select',
          label: 'Family Planning Outlook',
          required: true,
          options: [
            { value: 'ready-for-family', label: 'Ready to Build a Family' },
            { value: 'have-children-want-more', label: 'Have Children, Open to More' },
            { value: 'have-children-complete', label: 'Have Children, Family Complete' },
            { value: 'open-to-family', label: 'Open to Family with Right Partner' },
            { value: 'career-focused', label: 'Career-Focused, Family Later' },
            { value: 'child-free-choice', label: 'Child-Free by Choice' },
            { value: 'flexible-depends', label: 'Flexible, Depends on Relationship' }
          ]
        }
      ]
    },
    {
      id: 'psychology-compatibility',
      title: 'Personality & Connection Style',
      description: 'How you connect and communicate in relationships',
      fields: [
        {
          id: 'leadershipStyle',
          type: 'select',
          label: 'Natural Leadership Style',
          required: true,
          options: [
            { value: 'visionary-strategic', label: 'Visionary & Strategic' },
            { value: 'collaborative-inspiring', label: 'Collaborative & Inspiring' },
            { value: 'decisive-results', label: 'Decisive & Results-Oriented' },
            { value: 'innovative-disruptive', label: 'Innovative & Disruptive' },
            { value: 'diplomatic-consensus', label: 'Diplomatic & Consensus-Building' },
            { value: 'analytical-systematic', label: 'Analytical & Systematic' },
            { value: 'charismatic-influential', label: 'Charismatic & Influential' },
            { value: 'behind-scenes-strategic', label: 'Behind-the-Scenes Strategic' }
          ]
        },
        {
          id: 'personalityStrengths',
          type: 'multiselect',
          label: 'Your Greatest Personality Strengths (Select up to 4)',
          limit: 4,
          required: true,
          options: [
            'Strategic Thinking', 'Emotional Intelligence', 'Natural Charisma', 'Analytical Mind',
            'Creative Innovation', 'Inspiring Leadership', 'Diplomatic Skills', 'Resilience & Adaptability',
            'Intuitive Understanding', 'Decisive Action', 'Cultural Sophistication', 'Global Perspective',
            'Intellectual Curiosity', 'Authentic Presence', 'Entrepreneurial Spirit', 'Compassionate Wisdom'
          ]
        },
        {
          id: 'connectionPreference',
          type: 'select',
          label: 'How You Prefer to Connect',
          required: true,
          options: [
            { value: 'deep-intellectual', label: 'Deep Intellectual Conversations' },
            { value: 'shared-experiences', label: 'Shared Meaningful Experiences' },
            { value: 'emotional-intimacy', label: 'Emotional Intimacy & Vulnerability' },
            { value: 'adventure-exploration', label: 'Adventure & Exploration Together' },
            { value: 'cultural-sophistication', label: 'Cultural & Artistic Appreciation' },
            { value: 'business-partnership', label: 'Business & Professional Partnership' },
            { value: 'family-building', label: 'Family & Legacy Building' },
            { value: 'balanced-approach', label: 'Balanced Multi-Dimensional Connection' }
          ]
        },
        {
          id: 'communicationStyle',
          type: 'multiselect',
          label: 'Your Communication Style',
          required: true,
          options: [
            'Direct & Transparent', 'Diplomatic & Nuanced', 'Inspiring & Motivational',
            'Analytical & Logical', 'Emotionally Articulate', 'Witty & Sophisticated',
            'Thoughtful & Reflective', 'Passionate & Expressive', 'Strategic & Forward-Thinking'
          ]
        },
        {
          id: 'relationshipDynamics',
          type: 'select',
          label: 'Preferred Relationship Dynamic',
          required: true,
          options: [
            { value: 'equal-partnership', label: 'Equal Partnership - Both Strong Leaders' },
            { value: 'complementary-strengths', label: 'Complementary Strengths' },
            { value: 'intellectual-match', label: 'Intellectual & Strategic Match' },
            { value: 'supportive-foundation', label: 'Mutually Supportive Foundation' },
            { value: 'adventure-partners', label: 'Adventure & Growth Partners' },
            { value: 'power-couple', label: 'Power Couple - Amplifying Each Other' },
            { value: 'traditional-modern', label: 'Traditional Values, Modern Execution' },
            { value: 'flexible-adaptive', label: 'Flexible & Adaptive to Situations' }
          ]
        },
        {
          id: 'emotionalNeeds',
          type: 'multiselect',
          label: 'Your Primary Emotional Needs (Select up to 3)',
          limit: 3,
          required: true,
          options: [
            'Intellectual Stimulation', 'Emotional Security', 'Adventure & Growth',
            'Appreciation & Recognition', 'Deep Understanding', 'Physical Affection',
            'Shared Ambitions', 'Cultural Experiences', 'Family Connection',
            'Freedom & Independence', 'Luxury & Comfort', 'Spiritual Connection'
          ]
        },
        {
          id: 'personalGrowth',
          type: 'multiselect',
          label: 'Current Personal Growth Focus',
          options: [
            'Leadership Development', 'Emotional Intelligence', 'Physical Fitness & Health',
            'Spiritual/Mindfulness Practice', 'Cultural & Artistic Appreciation', 'Family & Relationships',
            'Philanthropic Impact', 'Business Innovation', 'Global Perspective',
            'Creative Expression', 'Financial Mastery', 'Life Balance & Wellness'
          ]
        }
      ]
    },
    {
      id: 'interests-culture',
      title: 'Interests & Lifestyle',
      description: 'Your passions and how you spend your time',
      fields: [
        {
          id: 'professionalPassions',
          type: 'multiselect',
          label: 'Professional Passions & Interests',
          required: true,
          options: [
            'Strategic Innovation', 'Disruptive Technology', 'Global Markets', 'Investment Strategy',
            'Sustainable Business', 'Leadership Development', 'Mergers & Acquisitions', 'Venture Capital',
            'Digital Transformation', 'International Relations', 'Economic Policy', 'Board Governance',
            'Thought Leadership', 'Industry Conferences', 'Executive Coaching', 'Mentoring Next Generation'
          ]
        },
        {
          id: 'culturalSophistication',
          type: 'multiselect',
          label: 'Cultural & Artistic Interests',
          required: true,
          options: [
            'Modern & Contemporary Art', 'Classical Music & Opera', 'Fine Literature & Philosophy',
            'Architecture & Design', 'Fashion & Luxury', 'Film & Documentary', 'Theater & Performing Arts',
            'Museum Collections', 'Art Collecting', 'Cultural Philanthropy', 'International Art Fairs',
            'Historic Preservation', 'Cultural Travel Experiences', 'Private Gallery Events'
          ]
        },
        {
          id: 'activePursuits',
          type: 'multiselect',
          label: 'Active Lifestyle & Sports',
          required: true,
          options: [
            'Golf (Private Clubs)', 'Tennis (Country Club)', 'Sailing & Yachting', 'Skiing (Aspen, St. Moritz)',
            'Equestrian Sports', 'Private Fitness Training', 'Yoga & Mindfulness', 'Hiking & Nature',
            'Cycling & Triathlon', 'Swimming & Water Sports', 'Rock Climbing', 'Martial Arts',
            'Spa & Wellness Retreats', 'Health Optimization', 'Adventure Racing', 'Executive Sports Leagues'
          ]
        },
        {
          id: 'socialScene',
          type: 'multiselect',
          label: 'Social & Entertainment Preferences',
          options: [
            'Exclusive Private Clubs', 'High-End Charity Galas', 'Wine & Spirits Collecting',
            'Michelin Star Dining', 'Private Chef Experiences', 'Intimate Dinner Parties',
            'Luxury Travel Groups', 'Cultural Society Events', 'Business Social Events',
            'Country Club Activities', 'Private Box Events', 'Exclusive Member Clubs',
            'Philanthropic Events', 'Industry Award Ceremonies'
          ]
        },
        {
          id: 'travelStyle',
          type: 'multiselect',
          label: 'Travel & Adventure Style',
          required: true,
          options: [
            'First-Class Global Business Travel', 'Private Jet Charters', 'Luxury Safari Experiences',
            'Michelin-Starred Culinary Tours', 'Private Yacht Charters', 'Exclusive Resort Stays',
            'Cultural Immersion (High-End)', 'Adventure with Luxury Base', 'Private Villa Rentals',
            'Wellness & Spa Retreats', 'Historic Properties & Castles', 'Art & Cultural Tours',
            'Wine Country Experiences', 'Expedition Cruises', 'Private Island Getaways'
          ]
        },
        {
          id: 'intellectualPursuits',
          type: 'multiselect',
          label: 'Intellectual & Personal Interests',
          required: true,
          options: [
            'Strategic Thinking & Planning', 'Economic & Market Analysis', 'Philosophy & Ethics',
            'History & Geopolitics', 'Science & Technology Innovation', 'Psychology & Human Behavior',
            'Environmental & Sustainability', 'Art History & Collecting', 'Literature & Writing',
            'Language Learning', 'Personal Development', 'Meditation & Mindfulness',
            'Family Legacy Planning', 'Coaching & Mentoring', 'Public Speaking', 'Board Service'
          ]
        },
        {
          id: 'collectionInterests',
          type: 'multiselect',
          label: 'Collections & Investments of Passion',
          options: [
            'Fine Art & Sculptures', 'Vintage Wines & Spirits', 'Classic or Luxury Automobiles',
            'Rare Books & Manuscripts', 'Watches & Timepieces', 'Jewelry & Precious Stones',
            'Antiques & Historical Artifacts', 'Photography & Vintage Cameras', 'Musical Instruments',
            'Real Estate Investment Properties', 'Venture Capital & Angel Investments', 'Not a Collector'
          ]
        },
        {
          id: 'typicalEvening',
          type: 'select',
          label: 'Your Ideal Evening',
          required: true,
          options: [
            { value: 'intimate-fine-dining', label: 'Intimate Fine Dining Experience' },
            { value: 'cultural-performance', label: 'Cultural Performance or Art Event' },
            { value: 'sophisticated-home', label: 'Sophisticated Evening at Home' },
            { value: 'business-social', label: 'Business Social Event or Networking' },
            { value: 'adventure-unique', label: 'Adventure or Unique Experience' },
            { value: 'wellness-reflection', label: 'Wellness & Personal Reflection' },
            { value: 'family-quality', label: 'Quality Family Time' },
            { value: 'varies-mood', label: 'Varies Based on Mood & Season' }
          ]
        }
      ]
    },
    {
      id: 'photo-preferences',
      title: 'Photo & Presentation',
      description: 'How you\'d like to present yourself visually',
      fields: [
        {
          id: 'photoStyle',
          type: 'select',
          label: 'Preferred Photo Style',
          required: true,
          options: [
            { value: 'professional-executive', label: 'Professional Executive Style' },
            { value: 'sophisticated-lifestyle', label: 'Sophisticated Lifestyle Photos' },
            { value: 'artistic-creative', label: 'Artistic & Creative Presentation' },
            { value: 'adventure-active', label: 'Adventure & Active Lifestyle' },
            { value: 'cultural-refined', label: 'Cultural & Refined Settings' },
            { value: 'natural-authentic', label: 'Natural & Authentic Moments' },
            { value: 'luxury-elegant', label: 'Luxury & Elegant Environments' }
          ]
        },
        {
          id: 'photoSettings',
          type: 'multiselect',
          label: 'Preferred Photo Settings',
          options: [
            'Professional Office/Boardroom', 'Luxury Restaurant/Club', 'Art Gallery/Museum',
            'Private Home/Estate', 'Yacht/Waterfront', 'Golf Course/Country Club',
            'Cultural Event/Theater', 'Travel Destinations', 'Nature/Outdoor Adventure',
            'Fitness/Wellness Environment', 'Classic Automobile', 'Private Jet/First Class'
          ]
        },
        {
          id: 'presentationStyle',
          type: 'select',
          label: 'Personal Presentation Style',
          required: true,
          options: [
            { value: 'classic-elegant', label: 'Classic & Elegant' },
            { value: 'modern-sophisticated', label: 'Modern & Sophisticated' },
            { value: 'casual-refined', label: 'Casual but Refined' },
            { value: 'artistic-creative', label: 'Artistic & Creative' },
            { value: 'athletic-wellness', label: 'Athletic & Wellness Focused' },
            { value: 'international-cosmopolitan', label: 'International & Cosmopolitan' },
            { value: 'traditional-with-edge', label: 'Traditional with Modern Edge' }
          ]
        }
      ]
    }
  ]
};
