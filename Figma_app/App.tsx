import { useState } from 'react';
import { AppProvider } from './contexts/AppContext';
import { TopBar } from './components/TopBar';
import { BottomNav } from './components/BottomNav';
import { UserHome } from './components/user/UserHome';
import { UserHistory } from './components/user/UserHistory';
import { UserUpcoming } from './components/user/UserUpcoming';
import { AdminHome } from './components/admin/AdminHome';
import { AdminProducts } from './components/admin/AdminProducts';
import { AdminOrders } from './components/admin/AdminOrders';
import { AdminUpcoming } from './components/admin/AdminUpcoming';
import { AdminStats } from './components/admin/AdminStats';
import { Toaster } from './components/ui/sonner';
import { useApp } from './contexts/AppContext';
import { Login } from './components/Login';

function AppContent() {
  const [currentPage, setCurrentPage] = useState('home');
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const { mode, setMode } = useApp();

  const handleLogin = (user: string, isAdmin: boolean) => {
    setMode(isAdmin ? 'admin' : 'user');
    setIsLoggedIn(true);
  };

  const handleLogout = () => {
    setIsLoggedIn(false);
    setCurrentPage('home');
  };

  if (!isLoggedIn) {
    return <Login onLogin={handleLogin} />;
  }

  const renderPage = () => {
    if (mode === 'user') {
      switch (currentPage) {
        case 'home':
          return <UserHome />;
        case 'history':
          return <UserHistory />;
        case 'upcoming':
          return <UserUpcoming />;
        default:
          return <UserHome />;
      }
    } else {
      switch (currentPage) {
        case 'home':
          return <AdminHome />;
        case 'products':
          return <AdminProducts />;
        case 'orders':
          return <AdminOrders />;
        case 'upcoming':
          return <AdminUpcoming />;
        case 'stats':
          return <AdminStats />;
        default:
          return <AdminHome />;
      }
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <TopBar onLogout={handleLogout} />
      <main className="max-w-md mx-auto">
        {renderPage()}
      </main>
      <BottomNav currentPage={currentPage} onPageChange={setCurrentPage} />
      <Toaster position="top-center" />
    </div>
  );
}

export default function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}
