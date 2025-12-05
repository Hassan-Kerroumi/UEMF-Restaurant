import { useApp } from '../contexts/AppContext';
import { 
  Coffee, 
  IceCream, 
  Cake, 
  Croissant, 
  Pizza, 
  Utensils, 
  Sandwich, 
  Salad, 
  Milk, 
  Cookie 
} from 'lucide-react';

const categoryIcons: { [key: string]: any } = {
  'hot-drinks': Coffee,
  'cold-drinks': IceCream,
  'cakes-desserts': Cake,
  'breakfast': Croissant,
  'pizza-pasta': Pizza,
  'dishes': Utensils,
  'sandwiches': Sandwich,
  'salads': Salad,
  'dairy': Milk,
  'snacks': Cookie,
};

interface CategoryScrollProps {
  selectedCategory: string | null;
  onCategorySelect: (categoryId: string | null) => void;
  categories: Array<{
    id: string;
    name: string;
    nameFr: string;
    nameAr: string;
  }>;
  mode?: 'user' | 'admin';
}

export function CategoryScroll({ selectedCategory, onCategorySelect, categories, mode = 'user' }: CategoryScrollProps) {
  const { t, language } = useApp();
  const accentColor = mode === 'admin' ? '#c74242' : '#3cad2a';

  return (
    <div className="w-full overflow-x-auto pb-2 scrollbar-hide">
      <div className="flex gap-2 min-w-max px-4">
        {/* All Categories Button */}
        <button
          onClick={() => onCategorySelect(null)}
          className={`flex flex-col items-center justify-center gap-1 px-4 py-3 rounded-xl transition-all min-w-[80px] ${
            selectedCategory === null
              ? `text-white shadow-md scale-105`
              : 'bg-card hover:bg-muted border border-border'
          }`}
          style={selectedCategory === null ? { backgroundColor: accentColor } : undefined}
        >
          <Utensils className="w-6 h-6" />
          <span className="text-xs whitespace-nowrap">
            {language === 'ar' ? 'الكل' : language === 'fr' ? 'Tout' : 'All'}
          </span>
        </button>

        {/* Category Buttons */}
        {categories.map((category) => {
          const Icon = categoryIcons[category.id] || Utensils;
          const categoryName = 
            language === 'ar' 
              ? category.nameAr 
              : language === 'fr' 
              ? category.nameFr 
              : category.name;

          return (
            <button
              key={category.id}
              onClick={() => onCategorySelect(category.id)}
              className={`flex flex-col items-center justify-center gap-1 px-4 py-3 rounded-xl transition-all min-w-[80px] ${
                selectedCategory === category.id
                  ? `text-white shadow-md scale-105`
                  : 'bg-card hover:bg-muted border border-border'
              }`}
              style={selectedCategory === category.id ? { backgroundColor: accentColor } : undefined}
            >
              <Icon className="w-6 h-6" />
              <span className="text-xs whitespace-nowrap">{categoryName}</span>
            </button>
          );
        })}
      </div>

      <style>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </div>
  );
}
