import { Toaster } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from "@/hooks/useAuth";
import Index from "./pages/Index";
import Auth from "./pages/Auth";
import Dashboard from "./pages/Dashboard";
import Discover from "./pages/Discover";
import Matches from "./pages/Matches";
import DailyMatches from "./pages/DailyMatches";
import Messages from "./pages/Messages";
import Membership from "./pages/Membership";
import Checkout from "./pages/Checkout";
import Legal from "./pages/Legal";
import HowItWorks from "./pages/HowItWorks";
import PreLaunchAudit from "./pages/PreLaunchAudit";
import SeedUsers from "./pages/SeedUsers";
const queryClient = new QueryClient();
function App() {
    return (<QueryClientProvider client={queryClient}>
      <AuthProvider>
        <TooltipProvider>
          <Router>
            <Routes>
              <Route path="/" element={<Index />}/>
              <Route path="/auth" element={<Auth />}/>
              <Route path="/dashboard" element={<Dashboard />}/>
              <Route path="/discover" element={<Discover />}/>
              <Route path="/matches" element={<Matches />}/>
              <Route path="/daily-matches" element={<DailyMatches />}/>
              <Route path="/messages" element={<Messages />}/>
              <Route path="/membership" element={<Membership />}/>
              <Route path="/checkout" element={<Checkout />}/>
              <Route path="/legal" element={<Legal />}/>
              <Route path="/how-it-works" element={<HowItWorks />}/>
              <Route path="/prelaunch" element={<PreLaunchAudit />}/>
              <Route path="/seed-users" element={<SeedUsers />}/>
            </Routes>
          </Router>
          <Toaster />
        </TooltipProvider>
      </AuthProvider>
    </QueryClientProvider>);
}
export default App;
