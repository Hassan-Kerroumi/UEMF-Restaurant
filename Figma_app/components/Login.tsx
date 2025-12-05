import { useState } from 'react';
import { LogIn, User, Lock } from 'lucide-react';
import { useApp } from '../contexts/AppContext';

interface LoginProps {
  onLogin: (username: string, isAdmin: boolean) => void;
}

export function Login({ onLogin }: LoginProps) {
  const { language } = useApp();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!username || !password) {
      setError(language === 'ar' ? 'يرجى ملء جميع الحقول' : language === 'fr' ? 'Veuillez remplir tous les champs' : 'Please fill in all fields');
      return;
    }

    const isAdmin = username.toLowerCase() === 'admin';
    onLogin(username, isAdmin);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#062c6b] via-[#0a4099] to-[#062c6b] flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo/Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-white/10 backdrop-blur-sm rounded-3xl mb-4">
            <Utensils className="w-10 h-10 text-white" />
          </div>
          <h1 className="text-white text-3xl mb-2">
            {language === 'ar' ? 'مطعم الجامعة' : language === 'fr' ? 'Restaurant Universitaire' : 'University Restaurant'}
          </h1>
          <p className="text-white/70">
            {language === 'ar' ? 'تسجيل الدخول للمتابعة' : language === 'fr' ? 'Connectez-vous pour continuer' : 'Sign in to continue'}
          </p>
        </div>

        {/* Login Form */}
        <div className="bg-white rounded-3xl shadow-2xl p-8">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Username */}
            <div>
              <label className="block text-sm mb-2 text-foreground">
                {language === 'ar' ? 'اسم المستخدم' : language === 'fr' ? 'Nom d\'utilisateur' : 'Username'}
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" size={20} />
                <input
                  type="text"
                  value={username}
                  onChange={(e) => {
                    setUsername(e.target.value);
                    setError('');
                  }}
                  placeholder={language === 'ar' ? 'أدخل اسم المستخدم' : language === 'fr' ? 'Entrez votre nom' : 'Enter username'}
                  className="w-full pl-10 pr-4 py-3 rounded-xl border border-border bg-background focus:outline-none focus:ring-2 focus:ring-[#3cad2a]"
                />
              </div>
            </div>

            {/* Password */}
            <div>
              <label className="block text-sm mb-2 text-foreground">
                {language === 'ar' ? 'كلمة المرور' : language === 'fr' ? 'Mot de passe' : 'Password'}
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" size={20} />
                <input
                  type="password"
                  value={password}
                  onChange={(e) => {
                    setPassword(e.target.value);
                    setError('');
                  }}
                  placeholder={language === 'ar' ? 'أدخل كلمة المرور' : language === 'fr' ? 'Entrez le mot de passe' : 'Enter password'}
                  className="w-full pl-10 pr-4 py-3 rounded-xl border border-border bg-background focus:outline-none focus:ring-2 focus:ring-[#3cad2a]"
                />
              </div>
            </div>

            {/* Error Message */}
            {error && (
              <div className="p-3 bg-red-500/10 border border-red-500/20 rounded-lg">
                <p className="text-sm text-red-500">{error}</p>
              </div>
            )}

            {/* Submit Button */}
            <button
              type="submit"
              className="w-full py-3 bg-[#3cad2a] text-white rounded-xl hover:bg-[#3cad2a]/90 transition-colors flex items-center justify-center gap-2"
            >
              <LogIn size={20} />
              {language === 'ar' ? 'تسجيل الدخول' : language === 'fr' ? 'Se connecter' : 'Sign In'}
            </button>
          </form>

          {/* Demo Info */}
          <div className="mt-6 p-4 bg-muted rounded-xl">
            <p className="text-sm text-muted-foreground mb-2">
              {language === 'ar' ? 'معلومات تجريبية:' : language === 'fr' ? 'Infos de démo:' : 'Demo Info:'}
            </p>
            <div className="text-xs space-y-1 text-muted-foreground">
              <p>
                {language === 'ar' ? 'مدير: admin' : language === 'fr' ? 'Admin: admin' : 'Admin: admin'}
              </p>
              <p>
                {language === 'ar' ? 'طالب: أي اسم آخر' : language === 'fr' ? 'Étudiant: tout autre nom' : 'Student: any other name'}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function Utensils({ className }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2" />
      <path d="M7 2v20" />
      <path d="M21 15V2v0a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7" />
    </svg>
  );
}
