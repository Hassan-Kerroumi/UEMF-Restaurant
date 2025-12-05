import { useState } from 'react';
import { Search, Calendar, Info } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { tomorrowSuggestions, Product } from '../../data/mockData';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '../ui/dialog';
import { toast } from 'sonner@2.0.3';

export function UserUpcoming() {
  const { t, language } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedMeal, setSelectedMeal] = useState<Product | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [quantity, setQuantity] = useState(1);
  const [preferredTime, setPreferredTime] = useState('12:00');

  const mealTypes = [
    { id: 'breakfast', name: 'Breakfast', time: '08:00 - 10:00' },
    { id: 'lunch', name: 'Lunch', time: '12:00 - 15:00' },
    { id: 'dinner', name: 'Dinner', time: '18:00 - 21:00' },
  ];

  const handlePreSelect = (product: Product) => {
    setSelectedMeal(product);
    setIsModalOpen(true);
  };

  const handleConfirm = () => {
    const mealName = language === 'fr' 
      ? selectedMeal?.nameFr 
      : language === 'ar' 
        ? selectedMeal?.nameAr 
        : selectedMeal?.name;
    toast.success(`Pre-selected ${quantity}x ${mealName} for tomorrow at ${preferredTime}`);
    setIsModalOpen(false);
    setQuantity(1);
  };

  const timeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00',
  ];

  return (
    <div className="pb-20 pt-16 px-4">
      {/* Header */}
      <div className="mb-6">
        <h2 className="mb-2">{t('tomorrowMenu')}</h2>
        <div className="flex items-start gap-2 p-3 bg-blue-500/10 border border-blue-500/20 rounded-lg">
          <Info size={18} className="text-blue-500 mt-0.5 flex-shrink-0" />
          <p className="text-sm text-blue-500">{t('changeUntilMidnight')}</p>
        </div>
      </div>

      {/* Search */}
      <div className="relative mb-6">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" size={20} />
        <input
          type="text"
          placeholder={t('search')}
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-10 pr-4 py-3 rounded-xl bg-card border border-border focus:outline-none focus:ring-2 focus:ring-[#3cad2a]"
        />
      </div>

      {/* Meal Type Categories */}
      <div className="mb-6">
        <h3 className="mb-3">Meal Times</h3>
        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {mealTypes.map((meal) => (
            <button
              key={meal.id}
              className="px-4 py-3 rounded-lg bg-card border border-border whitespace-nowrap hover:bg-muted transition-colors"
            >
              <div className="text-sm">{meal.name}</div>
              <div className="text-xs text-muted-foreground">{meal.time}</div>
            </button>
          ))}
        </div>
      </div>

      {/* Tomorrow's Suggestions */}
      <div>
        <h3 className="mb-4">Suggested Meals</h3>
        <div className="grid grid-cols-1 gap-4">
          {tomorrowSuggestions.map((product) => {
            const productName = language === 'fr' 
              ? product.nameFr 
              : language === 'ar' 
                ? product.nameAr 
                : product.name;

            return (
              <div
                key={product.id}
                className="bg-card rounded-xl overflow-hidden shadow-md hover:shadow-lg transition-shadow"
              >
                <div className="flex gap-4 p-4">
                  <img
                    src={product.image}
                    alt={productName}
                    className="w-24 h-24 rounded-lg object-cover"
                  />
                  <div className="flex-1 flex flex-col justify-between">
                    <div>
                      <h4 className="mb-1">{productName}</h4>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <Calendar size={14} />
                        <span>Available tomorrow</span>
                      </div>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-lg text-[#3cad2a]">${product.price}</span>
                      <button
                        onClick={() => handlePreSelect(product)}
                        className="px-4 py-2 bg-[#3cad2a] text-white rounded-lg hover:bg-[#3cad2a]/90 transition-colors"
                      >
                        {t('preSelect')}
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Pre-Selection Modal */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Pre-select for Tomorrow</DialogTitle>
          </DialogHeader>
          
          {selectedMeal && (
            <div className="space-y-4">
              <img 
                src={selectedMeal.image} 
                alt={language === 'fr' ? selectedMeal.nameFr : language === 'ar' ? selectedMeal.nameAr : selectedMeal.name}
                className="w-full h-48 object-cover rounded-lg"
              />
              
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground">{t('quantity')}</span>
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setQuantity(Math.max(1, quantity - 1))}
                    className="w-8 h-8 rounded-lg bg-muted flex items-center justify-center hover:bg-muted/80"
                  >
                    -
                  </button>
                  <span className="w-8 text-center">{quantity}</span>
                  <button
                    onClick={() => setQuantity(quantity + 1)}
                    className="w-8 h-8 rounded-lg bg-[#3cad2a] text-white flex items-center justify-center hover:bg-[#3cad2a]/90"
                  >
                    +
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-muted-foreground mb-2">
                  Preferred Time
                </label>
                <select
                  value={preferredTime}
                  onChange={(e) => setPreferredTime(e.target.value)}
                  className="w-full p-2 rounded-lg bg-input border border-border"
                >
                  {timeSlots.map((time) => (
                    <option key={time} value={time}>
                      {time}
                    </option>
                  ))}
                </select>
              </div>

              <div className="p-3 bg-blue-500/10 border border-blue-500/20 rounded-lg">
                <p className="text-sm text-blue-500">
                  {t('changeUntilMidnight')}
                </p>
              </div>

              <button
                onClick={handleConfirm}
                className="w-full py-3 bg-[#3cad2a] text-white rounded-lg hover:bg-[#3cad2a]/90 transition-colors"
              >
                {t('confirm')}
              </button>
            </div>
          )}
        </DialogContent>
      </Dialog>

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
