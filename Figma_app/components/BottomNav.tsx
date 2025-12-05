import { Home, History, Calendar, Package, BarChart3, ShoppingBag } from 'lucide-react';
import { useApp } from '../contexts/AppContext';

interface BottomNavProps {
  currentPage: string;
  onPageChange: (page: string) => void;
}

export function BottomNav({ currentPage, onPageChange }: BottomNavProps) {
  const { mode, t } = useApp();

  const userPages = [
    { id: 'home', icon: Home, label: t('home') },
    { id: 'history', icon: History, label: t('history') },
    { id: 'upcoming', icon: Calendar, label: t('upcoming') },
  ];

  const adminPages = [
    { id: 'home', icon: Home, label: t('home') },
    { id: 'products', icon: Package, label: t('products') },
    { id: 'orders', icon: ShoppingBag, label: t('allOrders') },
    { id: 'upcoming', icon: Calendar, label: t('upcoming') },
    { id: 'stats', icon: BarChart3, label: t('stats') },
  ];

  const pages = mode === 'user' ? userPages : adminPages;

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-card border-t border-border z-50">
      <div className="flex justify-around items-center h-16 max-w-md mx-auto">
        {pages.map((page) => {
          const Icon = page.icon;
          const isActive = currentPage === page.id;
          return (
            <button
              key={page.id}
              onClick={() => onPageChange(page.id)}
              className={`flex flex-col items-center justify-center flex-1 h-full transition-colors ${
                isActive 
                  ? mode === 'user' 
                    ? 'text-[#3cad2a]' 
                    : 'text-[#c74242]'
                  : 'text-muted-foreground'
              }`}
            >
              <Icon size={20} />
              <span className="text-xs mt-1">{page.label}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
