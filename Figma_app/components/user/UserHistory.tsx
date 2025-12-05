import { useState } from 'react';
import { Search, Clock, MapPin } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { mockOrders } from '../../data/mockData';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../ui/tabs';

export function UserHistory() {
  const { t, language } = useApp();
  const [searchQuery, setSearchQuery] = useState('');

  const statusTabs = ['pending', 'confirmed', 'paid', 'cancelled'];
  
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending':
        return 'bg-yellow-500/10 text-yellow-500';
      case 'confirmed':
        return 'bg-blue-500/10 text-blue-500';
      case 'paid':
        return 'bg-[#3cad2a]/10 text-[#3cad2a]';
      case 'cancelled':
        return 'bg-red-500/10 text-red-500';
      default:
        return 'bg-gray-500/10 text-gray-500';
    }
  };

  return (
    <div className="pb-20 pt-16 px-4">
      <h2 className="mb-4">{t('history')}</h2>

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

      {/* Status Tabs */}
      <Tabs defaultValue="pending" className="w-full">
        <TabsList className="grid w-full grid-cols-4 mb-6">
          {statusTabs.map((status) => (
            <TabsTrigger key={status} value={status} className="text-xs">
              {t(status)}
            </TabsTrigger>
          ))}
        </TabsList>

        {statusTabs.map((status) => (
          <TabsContent key={status} value={status} className="space-y-4">
            {mockOrders
              .filter((order) => order.status === status)
              .map((order) => {
                const productName = language === 'fr' 
                  ? order.items[0].product.nameFr 
                  : language === 'ar' 
                    ? order.items[0].product.nameAr 
                    : order.items[0].product.name;

                const totalItems = order.items.reduce((sum, item) => sum + item.quantity, 0);
                const totalPrice = order.items.reduce((sum, item) => sum + (item.product.price * item.quantity), 0);

                return (
                  <div
                    key={order.id}
                    className="bg-card rounded-xl p-4 shadow-md border border-border"
                  >
                    <div className="flex gap-4">
                      <img
                        src={order.items[0].product.image}
                        alt={productName}
                        className="w-20 h-20 rounded-lg object-cover"
                      />
                      <div className="flex-1 space-y-2">
                        <div className="flex items-start justify-between">
                          <div>
                            <h4>{productName}</h4>
                            {order.items.length > 1 && (
                              <p className="text-sm text-muted-foreground">
                                +{order.items.length - 1} more items
                              </p>
                            )}
                          </div>
                          <span className={`px-2 py-1 rounded-lg text-xs ${getStatusColor(order.status)}`}>
                            {t(order.status)}
                          </span>
                        </div>
                        
                        <div className="flex items-center gap-4 text-sm text-muted-foreground">
                          <div className="flex items-center gap-1">
                            <Clock size={14} />
                            <span>{order.pickupTime}</span>
                          </div>
                          <div className="flex items-center gap-1">
                            <MapPin size={14} />
                            <span>{t(order.type === 'eatin' ? 'eatIn' : 'takeAway')}</span>
                          </div>
                        </div>

                        <div className="flex items-center justify-between">
                          <span className="text-sm text-muted-foreground">
                            {totalItems} items
                          </span>
                          <span className="text-lg text-[#3cad2a]">
                            ${totalPrice.toFixed(2)}
                          </span>
                        </div>
                      </div>
                    </div>

                    {status === 'pending' && (
                      <button className="w-full mt-3 py-2 border border-red-500 text-red-500 rounded-lg hover:bg-red-500/10 transition-colors">
                        {t('cancel')}
                      </button>
                    )}
                  </div>
                );
              })}
            {mockOrders.filter((order) => order.status === status).length === 0 && (
              <div className="text-center py-12 text-muted-foreground">
                No {status} orders
              </div>
            )}
          </TabsContent>
        ))}
      </Tabs>
    </div>
  );
}
