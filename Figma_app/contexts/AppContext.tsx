import React, { createContext, useContext, useState, useEffect } from 'react';

type Language = 'en' | 'fr' | 'ar';
type Theme = 'light' | 'dark';
type UserMode = 'user' | 'admin';

interface AppContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  theme: Theme;
  toggleTheme: () => void;
  mode: UserMode;
  setMode: (mode: UserMode) => void;
  t: (key: string) => string;
}

const translations = {
  en: {
    // Common
    search: 'Search...',
    cancel: 'Cancel',
    confirm: 'Confirm',
    edit: 'Edit',
    delete: 'Delete',
    save: 'Save',
    
    // User App
    home: 'Home',
    history: 'History',
    upcoming: 'Upcoming',
    creditBalance: 'Credit Balance',
    categories: 'Categories',
    suggestions: 'Suggestions for you',
    order: 'Order',
    quantity: 'Quantity',
    pickupTime: 'Pickup Time',
    takeAway: 'Take Away',
    eatIn: 'Eat In',
    pending: 'Pending',
    confirmed: 'Confirmed',
    paid: 'Paid',
    cancelled: 'Cancelled',
    tomorrowMenu: "Tomorrow's Menu Suggestions",
    preSelect: 'Pre-select',
    changeUntilMidnight: 'You can change your choice until midnight',
    
    // Admin App
    ordersOfTheDay: 'Orders of the Day',
    products: 'Products',
    allOrders: 'All Orders',
    stats: 'Statistics',
    accept: 'Accept',
    refuse: 'Refuse',
    suggestTime: 'Suggest Time',
    addNew: 'Add New',
    tomorrowPlanned: "Tomorrow's Planned Meals",
    totalOrders: 'Total Orders Today',
    mostOrdered: 'Most Ordered Items',
    avgWaitTime: 'Average Waiting Time',
    accepted: 'Accepted',
    refused: 'Refused',
    
    // Categories
    hotDrinks: 'Hot Drinks',
    coldDrinks: 'Cold Drinks',
    cakesDesserts: 'Cakes & Desserts',
    breakfast: 'Breakfast',
    pizzaPasta: 'Pizza & Pasta',
    dishes: 'Main Dishes',
    sandwiches: 'Sandwiches',
    salads: 'Salads',
    dairy: 'Dairy',
    snacks: 'Snacks',
  },
  fr: {
    // Common
    search: 'Rechercher...',
    cancel: 'Annuler',
    confirm: 'Confirmer',
    edit: 'Modifier',
    delete: 'Supprimer',
    save: 'Enregistrer',
    
    // User App
    home: 'Accueil',
    history: 'Historique',
    upcoming: 'À venir',
    creditBalance: 'Solde de crédit',
    categories: 'Catégories',
    suggestions: 'Suggestions pour vous',
    order: 'Commander',
    quantity: 'Quantité',
    pickupTime: 'Heure de retrait',
    takeAway: 'À emporter',
    eatIn: 'Sur place',
    pending: 'En attente',
    confirmed: 'Confirmé',
    paid: 'Payé',
    cancelled: 'Annulé',
    tomorrowMenu: 'Menu de demain',
    preSelect: 'Pré-sélectionner',
    changeUntilMidnight: 'Vous pouvez changer votre choix jusqu\'à minuit',
    
    // Admin App
    ordersOfTheDay: 'Commandes du jour',
    products: 'Produits',
    allOrders: 'Toutes les commandes',
    stats: 'Statistiques',
    accept: 'Accepter',
    refuse: 'Refuser',
    suggestTime: 'Proposer un horaire',
    addNew: 'Ajouter',
    tomorrowPlanned: 'Repas prévus pour demain',
    totalOrders: 'Commandes totales aujourd\'hui',
    mostOrdered: 'Articles les plus commandés',
    avgWaitTime: 'Temps d\'attente moyen',
    accepted: 'Accepté',
    refused: 'Refusé',
    
    // Categories
    hotDrinks: 'Boissons chaudes',
    coldDrinks: 'Boissons froides',
    cakesDesserts: 'Gâteaux & desserts',
    breakfast: 'Petit déjeuner',
    pizzaPasta: 'Pizza & pâtes',
    dishes: 'Plats',
    sandwiches: 'Sandwiches',
    salads: 'Salades',
    dairy: 'Laitage',
    snacks: 'Snacks',
  },
  ar: {
    // Common
    search: 'بحث...',
    cancel: 'إلغاء',
    confirm: 'تأكيد',
    edit: 'تعديل',
    delete: 'حذف',
    save: 'حفظ',
    
    // User App
    home: 'الرئيسية',
    history: 'السجل',
    upcoming: 'القادم',
    creditBalance: 'رصيد الحساب',
    categories: 'الفئات',
    suggestions: 'اقتراحات لك',
    order: 'اطلب',
    quantity: 'الكمية',
    pickupTime: 'وقت الاستلام',
    takeAway: 'للخارج',
    eatIn: 'تناول هنا',
    pending: 'قيد الانتظار',
    confirmed: 'مؤكد',
    paid: 'مدفوع',
    cancelled: 'ملغى',
    tomorrowMenu: 'قائمة الغد',
    preSelect: 'اختيار مسبق',
    changeUntilMidnight: 'يمكنك تغيير اختيارك حتى منتصف الليل',
    
    // Admin App
    ordersOfTheDay: 'طلبات اليوم',
    products: 'المنتجات',
    allOrders: 'كل الطلبات',
    stats: 'الإحصائيات',
    accept: 'قبول',
    refuse: 'رفض',
    suggestTime: 'اقتراح وقت',
    addNew: 'إضافة جديد',
    tomorrowPlanned: 'الوجبات المخططة لغد',
    totalOrders: 'إجمالي الطلبات اليوم',
    mostOrdered: 'الأكثر طلباً',
    avgWaitTime: 'متوسط وقت الانتظار',
    accepted: 'مقبول',
    refused: 'مرفوض',
    
    // Categories
    hotDrinks: 'مشروبات ساخنة',
    coldDrinks: 'مشروبات باردة',
    cakesDesserts: 'كعك وحلويات',
    breakfast: 'فطور',
    pizzaPasta: 'بيتزا ومعكرونة',
    dishes: 'أطباق رئيسية',
    sandwiches: 'ساندويتشات',
    salads: 'سلطات',
    dairy: 'ألبان',
    snacks: 'وجبات خفيفة',
  },
};

const AppContext = createContext<AppContextType | undefined>(undefined);

export function AppProvider({ children }: { children: React.ReactNode }) {
  const [language, setLanguage] = useState<Language>('en');
  const [theme, setTheme] = useState<Theme>('dark');
  const [mode, setMode] = useState<UserMode>('user');

  useEffect(() => {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  const t = (key: string): string => {
    return translations[language][key as keyof typeof translations['en']] || key;
  };

  return (
    <AppContext.Provider value={{ language, setLanguage, theme, toggleTheme, mode, setMode, t }}>
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
}