import { useState } from 'react';
import { Search, User, Clock } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { mockOrders } from '../../data/mockData';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../ui/tabs';

export function AdminOrders() {
  const { t, language } = useApp();
  const [searchQuery, setSearchQuery] = useState('');

  const statusTabs = ['pending', 'accepted', 'refused', 'cancelled'];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending':
        return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'accepted':
      case 'confirmed':
        return 'bg-[#3cad2a]/10 text-[#3cad2a] border-[#3cad2a]/20';
      case 'refused':
      case 'cancelled':
        return 'bg-red-500/10 text-red-500 border-red-500/20';
      default:
        return 'bg-gray-500/10 text-gray-500 border-gray-500/20';
    }
  };

  return (
    <div className="pb-20 pt-16 px-4">
      <h2 className="mb-4 text-[#c74242]">{t('allOrders')}</h2>

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
                        <div>
                          <h4>{order.studentName}</h4>
                          <p className="text-xs text-muted-foreground">{order.date}</p>
                        </div>
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
                          <div key={index} className="flex items-center gap-3 bg-muted/30 p-2 rounded-lg">
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
                            <span className="text-sm">${(item.product.price * item.quantity).toFixed(2)}</span>
                          </div>
                        );
                      })}
                    </div>

                    <div className="flex items-center justify-between pt-3 border-t border-border">
                      <div className="flex items-center gap-4 text-sm text-muted-foreground">
                        <div className="flex items-center gap-1">
                          <Clock size={14} />
                          <span>{order.pickupTime}</span>
                        </div>
                        <span className="capitalize">{order.type}</span>
                      </div>
                      <span className="text-lg">${totalPrice.toFixed(2)}</span>
                    </div>
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
