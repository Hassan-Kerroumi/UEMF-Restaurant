import { Moon, Sun, Globe, LogOut } from 'lucide-react';
import { useApp } from '../contexts/AppContext';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from './ui/dropdown-menu';

export function TopBar({ onLogout }: { onLogout?: () => void }) {
  const { theme, toggleTheme, language, setLanguage } = useApp();

  return (
    <div className="fixed top-0 left-0 right-0 bg-card border-b border-border z-50">
      <div className="flex justify-between items-center h-14 px-4 max-w-md mx-auto">
        <h1 className="text-[#062c6b] dark:text-[#3cad2a]">
          Restaurant App
        </h1>
        
        <div className="flex items-center gap-2">
          {/* Language Selector */}
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <button className="p-2 hover:bg-accent/10 rounded-lg transition-colors">
                <Globe size={20} />
              </button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => setLanguage('en')}>
                {language === 'en' && '✓ '}English
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => setLanguage('fr')}>
                {language === 'fr' && '✓ '}Français
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => setLanguage('ar')}>
                {language === 'ar' && '✓ '}العربية
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>

          {/* Theme Toggle */}
          <button
            onClick={toggleTheme}
            className="p-2 hover:bg-accent/10 rounded-lg transition-colors"
          >
            {theme === 'light' ? <Moon size={20} /> : <Sun size={20} />}
          </button>

          {/* Logout Button */}
          <button
            onClick={onLogout}
            className="p-2 hover:bg-accent/10 rounded-lg transition-colors"
            title="Logout"
          >
            <LogOut size={20} />
          </button>
        </div>
      </div>
    </div>
  );
}