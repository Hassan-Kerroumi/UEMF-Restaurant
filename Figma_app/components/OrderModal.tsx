import { useState } from 'react';
import { X, Minus, Plus } from 'lucide-react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from './ui/dialog';
import { Product } from '../data/mockData';
import { useApp } from '../contexts/AppContext';
import { toast } from 'sonner@2.0.3';

interface OrderModalProps {
  product: Product | null;
  isOpen: boolean;
  onClose: () => void;
}

export function OrderModal({ product, isOpen, onClose }: OrderModalProps) {
  const { t, language } = useApp();
  const [quantity, setQuantity] = useState(1);
  const [pickupTime, setPickupTime] = useState('12:00');
  const [orderType, setOrderType] = useState<'takeaway' | 'eatin'>('eatin');

  if (!product) return null;

  const productName = language === 'fr' ? product.nameFr : language === 'ar' ? product.nameAr : product.name;

  const handleConfirm = () => {
    toast.success(`Order confirmed for ${quantity}x ${productName}`);
    onClose();
    setQuantity(1);
  };

  const timeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30', '18:00',
  ];

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>{productName}</DialogTitle>
        </DialogHeader>
        
        <div className="space-y-4">
          <img 
            src={product.image} 
            alt={productName}
            className="w-full h-48 object-cover rounded-lg"
          />
          
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">{t('quantity')}</span>
            <div className="flex items-center gap-3">
              <button
                onClick={() => setQuantity(Math.max(1, quantity - 1))}
                className="w-8 h-8 rounded-lg bg-muted flex items-center justify-center hover:bg-muted/80"
              >
                <Minus size={16} />
              </button>
              <span className="w-8 text-center">{quantity}</span>
              <button
                onClick={() => setQuantity(quantity + 1)}
                className="w-8 h-8 rounded-lg bg-[#3cad2a] text-white flex items-center justify-center hover:bg-[#3cad2a]/90"
              >
                <Plus size={16} />
              </button>
            </div>
          </div>

          <div>
            <label className="block text-muted-foreground mb-2">
              {t('pickupTime')}
            </label>
            <select
              value={pickupTime}
              onChange={(e) => setPickupTime(e.target.value)}
              className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#3cad2a]"
            >
              {timeSlots.map((time) => (
                <option key={time} value={time} className="bg-card text-foreground">
                  {time}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-muted-foreground mb-2">Type</label>
            <div className="flex gap-2">
              <button
                onClick={() => setOrderType('eatin')}
                className={`flex-1 p-3 rounded-lg border transition-colors ${
                  orderType === 'eatin'
                    ? 'bg-[#3cad2a] text-white border-[#3cad2a]'
                    : 'border-border hover:bg-muted'
                }`}
              >
                {t('eatIn')}
              </button>
              <button
                onClick={() => setOrderType('takeaway')}
                className={`flex-1 p-3 rounded-lg border transition-colors ${
                  orderType === 'takeaway'
                    ? 'bg-[#3cad2a] text-white border-[#3cad2a]'
                    : 'border-border hover:bg-muted'
                }`}
              >
                {t('takeAway')}
              </button>
            </div>
          </div>

          <div className="flex items-center justify-between pt-2">
            <div>
              <span className="text-muted-foreground">Total: </span>
              <span className="text-xl">${(product.price * quantity).toFixed(2)}</span>
            </div>
            <button
              onClick={handleConfirm}
              className="px-6 py-2 bg-[#3cad2a] text-white rounded-lg hover:bg-[#3cad2a]/90 transition-colors"
            >
              {t('confirm')}
            </button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
