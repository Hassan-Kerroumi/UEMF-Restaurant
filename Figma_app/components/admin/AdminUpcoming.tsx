import { useState } from 'react';
import { Search, Calendar, User, Filter, Plus, Edit, Trash2, Save } from 'lucide-react';
import { useApp } from '../../contexts/AppContext';
import { tomorrowSuggestions, products } from '../../data/mockData';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '../ui/dialog';
import { toast } from 'sonner@2.0.3';

export function AdminUpcoming() {
  const { t, language } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<'all' | 'breakfast' | 'lunch' | 'dinner'>('all');
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [editingItems, setEditingItems] = useState<string[]>([]);
  const [newMeal, setNewMeal] = useState({
    productId: products[0]?.id || '',
    mealType: 'lunch' as 'breakfast' | 'lunch' | 'dinner',
  });

  // Mock data for tomorrow's pre-selected orders
  const tomorrowOrders = [
    {
      id: '1',
      studentName: 'Ahmed Ali',
      meal: tomorrowSuggestions[0],
      quantity: 1,
      timeSlot: '12:30',
      mealType: 'lunch',
    },
    {
      id: '2',
      studentName: 'Sara Ben',
      meal: tomorrowSuggestions[1],
      quantity: 2,
      timeSlot: '13:00',
      mealType: 'lunch',
    },
    {
      id: '3',
      studentName: 'Mohamed Kadi',
      meal: tomorrowSuggestions[2],
      quantity: 1,
      timeSlot: '13:30',
      mealType: 'lunch',
    },
    {
      id: '4',
      studentName: 'Leila Hassan',
      meal: tomorrowSuggestions[3],
      quantity: 1,
      timeSlot: '12:00',
      mealType: 'lunch',
    },
    {
      id: '5',
      studentName: 'Youssef Amin',
      meal: tomorrowSuggestions[0],
      quantity: 2,
      timeSlot: '09:00',
      mealType: 'breakfast',
    },
  ];

  const filteredOrders = tomorrowOrders.filter((order) => {
    const matchesFilter = filterType === 'all' || order.mealType === filterType;
    const matchesSearch = !searchQuery || 
      order.studentName.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  const mealTypeFilters = [
    { id: 'all', label: 'All Meals' },
    { id: 'breakfast', label: 'Breakfast' },
    { id: 'lunch', label: 'Lunch' },
    { id: 'dinner', label: 'Dinner' },
  ];

  // Statistics
  const totalOrders = tomorrowOrders.length;
  const totalMeals = tomorrowOrders.reduce((sum, order) => sum + order.quantity, 0);
  const mealsByType = tomorrowOrders.reduce((acc, order) => {
    acc[order.mealType] = (acc[order.mealType] || 0) + order.quantity;
    return acc;
  }, {} as Record<string, number>);

  const handleAddMeal = () => {
    const selectedProduct = products.find(p => p.id === newMeal.productId);
    if (selectedProduct) {
      toast.success(`Added ${selectedProduct.name} to ${newMeal.mealType} menu`);
      setIsAddDialogOpen(false);
    }
  };

  const handleDelete = (orderId: string, mealName: string) => {
    if (confirm(`Remove ${mealName} from tomorrow's menu?`)) {
      toast.error(`${mealName} removed from menu`);
    }
  };

  const toggleEdit = (orderId: string) => {
    if (editingItems.includes(orderId)) {
      setEditingItems(editingItems.filter(id => id !== orderId));
      toast.success('Changes saved');
    } else {
      setEditingItems([...editingItems, orderId]);
    }
  };

  return (
    <div className="pb-20 pt-16 px-4">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-[#c74242]">{t('tomorrowPlanned')}</h2>
        <button
          onClick={() => setIsAddDialogOpen(true)}
          className="flex items-center gap-2 px-4 py-2 bg-[#c74242] text-white rounded-lg hover:bg-[#c74242]/90 transition-colors"
        >
          <Plus size={18} />
          Add Meal
        </button>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-2 gap-4 mb-6">
        <div className="bg-gradient-to-br from-[#c74242] to-[#a53535] text-white p-4 rounded-xl shadow-md">
          <p className="text-sm opacity-90 mb-1">Total Pre-orders</p>
          <p className="text-2xl">{totalOrders}</p>
        </div>
        <div className="bg-gradient-to-br from-[#3cad2a] to-[#2d8a20] text-white p-4 rounded-xl shadow-md">
          <p className="text-sm opacity-90 mb-1">Total Meals</p>
          <p className="text-2xl">{totalMeals}</p>
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
          className="w-full pl-10 pr-4 py-3 rounded-xl bg-card border border-border focus:outline-none focus:ring-2 focus:ring-[#c74242]"
        />
      </div>

      {/* Meal Type Filters */}
      <div className="mb-6">
        <div className="flex items-center gap-2 mb-3">
          <Filter size={18} />
          <h3>Filter by Meal Type</h3>
        </div>
        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {mealTypeFilters.map((filter) => (
            <button
              key={filter.id}
              onClick={() => setFilterType(filter.id as any)}
              className={`px-4 py-2 rounded-lg whitespace-nowrap transition-colors ${
                filterType === filter.id
                  ? 'bg-[#c74242] text-white'
                  : 'bg-card border border-border'
              }`}
            >
              {filter.label}
              {filter.id !== 'all' && mealsByType[filter.id] && (
                <span className="ml-2 px-2 py-0.5 bg-white/20 rounded-full text-xs">
                  {mealsByType[filter.id]}
                </span>
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Orders List */}
      <div className="space-y-4">
        {filteredOrders.map((order) => {
          const mealName = language === 'fr' 
            ? order.meal.nameFr 
            : language === 'ar' 
              ? order.meal.nameAr 
              : order.meal.name;

          const isEditing = editingItems.includes(order.id);
          
          return (
            <div
              key={order.id}
              className="bg-card rounded-xl p-4 shadow-md border border-border hover:shadow-lg transition-shadow"
            >
              <div className="flex gap-4">
                <img
                  src={order.meal.image}
                  alt={mealName}
                  className="w-20 h-20 rounded-lg object-cover"
                />
                <div className="flex-1">
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1">
                        <User size={16} className="text-muted-foreground" />
                        <h4 className="text-sm">{order.studentName}</h4>
                      </div>
                      <p className="text-muted-foreground text-sm">{mealName}</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="px-2 py-1 bg-[#3cad2a]/10 text-[#3cad2a] rounded-lg text-xs border border-[#3cad2a]/20">
                        {order.mealType}
                      </span>
                      <button
                        onClick={() => toggleEdit(order.id)}
                        className={`p-2 rounded-lg transition-colors ${
                          isEditing 
                            ? 'bg-[#3cad2a] text-white' 
                            : 'bg-muted hover:bg-muted/80'
                        }`}
                      >
                        {isEditing ? <Save size={16} /> : <Edit size={16} />}
                      </button>
                      <button
                        onClick={() => handleDelete(order.id, mealName)}
                        className="p-2 bg-red-500/10 text-red-500 rounded-lg hover:bg-red-500/20 transition-colors"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </div>

                  <div className="flex items-center justify-between pt-2 border-t border-border">
                    <div className="flex items-center gap-4 text-sm text-muted-foreground">
                      <div className="flex items-center gap-1">
                        <Calendar size={14} />
                        <span>{order.timeSlot}</span>
                      </div>
                    </div>
                    <span className="text-sm">${order.meal.price.toFixed(2)}</span>
                  </div>
                </div>
              </div>
            </div>
          );
        })}

        {filteredOrders.length === 0 && (
          <div className="text-center py-12 text-muted-foreground">
            No pre-orders for tomorrow
          </div>
        )}
      </div>

      {/* Add Meal Dialog */}
      <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Add Meal to Tomorrow's Menu</DialogTitle>
          </DialogHeader>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Select Product *</label>
              <select
                value={newMeal.productId}
                onChange={(e) => setNewMeal({ ...newMeal, productId: e.target.value })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              >
                {products.map((product) => (
                  <option key={product.id} value={product.id} className="bg-card text-foreground">
                    {product.name} - ${product.price}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm mb-2">Meal Type *</label>
              <select
                value={newMeal.mealType}
                onChange={(e) => setNewMeal({ ...newMeal, mealType: e.target.value as 'breakfast' | 'lunch' | 'dinner' })}
                className="w-full p-3 rounded-lg bg-card border border-border text-foreground focus:outline-none focus:ring-2 focus:ring-[#c74242]"
              >
                <option value="breakfast" className="bg-card text-foreground">Breakfast</option>
                <option value="lunch" className="bg-card text-foreground">Lunch</option>
                <option value="dinner" className="bg-card text-foreground">Dinner</option>
              </select>
            </div>

            <div className="p-3 bg-blue-500/10 border border-blue-500/20 rounded-lg">
              <p className="text-sm text-blue-500">
                This will add the selected meal to tomorrow's available menu for students to pre-order.
              </p>
            </div>

            <div className="flex gap-2">
              <button
                onClick={() => setIsAddDialogOpen(false)}
                className="flex-1 py-3 border border-border rounded-lg hover:bg-muted transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleAddMeal}
                className="flex-1 py-3 bg-[#c74242] text-white rounded-lg hover:bg-[#c74242]/90 transition-colors"
              >
                Add to Menu
              </button>
            </div>
          </div>
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
