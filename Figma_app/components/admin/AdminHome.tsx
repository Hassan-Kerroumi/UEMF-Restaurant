import { useState } from 'react';
import { Search, Clock, User, Check, X, MessageSquare } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { mockOrders, categories } from '../../data/mockData';
import { toast } from 'sonner@2.0.3';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '../ui/dialog';
import { CategoryScroll } from '../CategoryScroll';

export function AdminHome() {
  const { t, language } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [selectedOrder, setSelectedOrder] = useState<any>(null);
  const [suggestedTime, setSuggestedTime] = useState('');
  const [isTimeDialogOpen, setIsTimeDialogOpen] = useState(false);
  const [isAcceptDialogOpen, setIsAcceptDialogOpen] = useState(false);
  const [isRefuseDialogOpen, setIsRefuseDialogOpen] = useState(false);

  const todayOrders = mockOrders.filter(order => order.date === '2025-11-09');

  const handleAcceptClick = (order: any) => {
    setSelectedOrder(order);
    setIsAcceptDialogOpen(true);
  };

  const handleConfirmAccept = () => {
    toast.success(`Order from ${selectedOrder.studentName} accepted for ${selectedOrder.pickupTime}`);
    setIsAcceptDialogOpen(false);
    setSelectedOrder(null);
  };

  const handleRefuseClick = (order: any) => {
    setSelectedOrder(order);
    setIsRefuseDialogOpen(true);
  };

  const handleConfirmRefuse = () => {
    toast.error(`Order from ${selectedOrder.studentName} refused`);
    setIsRefuseDialogOpen(false);
    setSelectedOrder(null);
  };

  const handleSuggestTime = (orderId: string) => {
    setSelectedOrder(orderId);
    setIsTimeDialogOpen(true);
  };

  const handleConfirmSuggestedTime = () => {
    toast.success(`Suggested time ${suggestedTime} sent to student`);
    setIsTimeDialogOpen(false);
    setSuggestedTime('');
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending':
        return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'accepted':
        return 'bg-[#3cad2a]/10 text-[#3cad2a] border-[#3cad2a]/20';
      case 'refused':
        return 'bg-red-500/10 text-red-500 border-red-500/20';
      default:
        return 'bg-gray-500/10 text-gray-500 border-gray-500/20';
    }
  };

  const timeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30', '18:00',
  ];

  return (
    <div className="pb-20 pt-16 px-4">
      <h2 className="mb-4 text-[#c74242]">{t('ordersOfTheDay')}</h2>

      {/* Search */}
      <div className="relative mb-6">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" size={20} />
        <input
          type="text"
          placeholder={t('search')}
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-10 pr-4 py-3 rounded-xl bg-card border border-border focus:outline-none focus:ring-2 focus:ring-[#c74242]"
        />
      </div>

      {/* Categories */}
      <div className="mb-6">
        <h3 className="mb-3 px-4">{t('categories')}</h3>
        <CategoryScroll
          selectedCategory={selectedCategory}
          onCategorySelect={setSelectedCategory}
          categories={categories}
          mode="admin"
        />
      </div>

      {/* Orders List */}
      <div className="space-y-4">
        {todayOrders.map((order) => {
          const totalItems = order.items.reduce((sum, item) => sum + item.quantity, 0);
          const totalPrice = order.items.reduce((sum, item) => sum + (item.product.price * item.quantity), 0);

          return (
            <div
              key={order.id}
              className={`bg-card rounded-xl p-4 shadow-md border ${getStatusColor(order.status)}`}
            >
              <div className="flex items-start justify-between mb-3">
                <div className="flex items-center gap-2">
                  <User size={18} className="text-muted-foreground" />
                  <h4>{order.studentName}</h4>
                </div>
                <span className={`px-2 py-1 rounded-lg text-xs border ${getStatusColor(order.status)}`}>
                  {t(order.status)}
                </span>
              </div>

              <div className="space-y-2 mb-3">
                {order.items.map((item, index) => {
                  const productName = language === 'fr' 
                    ? item.product.nameFr 
                    : language === 'ar' 
                      ? item.product.nameAr 
                      : item.product.name;
                  return (
                    <div key={index} className="flex items-center gap-3">
                      <img
                        src={item.product.image}
                        alt={productName}
                        className="w-12 h-12 rounded-lg object-cover"
                      />
                      <div className="flex-1">
                        <p className="text-sm">{productName}</p>
                        <p className="text-xs text-muted-foreground">
                          Qty: {item.quantity} × ${item.product.price}
                        </p>
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="flex items-center gap-4 text-sm text-muted-foreground mb-3 pb-3 border-b border-border">
                <div className="flex items-center gap-1">
                  <Clock size={14} />
                  <span>{order.pickupTime}</span>
                </div>
                <span className="capitalize">{order.type}</span>
                <span className="ml-auto text-lg text-foreground">${totalPrice.toFixed(2)}</span>
              </div>

              {order.status === 'pending' && (
                <div className="flex gap-2">
                  <button
                    onClick={() => handleAcceptClick(order)}
                    className="flex-1 flex items-center justify-center gap-2 py-2 bg-[#3cad2a] text-white rounded-lg hover:bg-[#3cad2a]/90 transition-colors"
                  >
                    <Check size={16} />
                    {t('accept')}
                  </button>
                  <button
                    onClick={() => handleRefuseClick(order)}
                    className="flex-1 flex items-center justify-center gap-2 py-2 bg-red-500 text-white rounded-lg hover:bg-red-500/90 transition-colors"
                  >
                    <X size={16} />
                    {t('refuse')}
                  </button>
                  <button
                    onClick={() => handleSuggestTime(order.id)}
                    className="flex items-center justify-center gap-2 px-4 py-2 border border-border rounded-lg hover:bg-muted transition-colors"
                  >
                    <MessageSquare size={16} />
                  </button>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Suggest Time Dialog */}
      <Dialog open={isTimeDialogOpen} onOpenChange={setIsTimeDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{t('suggestTime')}</DialogTitle>
          </DialogHeader>
          
          <div className="space-y-4">
            <div>
              <label className="block text-muted-foreground mb-2">
                Suggested Pickup Time
              </label>
              <select
                value={suggestedTime}
                onChange={(e) => setSuggestedTime(e.target.value)}
                className="w-full p-2 rounded-lg bg-input border border-border"
              >
                <option value="">Select time...</option>
                {timeSlots.map((time) => (
                  <option key={time} value={time}>
                    {time}
                  </option>
                ))}
              </select>
            </div>

            <button
              onClick={handleConfirmSuggestedTime}
              disabled={!suggestedTime}
              className="w-full py-3 bg-[#c74242] text-white rounded-lg hover:bg-[#c74242]/90 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {t('confirm')}
            </button>
          </div>
        </DialogContent>
      </Dialog>

      {/* Accept Confirmation Dialog */}
      <Dialog open={isAcceptDialogOpen} onOpenChange={setIsAcceptDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Accept Order</DialogTitle>
          </DialogHeader>
          
          {selectedOrder && (
            <div className="space-y-4">
              <div className="p-4 bg-[#3cad2a]/10 border border-[#3cad2a]/20 rounded-lg">
                <p className="mb-2"><strong>Student:</strong> {selectedOrder.studentName}</p>
                <p className="mb-2"><strong>Pickup Time:</strong> {selectedOrder.pickupTime}</p>
                <p className="mb-2"><strong>Type:</strong> {selectedOrder.type}</p>
                <p><strong>Items:</strong></p>
                <ul className="list-disc list-inside mt-1">
                  {selectedOrder.items.map((item: any, idx: number) => (
                    <li key={idx} className="text-sm">
                      {item.quantity}x {item.product.name}
                    </li>
                  ))}
                </ul>
              </div>

              <p className="text-sm text-muted-foreground">
                Are you sure you want to accept this order? The student will be notified.
              </p>

              <div className="flex gap-2">
                <button
                  onClick={() => setIsAcceptDialogOpen(false)}
                  className="flex-1 py-3 border border-border rounded-lg hover:bg-muted transition-colors"
                >
                  Cancel
                </button>
                <button
                  onClick={handleConfirmAccept}
                  className="flex-1 py-3 bg-[#3cad2a] text-white rounded-lg hover:bg-[#3cad2a]/90 transition-colors"
                >
                  Confirm Accept
                </button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Refuse Confirmation Dialog */}
      <Dialog open={isRefuseDialogOpen} onOpenChange={setIsRefuseDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Refuse Order</DialogTitle>
          </DialogHeader>
          
          {selectedOrder && (
            <div className="space-y-4">
              <div className="p-4 bg-red-500/10 border border-red-500/20 rounded-lg">
                <p className="mb-2"><strong>Student:</strong> {selectedOrder.studentName}</p>
                <p className="mb-2"><strong>Pickup Time:</strong> {selectedOrder.pickupTime}</p>
                <p><strong>Items:</strong></p>
                <ul className="list-disc list-inside mt-1">
                  {selectedOrder.items.map((item: any, idx: number) => (
                    <li key={idx} className="text-sm">
                      {item.quantity}x {item.product.name}
                    </li>
                  ))}
                </ul>
              </div>

              <p className="text-sm text-red-500">
                Are you sure you want to refuse this order? The student will be notified and their credit will be refunded.
              </p>

              <div className="flex gap-2">
                <button
                  onClick={() => setIsRefuseDialogOpen(false)}
                  className="flex-1 py-3 border border-border rounded-lg hover:bg-muted transition-colors"
                >
                  Cancel
                </button>
                <button
                  onClick={handleConfirmRefuse}
                  className="flex-1 py-3 bg-red-500 text-white rounded-lg hover:bg-red-500/90 transition-colors"
                >
                  Confirm Refuse
                </button>
              </div>
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
