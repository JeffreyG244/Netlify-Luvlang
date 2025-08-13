import React, { useState } from 'react';
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import MessagingInterface from './Messages/MessagingInterface';
import ProfileForm from './ProfileForm';
import SecurityDashboard from './SecurityDashboard';
import { User, MessageCircle, Settings, Shield, Heart, Users } from 'lucide-react';

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState('matches');
  const [userStats] = useState({
    matches: 12,
    messages: 8,
    profileViews: 45,
    connections: 3
  });

  const tabs = [
    { id: 'matches', label: 'Matches', icon: Heart, count: userStats.matches },
    { id: 'messages', label: 'Messages', icon: MessageCircle, count: userStats.messages },
    { id: 'connections', label: 'Connections', icon: Users, count: userStats.connections },
    { id: 'profile', label: 'Profile', icon: User },
    { id: 'security', label: 'Security', icon: Shield },
    { id: 'settings', label: 'Settings', icon: Settings }
  ];

  const renderTabContent = () => {
    switch (activeTab) {
      case 'matches':
        return <MatchesView />;
      case 'messages':
        return <MessagingInterface />;
      case 'connections':
        return <ConnectionsView />;
      case 'profile':
        return <ProfileForm />;
      case 'security':
        return <SecurityDashboard />;
      case 'settings':
        return <SettingsView />;
      default:
        return <MatchesView />;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 via-purple-800 to-purple-900">
      {/* Header */}
      <div className="border-b border-white/10 bg-black/20 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="text-2xl font-bold bg-gradient-to-r from-purple-300 to-pink-300 bg-clip-text text-transparent">
                LuvLang Pro
              </div>
              <Badge className="bg-amber-500/20 text-amber-300 border-amber-400/30">
                Executive Member
              </Badge>
            </div>
            <div className="flex items-center space-x-4">
              <div className="text-purple-200 text-sm">
                Profile Views: <span className="text-white font-semibold">{userStats.profileViews}</span>
              </div>
              <div className="w-10 h-10 rounded-full bg-gradient-to-r from-purple-400 to-pink-400 flex items-center justify-center">
                <User className="w-5 h-5 text-white" />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="border-b border-white/10 bg-black/10 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto px-6">
          <div className="flex space-x-1">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              
              return (
                <Button
                  key={tab.id}
                  variant="ghost"
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center space-x-2 px-6 py-4 rounded-none border-b-2 transition-all duration-200 ${
                    isActive
                      ? 'border-purple-400 bg-purple-500/20 text-white'
                      : 'border-transparent text-purple-200 hover:text-white hover:bg-white/5'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  <span className="font-medium">{tab.label}</span>
                  {tab.count && (
                    <Badge className={`ml-1 ${
                      isActive 
                        ? 'bg-purple-400 text-white' 
                        : 'bg-white/10 text-purple-200'
                    }`}>
                      {tab.count}
                    </Badge>
                  )}
                </Button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-6 py-8">
        {renderTabContent()}
      </div>
    </div>
  );
};

// Matches View Component
const MatchesView = () => {
  const matches = [
    { id: 1, name: 'Alexandra Chen', age: 32, title: 'Tech CEO', company: 'InnovateCorp', location: 'San Francisco', image: '👩‍💼' },
    { id: 2, name: 'Victoria Sterling', age: 29, title: 'Investment Director', company: 'Goldman Sachs', location: 'New York', image: '👩‍💻' },
    { id: 3, name: 'Isabella Rodriguez', age: 35, title: 'Surgeon', company: 'Mayo Clinic', location: 'Rochester', image: '👩‍⚕️' },
    { id: 4, name: 'Sophia Williams', age: 31, title: 'Partner', company: 'McKinsey & Co', location: 'Chicago', image: '👩‍🎓' }
  ];

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-3xl font-bold text-white mb-2">Your Premium Matches</h2>
        <p className="text-purple-200">High-caliber professionals who share your ambitions</p>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {matches.map((match) => (
          <Card key={match.id} className="bg-white/5 border-white/10 hover:bg-white/10 transition-all duration-200 cursor-pointer group">
            <CardContent className="p-6">
              <div className="text-center space-y-4">
                <div className="text-6xl">{match.image}</div>
                <div>
                  <h3 className="text-xl font-semibold text-white">{match.name}</h3>
                  <p className="text-purple-200 text-sm">Age {match.age}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-white font-medium">{match.title}</p>
                  <p className="text-purple-300 text-sm">{match.company}</p>
                  <p className="text-purple-400 text-xs">{match.location}</p>
                </div>
                <div className="flex space-x-2">
                  <Button size="sm" className="bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white flex-1">
                    <Heart className="w-4 h-4 mr-1" />
                    Like
                  </Button>
                  <Button size="sm" variant="outline" className="border-white/20 text-purple-200 hover:bg-white/10 flex-1">
                    <MessageCircle className="w-4 h-4 mr-1" />
                    Message
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
};

// Connections View Component
const ConnectionsView = () => {
  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-3xl font-bold text-white mb-2">Your Connections</h2>
        <p className="text-purple-200">Professionals you've connected with</p>
      </div>
      
      <Card className="bg-white/5 border-white/10">
        <CardContent className="p-8 text-center">
          <Users className="w-16 h-16 text-purple-400 mx-auto mb-4" />
          <h3 className="text-xl font-semibold text-white mb-2">No Connections Yet</h3>
          <p className="text-purple-200 mb-4">Start making meaningful connections with successful professionals</p>
          <Button className="bg-purple-500 hover:bg-purple-600 text-white">
            Discover Matches
          </Button>
        </CardContent>
      </Card>
    </div>
  );
};

// Settings View Component
const SettingsView = () => {
  return (
    <div className="space-y-6">
      <div className="text-center">
        <h2 className="text-3xl font-bold text-white mb-2">Account Settings</h2>
        <p className="text-purple-200">Manage your preferences and account</p>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="bg-white/5 border-white/10">
          <CardContent className="p-6">
            <h3 className="text-lg font-semibold text-white mb-4">Privacy Settings</h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-purple-200">Show my profile to matches</span>
                <div className="w-12 h-6 bg-purple-500 rounded-full relative">
                  <div className="w-5 h-5 bg-white rounded-full absolute right-0.5 top-0.5"></div>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-purple-200">Allow direct messages</span>
                <div className="w-12 h-6 bg-purple-500 rounded-full relative">
                  <div className="w-5 h-5 bg-white rounded-full absolute right-0.5 top-0.5"></div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="bg-white/5 border-white/10">
          <CardContent className="p-6">
            <h3 className="text-lg font-semibold text-white mb-4">Notifications</h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-purple-200">New matches</span>
                <div className="w-12 h-6 bg-purple-500 rounded-full relative">
                  <div className="w-5 h-5 bg-white rounded-full absolute right-0.5 top-0.5"></div>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-purple-200">Messages</span>
                <div className="w-12 h-6 bg-purple-500 rounded-full relative">
                  <div className="w-5 h-5 bg-white rounded-full absolute right-0.5 top-0.5"></div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Dashboard;